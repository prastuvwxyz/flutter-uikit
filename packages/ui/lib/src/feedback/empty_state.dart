import 'package:flutter/material.dart';

/// An empty state component for displaying placeholders when content is unavailable.
///
/// The EmptyState component provides a user-friendly way to display empty or
/// error states with customizable icons, titles, descriptions, and actions.
/// It's commonly used in lists, search results, and other content areas when
/// no data is available.
///
/// Example:
/// ```dart
/// EmptyState(
///   icon: Icons.search,
///   title: 'No results found',
///   description: 'Try adjusting your search terms.',
///   action: Button.primary(
///     child: Text('Clear Search'),
///     onPressed: () => clearSearch(),
///   ),
/// )
/// ```
class EmptyState extends StatelessWidget {
  /// The title text to display
  final String title;

  /// Optional description text below the title
  final String? description;

  /// Optional icon to display above the title
  final IconData? icon;

  /// Optional custom image widget instead of icon
  final Widget? image;

  /// Optional primary action button
  final Widget? action;

  /// Optional secondary action button
  final Widget? secondaryAction;

  /// Custom text style for the title
  final TextStyle? titleStyle;

  /// Custom text style for the description
  final TextStyle? descriptionStyle;

  /// Size of the icon (if used)
  final double iconSize;

  /// Spacing between elements
  final double spacing;

  /// Padding around the entire component
  final EdgeInsets padding;

  /// Alignment of the content
  final Alignment alignment;

  /// Maximum width constraint for the content
  final double? maxWidth;

  /// Creates an EmptyState component.
  ///
  /// The [title] parameter is required and displays the main message.
  /// Either [icon] or [image] can be provided, but not both.
  const EmptyState({
    super.key,
    required this.title,
    this.description,
    this.icon,
    this.image,
    this.action,
    this.secondaryAction,
    this.titleStyle,
    this.descriptionStyle,
    this.iconSize = 64.0,
    this.spacing = 16.0,
    this.padding = const EdgeInsets.all(24.0),
    this.alignment = Alignment.center,
    this.maxWidth = 400.0,
  }) : assert(!(icon != null && image != null), 'Cannot provide both icon and image');

  /// Creates a search empty state
  factory EmptyState.search({
    String title = 'No results found',
    String? description = 'Try adjusting your search terms or filters.',
    Widget? action,
  }) =>
      EmptyState(
        icon: Icons.search_off,
        title: title,
        description: description,
        action: action,
      );

  /// Creates a data empty state
  factory EmptyState.data({
    String title = 'No data available',
    String? description = 'There is no data to display at this time.',
    Widget? action,
  }) =>
      EmptyState(
        icon: Icons.inbox_outlined,
        title: title,
        description: description,
        action: action,
      );

  /// Creates an error empty state
  factory EmptyState.error({
    String title = 'Something went wrong',
    String? description = 'Unable to load content. Please try again.',
    Widget? action,
  }) =>
      EmptyState(
        icon: Icons.error_outline,
        title: title,
        description: description,
        action: action,
      );

  /// Creates a network error empty state
  factory EmptyState.network({
    String title = 'No internet connection',
    String? description = 'Check your connection and try again.',
    Widget? action,
  }) =>
      EmptyState(
        icon: Icons.wifi_off,
        title: title,
        description: description,
        action: action,
      );

  /// Creates a content loading empty state
  factory EmptyState.loading({
    String title = 'Loading...',
    String? description,
  }) =>
      EmptyState(
        icon: Icons.hourglass_empty,
        title: title,
        description: description,
      );

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final effectiveTitleStyle = titleStyle ??
        theme.textTheme.titleLarge?.copyWith(
          fontWeight: FontWeight.w600,
          color: theme.colorScheme.onSurface,
        );

    final effectiveDescriptionStyle = descriptionStyle ??
        theme.textTheme.bodyMedium?.copyWith(
          color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
        );

    final List<Widget> columnChildren = [];

    // Add image or icon
    if (image != null) {
      columnChildren.add(Center(child: image!));
    } else if (icon != null) {
      columnChildren.add(
        Icon(
          icon!,
          size: iconSize,
          color: theme.colorScheme.onSurface.withValues(alpha: 0.4),
          semanticLabel: 'Empty state icon',
        ),
      );
    }

    // Add title
    if (title.isNotEmpty) {
      if (columnChildren.isNotEmpty) {
        columnChildren.add(SizedBox(height: this.spacing));
      }
      columnChildren.add(
        Text(
          title,
          style: effectiveTitleStyle,
          textAlign: TextAlign.center,
        ),
      );
    }

    // Add description
    if (description != null && description!.isNotEmpty) {
      columnChildren.add(SizedBox(height: this.spacing / 2));
      columnChildren.add(
        Text(
          description!,
          style: effectiveDescriptionStyle,
          textAlign: TextAlign.center,
        ),
      );
    }

    // Add actions
    final actions = <Widget>[];
    if (action != null) actions.add(action!);
    if (secondaryAction != null) {
      if (actions.isNotEmpty) actions.add(SizedBox(width: this.spacing));
      actions.add(secondaryAction!);
    }

    if (actions.isNotEmpty) {
      columnChildren.add(SizedBox(height: this.spacing));
      columnChildren.add(
        Wrap(
          alignment: WrapAlignment.center,
          spacing: this.spacing / 2,
          runSpacing: this.spacing / 2,
          children: actions,
        ),
      );
    }

    Widget content = ConstrainedBox(
      constraints: BoxConstraints(
        maxWidth: maxWidth ?? double.infinity,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: columnChildren,
      ),
    );

    content = Semantics(
      container: true,
      liveRegion: true,
      label: title.isNotEmpty ? 'Empty state: $title' : 'Empty state',
      child: content,
    );

    return Align(
      alignment: alignment,
      child: Padding(
        padding: padding,
        child: content,
      ),
    );
  }
}