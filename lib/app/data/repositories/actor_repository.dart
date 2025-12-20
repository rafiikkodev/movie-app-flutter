import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:template_project_flutter/app/core/config/api_config.dart';
import 'package:template_project_flutter/app/data/models/actor_model.dart';

class ActorRepository {
  Future<ActorDetailModel> getActorDetail(int actorId) async {
    final url = Uri.parse(
      '${ApiConfig.baseUrl}/person/$actorId?api_key=${ApiConfig.apiKey}&language=en-US',
    );

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return ActorDetailModel.fromJson(data);
      } else {
        throw Exception('Failed to load actor details: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching actor details: $e');
    }
  }

  Future<List<ActorMovieCredit>> getActorMovieCredits(int actorId) async {
    final url = Uri.parse(
      '${ApiConfig.baseUrl}/person/$actorId/movie_credits?api_key=${ApiConfig.apiKey}&language=en-US',
    );

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List<dynamic> cast = data['cast'] ?? [];

        // Sort by release date (newest first) and take top 20
        final credits =
            cast.map((json) => ActorMovieCredit.fromJson(json)).toList()
              ..sort((a, b) {
                if (a.releaseDate == null) return 1;
                if (b.releaseDate == null) return -1;
                return b.releaseDate!.compareTo(a.releaseDate!);
              });

        return credits.take(20).toList();
      } else {
        throw Exception(
          'Failed to load actor movie credits: ${response.statusCode}',
        );
      }
    } catch (e) {
      throw Exception('Error fetching actor movie credits: $e');
    }
  }

  Future<List<SearchResult>> searchMulti(String query) async {
    if (query.trim().isEmpty) {
      return [];
    }

    final url = Uri.parse(
      '${ApiConfig.baseUrl}/search/multi?api_key=${ApiConfig.apiKey}&language=en-US&query=${Uri.encodeComponent(query)}&page=1&include_adult=false',
    );

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List<dynamic> results = data['results'] ?? [];

        // Filter only movies and persons
        return results
            .where((json) {
              final mediaType = json['media_type'];
              return mediaType == 'movie' || mediaType == 'person';
            })
            .map((json) => SearchResult.fromJson(json))
            .toList();
      } else {
        throw Exception('Failed to search: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error searching: $e');
    }
  }
}
