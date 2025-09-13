import 'package:flutter/material.dart';

enum SemanticIconType { success, error, warning, info, primary, secondary }

enum IconSize {
  xs(12.0),
  sm(16.0),
  md(24.0),
  lg(32.0),
  xl(48.0),
  xxl(64.0);

  const IconSize(this.size);
  final double size;
}

class CustomIcon extends StatelessWidget {
  const CustomIcon(
    this.icon, {
    super.key,
    this.size,
    this.color,
    this.semanticLabel,
    this.textDirection,
  }) : semanticType = null;

  const CustomIcon.semantic(
    this.icon, {
    super.key,
    required this.semanticType,
    this.size,
    this.color,
    this.semanticLabel,
    this.textDirection,
  });

  final IconData icon;
  final double? size;
  final Color? color;
  final String? semanticLabel;
  final TextDirection? textDirection;
  final SemanticIconType? semanticType;

  double _getIconSize(BuildContext context) {
    if (size != null) return size!;
    return IconSize.md.size;
  }

  Color? _getIconColor(BuildContext context) {
    if (color != null) return color;
    if (semanticType != null) return _getSemanticColor(context, semanticType!);
    return Theme.of(context).colorScheme.onSurface;
  }

  Color? _getSemanticColor(BuildContext context, SemanticIconType type) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    switch (type) {
      case SemanticIconType.success:
        return colorScheme.primary;
      case SemanticIconType.error:
        return colorScheme.error;
      case SemanticIconType.warning:
        return Colors.orange;
      case SemanticIconType.info:
        return colorScheme.primary;
      case SemanticIconType.primary:
        return colorScheme.primary;
      case SemanticIconType.secondary:
        return colorScheme.secondary;
    }
  }

  bool _isDecorative() {
    return semanticLabel == null && semanticType == null;
  }

  String? _getSemanticLabel() {
    if (semanticLabel != null) return semanticLabel;
    if (semanticType != null) {
      switch (semanticType!) {
        case SemanticIconType.success:
          return 'Success';
        case SemanticIconType.error:
          return 'Error';
        case SemanticIconType.warning:
          return 'Warning';
        case SemanticIconType.info:
          return 'Information';
        case SemanticIconType.primary:
          return null;
        case SemanticIconType.secondary:
          return null;
      }
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: _getSemanticLabel(),
      excludeSemantics: _isDecorative(),
      child: Icon(
        icon,
        size: _getIconSize(context),
        color: _getIconColor(context),
        textDirection: textDirection,
      ),
    );
  }
}

class AppIcons {
  // Navigation
  static const IconData home = Icons.home;
  static const IconData menu = Icons.menu;
  static const IconData back = Icons.arrow_back;
  static const IconData forward = Icons.arrow_forward;
  static const IconData close = Icons.close;
  static const IconData search = Icons.search;

  // Actions
  static const IconData add = Icons.add;
  static const IconData edit = Icons.edit;
  static const IconData delete = Icons.delete;
  static const IconData save = Icons.save;
  static const IconData share = Icons.share;
  static const IconData download = Icons.download;

  // Content
  static const IconData favorite = Icons.favorite;
  static const IconData star = Icons.star;
  static const IconData bookmark = Icons.bookmark;
  static const IconData comment = Icons.comment;
  static const IconData attach = Icons.attach_file;
  static const IconData image = Icons.image;

  // Status
  static const IconData success = Icons.check_circle;
  static const IconData error = Icons.error;
  static const IconData warning = Icons.warning;
  static const IconData info = Icons.info;
  static const IconData loading = Icons.hourglass_empty;

  // Data
  static const IconData sort = Icons.sort;
  static const IconData filter = Icons.filter_list;
  static const IconData refresh = Icons.refresh;
  static const IconData sync = Icons.sync;

  // Communication
  static const IconData phone = Icons.phone;
  static const IconData email = Icons.email;
  static const IconData message = Icons.message;
  static const IconData notification = Icons.notifications;

  // Media
  static const IconData play = Icons.play_arrow;
  static const IconData pause = Icons.pause;
  static const IconData stop = Icons.stop;
  static const IconData volume = Icons.volume_up;

  // Settings
  static const IconData settings = Icons.settings;
  static const IconData profile = Icons.person;
  static const IconData help = Icons.help;
  static const IconData logout = Icons.logout;
}

class IconCategories {
  static const List<IconData> navigation = [
    AppIcons.home,
    AppIcons.menu,
    AppIcons.back,
    AppIcons.forward,
    AppIcons.close,
    AppIcons.search,
  ];

  static const List<IconData> actions = [
    AppIcons.add,
    AppIcons.edit,
    AppIcons.delete,
    AppIcons.save,
    AppIcons.share,
    AppIcons.download,
  ];

  static const List<IconData> status = [
    AppIcons.success,
    AppIcons.error,
    AppIcons.warning,
    AppIcons.info,
    AppIcons.loading,
  ];
}