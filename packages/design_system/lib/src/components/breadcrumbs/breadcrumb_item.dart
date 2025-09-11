import 'package:flutter/material.dart';

class BreadcrumbItem {
  final Widget child;
  final bool isCurrent;

  const BreadcrumbItem({required this.child, this.isCurrent = false});
}
