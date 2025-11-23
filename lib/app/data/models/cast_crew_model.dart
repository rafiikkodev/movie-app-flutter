import 'package:template_project_flutter/app/core/config/api_config.dart';

// Model untuk Cast (Pemeran)
class CastModel {
  final bool adult;
  final int? gender;
  final int id;
  final String knownForDepartment;
  final String name;
  final String originalName;
  final double popularity;
  final String? profilePath;
  final int castId;
  final String character;
  final String creditId;
  final int order;

  CastModel({
    required this.adult,
    this.gender,
    required this.id,
    required this.knownForDepartment,
    required this.name,
    required this.originalName,
    required this.popularity,
    this.profilePath,
    required this.castId,
    required this.character,
    required this.creditId,
    required this.order,
  });

  factory CastModel.fromJson(Map<String, dynamic> json) {
    return CastModel(
      adult: json['adult'] ?? false,
      gender: json['gender'],
      id: json['id'] ?? 0,
      knownForDepartment: json['known_for_department'] ?? '',
      name: json['name'] ?? '',
      originalName: json['original_name'] ?? '',
      popularity: (json['popularity'] ?? 0).toDouble(),
      profilePath: json['profile_path'],
      castId: json['cast_id'] ?? 0,
      character: json['character'] ?? '',
      creditId: json['credit_id'] ?? '',
      order: json['order'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'adult': adult,
      'gender': gender,
      'id': id,
      'known_for_department': knownForDepartment,
      'name': name,
      'original_name': originalName,
      'popularity': popularity,
      'profile_path': profilePath,
      'cast_id': castId,
      'character': character,
      'credit_id': creditId,
      'order': order,
    };
  }

  // Helper untuk get profile image URL
  String get profileUrl => ApiConfig.getImageUrl(profilePath);

  // Helper untuk format gender
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

  // Helper untuk check apakah punya foto
  bool get hasProfile => profilePath != null && profilePath!.isNotEmpty;
}

// Model untuk Crew (Kru)
class CrewModel {
  final bool adult;
  final int? gender;
  final int id;
  final String knownForDepartment;
  final String name;
  final String originalName;
  final double popularity;
  final String? profilePath;
  final String creditId;
  final String department;
  final String job;

  CrewModel({
    required this.adult,
    this.gender,
    required this.id,
    required this.knownForDepartment,
    required this.name,
    required this.originalName,
    required this.popularity,
    this.profilePath,
    required this.creditId,
    required this.department,
    required this.job,
  });

  factory CrewModel.fromJson(Map<String, dynamic> json) {
    return CrewModel(
      adult: json['adult'] ?? false,
      gender: json['gender'],
      id: json['id'] ?? 0,
      knownForDepartment: json['known_for_department'] ?? '',
      name: json['name'] ?? '',
      originalName: json['original_name'] ?? '',
      popularity: (json['popularity'] ?? 0).toDouble(),
      profilePath: json['profile_path'],
      creditId: json['credit_id'] ?? '',
      department: json['department'] ?? '',
      job: json['job'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'adult': adult,
      'gender': gender,
      'id': id,
      'known_for_department': knownForDepartment,
      'name': name,
      'original_name': originalName,
      'popularity': popularity,
      'profile_path': profilePath,
      'credit_id': creditId,
      'department': department,
      'job': job,
    };
  }

  // Helper untuk get profile image URL
  String get profileUrl => ApiConfig.getImageUrl(profilePath);

  // Helper untuk format gender
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

  // Helper untuk check apakah punya foto
  bool get hasProfile => profilePath != null && profilePath!.isNotEmpty;
}

// Response wrapper untuk Credits (Cast & Crew)
class MovieCreditsResponse {
  final int id;
  final List<CastModel> cast;
  final List<CrewModel> crew;

  MovieCreditsResponse({
    required this.id,
    required this.cast,
    required this.crew,
  });

  factory MovieCreditsResponse.fromJson(Map<String, dynamic> json) {
    return MovieCreditsResponse(
      id: json['id'] ?? 0,
      cast:
          (json['cast'] as List?)
              ?.map((cast) => CastModel.fromJson(cast))
              .toList() ??
          [],
      crew:
          (json['crew'] as List?)
              ?.map((crew) => CrewModel.fromJson(crew))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'cast': cast.map((c) => c.toJson()).toList(),
      'crew': crew.map((c) => c.toJson()).toList(),
    };
  }

  // Helper untuk get top cast (misalnya 10 pemeran utama)
  List<CastModel> getTopCast([int limit = 10]) {
    return cast.take(limit).toList();
  }

  // Helper untuk filter crew berdasarkan department
  List<CrewModel> getCrewByDepartment(String department) {
    return crew.where((c) => c.department == department).toList();
  }

  // Helper untuk get director
  CrewModel? get director {
    try {
      return crew.firstWhere((c) => c.job == 'Director');
    } catch (e) {
      return null;
    }
  }

  // Helper untuk get all directors (bisa ada lebih dari 1)
  List<CrewModel> get directors {
    return crew.where((c) => c.job == 'Director').toList();
  }

  // Helper untuk get writer
  List<CrewModel> get writers {
    return crew
        .where(
          (c) =>
              c.department == 'Writing' ||
              c.job == 'Writer' ||
              c.job == 'Screenplay',
        )
        .toList();
  }

  // Helper untuk get producer
  List<CrewModel> get producers {
    return crew
        .where(
          (c) =>
              c.department == 'Production' &&
              (c.job == 'Producer' || c.job == 'Executive Producer'),
        )
        .toList();
  }

  // Helper untuk total cast & crew
  int get totalCredits => cast.length + crew.length;
}
