import 'dart:io';
import 'package:supabase_flutter/supabase_flutter.dart';

class StorageService {
  final SupabaseClient _supabase = Supabase.instance.client;

  // Upload avatar to Supabase Storage
  Future<String> uploadAvatar({
    required String userId,
    required File imageFile,
  }) async {
    try {
      // Generate unique filename dengan user ID + timestamp
      final fileExt = imageFile.path.split('.').last;
      final fileName =
          '$userId-${DateTime.now().millisecondsSinceEpoch}.$fileExt';
      final filePath = fileName;

      // Upload ke bucket 'avatars'
      await _supabase.storage
          .from('avatars')
          .upload(
            filePath,
            imageFile,
            fileOptions: const FileOptions(
              cacheControl: '3600',
              upsert: true, // Replace if exists
            ),
          );

      // Get public URL
      final publicUrl = _supabase.storage
          .from('avatars')
          .getPublicUrl(filePath);

      print('Avatar uploaded successfully: $publicUrl');
      return publicUrl;
    } catch (e) {
      print('Upload avatar error: $e');
      rethrow;
    }
  }

  // Delete avatar from Supabase Storage
  Future<void> deleteAvatar(String avatarUrl) async {
    try {
      // Extract filename from URL
      final uri = Uri.parse(avatarUrl);
      final fileName = uri.pathSegments.last;

      await _supabase.storage.from('avatars').remove([fileName]);
      print('Avatar deleted: $fileName');
    } catch (e) {
      print('Delete avatar error: $e');
      rethrow;
    }
  }

  // Update avatar (delete old, upload new)
  Future<String> updateAvatar({
    required String userId,
    required File newImageFile,
    String? oldAvatarUrl,
  }) async {
    try {
      // Delete old avatar if exists
      if (oldAvatarUrl != null && oldAvatarUrl.isNotEmpty) {
        try {
          await deleteAvatar(oldAvatarUrl);
        } catch (e) {
          print('Warning: Failed to delete old avatar: $e');
          // Continue even if delete fails
        }
      }

      // Upload new avatar
      return await uploadAvatar(userId: userId, imageFile: newImageFile);
    } catch (e) {
      print('Update avatar error: $e');
      rethrow;
    }
  }
}
