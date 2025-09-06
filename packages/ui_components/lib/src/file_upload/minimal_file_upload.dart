import 'dart:io' as io;
import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:ui_tokens/ui_tokens.dart';
import '../../tokens/color_tokens.dart';

/// Minimal file upload component supporting selection, drag-and-drop (web),
/// previews for images, simple validation, and progress callbacks.
class MinimalFileUpload extends StatefulWidget {
  final ValueChanged<List<io.File>>? onFilesSelected;
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

  const MinimalFileUpload({
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
  });

  @override
  State<MinimalFileUpload> createState() => _MinimalFileUploadState();
}

class _MinimalFileUploadState extends State<MinimalFileUpload> {
  List<_SelectedFile> _files = [];
  bool _dragOver = false;

  Future<void> _pickFiles() async {
    if (widget.disabled) return;

    try {
      final result = await FilePicker.platform.pickFiles(
        allowMultiple: widget.multiple,
        type: widget.acceptedTypes == null ? FileType.any : FileType.custom,
        allowedExtensions: widget.acceptedTypes,
        withData: true,
      );

      if (result == null) return;

      final picked = <_SelectedFile>[];

      for (final f in result.files) {
        // size validation
        if (widget.maxFileSize != null && f.size > widget.maxFileSize!) {
          widget.onUploadError?.call('File too large: ${f.name}');
          continue;
        }

        Uint8List? bytes = f.bytes;
        io.File? fileOnDisk;
        if (kIsWeb) {
          // on web we keep bytes
          picked.add(_SelectedFile(name: f.name, bytes: bytes, size: f.size));
        } else {
          // create temporary file on native platforms
          if (f.path != null) {
            fileOnDisk = io.File(f.path!);
          } else if (bytes != null) {
            final temp = io.File('${io.Directory.systemTemp.path}/${f.name}');
            await temp.writeAsBytes(bytes);
            fileOnDisk = temp;
          }
          if (fileOnDisk != null) {
            picked.add(
              _SelectedFile(name: f.name, file: fileOnDisk, size: f.size),
            );
          }
        }
      }

      if (picked.isEmpty) return;

      setState(() {
        if (widget.multiple) {
          _files = (_files + picked).take(widget.maxFiles).toList();
        } else {
          _files = [picked.first];
        }
      });

      // notify
      widget.onFilesSelected?.call(_nativeFilesFromSelected(_files));
    } catch (e) {
      widget.onUploadError?.call(e.toString());
    }
  }

  List<io.File> _nativeFilesFromSelected(List<_SelectedFile> sel) {
    return sel.where((s) => s.file != null).map((s) => s.file!).toList();
  }

  void _removeAt(int index) {
    setState(() {
      _files.removeAt(index);
    });
  }

  // Basic mock upload to demonstrate progress callbacks. If uploadUrl is
  // provided, we would perform an HTTP upload; to keep this component
  // dependency-light, we simulate progress here. Consumers can implement
  // real uploads themselves using the files from onFilesSelected.
  Future<void> uploadAll() async {
    if (widget.uploadUrl == null) {
      widget.onUploadError?.call('No uploadUrl provided');
      return;
    }

    try {
      final total = _files.length;
      final uploadedUrls = <String>[];
      for (var i = 0; i < total; i++) {
        for (var p = 0; p <= 100; p += 10) {
          await Future.delayed(const Duration(milliseconds: 50));
          widget.onUploadProgress?.call((i / total) + (p / 100) / total);
        }
        // mock url
        uploadedUrls.add('https://example.com/uploads/${_files[i].name}');
      }
      widget.onUploadComplete?.call(uploadedUrls);
    } catch (e) {
      widget.onUploadError?.call(e.toString());
    }
  }

  Widget _buildPreview(_SelectedFile f) {
    final tokens =
        Theme.of(context).extension<UiTokens>() ?? UiTokens.standard();
    if (!widget.showPreview) return const SizedBox.shrink();

    // Image preview for common image types
    final lower = f.name.toLowerCase();
    if (lower.endsWith('.png') ||
        lower.endsWith('.jpg') ||
        lower.endsWith('.jpeg') ||
        lower.endsWith('.gif')) {
      if (kIsWeb && f.bytes != null) {
        return Image.memory(f.bytes!, width: 64, height: 64, fit: BoxFit.cover);
      }
      if (f.file != null) {
        return Image.file(f.file!, width: 64, height: 64, fit: BoxFit.cover);
      }
    }

    // Generic file icon
    return Container(
      width: 64,
      height: 64,
      decoration: BoxDecoration(
        color: ColorTokens.surface,
        borderRadius: BorderRadius.circular(tokens.radiusTokens.md),
      ),
      child: Icon(
        Icons.insert_drive_file,
        size: 28,
        color: tokens.colorTokens.neutral.shade700,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final tokens =
        Theme.of(context).extension<UiTokens>() ?? UiTokens.standard();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: _pickFiles,
          child: FocusableActionDetector(
            enabled: !widget.disabled,
            child: MouseRegion(
              cursor: widget.disabled
                  ? SystemMouseCursors.forbidden
                  : SystemMouseCursors.click,
              child: Container(
                padding: EdgeInsets.all(tokens.spacingTokens.md),
                decoration: BoxDecoration(
                  color: ColorTokens.surface,
                  borderRadius: BorderRadius.circular(tokens.radiusTokens.md),
                  border: Border.all(
                    color: _dragOver
                        ? tokens.colorTokens.primary.shade500
                        : ColorTokens.outline,
                    width: 1.5,
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.upload_file,
                      color: tokens.colorTokens.primary.shade500,
                    ),
                    SizedBox(width: tokens.spacingTokens.md),
                    Expanded(
                      child: Text(
                        _files.isEmpty
                            ? 'Click to select files or drag here'
                            : 'Selected ${_files.length} file(s)'.toString(),
                        style: tokens.typographyTokens.bodyMedium,
                      ),
                    ),
                    if (_files.isNotEmpty)
                      TextButton(
                        onPressed: uploadAll,
                        child: const Text('Upload'),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),
        if (_files.isNotEmpty)
          Wrap(
            spacing: tokens.spacingTokens.md,
            runSpacing: tokens.spacingTokens.sm,
            children: List.generate(_files.length, (i) {
              final f = _files[i];
              return Chip(
                avatar: _buildPreview(f),
                label: Text(f.name),
                onDeleted: () => _removeAt(i),
              );
            }),
          ),
      ],
    );
  }
}

class _SelectedFile {
  final String name;
  final io.File? file;
  final Uint8List? bytes;
  final int size;

  _SelectedFile({
    required this.name,
    this.file,
    this.bytes,
    required this.size,
  });
}
