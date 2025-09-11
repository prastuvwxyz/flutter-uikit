import 'package:flutter/material.dart';
import '../../tokens/ui_tokens.dart';

/// LXCard - A flexible card component with header, body, and footer sections
/// 
/// This card follows Material Design patterns and provides a clean structure
/// for displaying content with optional header, body, and footer sections.
class LXCard extends StatelessWidget {
  /// Optional header widget (typically contains title and actions)
  final Widget? header;
  
  /// Main body content of the card
  final Widget? body;
  
  /// Optional footer widget (typically contains actions or additional info)
  final Widget? footer;
  
  /// Card background color (null for default white)
  final Color? backgroundColor;
  
  /// Whether to show a divider between sections
  final bool showDividers;
  
  /// Card elevation/shadow
  final double elevation;
  
  /// Custom padding for the entire card
  final EdgeInsets? padding;
  
  /// Optional tap handler
  final VoidCallback? onTap;

  const LXCard({
    super.key,
    this.header,
    this.body,
    this.footer,
    this.backgroundColor,
    this.showDividers = true,
    this.elevation = 0,
    this.padding,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final tokens = UiTokens.of(context);
    
    return Card(
      elevation: elevation,
      margin: EdgeInsets.zero,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          decoration: BoxDecoration(
            color: backgroundColor ?? Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: elevation == 0 ? [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.04),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ] : null,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header section
              if (header != null) ...[
                Padding(
                  padding: padding ?? const EdgeInsets.fromLTRB(24, 20, 24, 16),
                  child: header!,
                ),
                if (showDividers && body != null) 
                  Divider(
                    height: 1,
                    thickness: 1,
                    color: tokens.colorTokens.neutral.shade200,
                    indent: 24,
                    endIndent: 24,
                  ),
              ],
              
              // Body section
              if (body != null) ...[
                Padding(
                  padding: padding ?? EdgeInsets.fromLTRB(
                    24, 
                    header != null ? 16 : 20, 
                    24, 
                    footer != null ? 16 : 20
                  ),
                  child: body!,
                ),
                if (showDividers && footer != null)
                  Divider(
                    height: 1,
                    thickness: 1,
                    color: tokens.colorTokens.neutral.shade200,
                    indent: 24,
                    endIndent: 24,
                  ),
              ],
              
              // Footer section
              if (footer != null)
                Padding(
                  padding: padding ?? const EdgeInsets.fromLTRB(24, 16, 24, 20),
                  child: footer!,
                ),
            ],
          ),
        ),
      ),
    );
  }
}

/// LXCardHeader - Pre-built header component for LXCard
class LXCardHeader extends StatelessWidget {
  final String title;
  final String? subtitle;
  final Widget? leading;
  final Widget? trailing;
  final VoidCallback? onTap;

  const LXCardHeader({
    super.key,
    required this.title,
    this.subtitle,
    this.leading,
    this.trailing,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final tokens = UiTokens.of(context);
    
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Row(
        children: [
          if (leading != null) ...[
            leading!,
            const SizedBox(width: 12),
          ],
          
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: tokens.colorTokens.neutral.shade900,
                  ),
                ),
                if (subtitle != null) ...[
                  const SizedBox(height: 2),
                  Text(
                    subtitle!,
                    style: TextStyle(
                      fontSize: 14,
                      color: tokens.colorTokens.neutral.shade600,
                    ),
                  ),
                ],
              ],
            ),
          ),
          
          if (trailing != null) ...[
            const SizedBox(width: 12),
            trailing!,
          ],
        ],
      ),
    );
  }
}

/// LXCardFooter - Pre-built footer component for LXCard
class LXCardFooter extends StatelessWidget {
  final List<Widget> actions;
  final MainAxisAlignment alignment;

  const LXCardFooter({
    super.key,
    required this.actions,
    this.alignment = MainAxisAlignment.end,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: alignment,
      children: actions
          .expand((action) => [action, const SizedBox(width: 8)])
          .take(actions.length * 2 - 1)
          .toList(),
    );
  }
}