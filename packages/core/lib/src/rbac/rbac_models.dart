/// RBAC models for permission management
class Permission {
  final String name;
  final String resource;
  final String action;

  const Permission({
    required this.name,
    required this.resource,
    required this.action,
  });
}

class Role {
  final String name;
  final List<Permission> permissions;

  const Role({required this.name, required this.permissions});
}
