import 'package:flutter/foundation.dart';

/// A simple tree node model used by MinimalTreeView.
@immutable
class TreeNode {
  final String id;
  final String label;
  final List<TreeNode> children;
  final bool isLoading;

  const TreeNode({
    required this.id,
    required this.label,
    this.children = const [],
    this.isLoading = false,
  });

  bool get hasChildren => children.isNotEmpty;

  TreeNode copyWith({
    String? id,
    String? label,
    List<TreeNode>? children,
    bool? isLoading,
  }) {
    return TreeNode(
      id: id ?? this.id,
      label: label ?? this.label,
      children: children ?? this.children,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}
