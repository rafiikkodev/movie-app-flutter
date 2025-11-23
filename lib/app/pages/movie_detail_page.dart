import 'package:flutter/material.dart';
import 'package:template_project_flutter/app/core/theme/theme.dart';
import 'package:template_project_flutter/app/data/models/movie_model.dart';
import 'package:template_project_flutter/app/data/models/cast_crew_model.dart';
import 'package:template_project_flutter/app/data/repositories/movie_repository.dart';
import 'package:template_project_flutter/app/data/repositories/cast_crew_repository.dart';
import 'package:template_project_flutter/widgets/buttons.dart';
import 'package:template_project_flutter/widgets/rate.dart';
import 'package:template_project_flutter/widgets/app_bar.dart';
import 'package:template_project_flutter/widgets/home_card.dart';

class MovieDetailPage extends StatefulWidget {
  final MovieModel movie;

  const MovieDetailPage({super.key, required this.movie});

  @override
  State<MovieDetailPage> createState() => _MovieDetailPageState();
}

class _MovieDetailPageState extends State<MovieDetailPage> {
  final ScrollController _scrollController = ScrollController();
  final MovieRepository _movieRepository = MovieRepository();
  final CastCrewRepository _castCrewRepository = CastCrewRepository();

  double _scrollOffset = 0.0;
  bool _isFavorite = false;
  bool _isLoading = true;

  List<CastModel> _cast = [];
  List<MovieModel> _similarMovies = [];

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    _loadMovieDetails();
  }

  Future<void> _loadMovieDetails() async {
    try {
      setState(() {
        _isLoading = true;
      });

      // Load cast dan similar movies secara paralel
      final results = await Future.wait([
        _castCrewRepository.getTopCast(widget.movie.id, limit: 10),
        _movieRepository.getSimilarMovies(widget.movie.id),
      ]);

      setState(() {
        _cast = results[0] as List<CastModel>;
        _similarMovies = results[1] as List<MovieModel>;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      // TODO: Show error snackbar or dialog
      debugPrint('Error loading movie details: $e');
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    setState(() {
      _scrollOffset = _scrollController.offset;
    });
  }

  void _toggleFavorite() {
    setState(() {
      _isFavorite = !_isFavorite;
    });
  }

  double get _overlayOpacity => (_scrollOffset / 200).clamp(0.0, 1.0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          _buildBackgroundImage(),
          _buildScrollOverlay(),
          _buildContent(),
        ],
      ),
    );
  }

  Widget _buildBackgroundImage() {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: Container(
        height: 400,
        decoration: BoxDecoration(
          image: DecorationImage(
            image:
                widget.movie.backdropPath != null &&
                    widget.movie.backdropPath!.isNotEmpty
                ? NetworkImage(widget.movie.backdropUrl)
                : const AssetImage('assets/images/card.png') as ImageProvider,
            fit: BoxFit.cover,
          ),
        ),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.transparent,
                darkBackgroundColor.withAlpha(100),
                darkBackgroundColor,
              ],
              stops: const [0.0, 0.7, 1.0],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildScrollOverlay() {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 100),
        height: 400,
        color: darkBackgroundColor.withOpacity(_overlayOpacity),
      ),
    );
  }

  Widget _buildContent() {
    return CustomScrollView(
      controller: _scrollController,
      slivers: [
        CustomAppBar(
          showBackButton: true,
          showFavoriteButton: true,
          isFavorite: _isFavorite,
          onFavoritePressed: _toggleFavorite,
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.only(left: 24, right: 24, top: 40),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _MovieHeader(movie: widget.movie),
                const SizedBox(height: 24),
                const _ActionButtons(),
                const SizedBox(height: 24),
                _SynopsisSection(overview: widget.movie.overview),
                const SizedBox(height: 24),
                _CastSection(cast: _cast, isLoading: _isLoading),
                const SizedBox(height: 24),
                _SimilarMoviesSection(
                  movies: _similarMovies,
                  isLoading: _isLoading,
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _MovieHeader extends StatelessWidget {
  final MovieModel movie;

  const _MovieHeader({required this.movie});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: movie.posterPath != null && movie.posterPath!.isNotEmpty
                ? Image.network(
                    movie.posterUrl,
                    height: 287,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        height: 287,
                        color: darkGreyColor,
                        child: Icon(Icons.movie, size: 80, color: greyColor),
                      );
                    },
                  )
                : Container(
                    height: 287,
                    color: darkGreyColor,
                    child: Icon(Icons.movie, size: 80, color: greyColor),
                  ),
          ),
        ),
        const SizedBox(height: 52),
        _TitleAndRating(title: movie.title, rating: movie.rating),
        const SizedBox(height: 16),
        _MovieInfo(year: movie.year),
        const SizedBox(height: 16),
        _Genres(genres: movie.genreNames),
      ],
    );
  }
}

class _TitleAndRating extends StatelessWidget {
  final String title;
  final String rating;

  const _TitleAndRating({required this.title, required this.rating});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            title,
            style: whiteTextStyle.copyWith(fontSize: 24, fontWeight: semiBold),
          ),
        ),
        const SizedBox(width: 12),
        CustomFillRate(number: rating),
      ],
    );
  }
}

