import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService {
  final SupabaseClient _supabase = Supabase.instance.client;

  // Get current user
  User? get currentUser => _supabase.auth.currentUser;

  // Get current session
  Session? get currentSession => _supabase.auth.currentSession;

  // Check if user is logged in
  bool get isLoggedIn => currentUser != null;

  // REGISTER (Sign Up)
  Future<AuthResponse> signUp({
    required String email,
    required String password,
    String? username,
  }) async {
    try {
      final response = await _supabase.auth.signUp(
        email: email,
        password: password,
        data: {
          'username': username ?? email.split('@')[0],
        },
      );

      if (response.user != null) {
        // Profile akan auto-created oleh trigger
        print('User created: ${response.user!.id}');
      }

      return response;
    } catch (e) {
      print('Sign up error: $e');
      rethrow;
    }
  }

  // LOGIN (Sign In)
  Future<AuthResponse> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );

      print('User logged in: ${response.user!.id}');
      return response;
    } catch (e) {
      print('Sign in error: $e');
      rethrow;
    }
  }

  // LOGOUT (Sign Out)
  Future<void> signOut() async {
    try {
      await _supabase.auth.signOut();
      print('User logged out');
    } catch (e) {
      print('Sign out error: $e');
      rethrow;
    }
  }

  // RESET PASSWORD
  Future<void> resetPassword(String email) async {
    try {
      await _supabase.auth.resetPasswordForEmail(email);
      print('Password reset email sent to: $email');
    } catch (e) {
      print('Reset password error: $e');
      rethrow;
    }
  }

  // UPDATE USER DATA
  Future<UserResponse> updateUser({
    String? email,
    String? password,
    Map<String, dynamic>? data,
  }) async {
    try {
      return await _supabase.auth.updateUser(
        UserAttributes(
          email: email,
          password: password,
          data: data,
        ),
      );
    } catch (e) {
      print('Update user error: $e');
      rethrow;
    }
  }

  // GET USER PROFILE
  Future<Map<String, dynamic>?> getUserProfile() async {
    try {
      final userId = currentUser?.id;
      if (userId == null) return null;

      final response = await _supabase
          .from('profiles')
          .select()
          .eq('id', userId)
          .single();

      return response;
    } catch (e) {
      print('Get profile error: $e');
      return null;
    }
  }

  // UPDATE USER PROFILE
  Future<void> updateProfile({
    String? username,
    String? fullName,
    String? avatarUrl,
  }) async {
    try {
      final userId = currentUser?.id;
      if (userId == null) throw Exception('User not logged in');

      await _supabase.from('profiles').update({
        if (username != null) 'username': username,
        if (fullName != null) 'full_name': fullName,
        if (avatarUrl != null) 'avatar_url': avatarUrl,
        'updated_at': DateTime.now().toIso8601String(),
      }).eq('id', userId);

      print('Profile updated');
    } catch (e) {
      print('Update profile error: $e');
      rethrow;
    }
  }
}