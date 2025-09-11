import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'auth_models.dart';

/// Authentication service interface
abstract class AuthService extends ChangeNotifier {
  User? get currentUser;
  AuthToken? get currentToken;
  AuthState get state;

  Future<AuthResult> signIn({required String email, required String password});

  Future<AuthResult> signInWithOAuth(String provider);

  Future<AuthResult> refreshToken();

  Future<void> signOut();

  Future<bool> isAuthenticated();
}

/// OAuth2 implementation of AuthService
class OAuth2AuthService extends AuthService {
  User? _currentUser;
  AuthToken? _currentToken;
  AuthState _state = AuthState.initial;

  static const String _userKey = 'auth_user';
  static const String _tokenKey = 'auth_token';

  @override
  User? get currentUser => _currentUser;

  @override
  AuthToken? get currentToken => _currentToken;

  @override
  AuthState get state => _state;

  /// Initialize the auth service and check for existing session
  Future<void> initialize() async {
    _setState(AuthState.loading);

    try {
      final prefs = await SharedPreferences.getInstance();

      // Load stored user and token
      final userJson = prefs.getString(_userKey);
      final tokenJson = prefs.getString(_tokenKey);

      if (userJson != null && tokenJson != null) {
        _currentUser = User.fromJson(_parseJson(userJson));
        _currentToken = AuthToken.fromJson(_parseJson(tokenJson));

        // Check if token is still valid
        if (_currentToken!.isValid) {
          _setState(AuthState.authenticated);
        } else {
          // Try to refresh token
          final result = await refreshToken();
          if (!result.success) {
            await _clearSession();
            _setState(AuthState.unauthenticated);
          }
        }
      } else {
        _setState(AuthState.unauthenticated);
      }
    } catch (e) {
      debugPrint('Auth initialization error: $e');
      _setState(AuthState.unauthenticated);
    }
  }

  @override
  Future<AuthResult> signIn({
    required String email,
    required String password,
  }) async {
    _setState(AuthState.loading);

    try {
      // TODO: Implement actual OAuth2 flow
      // This is a mock implementation
      await Future.delayed(const Duration(seconds: 1));

      // Mock authentication
      if (email.isNotEmpty && password.isNotEmpty) {
        final user = User(
          id: 'user_123',
          email: email,
          name: 'Test User',
          roles: ['fleet_manager'],
        );

        final token = AuthToken(
          accessToken: 'mock_access_token',
          refreshToken: 'mock_refresh_token',
          expiresAt: DateTime.now().add(const Duration(hours: 1)),
        );

        await _saveSession(user, token);
        _currentUser = user;
        _currentToken = token;
        _setState(AuthState.authenticated);

        return AuthResult.success(user: user, token: token);
      } else {
        _setState(AuthState.unauthenticated);
        return const AuthResult.failure(error: 'Invalid credentials');
      }
    } catch (e) {
      _setState(AuthState.error);
      return AuthResult.failure(error: e.toString());
    }
  }

  @override
  Future<AuthResult> signInWithOAuth(String provider) async {
    _setState(AuthState.loading);

    try {
      // TODO: Implement OAuth2 provider flow (Google, Microsoft, etc.)
      await Future.delayed(const Duration(seconds: 2));

      _setState(AuthState.unauthenticated);
      return const AuthResult.failure(error: 'OAuth not implemented yet');
    } catch (e) {
      _setState(AuthState.error);
      return AuthResult.failure(error: e.toString());
    }
  }

  @override
  Future<AuthResult> refreshToken() async {
    if (_currentToken?.refreshToken == null) {
      return const AuthResult.failure(error: 'No refresh token available');
    }

    try {
      // TODO: Implement actual token refresh
      await Future.delayed(const Duration(milliseconds: 500));

      final newToken = AuthToken(
        accessToken: 'new_mock_access_token',
        refreshToken: _currentToken!.refreshToken,
        expiresAt: DateTime.now().add(const Duration(hours: 1)),
      );

      await _saveToken(newToken);
      _currentToken = newToken;
      _setState(AuthState.authenticated);

      return AuthResult.success(user: _currentUser!, token: newToken);
    } catch (e) {
      return AuthResult.failure(error: e.toString());
    }
  }

  @override
  Future<void> signOut() async {
    await _clearSession();
    _currentUser = null;
    _currentToken = null;
    _setState(AuthState.unauthenticated);
  }

  @override
  Future<bool> isAuthenticated() async {
    return _currentUser != null &&
        _currentToken != null &&
        _currentToken!.isValid;
  }

  void _setState(AuthState newState) {
    _state = newState;
    notifyListeners();
  }

  Future<void> _saveSession(User user, AuthToken token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userKey, _stringifyJson(user.toJson()));
    await prefs.setString(_tokenKey, _stringifyJson(token.toJson()));
  }

  Future<void> _saveToken(AuthToken token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, _stringifyJson(token.toJson()));
  }

  Future<void> _clearSession() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_userKey);
    await prefs.remove(_tokenKey);
  }

  Map<String, dynamic> _parseJson(String json) {
    // In a real implementation, use dart:convert
    // For now, this is a placeholder
    return <String, dynamic>{};
  }

  String _stringifyJson(Map<String, dynamic> json) {
    // In a real implementation, use dart:convert
    // For now, this is a placeholder
    return '';
  }
}
