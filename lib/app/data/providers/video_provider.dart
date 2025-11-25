import 'package:dio/dio.dart';
import 'package:template_project_flutter/app/core/config/api_config.dart';
import 'package:template_project_flutter/app/data/models/video_model.dart';

class VideoProvider {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: ApiConfig.baseUrl,
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
    ),
  );

  /// Get movie videos (trailers, teasers, etc.)
  Future<MovieVideosResponse> getMovieVideos(int movieId) async {
    try {
      final response = await _dio.get(
        '/movie/$movieId/videos',
        queryParameters: {'api_key': ApiConfig.apiKey, 'language': 'en-US'},
      );

      return MovieVideosResponse.fromJson(response.data);
    } catch (e) {
      throw Exception('Failed to load movie videos: $e');
    }
  }
}
