import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:template_project_flutter/app/core/utils/logger.dart';

class AuthService {
  final SupabaseClient _supabase = Supabase.instance.client;

  User? get currentUser => _supabase.auth.currentUser;
  Session? get currentSession => _supabase.auth.currentSession;
  bool get isLoggedIn => currentUser != null;

  Future<AuthResponse> signUp({
    required String email,
    required String password,
    String? username,
    String? avatarUrl,
  }) async {
    try {
      final response = await _supabase.auth.signUp(
        email: email,
        password: password,
        data: {'username': username ?? email.split('@')[0]},
      );

      if (response.user != null) {
        final userId = response.user!.id;
        final userName = username ?? email.split('@')[0];

        LoggerService.success('User created', userId);

        try {
          await _createProfileIfNotExists(
            userId: userId,
            email: email,
            username: userName,
            avatarUrl: avatarUrl,
          );
          LoggerService.success('Profile created', userId);
        } catch (profileError) {
          if (profileError.toString().contains('duplicate') ||
              profileError.toString().contains('23505')) {
            LoggerService.info('Profile already exists (trigger)');
          } else {
            LoggerService.warning('Failed to create profile', profileError);
          }
        }
      }

      return response;
    } catch (e) {
      LoggerService.error('Sign up error', e);
      rethrow;
    }
  }

  Future<void> _createProfileIfNotExists({
    required String userId,
    required String email,
    required String username,
    String? avatarUrl,
  }) async {
    // Optimized: select only 'id' field for check
    final existingProfile = await _supabase
        .from('profiles')
        .select('id')
        .eq('id', userId)
        .maybeSingle();

    if (existingProfile == null) {
      await _supabase.from('profiles').insert({
        'id': userId,
        'email': email,
        'username': username,
        if (avatarUrl != null) 'avatar_url': avatarUrl,
        'created_at': DateTime.now().toIso8601String(),
        'updated_at': DateTime.now().toIso8601String(),
      });
    }
  }

  Future<AuthResponse> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );
      LoggerService.success('User logged in', response.user!.id);
      return response;
    } catch (e) {
      LoggerService.error('Sign in error', e);
      rethrow;
    }
  }

  Future<void> signOut() async {
    try {
      await _supabase.auth.signOut();
      LoggerService.info('User logged out');
    } catch (e) {
      LoggerService.error('Sign out error', e);
      rethrow;
    }
  }

  Future<void> resetPassword(String email) async {
    try {
      await _supabase.auth.resetPasswordForEmail(email);
      LoggerService.info('Password reset email sent', email);
    } catch (e) {
      LoggerService.error('Reset password error', e);
      rethrow;
    }
  }

  Future<UserResponse> updateUser({
    String? email,
    String? password,
    Map<String, dynamic>? data,
  }) async {
    try {
      return await _supabase.auth.updateUser(
        UserAttributes(email: email, password: password, data: data),
      );
    } catch (e) {
      LoggerService.error('Update user error', e);
      rethrow;
    }
  }

  // Optimized: select only required fields
  Future<Map<String, dynamic>?> getUserProfile() async {
    try {
      final userId = currentUser?.id;
      if (userId == null) return null;

      final response = await _supabase
          .from('profiles')
          .select('username, full_name, email, avatar_url')
          .eq('id', userId)
          .single();

      return response;
    } catch (e) {
      LoggerService.error('Get profile error', e);
      return null;
    }
  }

  Future<void> updateProfile({
    String? username,
    String? fullName,
    String? avatarUrl,
  }) async {
    try {
      final userId = currentUser?.id;
      if (userId == null) throw Exception('User not logged in');

      await _supabase
          .from('profiles')
          .update({
            if (username != null) 'username': username,
            if (fullName != null) 'full_name': fullName,
            if (avatarUrl != null) 'avatar_url': avatarUrl,
            'updated_at': DateTime.now().toIso8601String(),
          })
          .eq('id', userId);

      LoggerService.success('Profile updated');
    } catch (e) {
      LoggerService.error('Update profile error', e);
      rethrow;
    }
  }
}
