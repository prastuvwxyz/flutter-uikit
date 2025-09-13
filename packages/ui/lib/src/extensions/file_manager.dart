import 'package:flutter/material.dart';

/// A file manager widget for browsing, selecting, and managing files
class FileManager extends StatefulWidget {
  /// Current directory path
  final String currentPath;

  /// List of files and directories to display
  final List<FileItem> items;

  /// Callback when a file is selected
  final Function(FileItem file)? onFileSelected;

  /// Callback when a directory is opened
  final Function(FileItem directory)? onDirectoryOpened;

  /// Callback when files are deleted
  final Function(List<FileItem> files)? onFilesDeleted;

  /// Callback when files are renamed
  final Function(FileItem file, String newName)? onFileRenamed;

  /// Callback when files are moved
  final Function(List<FileItem> files, String destinationPath)? onFilesMoved;

  /// Whether to allow multiple file selection
  final bool allowMultipleSelection;

  /// Whether to show hidden files
  final bool showHiddenFiles;

  /// File view mode (list, grid, details)
  final FileViewMode viewMode;

  /// Allowed file extensions (null for all files)
  final List<String>? allowedExtensions;

  /// Whether files can be deleted
  final bool allowDelete;

  /// Whether files can be renamed
  final bool allowRename;

  /// Whether files can be moved
  final bool allowMove;

  /// Whether to show file details
  final bool showFileDetails;

  /// Custom file icon builder
  final Widget Function(FileItem file)? fileIconBuilder;

  /// Custom directory icon builder
  final Widget Function(FileItem directory)? directoryIconBuilder;

  /// Custom context menu items
  final List<ContextMenuItem> contextMenuItems;

  /// Grid view settings
  final FileGridSettings? gridSettings;

  const FileManager({
    super.key,
    required this.currentPath,
    required this.items,
    this.onFileSelected,
    this.onDirectoryOpened,
    this.onFilesDeleted,
    this.onFileRenamed,
    this.onFilesMoved,
    this.allowMultipleSelection = false,
    this.showHiddenFiles = false,
    this.viewMode = FileViewMode.list,
    this.allowedExtensions,
    this.allowDelete = true,
    this.allowRename = true,
    this.allowMove = true,
    this.showFileDetails = true,
    this.fileIconBuilder,
    this.directoryIconBuilder,
    this.contextMenuItems = const [],
    this.gridSettings,
  });

  @override
  State<FileManager> createState() => _FileManagerState();
}

class _FileManagerState extends State<FileManager> {
  final Set<FileItem> _selectedItems = {};
  FileViewMode _currentViewMode = FileViewMode.list;

  @override
  void initState() {
    super.initState();
    _currentViewMode = widget.viewMode;
  }

  List<FileItem> get _filteredItems {
    return widget.items.where((item) {
      // Filter hidden files
      if (!widget.showHiddenFiles && item.name.startsWith('.')) {
        return false;
      }

      // Filter by allowed extensions
      if (widget.allowedExtensions != null && !item.isDirectory) {
        final extension = item.extension?.toLowerCase();
        return extension != null && widget.allowedExtensions!.contains(extension);
      }

      return true;
    }).toList();
  }

  void _toggleSelection(FileItem item) {
    setState(() {
      if (_selectedItems.contains(item)) {
        _selectedItems.remove(item);
      } else {
        if (!widget.allowMultipleSelection) {
          _selectedItems.clear();
        }
        _selectedItems.add(item);
      }
    });
  }

  void _onItemTap(FileItem item) {
    if (item.isDirectory) {
      widget.onDirectoryOpened?.call(item);
    } else {
      widget.onFileSelected?.call(item);
    }
  }

  void _onItemLongPress(FileItem item) {
    _toggleSelection(item);
  }

