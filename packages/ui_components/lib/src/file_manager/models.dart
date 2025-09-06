import 'dart:io' as io;

/// Simple file item model used by MinimalFileManager.
class FileItem {
  final String id;
  final String name;
  final int size;
  final DateTime? modified;
  final String? mimeType;
  final bool isFolder;
  final List<FileItem> children;
  final io.File? file;

  FileItem({
    required this.id,
    required this.name,
    this.size = 0,
    this.modified,
    this.mimeType,
    this.isFolder = false,
    this.children = const [],
    this.file,
  });
}

class RenameData {
  final String id;
  final String newName;

  RenameData({required this.id, required this.newName});
}

enum FileViewMode { grid, list }
