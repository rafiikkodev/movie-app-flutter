// Repository untuk Cast & Crew - mengelola data dari provider

import 'package:template_project_flutter/app/data/models/cast_crew_model.dart';
import 'package:template_project_flutter/app/data/providers/cast_crew_provider.dart';

class CastCrewRepository {
  final CastCrewProvider _provider = CastCrewProvider();

  // Get Movie Credits
  Future<MovieCreditsResponse> getMovieCredits(int movieId) async {
    try {
      return await _provider.getMovieCredits(movieId);
    } catch (e) {
      rethrow;
    }
  }

  // Get Top Cast (limit default 10)
  Future<List<CastModel>> getTopCast(int movieId, {int limit = 10}) async {
    try {
      final credits = await _provider.getMovieCredits(movieId);
      return credits.getTopCast(limit);
    } catch (e) {
      rethrow;
    }
  }

  // Get Directors
  Future<List<CrewModel>> getDirectors(int movieId) async {
    try {
      final credits = await _provider.getMovieCredits(movieId);
      return credits.directors;
    } catch (e) {
      rethrow;
    }
  }

  // Get All Crew
  Future<List<CrewModel>> getCrew(int movieId) async {
    try {
      final credits = await _provider.getMovieCredits(movieId);
      return credits.crew;
    } catch (e) {
      rethrow;
    }
  }
}