  void _showContextMenu(BuildContext context, FileItem item, Offset position) {
    final menuItems = <PopupMenuEntry<String>>[
      if (widget.allowRename)
        const PopupMenuItem(
          value: 'rename',
          child: Row(
            children: [
              Icon(Icons.edit),
              SizedBox(width: 8),
              Text('Rename'),
            ],
          ),
        ),
      if (widget.allowMove)
        const PopupMenuItem(
          value: 'move',
          child: Row(
            children: [
              Icon(Icons.drive_file_move),
              SizedBox(width: 8),
              Text('Move'),
            ],
          ),
        ),
      if (widget.allowDelete)
        const PopupMenuItem(
          value: 'delete',
          child: Row(
            children: [
              Icon(Icons.delete, color: Colors.red),
              SizedBox(width: 8),
              Text('Delete', style: TextStyle(color: Colors.red)),
            ],
          ),
        ),
      ...widget.contextMenuItems.map((item) => PopupMenuItem(
        value: item.value,
        child: Row(
          children: [
            if (item.icon != null) ...[
              Icon(item.icon),
              const SizedBox(width: 8),
            ],
            Text(item.title),
          ],
        ),
      )),
    ];

    showMenu(
      context: context,
      position: RelativeRect.fromLTRB(
        position.dx,
        position.dy,
        position.dx + 1,
        position.dy + 1,
      ),
      items: menuItems,
    ).then((value) {
      if (value != null) {
        _handleContextMenuAction(value, item);
      }
    });
  }

  void _handleContextMenuAction(String action, FileItem item) {
    switch (action) {
      case 'rename':
        _showRenameDialog(item);
        break;
      case 'move':
        // Handle move action
        break;
      case 'delete':
        _showDeleteConfirmation([item]);
        break;
    }
  }