class _MovieInfo extends StatelessWidget {
  final String year;

  const _MovieInfo({required this.year});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _InfoText(year.isNotEmpty ? year : 'N/A'),
        const _DotSeparator(),
        const _InfoText('Movie'),
        const _DotSeparator(),
        const _RatingBadge('PG-13'),
      ],
    );
  }
}

class _InfoText extends StatelessWidget {
  final String text;

  const _InfoText(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: greyTextStyle.copyWith(fontSize: 14, fontWeight: medium),
    );
  }
}

class _DotSeparator extends StatelessWidget {
  const _DotSeparator();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8),
      width: 4,
      height: 4,
      decoration: BoxDecoration(color: greyColor, shape: BoxShape.circle),
    );
  }
}

class _RatingBadge extends StatelessWidget {
  final String rating;

  const _RatingBadge(this.rating);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        border: Border.all(color: darkBlueAccent, width: 1),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        rating,
        style: darkBlueTextStyle.copyWith(fontSize: 12, fontWeight: medium),
      ),
    );
  }
}

class _Genres extends StatelessWidget {
  final String genres;

  const _Genres({required this.genres});

  @override
  Widget build(BuildContext context) {
    return Text(
      genres,
      style: greyTextStyle.copyWith(fontSize: 14, fontWeight: medium),
    );
  }
}

class _ActionButtons extends StatelessWidget {
  const _ActionButtons();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: CustomButton.primary(
            title: 'Play',
            width: double.infinity,
            fontSize: 16,
            onPressed: () {},
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: CustomButton.outlined(
            title: 'Download',
            width: double.infinity,
            fontSize: 16,
            onPressed: () {},
          ),
        ),
      ],
    );
  }
}

class _SynopsisSection extends StatelessWidget {
  final String overview;

  const _SynopsisSection({required this.overview});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _SectionTitle('Synopsis'),
        const SizedBox(height: 12),
        Text(
          overview.isNotEmpty ? overview : 'No synopsis available.',
          style: greyTextStyle.copyWith(
            fontSize: 14,
            fontWeight: medium,
            height: 1.5,
          ),
        ),
      ],
    );
  }
}

class _CastSection extends StatelessWidget {
  final List<CastModel> cast;
  final bool isLoading;

  const _CastSection({required this.cast, required this.isLoading});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _SectionTitle('Cast'),
        const SizedBox(height: 16),
        SizedBox(
          height: 120,
          child: isLoading
              ? Center(child: CircularProgressIndicator(color: darkBlueAccent))
              : cast.isEmpty
              ? Center(
                  child: Text(
                    'No cast information available',
                    style: greyTextStyle.copyWith(
                      fontSize: 14,
                      fontWeight: medium,
                    ),
                  ),
                )
              : ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: cast.length,
                  separatorBuilder: (context, index) =>
                      const SizedBox(width: 12),
                  itemBuilder: (context, index) => _CastItem(cast: cast[index]),
                ),
        ),
      ],
    );
  }
}

class _CastItem extends StatelessWidget {
  final CastModel cast;

  const _CastItem({required this.cast});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: darkGreyColor,
          ),
          child: ClipOval(
            child: cast.hasProfile
                ? Image.network(
                    cast.profileUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Icon(Icons.person, size: 40, color: greyColor);
                    },
                  )
                : Icon(Icons.person, size: 40, color: greyColor),
          ),
        ),
        const SizedBox(height: 8),
        SizedBox(
          width: 80,
          child: Text(
            cast.name,
            style: whiteTextStyle.copyWith(fontSize: 12, fontWeight: medium),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}

class _SimilarMoviesSection extends StatelessWidget {
  final List<MovieModel> movies;
  final bool isLoading;

  const _SimilarMoviesSection({required this.movies, required this.isLoading});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _SectionTitle('Similar Movies'),
        const SizedBox(height: 16),
        SizedBox(
          height: 231,
          child: isLoading
              ? Center(child: CircularProgressIndicator(color: darkBlueAccent))
              : movies.isEmpty
              ? Center(
                  child: Text(
                    'No similar movies found',
                    style: greyTextStyle.copyWith(
                      fontSize: 14,
                      fontWeight: medium,
                    ),
                  ),
                )
              : ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: movies.length,
                  separatorBuilder: (context, index) =>
                      const SizedBox(width: 12),
                  itemBuilder: (context, index) =>
                      _SimilarMovieItem(movie: movies[index]),
                ),
        ),
      ],
    );
  }
}

class _SimilarMovieItem extends StatelessWidget {
  final MovieModel movie;

  const _SimilarMovieItem({required this.movie});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MovieDetailPage(movie: movie),
          ),
        );
      },
      child: HomeCard(
        imageUrl: movie.posterUrl,
        voteAverage: movie.voteAverage.toString(),
        title: movie.title,
        genreIds: movie.genreNames,
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;

  const _SectionTitle(this.title);

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: whiteTextStyle.copyWith(fontSize: 18, fontWeight: semiBold),
    );
  }
}
