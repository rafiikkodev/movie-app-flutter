import 'package:flutter/material.dart';
import 'package:template_project_flutter/app/core/utils/logger.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:template_project_flutter/app/core/theme/theme.dart';
import 'package:template_project_flutter/app/data/models/movie_model.dart';
import 'package:template_project_flutter/app/data/models/video_model.dart';
import 'package:template_project_flutter/app/data/models/cast_crew_model.dart';
import 'package:template_project_flutter/app/data/providers/favorite_provider.dart';
import 'package:template_project_flutter/app/data/repositories/video_repository.dart';
import 'package:template_project_flutter/app/data/repositories/cast_crew_repository.dart';
import 'package:template_project_flutter/widgets/app_bar.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class TrailerPage extends StatefulWidget {
  final MovieModel movie;

  const TrailerPage({super.key, required this.movie});

  @override
  State<TrailerPage> createState() => _TrailerPageState();
}

class _TrailerPageState extends State<TrailerPage> {
  final VideoRepository _videoRepository = VideoRepository();
  final CastCrewRepository _castCrewRepository = CastCrewRepository();

  bool _isLoading = true;
  List<VideoModel> _trailers = [];
  List<CastModel> _cast = [];
  List<CrewModel> _crew = [];
  String _errorMessage = '';
  YoutubePlayerController? _youtubeController;

  @override
  void initState() {
    super.initState();
    _loadTrailerData();
  }

