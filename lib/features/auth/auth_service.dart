import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService {
  AuthService(this._supabase);

  final SupabaseClient _supabase;

  User? get currentUser => _supabase.auth.currentUser;

  Stream<AuthState> get authStateChanges =>
      _supabase.auth.onAuthStateChange;

  Future<AuthResponse> register({
    required String email,
    required String password,
    required String username,
    required String displayName,
  }) {
    return _supabase.auth.signUp(
      email: email,
      password: password,
      data: {
        'username': username,
        'display_name': displayName,
      },
    );
  }

  Future<AuthResponse> login({
    required String email,
    required String password,
  }) {
    return _supabase.auth.signInWithPassword(
      email: email,
      password: password,
    );
  }

  Future<void> logout() {
    return _supabase.auth.signOut();
  }
}