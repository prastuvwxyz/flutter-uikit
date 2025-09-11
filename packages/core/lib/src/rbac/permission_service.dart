import 'rbac_models.dart';

/// Permission service for role-based access control
class PermissionService {
  final List<Role> _roles = [];

  /// Check if user has permission for a specific action
  bool hasPermission(List<String> userRoles, String resource, String action) {
    for (final roleName in userRoles) {
      final role = _roles.firstWhere(
        (r) => r.name == roleName,
        orElse: () => const Role(name: '', permissions: []),
      );

      for (final permission in role.permissions) {
        if (permission.resource == resource && permission.action == action) {
          return true;
        }
      }
    }
    return false;
  }

  /// Add a role to the system
  void addRole(Role role) {
    _roles.add(role);
  }

  /// Get all roles
  List<Role> get roles => List.unmodifiable(_roles);
}