  void _toggleFavorite() {
    final provider = context.read<FavoriteProvider>();
    final wasF = provider.isFavorite(widget.movie.id);

    // Optimistic update - akan langsung update UI
    provider.toggleFavorite(widget.movie);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          !wasF ? 'Added to favorites' : 'Removed from favorites',
          style: whiteTextStyle.copyWith(fontSize: 14),
        ),
        backgroundColor: darkBlueAccent,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  Future<void> _loadTrailerData() async {
    try {
      setState(() {
        _isLoading = true;
        _errorMessage = '';
      });

      final results = await Future.wait([
        _videoRepository.getMovieTrailers(widget.movie.id),
        _castCrewRepository.getTopCast(widget.movie.id, limit: 10),
        _castCrewRepository.getCrew(widget.movie.id),
      ]);

      setState(() {
        _trailers = results[0] as List<VideoModel>;
        _cast = results[1] as List<CastModel>;
        _crew = results[2] as List<CrewModel>;
        _isLoading = false;
      });

      // Initialize YouTube player with first trailer
      if (_trailers.isNotEmpty) {
        _initializeYoutubePlayer(_trailers.first);
      }
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
        _isLoading = false;
      });
      LoggerService.error('Error loading trailer data', e);
    }
  }

  void _initializeYoutubePlayer(VideoModel trailer) {
    _youtubeController?.dispose();

    _youtubeController = YoutubePlayerController(
      initialVideoId: trailer.key,
      flags: const YoutubePlayerFlags(
        autoPlay: false,
        mute: false,
        enableCaption: true,
        controlsVisibleAtStart: true,
      ),
    );

    setState(() {});
  }

  void _playVideo(VideoModel trailer) {
    _initializeYoutubePlayer(trailer);

    // Show fullscreen player
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => Dialog(
        backgroundColor: Colors.black,
        insetPadding: EdgeInsets.zero,
        child: Stack(
          children: [
            Center(
              child: YoutubePlayer(
                controller: _youtubeController!,
                showVideoProgressIndicator: true,
                progressIndicatorColor: darkBlueAccent,
                progressColors: ProgressBarColors(
                  playedColor: darkBlueAccent,
                  handleColor: darkBlueAccent,
                ),
              ),
            ),
            Positioned(
              top: 40,
              right: 16,
              child: IconButton(
                icon: Icon(Icons.close, color: whiteColor, size: 32),
                onPressed: () {
                  _youtubeController?.pause();
                  Navigator.pop(context);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _youtubeController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<FavoriteProvider>(
        builder: (context, favoriteProvider, child) {
          final isFavorite = favoriteProvider.isFavorite(widget.movie.id);

          return CustomScrollView(
            slivers: [
              CustomAppBar(
                showBackButton: true,
                title: "Trailer",
                showFavoriteButton: true,
                isFavorite: isFavorite,
                onFavoritePressed: _toggleFavorite,
              ),
              if (_isLoading)
                SliverFillRemaining(
                  child: Center(
                    child: CircularProgressIndicator(color: darkBlueAccent),
                  ),
                )
              else if (_errorMessage.isNotEmpty)
                SliverFillRemaining(
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.error_outline, size: 64, color: greyColor),
                          const SizedBox(height: 16),
                          Text(
                            'Failed to load trailer',
                            style: whiteTextStyle.copyWith(
                              fontSize: 18,
                              fontWeight: semiBold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            _errorMessage,
                            style: greyTextStyle.copyWith(fontSize: 14),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              else
                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  sliver: SliverList(
                    delegate: SliverChildListDelegate([
                      const SizedBox(height: 24),
                      _buildVideoPlayer(),
                      const SizedBox(height: 24),
                      _buildMovieInfo(),
                      const SizedBox(height: 24),
                      _buildSynopsis(),
                      const SizedBox(height: 24),
                      _buildCastAndCrew(),
                      const SizedBox(height: 24),
                      _buildGallery(),
                      const SizedBox(height: 24),
                    ]),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildVideoPlayer() {
    if (_trailers.isEmpty) {
      return Container(
        height: 200,
        decoration: BoxDecoration(
          color: darkGreyColor,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.videocam_off, size: 48, color: greyColor),
              const SizedBox(height: 8),
              Text(
                'No trailer available',
                style: greyTextStyle.copyWith(fontSize: 14),
              ),
            ],
          ),
        ),
      );
    }

    final trailer = _trailers.first;

    // Show YouTube player if available
    if (_youtubeController != null) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: YoutubePlayer(
          controller: _youtubeController!,
          showVideoProgressIndicator: true,
          progressIndicatorColor: darkBlueAccent,
          progressColors: ProgressBarColors(
            playedColor: darkBlueAccent,
            handleColor: darkBlueAccent,
          ),
          bottomActions: [
            CurrentPosition(),
            ProgressBar(isExpanded: true),
            RemainingDuration(),
            const PlaybackSpeedButton(),
            FullScreenButton(),
          ],
        ),
      );
    }

    // Fallback to thumbnail with play button
    return GestureDetector(
      onTap: () => _playVideo(trailer),
      child: Container(
        height: 200,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          image: DecorationImage(
            image: NetworkImage(trailer.youtubeThumbnail),
            fit: BoxFit.cover,
          ),
        ),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Colors.transparent, Colors.black.withOpacity(0.7)],
            ),
          ),
          child: Stack(
            children: [
              // Play button
              Center(
                child: Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    color: darkBlueAccent,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.play_arrow, size: 40, color: whiteColor),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMovieInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.movie.title,
          style: whiteTextStyle.copyWith(fontSize: 24, fontWeight: semiBold),
        ),
        const SizedBox(height: 12),
        Column(
          children: [
            Row(
              children: [
                Icon(Icons.calendar_today, size: 16, color: greyColor),
                const SizedBox(width: 8),
                Text(
                  'Release Date: ${widget.movie.releaseDate}',
                  style: greyTextStyle.copyWith(
                    fontSize: 14,
                    fontWeight: medium,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Icon(Icons.movie, size: 16, color: greyColor),
                const SizedBox(width: 8),
                Text(
                  widget.movie.genreNamesDisplay.split(', ').first,
                  style: greyTextStyle.copyWith(
                    fontSize: 14,
                    fontWeight: medium,
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSynopsis() {
    return _SynopsisExpandable(overview: widget.movie.overview);
  }

  Widget _buildCastAndCrew() {
    // Get directors and writers from crew
    final directors = _crew
        .where((c) => c.job.toLowerCase() == 'director')
        .take(3)
        .toList();
    final writers = _crew
        .where(
          (c) =>
              c.job.toLowerCase() == 'writer' ||
              c.job.toLowerCase() == 'screenplay',
        )
        .take(3)
        .toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Cast and Crew',
          style: whiteTextStyle.copyWith(fontSize: 18, fontWeight: semiBold),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 120,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: _cast.length + directors.length + writers.length,
            separatorBuilder: (context, index) => const SizedBox(width: 16),
            itemBuilder: (context, index) {
              if (index < directors.length) {
                return _buildCrewMember(directors[index], 'Directors');
              } else if (index < directors.length + writers.length) {
                return _buildCrewMember(
                  writers[index - directors.length],
                  'Writers',
                );
              } else {
                return _buildCastMember(
                  _cast[index - directors.length - writers.length],
                );
              }
            },
          ),
        ),
      ],
    );
  }

  Widget _buildCastMember(CastModel cast) {
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

  Widget _buildCrewMember(CrewModel crew, String role) {
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
            child: crew.hasProfile
                ? Image.network(
                    crew.profileUrl,
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
          child: Column(
            children: [
              Text(
                crew.name,
                style: whiteTextStyle.copyWith(
                  fontSize: 12,
                  fontWeight: medium,
                ),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              Text(
                role,
                style: greyTextStyle.copyWith(fontSize: 10),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildGallery() {
    if (_trailers.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'More Trailers',
          style: whiteTextStyle.copyWith(fontSize: 18, fontWeight: semiBold),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 150,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: _trailers.length,
            separatorBuilder: (context, index) => const SizedBox(width: 12),
            itemBuilder: (context, index) {
              final trailer = _trailers[index];
              return GestureDetector(
                onTap: () => _playVideo(trailer),
                child: Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.network(
                        trailer.youtubeThumbnail,
                        width: 200,
                        height: 150,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            width: 200,
                            height: 150,
                            color: darkGreyColor,
                            child: Icon(
                              Icons.image,
                              size: 40,
                              color: greyColor,
                            ),
                          );
                        },
                      ),
                    ),
                    Positioned.fill(
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.transparent,
                              Colors.black.withOpacity(0.6),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Positioned.fill(
                      child: Center(
                        child: Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            color: darkBlueAccent.withOpacity(0.9),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.play_arrow,
                            size: 32,
                            color: whiteColor,
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 8,
                      left: 8,
                      right: 8,
                      child: Text(
                        trailer.name,
                        style: whiteTextStyle.copyWith(
                          fontSize: 11,
                          fontWeight: medium,
                          shadows: [
                            Shadow(
                              color: Colors.black.withOpacity(0.8),
                              blurRadius: 4,
                            ),
                          ],
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _SynopsisExpandable extends StatefulWidget {
  final String overview;

  const _SynopsisExpandable({required this.overview});

  @override
  State<_SynopsisExpandable> createState() => _SynopsisExpandableState();
}

class _SynopsisExpandableState extends State<_SynopsisExpandable> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Synopsis',
          style: whiteTextStyle.copyWith(fontSize: 18, fontWeight: semiBold),
        ),
        const SizedBox(height: 12),
        Text(
          widget.overview.isNotEmpty
              ? widget.overview
              : 'No synopsis available.',
          style: greyTextStyle.copyWith(
            fontSize: 14,
            fontWeight: medium,
            height: 1.5,
          ),
          maxLines: _isExpanded ? null : 4,
          overflow: _isExpanded ? TextOverflow.visible : TextOverflow.ellipsis,
        ),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: () {
            setState(() {
              _isExpanded = !_isExpanded;
            });
          },
          child: Text(
            _isExpanded ? 'Less' : 'More',
            style: darkBlueTextStyle.copyWith(
              fontSize: 16,
              fontWeight: semiBold,
            ),
          ),
        ),
      ],
    );
  }
}
