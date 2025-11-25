import 'package:template_project_flutter/app/data/models/video_model.dart';
import 'package:template_project_flutter/app/data/providers/video_provider.dart';

class VideoRepository {
  final VideoProvider _provider = VideoProvider();

  /// Get all videos for a movie
  Future<MovieVideosResponse> getMovieVideos(int movieId) async {
    return await _provider.getMovieVideos(movieId);
  }

  /// Get only trailers for a movie
  Future<List<VideoModel>> getMovieTrailers(int movieId) async {
    final response = await _provider.getMovieVideos(movieId);
    return response.getTrailers();
  }

  /// Get official trailers for a movie
  Future<List<VideoModel>> getOfficialTrailers(int movieId) async {
    final response = await _provider.getMovieVideos(movieId);
    return response.getOfficialTrailers();
  }
}
