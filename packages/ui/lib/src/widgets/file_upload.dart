import 'dart:io' as io;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';

class FileUpload extends StatefulWidget {
  final ValueChanged<List<PlatformFile>>? onFilesSelected;
  final ValueChanged<double>? onUploadProgress;
  final ValueChanged<List<String>>? onUploadComplete;
  final ValueChanged<String>? onUploadError;
  final List<String>? acceptedTypes;
  final int? maxFileSize;
  final int maxFiles;
  final bool multiple;
  final bool dragAndDrop;
  final bool showPreview;
  final String? uploadUrl;
  final Map<String, String>? headers;
  final bool disabled;
  final String? label;
  final String? helperText;
  final Widget? uploadIcon;

  const FileUpload({
    super.key,
    this.onFilesSelected,
    this.onUploadProgress,
    this.onUploadComplete,
    this.onUploadError,
    this.acceptedTypes,
    this.maxFileSize,
    this.maxFiles = 1,
    this.multiple = false,
    this.dragAndDrop = true,
    this.showPreview = true,
    this.uploadUrl,
    this.headers,
    this.disabled = false,
    this.label,
    this.helperText,
    this.uploadIcon,
  });

  @override
  State<FileUpload> createState() => _FileUploadState();
}

class _FileUploadState extends State<FileUpload> {
  List<PlatformFile> _files = [];
  bool _dragOver = false;
  bool _uploading = false;
  double _uploadProgress = 0.0;

  Future<void> _pickFiles() async {
    if (widget.disabled || _uploading) return;

    try {
      final result = await FilePicker.platform.pickFiles(
        allowMultiple: widget.multiple,
        type: widget.acceptedTypes == null ? FileType.any : FileType.custom,
        allowedExtensions: widget.acceptedTypes,
        withData: true,
      );

      if (result == null) return;

      final picked = <PlatformFile>[];

      for (final f in result.files) {
        // Size validation
        if (widget.maxFileSize != null && f.size > widget.maxFileSize!) {
          widget.onUploadError?.call('File too large: ${f.name}');
          continue;
        }

        picked.add(f);
      }

      if (picked.isEmpty) return;

      setState(() {
        if (widget.multiple) {
          _files = (_files + picked).take(widget.maxFiles).toList();
        } else {
          _files = [picked.first];
        }
      });

      widget.onFilesSelected?.call(_files);
    } catch (e) {
      widget.onUploadError?.call(e.toString());
    }
  }

  void _removeAt(int index) {
    if (widget.disabled || _uploading) return;
    setState(() {
      _files.removeAt(index);
    });
  }

  void _clearAll() {
    if (widget.disabled || _uploading) return;
    setState(() {
      _files.clear();
    });
  }

  // Mock upload simulation - in real implementation, this would perform HTTP upload
  Future<void> uploadAll() async {
    if (widget.uploadUrl == null || _files.isEmpty || _uploading) return;

    setState(() {
      _uploading = true;
      _uploadProgress = 0.0;
    });

    try {
      final total = _files.length;
      final uploadedUrls = <String>[];

      for (var i = 0; i < total; i++) {
        for (var p = 0; p <= 100; p += 10) {
          await Future.delayed(const Duration(milliseconds: 50));
          final progress = (i / total) + (p / 100) / total;
          setState(() {
            _uploadProgress = progress;
          });
          widget.onUploadProgress?.call(progress);
        }
        // Mock uploaded URL
        uploadedUrls.add('${widget.uploadUrl}/${_files[i].name}');
      }

      widget.onUploadComplete?.call(uploadedUrls);
    } catch (e) {
      widget.onUploadError?.call(e.toString());
    } finally {
      setState(() {
        _uploading = false;
        _uploadProgress = 0.0;
      });
    }
  }

