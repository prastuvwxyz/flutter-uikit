import 'dart:io' as io;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:ui_tokens/ui_tokens.dart';
import '../../tokens/color_tokens.dart';
import 'models.dart';

/// A minimal file manager supporting grid/list view, selection, search and
/// simple upload hook via onFileUpload.
class MinimalFileManager extends StatefulWidget {
  final List<FileItem> files;
  final ValueChanged<FileItem>? onFileSelect;
  final ValueChanged<List<io.File>>? onFileUpload;
  final ValueChanged<FileItem>? onFileDelete;
  final ValueChanged<String>? onFolderCreate;
  final ValueChanged<RenameData>? onFileRename;
  final FileViewMode viewMode;
  final bool allowUpload;
  final bool allowDelete;
  final bool allowRename;
  final bool allowFolderCreate;
  final bool multiSelect;
  final List<String> acceptedTypes;
  final int? maxFileSize;
  final bool showSearch;
  final bool showSort;
  final bool showFilter;
  final double thumbnailSize;

  const MinimalFileManager({
    super.key,
    this.files = const [],
    this.onFileSelect,
    this.onFileUpload,
    this.onFileDelete,
    this.onFolderCreate,
    this.onFileRename,
    this.viewMode = FileViewMode.grid,
    this.allowUpload = true,
    this.allowDelete = true,
    this.allowRename = true,
    this.allowFolderCreate = true,
    this.multiSelect = false,
    this.acceptedTypes = const [],
    this.maxFileSize,
    this.showSearch = true,
    this.showSort = true,
    this.showFilter = true,
    this.thumbnailSize = 120.0,
  });

  @override
  State<MinimalFileManager> createState() => _MinimalFileManagerState();
}

class _MinimalFileManagerState extends State<MinimalFileManager> {
  String _search = '';
  Set<String> _selected = {};

  List<FileItem> get _filtered {
    if (_search.trim().isEmpty) return widget.files;
    final q = _search.toLowerCase();
    return widget.files.where((f) => f.name.toLowerCase().contains(q)).toList();
  }

  void _onTap(FileItem item) {
    setState(() {
      if (widget.multiSelect) {
        if (_selected.contains(item.id)) {
          _selected.remove(item.id);
        } else {
          _selected.add(item.id);
        }
      } else {
        _selected = {item.id};
      }
    });
    widget.onFileSelect?.call(item);
  }

  Future<void> _pickAndUpload() async {
    // Keep implementation minimal: use file picker when not web, otherwise do
    // nothing. Consumers can provide their own using onFileUpload.
    if (widget.onFileUpload == null) return;
    try {
      // Not importing file_picker here to keep surface small; we accept io.File
      // from a native file path example. For now, call with empty list to
      // indicate upload action triggered.
      widget.onFileUpload?.call([]);
    } catch (e) {
      // ignore
    }
  }

  Widget _buildGrid(BuildContext context) {
    final tokens =
        Theme.of(context).extension<UiTokens>() ?? UiTokens.standard();
    final list = _filtered;
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisSpacing: tokens.spacingTokens.md,
        crossAxisSpacing: tokens.spacingTokens.md,
        childAspectRatio: 0.9,
      ),
      itemCount: list.length,
      itemBuilder: (context, i) {
        final f = list[i];
        final selected = _selected.contains(f.id);
        return GestureDetector(
          onTap: () => _onTap(f),
          child: Container(
            padding: EdgeInsets.all(tokens.spacingTokens.sm),
            decoration: BoxDecoration(
              color: selected
                  ? tokens.colorTokens.primary.shade50
                  : ColorTokens.surface,
              borderRadius: BorderRadius.circular(tokens.radiusTokens.md),
              border: Border.all(color: ColorTokens.outline),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: double.infinity,
                  height: widget.thumbnailSize,
                  decoration: BoxDecoration(
                    color: ColorTokens.surface,
                    borderRadius: BorderRadius.circular(tokens.radiusTokens.sm),
                  ),
                  child: f.mimeType != null && f.mimeType!.startsWith('image')
                      ? (f.file != null && !kIsWeb
                            ? Image.file(f.file!, fit: BoxFit.cover)
                            : Center(child: Icon(Icons.image)))
                      : Center(
                          child: Icon(
                            f.isFolder ? Icons.folder : Icons.insert_drive_file,
                          ),
                        ),
                ),
                SizedBox(height: tokens.spacingTokens.sm),
                Text(
                  f.name,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: tokens.typographyTokens.bodySmall,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildList(BuildContext context) {
    final tokens =
        Theme.of(context).extension<UiTokens>() ?? UiTokens.standard();
    final list = _filtered;
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: list.length,
      separatorBuilder: (_, __) => SizedBox(height: tokens.spacingTokens.sm),
      itemBuilder: (context, i) {
        final f = list[i];
        final selected = _selected.contains(f.id);
        return ListTile(
          leading: Icon(f.isFolder ? Icons.folder : Icons.insert_drive_file),
          title: Text(f.name, style: tokens.typographyTokens.bodyMedium),
          selected: selected,
          onTap: () => _onTap(f),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (widget.allowDelete)
                IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () => widget.onFileDelete?.call(f),
                ),
              if (widget.allowRename)
                IconButton(
                  icon: Icon(Icons.drive_file_rename_outline),
                  onPressed: () async {
                    final name = await _showRenameDialog(f.name);
                    if (name != null && name.isNotEmpty) {
                      widget.onFileRename?.call(
                        RenameData(id: f.id, newName: name),
                      );
                    }
                  },
                ),
            ],
          ),
        );
      },
    );
  }

  Future<String?> _showRenameDialog(String current) {
    final ctl = TextEditingController(text: current);
    return showDialog<String>(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: const Text('Rename'),
          content: TextField(controller: ctl, autofocus: true),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(ctx, ctl.text.trim()),
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final tokens =
        Theme.of(context).extension<UiTokens>() ?? UiTokens.standard();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            if (widget.showSearch)
              Expanded(
                child: TextField(
                  decoration: const InputDecoration(hintText: 'Search files'),
                  onChanged: (v) => setState(() => _search = v),
                ),
              ),
            if (widget.allowFolderCreate)
              Padding(
                padding: EdgeInsets.only(left: tokens.spacingTokens.md),
                child: ElevatedButton.icon(
                  onPressed: () async {
                    final name = await _showRenameDialog('New folder');
                    if (name != null && name.isNotEmpty) {
                      widget.onFolderCreate?.call(name);
                    }
                  },
                  icon: const Icon(Icons.create_new_folder),
                  label: const Text('Folder'),
                ),
              ),
            if (widget.allowUpload)
              Padding(
                padding: EdgeInsets.only(left: tokens.spacingTokens.md),
                child: ElevatedButton.icon(
                  onPressed: _pickAndUpload,
                  icon: const Icon(Icons.upload_file),
                  label: const Text('Upload'),
                ),
              ),
          ],
        ),
        SizedBox(height: tokens.spacingTokens.md),
        if (widget.viewMode == FileViewMode.grid)
          _buildGrid(context)
        else
          _buildList(context),
      ],
    );
  }
}
