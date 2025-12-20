import 'package:flutter/material.dart';
import 'package:template_project_flutter/app/core/theme/theme.dart';
import 'package:template_project_flutter/app/data/models/actor_model.dart';
import 'package:template_project_flutter/app/data/repositories/actor_repository.dart';
import 'package:template_project_flutter/app/data/repositories/movie_repository.dart';
import 'package:template_project_flutter/app/pages/movie_detail_page.dart';
import 'package:template_project_flutter/widgets/app_bar.dart';
import 'package:template_project_flutter/widgets/home_card.dart';

class ActorDetailPage extends StatefulWidget {
  final int actorId;
  final String? actorName;

  const ActorDetailPage({super.key, required this.actorId, this.actorName});

  @override
  State<ActorDetailPage> createState() => _ActorDetailPageState();
}

class _ActorDetailPageState extends State<ActorDetailPage> {
  final ScrollController _scrollController = ScrollController();
  final ActorRepository _actorRepository = ActorRepository();
  final MovieRepository _movieRepository = MovieRepository();

  double _scrollOffset = 0.0;
  bool _isLoading = true;
  String _errorMessage = '';

  ActorDetailModel? _actorDetail;
  List<ActorMovieCredit> _movieCredits = [];

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    _loadActorDetails();
  }

  Future<void> _loadActorDetails() async {
    try {
      setState(() {
        _isLoading = true;
        _errorMessage = '';
      });

      final results = await Future.wait([
        _actorRepository.getActorDetail(widget.actorId),
        _actorRepository.getActorMovieCredits(widget.actorId),
      ]);

      setState(() {
        _actorDetail = results[0] as ActorDetailModel;
        _movieCredits = results[1] as List<ActorMovieCredit>;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
        _isLoading = false;
      });
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

  double get _overlayOpacity => (_scrollOffset / 200).clamp(0.0, 1.0);

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        body: Center(child: CircularProgressIndicator(color: darkBlueAccent)),
      );
    }

    if (_errorMessage.isNotEmpty) {
      return Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.error_outline, size: 60, color: redColor),
                const SizedBox(height: 16),
                Text(
                  'Failed to load actor details',
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
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: _loadActorDetails,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: darkBlueAccent,
                  ),
                  child: Text('Retry', style: whiteTextStyle),
                ),
              ],
            ),
          ),
        ),
      );
    }

    if (_actorDetail == null) {
      return Scaffold(
        body: Center(
          child: Text(
            'Actor not found',
            style: whiteTextStyle.copyWith(fontSize: 16),
          ),
        ),
      );
    }

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
            image: _actorDetail!.hasProfile
                ? NetworkImage(_actorDetail!.profileUrl)
                : const AssetImage('assets/images/actors.png') as ImageProvider,
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
        const CustomAppBar(showBackButton: true),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.only(left: 24, right: 24, top: 40),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _ActorHeader(actor: _actorDetail!),
                const SizedBox(height: 24),
                _BiographySection(biography: _actorDetail!.biography),
                const SizedBox(height: 24),
                _PersonalInfoSection(actor: _actorDetail!),
                const SizedBox(height: 24),
                _MovieCreditsSection(
                  credits: _movieCredits,
                  movieRepository: _movieRepository,
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

class _ActorHeader extends StatelessWidget {
  final ActorDetailModel actor;

  const _ActorHeader({required this.actor});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(
          child: Container(
            width: 200,
            height: 200,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: darkGreyColor,
            ),
            child: ClipOval(
              child: actor.hasProfile
                  ? Image.network(
                      actor.profileUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Icon(Icons.person, size: 80, color: greyColor);
                      },
                    )
                  : Icon(Icons.person, size: 80, color: greyColor),
            ),
          ),
        ),
        const SizedBox(height: 24),
        Text(
          actor.name,
          style: whiteTextStyle.copyWith(fontSize: 24, fontWeight: semiBold),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        Text(
          actor.knownForDepartment,
          style: greyTextStyle.copyWith(fontSize: 16, fontWeight: medium),
        ),
      ],
    );
  }
}

class _BiographySection extends StatelessWidget {
  final String biography;

  const _BiographySection({required this.biography});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Biography',
          style: whiteTextStyle.copyWith(fontSize: 18, fontWeight: semiBold),
        ),
        const SizedBox(height: 12),
        Text(
          biography.isNotEmpty ? biography : 'No biography available.',
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

class _PersonalInfoSection extends StatelessWidget {
  final ActorDetailModel actor;

  const _PersonalInfoSection({required this.actor});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Personal Info',
          style: whiteTextStyle.copyWith(fontSize: 18, fontWeight: semiBold),
        ),
        const SizedBox(height: 16),
        _InfoRow(label: 'Known For', value: actor.knownForDepartment),
        const SizedBox(height: 12),
        _InfoRow(label: 'Gender', value: actor.genderString),
        const SizedBox(height: 12),
        _InfoRow(
          label: 'Birthday',
          value: actor.birthday.isNotEmpty ? actor.birthday : 'N/A',
        ),
        const SizedBox(height: 12),
        _InfoRow(label: 'Age', value: actor.age),
        const SizedBox(height: 12),
        _InfoRow(
          label: 'Place of Birth',
          value: actor.placeOfBirth.isNotEmpty ? actor.placeOfBirth : 'N/A',
        ),
        if (actor.alsoKnownAs.isNotEmpty) ...[
          const SizedBox(height: 12),
          _InfoRow(
            label: 'Also Known As',
            value: actor.alsoKnownAs.take(3).join(', '),
          ),
        ],
      ],
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;

  const _InfoRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 120,
          child: Text(
            label,
            style: greyTextStyle.copyWith(fontSize: 14, fontWeight: medium),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: whiteTextStyle.copyWith(fontSize: 14, fontWeight: medium),
          ),
        ),
      ],
    );
  }
}

class _MovieCreditsSection extends StatelessWidget {
  final List<ActorMovieCredit> credits;
  final MovieRepository movieRepository;

  const _MovieCreditsSection({
    required this.credits,
    required this.movieRepository,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Known For (${credits.length} movies)',
          style: whiteTextStyle.copyWith(fontSize: 18, fontWeight: semiBold),
        ),
        const SizedBox(height: 16),
        credits.isEmpty
            ? Center(
                child: Text(
                  'No movie credits available',
                  style: greyTextStyle.copyWith(
                    fontSize: 14,
                    fontWeight: medium,
                  ),
                ),
              )
            : SizedBox(
                height: 231,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: credits.length,
                  separatorBuilder: (context, index) =>
                      const SizedBox(width: 12),
                  itemBuilder: (context, index) {
                    final credit = credits[index];
                    return _MovieCreditItem(
                      credit: credit,
                      movieRepository: movieRepository,
                    );
                  },
                ),
              ),
      ],
    );
  }
}

class _MovieCreditItem extends StatelessWidget {
  final ActorMovieCredit credit;
  final MovieRepository movieRepository;

  const _MovieCreditItem({required this.credit, required this.movieRepository});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        // Load full movie details and navigate
        try {
          final movie = await movieRepository.getMovieById(credit.id);
          if (context.mounted) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => MovieDetailPage(movie: movie),
              ),
            );
          }
        } catch (e) {
          if (context.mounted) {
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
      child: HomeCard(
        imageUrl: credit.posterUrl,
        voteAverage: credit.rating,
        title: credit.title,
        genreIds: credit.character ?? 'Unknown',
      ),
    );
  }
}