  void _showRenameDialog(FileItem item) {
    final controller = TextEditingController(text: item.name);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Rename File'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(labelText: 'New name'),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              widget.onFileRenamed?.call(item, controller.text);
              Navigator.pop(context);
            },
            child: const Text('Rename'),
          ),
        ],
      ),
    );
  }

  void _showDeleteConfirmation(List<FileItem> items) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Files'),
        content: Text(
          'Are you sure you want to delete ${items.length} item${items.length > 1 ? 's' : ''}?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              widget.onFilesDeleted?.call(items);
              Navigator.pop(context);
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      title: Text(_getDirectoryName()),
      actions: [
        if (_selectedItems.isNotEmpty) ...[
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () => _showDeleteConfirmation(_selectedItems.toList()),
          ),
          IconButton(
            icon: const Icon(Icons.clear),
            onPressed: () => setState(() => _selectedItems.clear()),
          ),
        ],
        PopupMenuButton<FileViewMode>(
          icon: const Icon(Icons.view_module),
          onSelected: (mode) => setState(() => _currentViewMode = mode),
          itemBuilder: (context) => [
            const PopupMenuItem(
              value: FileViewMode.list,
              child: Row(
                children: [
                  Icon(Icons.list),
                  SizedBox(width: 8),
                  Text('List'),
                ],
              ),
            ),
            const PopupMenuItem(
              value: FileViewMode.grid,
              child: Row(
                children: [
                  Icon(Icons.grid_view),
                  SizedBox(width: 8),
                  Text('Grid'),
                ],
              ),
            ),
            const PopupMenuItem(
              value: FileViewMode.details,
              child: Row(
                children: [
                  Icon(Icons.view_list),
                  SizedBox(width: 8),
                  Text('Details'),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  String _getDirectoryName() {
    if (widget.currentPath == '/') return 'Root';
    return widget.currentPath.split('/').last;
  }

  Widget _buildFileIcon(FileItem item) {
    if (item.isDirectory) {
      return widget.directoryIconBuilder?.call(item) ??
             Icon(Icons.folder, size: _getIconSize(), color: Colors.blue);
    }

    if (widget.fileIconBuilder != null) {
      return widget.fileIconBuilder!(item);
    }

    // Default file icons based on extension
    switch (item.extension?.toLowerCase()) {
      case 'pdf':
        return Icon(Icons.picture_as_pdf, size: _getIconSize(), color: Colors.red);
      case 'doc':
      case 'docx':
        return Icon(Icons.description, size: _getIconSize(), color: Colors.blue);
      case 'xls':
      case 'xlsx':
        return Icon(Icons.table_chart, size: _getIconSize(), color: Colors.green);
      case 'jpg':
      case 'jpeg':
      case 'png':
      case 'gif':
        return Icon(Icons.image, size: _getIconSize(), color: Colors.orange);
      case 'mp4':
      case 'avi':
      case 'mov':
        return Icon(Icons.video_file, size: _getIconSize(), color: Colors.purple);
      case 'mp3':
      case 'wav':
      case 'flac':
        return Icon(Icons.audio_file, size: _getIconSize(), color: Colors.teal);
      case 'zip':
      case 'rar':
      case '7z':
        return Icon(Icons.archive, size: _getIconSize(), color: Colors.brown);
      default:
        return Icon(Icons.insert_drive_file, size: _getIconSize(), color: Colors.grey);
    }
  }

  double _getIconSize() {
    switch (_currentViewMode) {
      case FileViewMode.list:
        return 24;
      case FileViewMode.grid:
        return widget.gridSettings?.iconSize ?? 48;
      case FileViewMode.details:
        return 20;
    }
  }

  Widget _buildListView() {
    return ListView.builder(
      itemCount: _filteredItems.length,
      itemBuilder: (context, index) {
        final item = _filteredItems[index];
        final isSelected = _selectedItems.contains(item);

        return ListTile(
          leading: _buildFileIcon(item),
          title: Text(item.name),
          subtitle: widget.showFileDetails ? Text(_getFileDetails(item)) : null,
          selected: isSelected,
          onTap: () => _onItemTap(item),
          onLongPress: () => _onItemLongPress(item),
          trailing: widget.allowMultipleSelection
              ? Checkbox(
                  value: isSelected,
                  onChanged: (_) => _toggleSelection(item),
                )
              : null,
        );
      },
    );
  }

  Widget _buildGridView() {
    final settings = widget.gridSettings ?? FileGridSettings.defaultSettings();

    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: settings.crossAxisCount,
        mainAxisSpacing: settings.mainAxisSpacing,
        crossAxisSpacing: settings.crossAxisSpacing,
        childAspectRatio: settings.childAspectRatio,
      ),
      itemCount: _filteredItems.length,
      itemBuilder: (context, index) {
        final item = _filteredItems[index];
        final isSelected = _selectedItems.contains(item);

        return Card(
          color: isSelected ? Theme.of(context).colorScheme.primary.withValues(alpha: 0.12) : null,
          child: InkWell(
            onTap: () => _onItemTap(item),
            onLongPress: () => _onItemLongPress(item),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildFileIcon(item),
                  const SizedBox(height: 8),
                  Text(
                    item.name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  if (isSelected)
                    const Icon(Icons.check_circle, color: Colors.blue, size: 16),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildDetailsView() {
    return ListView.builder(
      itemCount: _filteredItems.length,
      itemBuilder: (context, index) {
        final item = _filteredItems[index];
        final isSelected = _selectedItems.contains(item);

        return ListTile(
          dense: true,
          leading: _buildFileIcon(item),
          title: Text(item.name),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(_getFileDetails(item)),
              if (item.modifiedDate != null)
                Text(
                  'Modified: ${_formatDate(item.modifiedDate!)}',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
            ],
          ),
          selected: isSelected,
          onTap: () => _onItemTap(item),
          onLongPress: () => _onItemLongPress(item),
          trailing: widget.allowMultipleSelection
              ? Checkbox(
                  value: isSelected,
                  onChanged: (_) => _toggleSelection(item),
                )
              : null,
        );
      },
    );
  }

  String _getFileDetails(FileItem item) {
    if (item.isDirectory) {
      return 'Directory';
    }

    final parts = <String>[];
    if (item.size != null) {
      parts.add(_formatFileSize(item.size!));
    }
    if (item.extension != null) {
      parts.add(item.extension!.toUpperCase());
    }

    return parts.join(' " ');
  }

  String _formatFileSize(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    if (bytes < 1024 * 1024 * 1024) return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
    return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(1)} GB';
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: Column(
        children: [
          if (_selectedItems.isNotEmpty)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16.0),
              color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
              child: Text(
                '${_selectedItems.length} item${_selectedItems.length > 1 ? 's' : ''} selected',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          Expanded(
            child: _filteredItems.isEmpty
                ? const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.folder_open, size: 64, color: Colors.grey),
                        SizedBox(height: 16),
                        Text('No files found'),
                      ],
                    ),
                  )
                : _buildCurrentView(),
          ),
        ],
      ),
    );
  }

  Widget _buildCurrentView() {
    switch (_currentViewMode) {
      case FileViewMode.list:
        return _buildListView();
      case FileViewMode.grid:
        return _buildGridView();
      case FileViewMode.details:
        return _buildDetailsView();
    }
  }
}

/// Represents a file or directory item
class FileItem {
  final String name;
  final String path;
  final bool isDirectory;
  final int? size;
  final DateTime? modifiedDate;
  final DateTime? createdDate;
  final String? mimeType;

  const FileItem({
    required this.name,
    required this.path,
    required this.isDirectory,
    this.size,
    this.modifiedDate,
    this.createdDate,
    this.mimeType,
  });

  String? get extension {
    if (isDirectory) return null;
    final parts = name.split('.');
    return parts.length > 1 ? parts.last : null;
  }

  @override
  bool operator ==(Object other) {
    return other is FileItem && other.path == path;
  }

  @override
  int get hashCode => path.hashCode;
}

/// File view modes
enum FileViewMode {
  list,
  grid,
  details,
}

/// Grid view configuration
class FileGridSettings {
  final int crossAxisCount;
  final double mainAxisSpacing;
  final double crossAxisSpacing;
  final double childAspectRatio;
  final double iconSize;

  const FileGridSettings({
    required this.crossAxisCount,
    required this.mainAxisSpacing,
    required this.crossAxisSpacing,
    required this.childAspectRatio,
    required this.iconSize,
  });

  static FileGridSettings defaultSettings() => const FileGridSettings(
    crossAxisCount: 3,
    mainAxisSpacing: 8.0,
    crossAxisSpacing: 8.0,
    childAspectRatio: 0.8,
    iconSize: 48.0,
  );

  static FileGridSettings compact() => const FileGridSettings(
    crossAxisCount: 4,
    mainAxisSpacing: 4.0,
    crossAxisSpacing: 4.0,
    childAspectRatio: 1.0,
    iconSize: 32.0,
  );

  static FileGridSettings large() => const FileGridSettings(
    crossAxisCount: 2,
    mainAxisSpacing: 12.0,
    crossAxisSpacing: 12.0,
    childAspectRatio: 0.7,
    iconSize: 64.0,
  );
}

/// Context menu item configuration
class ContextMenuItem {
  final String value;
  final String title;
  final IconData? icon;

  const ContextMenuItem({
    required this.value,
    required this.title,
    this.icon,
  });
}

/// Pre-built file manager configurations
class FileManagerPresets {
  /// Basic file browser
  static FileManager browser({
    required String currentPath,
    required List<FileItem> items,
    Function(FileItem)? onFileSelected,
    Function(FileItem)? onDirectoryOpened,
  }) {
    return FileManager(
      currentPath: currentPath,
      items: items,
      onFileSelected: onFileSelected,
      onDirectoryOpened: onDirectoryOpened,
      allowMultipleSelection: false,
      allowDelete: false,
      allowRename: false,
      allowMove: false,
    );
  }

  /// Image gallery file manager
  static FileManager imageGallery({
    required String currentPath,
    required List<FileItem> items,
    Function(FileItem)? onFileSelected,
    Function(FileItem)? onDirectoryOpened,
  }) {
    return FileManager(
      currentPath: currentPath,
      items: items,
      onFileSelected: onFileSelected,
      onDirectoryOpened: onDirectoryOpened,
      allowedExtensions: ['jpg', 'jpeg', 'png', 'gif', 'webp'],
      viewMode: FileViewMode.grid,
      gridSettings: FileGridSettings.large(),
      allowMultipleSelection: true,
    );
  }

  /// Document manager
  static FileManager documentManager({
    required String currentPath,
    required List<FileItem> items,
    Function(FileItem)? onFileSelected,
    Function(FileItem)? onDirectoryOpened,
    Function(List<FileItem>)? onFilesDeleted,
    Function(FileItem, String)? onFileRenamed,
  }) {
    return FileManager(
      currentPath: currentPath,
      items: items,
      onFileSelected: onFileSelected,
      onDirectoryOpened: onDirectoryOpened,
      onFilesDeleted: onFilesDeleted,
      onFileRenamed: onFileRenamed,
      allowedExtensions: ['pdf', 'doc', 'docx', 'txt', 'rtf'],
      viewMode: FileViewMode.details,
      showFileDetails: true,
    );
  }
}

/// Extension for easy file manager integration
extension FileManagerExtension on Widget {
  /// Wrap with a file manager
  Widget withFileManager({
    required String currentPath,
    required List<FileItem> items,
    Function(FileItem)? onFileSelected,
  }) {
    return Column(
      children: [
        this,
        Expanded(
          child: FileManagerPresets.browser(
            currentPath: currentPath,
            items: items,
            onFileSelected: onFileSelected,
          ),
        ),
      ],
    );
  }
}