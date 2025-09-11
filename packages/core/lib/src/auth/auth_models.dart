/// Authentication models for the core package
class User {
  final String id;
  final String email;
  final String? name;
  final List<String> roles;
  final Map<String, dynamic> metadata;

  const User({
    required this.id,
    required this.email,
    this.name,
    required this.roles,
    this.metadata = const {},
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as String,
      email: json['email'] as String,
      name: json['name'] as String?,
      roles: List<String>.from(json['roles'] ?? []),
      metadata: Map<String, dynamic>.from(json['metadata'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'roles': roles,
      'metadata': metadata,
    };
  }

  User copyWith({
    String? id,
    String? email,
    String? name,
    List<String>? roles,
    Map<String, dynamic>? metadata,
  }) {
    return User(
      id: id ?? this.id,
      email: email ?? this.email,
      name: name ?? this.name,
      roles: roles ?? this.roles,
      metadata: metadata ?? this.metadata,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is User &&
        other.id == id &&
        other.email == email &&
        other.name == name;
  }

  @override
  int get hashCode => Object.hash(id, email, name);
}

/// Authentication token model
class AuthToken {
  final String accessToken;
  final String? refreshToken;
  final DateTime expiresAt;
  final String tokenType;

  const AuthToken({
    required this.accessToken,
    this.refreshToken,
    required this.expiresAt,
    this.tokenType = 'Bearer',
  });

  factory AuthToken.fromJson(Map<String, dynamic> json) {
    return AuthToken(
      accessToken: json['access_token'] as String,
      refreshToken: json['refresh_token'] as String?,
      expiresAt: DateTime.fromMillisecondsSinceEpoch(
        (json['expires_at'] as int) * 1000,
      ),
      tokenType: json['token_type'] as String? ?? 'Bearer',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'access_token': accessToken,
      'refresh_token': refreshToken,
      'expires_at': expiresAt.millisecondsSinceEpoch ~/ 1000,
      'token_type': tokenType,
    };
  }

  bool get isExpired => DateTime.now().isAfter(expiresAt);
  bool get isValid => !isExpired;
}

/// Authentication state
enum AuthState { initial, authenticated, unauthenticated, loading, error }

/// Authentication result
class AuthResult {
  final bool success;
  final User? user;
  final AuthToken? token;
  final String? error;

  const AuthResult({required this.success, this.user, this.token, this.error});

  const AuthResult.success({required this.user, required this.token})
    : success = true,
      error = null;

  const AuthResult.failure({required this.error})
    : success = false,
      user = null,
      token = null;
}
