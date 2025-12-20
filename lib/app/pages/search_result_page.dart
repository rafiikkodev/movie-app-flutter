import 'package:flutter/material.dart';
import 'package:template_project_flutter/app/core/theme/theme.dart';
import 'package:template_project_flutter/app/data/models/actor_model.dart';
import 'package:template_project_flutter/app/data/repositories/actor_repository.dart';
import 'package:template_project_flutter/app/data/repositories/movie_repository.dart';
import 'package:template_project_flutter/app/pages/actor_detail_page.dart';
import 'package:template_project_flutter/app/pages/movie_detail_page.dart';
import 'package:template_project_flutter/widgets/home_card.dart';

class SearchResultPage extends StatefulWidget {
  const SearchResultPage({super.key});

  @override
  State<SearchResultPage> createState() => _SearchResultPageState();
}

class _SearchResultPageState extends State<SearchResultPage> {
  final TextEditingController searchController = TextEditingController();
  final ActorRepository _actorRepository = ActorRepository();
  final MovieRepository _movieRepository = MovieRepository();

  List<SearchResult> _searchResults = [];
  bool _isSearching = false;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    searchController.removeListener(_onSearchChanged);
    searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    if (searchController.text.trim().isEmpty) {
      setState(() {
        _searchResults = [];
        _isSearching = false;
      });
    }
  }

  Future<void> _performSearch() async {
    final query = searchController.text.trim();
    if (query.isEmpty) return;

    setState(() {
      _isSearching = true;
      _errorMessage = '';
    });

    try {
      final results = await _actorRepository.searchMulti(query);
      setState(() {
        _searchResults = results;
        _isSearching = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
        _isSearching = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        padding: const EdgeInsets.only(right: 24, left: 24, top: 52),
        children: [
          // Search input
          Container(
            height: 48,
            decoration: BoxDecoration(
              color: softColor,
              borderRadius: BorderRadius.circular(56),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Icon(Icons.search, color: greyColor, size: 20),
                const SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    controller: searchController,
                    style: whiteTextStyle.copyWith(fontSize: 14),
                    decoration: InputDecoration(
                      hintText: 'Search movies or actors...',
                      hintStyle: TextStyle(
                        color: greyColor,
                        fontSize: 12,
                        fontWeight: medium,
                      ),
                      border: InputBorder.none,
                    ),
                    onSubmitted: (_) => _performSearch(),
                  ),
                ),
                if (searchController.text.isNotEmpty)
                  IconButton(
                    icon: Icon(Icons.clear, color: greyColor, size: 20),
                    onPressed: () {
                      searchController.clear();
                      setState(() {
                        _searchResults = [];
                      });
                    },
                  ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Loading state
          if (_isSearching)
            const Center(
              child: Padding(
                padding: EdgeInsets.all(50),
                child: CircularProgressIndicator(),
              ),
            ),

          // Error state
          if (_errorMessage.isNotEmpty)
            Center(
              child: Padding(
                padding: const EdgeInsets.all(50),
                child: Column(
                  children: [
                    Icon(Icons.error_outline, size: 60, color: redColor),
                    const SizedBox(height: 16),
                    Text(
                      'Search failed',
                      style: whiteTextStyle.copyWith(
                        fontSize: 16,
                        fontWeight: semiBold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _errorMessage,
                      style: greyTextStyle,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),

          // Empty state
          if (!_isSearching &&
              _searchResults.isEmpty &&
              searchController.text.isNotEmpty)
            Center(
              child: Padding(
                padding: const EdgeInsets.all(50),
                child: Column(
                  children: [
                    Icon(Icons.search_off, size: 60, color: greyColor),
                    const SizedBox(height: 16),
                    Text(
                      'No results found',
                      style: whiteTextStyle.copyWith(
                        fontSize: 16,
                        fontWeight: semiBold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Try searching with different keywords',
                      style: greyTextStyle,
                    ),
                  ],
                ),
              ),
            ),

          // Results
          if (!_isSearching && _searchResults.isNotEmpty) buildSearchResults(),
        ],
      ),
    );
  }

  Widget buildSearchResults() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Results (${_searchResults.length})',
          style: whiteTextStyle.copyWith(fontSize: 16, fontWeight: semiBold),
        ),
        const SizedBox(height: 16),
        Column(
          children: List.generate(_searchResults.length, (index) {
            final result = _searchResults[index];
            return Padding(
              padding: EdgeInsets.only(
                bottom: index < _searchResults.length - 1 ? 16 : 0,
              ),
              child: result.isMovie
                  ? _buildMovieCard(result)
                  : _buildActorCard(result),
            );
          }),
        ),
      ],
    );
  }

  Widget _buildMovieCard(SearchResult result) {
    return SearchCard(
      imageUrl: result.imageUrl,
      title: result.displayTitle,
      year: result.year,
      duration: '',
      rating: 'PG-13',
      genre: 'Movie',
      rate: result.voteAverage?.toStringAsFixed(1) ?? '0.0',
      onTap: () async {
        try {
          final movie = await _movieRepository.getMovieById(result.id);
          if (mounted) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => MovieDetailPage(movie: movie),
              ),
            );
          }
        } catch (e) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  'Failed to load movie details',
                  style: whiteTextStyle.copyWith(fontSize: 14),
                ),
                backgroundColor: redColor,
              ),
            );
          }
        }
      },
    );
  }

  Widget _buildActorCard(SearchResult result) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                ActorDetailPage(actorId: result.id, actorName: result.name),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: softColor,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: darkGreyColor,
              ),
              child: ClipOval(
                child:
                    result.profilePath != null && result.profilePath!.isNotEmpty
                    ? Image.network(
                        result.imageUrl,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Icon(Icons.person, size: 30, color: greyColor);
                        },
                      )
                    : Icon(Icons.person, size: 30, color: greyColor),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    result.displayTitle,
                    style: whiteTextStyle.copyWith(
                      fontSize: 14,
                      fontWeight: semiBold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    result.knownForDepartment ?? 'Actor',
                    style: greyTextStyle.copyWith(
                      fontSize: 12,
                      fontWeight: medium,
                    ),
                  ),
                ],
              ),
            ),
            Icon(Icons.chevron_right, color: greyColor),
          ],
        ),
      ),
    );
  }
}
