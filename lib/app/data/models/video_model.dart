class VideoModel {
  final String id;
  final String key;
  final String name;
  final String site;
  final int size;
  final String type;
  final bool official;
  final String publishedAt;

  VideoModel({
    required this.id,
    required this.key,
    required this.name,
    required this.site,
    required this.size,
    required this.type,
    required this.official,
    required this.publishedAt,
  });

  factory VideoModel.fromJson(Map<String, dynamic> json) {
    return VideoModel(
      id: json['id'] ?? '',
      key: json['key'] ?? '',
      name: json['name'] ?? '',
      site: json['site'] ?? '',
      size: json['size'] ?? 0,
      type: json['type'] ?? '',
      official: json['official'] ?? false,
      publishedAt: json['published_at'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'key': key,
      'name': name,
      'site': site,
      'size': size,
      'type': type,
      'official': official,
      'published_at': publishedAt,
    };
  }

  // Helper untuk get YouTube URL
  String get youtubeUrl => 'https://www.youtube.com/watch?v=$key';

  // Helper untuk get YouTube thumbnail
  String get youtubeThumbnail =>
      'https://img.youtube.com/vi/$key/maxresdefault.jpg';

  // Helper untuk get YouTube embed URL
  String get youtubeEmbedUrl => 'https://www.youtube.com/embed/$key';

  // Check if video is trailer
  bool get isTrailer => type.toLowerCase() == 'trailer';

  // Check if video is from YouTube
  bool get isYouTube => site.toLowerCase() == 'youtube';
}

class MovieVideosResponse {
  final int id;
  final List<VideoModel> results;

  MovieVideosResponse({required this.id, required this.results});

  factory MovieVideosResponse.fromJson(Map<String, dynamic> json) {
    return MovieVideosResponse(
      id: json['id'] ?? 0,
      results:
          (json['results'] as List<dynamic>?)
              ?.map((video) => VideoModel.fromJson(video))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'results': results.map((video) => video.toJson()).toList(),
    };
  }

  // Helper untuk get trailers saja
  List<VideoModel> getTrailers() {
    return results
        .where((video) => video.isTrailer && video.isYouTube)
        .toList();
  }

  // Helper untuk get official trailers
  List<VideoModel> getOfficialTrailers() {
    return results
        .where((video) => video.isTrailer && video.isYouTube && video.official)
        .toList();
  }
}
