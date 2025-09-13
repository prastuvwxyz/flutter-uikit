import 'package:flutter/material.dart';
import 'package:tokens/tokens.dart' as tokens;

/// Header action configuration
class HeaderAction {
  final IconData icon;
  final String? tooltip;
  final VoidCallback? onPressed;
  final Widget? badge;

  const HeaderAction({
    required this.icon,
    this.tooltip,
    this.onPressed,
    this.badge,
  });
}

/// User profile menu item
class UserProfileMenuItem {
  final IconData icon;
  final String label;
  final VoidCallback? onTap;
  final Color? color;

  const UserProfileMenuItem({
    required this.icon,
    required this.label,
    this.onTap,
    this.color,
  });
}

/// User profile configuration for header
class UserProfile {
  final String? displayName;
  final String? email;
  final String? role;
  final Widget? avatar;
  final VoidCallback? onTap;
  final List<UserProfileMenuItem>? menuItems;

  const UserProfile({
    this.displayName,
    this.email,
    this.role,
    this.avatar,
    this.onTap,
    this.menuItems,
  });
}

/// A reusable app header component
class Header extends StatelessWidget {
  final String currentRoute;
  final bool isDesktop;
  final List<HeaderAction>? headerActions;
  final UserProfile? userProfile;
  final Widget? customTitle;
  final String? title;
  final Map<String, String>? routeTitleMap;
  final Widget? leading;

  const Header({
    super.key,
    required this.currentRoute,
    this.isDesktop = true,
    this.headerActions,
    this.userProfile,
    this.customTitle,
    this.title,
    this.routeTitleMap,
    this.leading,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = tokens.Spacing.of(context);

    return Container(
      height: 64,
      padding: EdgeInsets.symmetric(horizontal: spacing.lg),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        border: Border(
          bottom: BorderSide(
            color: theme.colorScheme.outline.withValues(alpha: 0.12),
            width: 1,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.shadow.withValues(alpha: 0.02),
            offset: const Offset(0, 1),
            blurRadius: 3,
          ),
        ],
      ),
      child: Row(
        children: [
          // Leading widget (mobile menu button, etc.)
          if (leading != null)
            leading!
          else if (!isDesktop)
            Builder(
              builder: (context) => IconButton(
                icon: const Icon(Icons.menu),
                onPressed: () => Scaffold.of(context).openDrawer(),
                tooltip: 'Open menu',
              ),
            ),

          const Spacer(),

          // Header Actions
          if (headerActions != null)
            ..._buildHeaderActions(context, spacing)
          else
            ..._buildDefaultActions(context, spacing),
        ],
      ),
    );
  }

  List<Widget> _buildHeaderActions(
    BuildContext context,
    tokens.Spacing spacing,
  ) {
    return headerActions!.map((action) {
      return Padding(
        padding: EdgeInsets.only(left: spacing.xs),
        child: action.badge != null
            ? Stack(
                children: [
                  IconButton(
                    onPressed: action.onPressed,
                    icon: Icon(
                      action.icon,
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                    tooltip: action.tooltip,
                  ),
                  Positioned(right: 6, top: 6, child: action.badge!),
                ],
              )
            : IconButton(
                onPressed: action.onPressed,
                icon: Icon(
                  action.icon,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
                tooltip: action.tooltip,
              ),
      );
    }).toList();
  }

  List<Widget> _buildDefaultActions(
    BuildContext context,
    tokens.Spacing spacing,
  ) {
    final theme = Theme.of(context);

    return [
      IconButton(
        onPressed: () {
          // TODO: Implement notifications
        },
        icon: Icon(
          Icons.notifications_outlined,
          color: theme.colorScheme.onSurfaceVariant,
        ),
        tooltip: 'Notifications',
      ),
      SizedBox(width: spacing.xs),
      IconButton(
        onPressed: () {
          // TODO: Implement search
        },
        icon: Icon(Icons.search, color: theme.colorScheme.onSurfaceVariant),
        tooltip: 'Search',
      ),
      SizedBox(width: spacing.md),

      // User Profile
      _buildUserProfile(context, spacing),
    ];
  }

  Widget _buildUserProfile(BuildContext context, tokens.Spacing spacing) {
    final theme = Theme.of(context);
    final profile = userProfile ?? const UserProfile(displayName: 'Admin User');

    Widget profileWidget = Container(
      padding: EdgeInsets.symmetric(
        horizontal: spacing.sm,
        vertical: spacing.xs / 2,
      ),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          profile.avatar ??
              CircleAvatar(
                radius: 16,
                backgroundColor: theme.colorScheme.primary,
                child: Icon(
                  Icons.person,
                  color: theme.colorScheme.onPrimary,
                  size: 18,
                ),
              ),
          if (profile.displayName != null) ...[
            SizedBox(width: spacing.xs),
            Text(
              profile.displayName!,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w500,
                color: theme.colorScheme.onSurface,
              ),
            ),
            SizedBox(width: spacing.xs / 2),
            Icon(
              Icons.keyboard_arrow_down,
              size: 16,
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ],
        ],
      ),
    );

    // If there are menu items, wrap with PopupMenuButton
    if (profile.menuItems != null && profile.menuItems!.isNotEmpty) {
      return PopupMenuButton<String>(
        offset: const Offset(0, 50),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: profileWidget,
        itemBuilder: (context) {
          List<PopupMenuEntry<String>> items = [];

          // Add user info section if email or role is provided
          if (profile.email != null || profile.role != null) {
            items.add(
              PopupMenuItem<String>(
                enabled: false,
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          profile.avatar ??
                              CircleAvatar(
                                radius: 20,
                                backgroundColor: theme.colorScheme.primary,
                                child: Icon(
                                  Icons.person,
                                  color: theme.colorScheme.onPrimary,
                                  size: 20,
                                ),
                              ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                if (profile.displayName != null)
                                  Text(
                                    profile.displayName!,
                                    style: theme.textTheme.titleSmall?.copyWith(
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                if (profile.email != null)
                                  Text(
                                    profile.email!,
                                    style: theme.textTheme.bodySmall?.copyWith(
                                      color: theme.colorScheme.onSurfaceVariant,
                                    ),
                                  ),
                                if (profile.role != null)
                                  Text(
                                    profile.role!,
                                    style: theme.textTheme.bodySmall?.copyWith(
                                      color: theme.colorScheme.primary,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
            items.add(const PopupMenuDivider());
          }

          // Add menu items
          for (int i = 0; i < profile.menuItems!.length; i++) {
            final item = profile.menuItems![i];
            items.add(
              PopupMenuItem<String>(
                value: i.toString(),
                child: ListTile(
                  leading: Icon(
                    item.icon,
                    color: item.color ?? theme.colorScheme.onSurface,
                  ),
                  title: Text(
                    item.label,
                    style: TextStyle(
                      color: item.color ?? theme.colorScheme.onSurface,
                    ),
                  ),
                  contentPadding: EdgeInsets.zero,
                ),
              ),
            );
          }

          return items;
        },
        onSelected: (value) {
          final index = int.tryParse(value);
          if (index != null &&
              index >= 0 &&
              index < profile.menuItems!.length) {
            profile.menuItems![index].onTap?.call();
          }
        },
      );
    }

    // Fallback to simple InkWell if no menu items
    return InkWell(
      onTap: profile.onTap,
      borderRadius: BorderRadius.circular(20),
      child: profileWidget,
    );
  }
}
