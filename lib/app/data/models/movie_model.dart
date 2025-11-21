import 'package:template_project_flutter/app/core/config/api_config.dart';

class MovieModel {
  final int id;
  final String title;
  final String overview;
  final String? posterPath;
  final String? backdropPath;
  final double voteAverage;
  final String releaseDate;
  final List<int> genreIds;

  MovieModel({
    required this.id,
    required this.title,
    required this.overview,
    this.posterPath,
    this.backdropPath,
    required this.voteAverage,
    required this.releaseDate,
    required this.genreIds,
  });

  factory MovieModel.fromJson(Map<String, dynamic> json) {
    return MovieModel(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      overview: json['overview'] ?? '',
      posterPath: json['poster_path'],
      backdropPath: json['backdrop_path'],
      voteAverage: (json['vote_average'] ?? 0).toDouble(),
      releaseDate: json['release_date'] ?? '',
      genreIds: List<int>.from(json['genre_ids'] ?? []),
    );
  }

  // Convert Model to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'overview': overview,
      'poster_path': posterPath,
      'backdrop_path': backdropPath,
      'vote_average': voteAverage,
      'release_date': releaseDate,
      'genre_ids': genreIds,
    };
  }

  // Helper untuk get image URL
  String get posterUrl => ApiConfig.getImageUrl(posterPath);
  String get backdropUrl => ApiConfig.getImageUrl(backdropPath);

  // Helper untuk format rating
  String get rating => voteAverage.toStringAsFixed(1);

  // Helper untuk format tahun
  String get year {
    if (releaseDate.isEmpty) return '';
    return releaseDate.split('-').first;
  }

  // Helper untuk get genre names
  String get genreNames {
    // Genre mapping dari TMDB
    const genreMap = {
      28: 'Action',
      12: 'Adventure',
      16: 'Animation',
      35: 'Comedy',
      80: 'Crime',
      99: 'Documentary',
      18: 'Drama',
      10751: 'Family',
      14: 'Fantasy',
      36: 'History',
      27: 'Horror',
      10402: 'Music',
      9648: 'Mystery',
      10749: 'Romance',
      878: 'Sci-Fi',
      10770: 'TV Movie',
      53: 'Thriller',
      10752: 'War',
      37: 'Western',
    };

    if (genreIds.isEmpty) return 'Unknown';

    // Ambil maksimal 2 genre pertama
    final genres = genreIds
        .take(2)
        .map((id) => genreMap[id] ?? 'Unknown')
        .where((name) => name != 'Unknown')
        .toList();

    return genres.isEmpty ? 'Unknown' : genres.join(' • ');
  }
}

// Response wrapper untuk list movies
class MovieListResponse {
  final int page;
  final List<MovieModel> results;
  final int totalPages;
  final int totalResults;

  MovieListResponse({
    required this.page,
    required this.results,
    required this.totalPages,
    required this.totalResults,
  });

  factory MovieListResponse.fromJson(Map<String, dynamic> json) {
    return MovieListResponse(
      page: json['page'] ?? 1,
      results: (json['results'] as List)
          .map((movie) => MovieModel.fromJson(movie))
          .toList(),
      totalPages: json['total_pages'] ?? 0,
      totalResults: json['total_results'] ?? 0,
    );
  }
}