  Widget _buildPreview(PlatformFile file) {
    if (!widget.showPreview) return const SizedBox.shrink();

    // Image preview for common image types
    final lower = file.name.toLowerCase();
    if (lower.endsWith('.png') ||
        lower.endsWith('.jpg') ||
        lower.endsWith('.jpeg') ||
        lower.endsWith('.gif')) {
      if (kIsWeb && file.bytes != null) {
        return ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: Image.memory(
            file.bytes!,
            width: 48,
            height: 48,
            fit: BoxFit.cover,
          ),
        );
      }
      if (!kIsWeb && file.path != null) {
        return ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: Image.file(
            io.File(file.path!),
            width: 48,
            height: 48,
            fit: BoxFit.cover,
          ),
        );
      }
    }

    // Generic file icon
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Icon(
        Icons.insert_drive_file,
        size: 24,
        color: Theme.of(context).colorScheme.onSurfaceVariant,
      ),
    );
  }

  String _formatFileSize(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
  }

  Widget _buildFileChip(PlatformFile file, int index) {
    final theme = Theme.of(context);
    return Container(
      margin: EdgeInsets.only(right: 8, bottom: 8),
      child: Chip(
        avatar: _buildPreview(file),
        label: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              file.name,
              style: theme.textTheme.bodySmall,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            Text(
              _formatFileSize(file.size),
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
        onDeleted: () => _removeAt(index),
        deleteIcon: Icon(Icons.close, size: 18),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.label != null) ...[
          Text(
            widget.label!,
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 8),
        ],

        // Upload area
        GestureDetector(
          onTap: _pickFiles,
          child: MouseRegion(
            cursor: widget.disabled || _uploading
                ? SystemMouseCursors.forbidden
                : SystemMouseCursors.click,
            child: AnimatedContainer(
              duration: Duration(milliseconds: 200),
              padding: EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: _dragOver
                  ? colorScheme.primary.withValues(alpha: 0.08)
                  : colorScheme.surface,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: _dragOver
                      ? colorScheme.primary
                      : colorScheme.outline,
                  width: _dragOver ? 2 : 1,
                  strokeAlign: BorderSide.strokeAlignInside,
                ),
              ),
              child: Column(
                children: [
                  widget.uploadIcon ?? Icon(
                    Icons.cloud_upload_outlined,
                    size: 48,
                    color: widget.disabled || _uploading
                        ? colorScheme.onSurfaceVariant.withValues(alpha: 0.38)
                        : colorScheme.primary,
                  ),
                  SizedBox(height: 16),
                  Text(
                    _files.isEmpty
                        ? 'Click to select files or drag and drop'
                        : 'Selected ${_files.length} file(s)',
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: widget.disabled || _uploading
                          ? colorScheme.onSurfaceVariant.withValues(alpha: 0.38)
                          : colorScheme.onSurface,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  if (widget.helperText != null) ...[
                    SizedBox(height: 8),
                    Text(
                      widget.helperText!,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),

        // Upload progress
        if (_uploading) ...[
          SizedBox(height: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Uploading... ${(_uploadProgress * 100).toInt()}%',
                style: theme.textTheme.bodySmall,
              ),
              SizedBox(height: 4),
              LinearProgressIndicator(
                value: _uploadProgress,
                backgroundColor: colorScheme.surfaceContainerHighest,
                valueColor: AlwaysStoppedAnimation(colorScheme.primary),
              ),
            ],
          ),
        ],

        // File list
        if (_files.isNotEmpty) ...[
          SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Selected Files',
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
              Row(
                children: [
                  if (widget.uploadUrl != null && !_uploading)
                    ElevatedButton.icon(
                      onPressed: uploadAll,
                      icon: Icon(Icons.upload, size: 16),
                      label: Text('Upload'),
                    ),
                  SizedBox(width: 8),
                  TextButton(
                    onPressed: _clearAll,
                    child: Text('Clear All'),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 8),
          Wrap(
            children: List.generate(
              _files.length,
              (index) => _buildFileChip(_files[index], index),
            ),
          ),
        ],
      ],
    );
  }
}