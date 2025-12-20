import 'package:template_project_flutter/app/core/config/api_config.dart';

class ActorDetailModel {
  final bool adult;
  final List<String> alsoKnownAs;
  final String biography;
  final String birthday;
  final String? deathday;
  final int gender;
  final String? homepage;
  final int id;
  final String imdbId;
  final String knownForDepartment;
  final String name;
  final String placeOfBirth;
  final double popularity;
  final String? profilePath;

  ActorDetailModel({
    required this.adult,
    required this.alsoKnownAs,
    required this.biography,
    required this.birthday,
    this.deathday,
    required this.gender,
    this.homepage,
    required this.id,
    required this.imdbId,
    required this.knownForDepartment,
    required this.name,
    required this.placeOfBirth,
    required this.popularity,
    this.profilePath,
  });

  factory ActorDetailModel.fromJson(Map<String, dynamic> json) {
    return ActorDetailModel(
      adult: json['adult'] ?? false,
      alsoKnownAs: List<String>.from(json['also_known_as'] ?? []),
      biography: json['biography'] ?? '',
      birthday: json['birthday'] ?? '',
      deathday: json['deathday'],
      gender: json['gender'] ?? 0,
      homepage: json['homepage'],
      id: json['id'] ?? 0,
      imdbId: json['imdb_id'] ?? '',
      knownForDepartment: json['known_for_department'] ?? '',
      name: json['name'] ?? '',
      placeOfBirth: json['place_of_birth'] ?? '',
      popularity: (json['popularity'] ?? 0).toDouble(),
      profilePath: json['profile_path'],
    );
  }

  String get profileUrl => ApiConfig.getImageUrl(profilePath);

  bool get hasProfile => profilePath != null && profilePath!.isNotEmpty;

  String get genderString {
    switch (gender) {
      case 1:
        return 'Female';
      case 2:
        return 'Male';
      case 3:
        return 'Non-binary';
      default:
        return 'Not specified';
    }
  }

  String get age {
    if (birthday.isEmpty) return 'N/A';

    try {
      final birthDate = DateTime.parse(birthday);
      final endDate = deathday != null
          ? DateTime.parse(deathday!)
          : DateTime.now();
      final age = endDate.year - birthDate.year;

      if (deathday != null) {
        return '$age (deceased)';
      }
      return '$age years old';
    } catch (e) {
      return 'N/A';
    }
  }

  String get birthYear {
    if (birthday.isEmpty) return 'N/A';
    try {
      final birthDate = DateTime.parse(birthday);
      return birthDate.year.toString();
    } catch (e) {
      return 'N/A';
    }
  }
}

class ActorMovieCredit {
  final int id;
  final String title;
  final String? posterPath;
  final String? character;
  final String? releaseDate;
  final double voteAverage;

  ActorMovieCredit({
    required this.id,
    required this.title,
    this.posterPath,
    this.character,
    this.releaseDate,
    required this.voteAverage,
  });

  factory ActorMovieCredit.fromJson(Map<String, dynamic> json) {
    return ActorMovieCredit(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      posterPath: json['poster_path'],
      character: json['character'],
      releaseDate: json['release_date'],
      voteAverage: (json['vote_average'] ?? 0).toDouble(),
    );
  }

  String get posterUrl => ApiConfig.getImageUrl(posterPath);

  bool get hasPoster => posterPath != null && posterPath!.isNotEmpty;

  String get year {
    if (releaseDate == null || releaseDate!.isEmpty) return 'N/A';
    try {
      final date = DateTime.parse(releaseDate!);
      return date.year.toString();
    } catch (e) {
      return 'N/A';
    }
  }

  String get rating => voteAverage.toStringAsFixed(1);
}

class SearchResult {
  final String mediaType; // 'movie' or 'person'
  final int id;
  final String title;
  final String? posterPath;
  final double? voteAverage;
  final String? releaseDate;

  // For person
  final String? name;
  final String? profilePath;
  final String? knownForDepartment;

  SearchResult({
    required this.mediaType,
    required this.id,
    this.title = '',
    this.posterPath,
    this.voteAverage,
    this.releaseDate,
    this.name,
    this.profilePath,
    this.knownForDepartment,
  });

  factory SearchResult.fromJson(Map<String, dynamic> json) {
    final mediaType = json['media_type'] ?? 'movie';

    return SearchResult(
      mediaType: mediaType,
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      posterPath: json['poster_path'],
      voteAverage: (json['vote_average'] ?? 0).toDouble(),
      releaseDate: json['release_date'],
      name: json['name'],
      profilePath: json['profile_path'],
      knownForDepartment: json['known_for_department'],
    );
  }

  bool get isMovie => mediaType == 'movie';
  bool get isPerson => mediaType == 'person';

  String get imageUrl => isMovie
      ? ApiConfig.getImageUrl(posterPath)
      : ApiConfig.getImageUrl(profilePath);

  String get displayTitle => isMovie ? title : (name ?? '');

  String get year {
    if (releaseDate == null || releaseDate!.isEmpty) return '';
    try {
      final date = DateTime.parse(releaseDate!);
      return date.year.toString();
    } catch (e) {
      return '';
    }
  }
}
