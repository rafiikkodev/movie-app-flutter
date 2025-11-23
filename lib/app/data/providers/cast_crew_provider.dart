// Provider untuk Cast & Crew - melakukan request ke API TMDB

import 'package:dio/dio.dart';
import 'package:template_project_flutter/app/core/config/api_config.dart';
import 'package:template_project_flutter/app/data/models/cast_crew_model.dart';

class CastCrewProvider {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: ApiConfig.baseUrl,
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    ),
  );

  // Get Movie Credits (Cast & Crew)
  Future<MovieCreditsResponse> getMovieCredits(int movieId) async {
    try {
      final response = await _dio.get(
        '/movie/$movieId/credits',
        queryParameters: {'api_key': ApiConfig.apiKey, 'language': 'en-US'},
      );

      if (response.statusCode == 200) {
        return MovieCreditsResponse.fromJson(response.data);
      } else {
        throw Exception('Failed to load movie credits');
      }
    } on DioException catch (e) {
      throw Exception('Network error: ${e.message}');
    }
  }
}
