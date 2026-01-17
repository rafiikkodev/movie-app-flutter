import 'dart:io';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:template_project_flutter/app/core/utils/logger.dart';

class StorageService {
  final SupabaseClient _supabase = Supabase.instance.client;

  Future<String> uploadAvatar({
    required String userId,
    required File imageFile,
  }) async {
    try {
      final fileExt = imageFile.path.split('.').last;
      final fileName =
          '$userId-${DateTime.now().millisecondsSinceEpoch}.$fileExt';

      await _supabase.storage
          .from('avatars')
          .upload(
            fileName,
            imageFile,
            fileOptions: const FileOptions(cacheControl: '3600', upsert: true),
          );

      final publicUrl = _supabase.storage
          .from('avatars')
          .getPublicUrl(fileName);

      LoggerService.success('Avatar uploaded', publicUrl);
      return publicUrl;
    } catch (e) {
      LoggerService.error('Upload avatar error', e);
      rethrow;
    }
  }

  Future<void> deleteAvatar(String avatarUrl) async {
    try {
      final uri = Uri.parse(avatarUrl);
      final fileName = uri.pathSegments.last;
      await _supabase.storage.from('avatars').remove([fileName]);
      LoggerService.info('Avatar deleted', fileName);
    } catch (e) {
      LoggerService.error('Delete avatar error', e);
      rethrow;
    }
  }

  Future<String> updateAvatar({
    required String userId,
    required File newImageFile,
    String? oldAvatarUrl,
  }) async {
    try {
      if (oldAvatarUrl != null && oldAvatarUrl.isNotEmpty) {
        try {
          await deleteAvatar(oldAvatarUrl);
        } catch (e) {
          LoggerService.warning('Failed to delete old avatar', e);
        }
      }
      return await uploadAvatar(userId: userId, imageFile: newImageFile);
    } catch (e) {
      LoggerService.error('Update avatar error', e);
      rethrow;
    }
  }
}
