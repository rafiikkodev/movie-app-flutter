import 'package:flutter/material.dart';
import 'package:template_project_flutter/app/core/theme/theme.dart';
import 'package:template_project_flutter/widgets/buttons.dart';
import 'package:template_project_flutter/widgets/rate.dart';
import 'package:template_project_flutter/widgets/app_bar.dart';

class MovieDetailPage extends StatefulWidget {
  const MovieDetailPage({super.key});

  @override
  State<MovieDetailPage> createState() => _MovieDetailPageState();
}

class _MovieDetailPageState extends State<MovieDetailPage> {
  final ScrollController _scrollController = ScrollController();
  double _scrollOffset = 0.0;
  bool _isFavorite = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
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
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/card.png'),
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
                _MovieHeader(),
                const SizedBox(height: 24),
                _ActionButtons(),
                const SizedBox(height: 24),
                _SynopsisSection(),
                const SizedBox(height: 24),
                _CastSection(),
                const SizedBox(height: 24),
                _SimilarMoviesSection(),
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
  const _MovieHeader();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(
              12,
            ),
            child: Image.asset(
              "assets/images/card2.png",
              height: 287,
              fit: BoxFit.cover,
            ),
          ),
        ),

        const SizedBox(height: 52),
        _TitleAndRating(),
        const SizedBox(height: 16),
        _MovieInfo(),
        const SizedBox(height: 16),
        _Genres(),
      ],
    );
  }
}

class _TitleAndRating extends StatelessWidget {
  const _TitleAndRating();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            'Spider-Man: No Way Home',
            style: whiteTextStyle.copyWith(fontSize: 24, fontWeight: semiBold),
          ),
        ),
        const SizedBox(width: 12),
        const CustomRate(number: '4.8'),
      ],
    );
  }
}

class _MovieInfo extends StatelessWidget {
  const _MovieInfo();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _InfoText('2021'),
        _DotSeparator(),
        _InfoText('148 Minutes'),
        _DotSeparator(),
        _RatingBadge('PG-13'),
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
  const _Genres();

  @override
  Widget build(BuildContext context) {
    return Text(
      'Action • Adventure • Fantasy',
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
  const _SynopsisSection();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SectionTitle('Synopsis'),
        const SizedBox(height: 12),
        Text(
          'Peter Parker is unmasked and no longer able to separate his normal life from the high-stakes of being a super-hero. When he asks for help from Doctor Strange the stakes become even more dangerous, forcing him to discover what it truly means to be Spider-Man.',
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
  const _CastSection();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SectionTitle('Cast'),
        const SizedBox(height: 16),
        SizedBox(
          height: 120,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: 5,
            separatorBuilder: (context, index) => const SizedBox(width: 12),
            itemBuilder: (context, index) => const _CastItem(
              name: 'Tom Holland',
              imageUrl: 'assets/images/ic-profile-image.png',
            ),
          ),
        ),
      ],
    );
  }
}

class _CastItem extends StatelessWidget {
  final String name;
  final String imageUrl;

  const _CastItem({required this.name, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            image: DecorationImage(
              image: AssetImage(imageUrl),
              fit: BoxFit.cover,
            ),
          ),
        ),
        const SizedBox(height: 8),
        SizedBox(
          width: 80,
          child: Text(
            name,
            style: whiteTextStyle.copyWith(fontSize: 12, fontWeight: medium),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}

class _SimilarMoviesSection extends StatelessWidget {
  const _SimilarMoviesSection();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SectionTitle('Similar Movies'),
        const SizedBox(height: 16),
        SizedBox(
          height: 200,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: 5,
            separatorBuilder: (context, index) => const SizedBox(width: 12),
            itemBuilder: (context, index) => const _SimilarMovieItem(
              imageUrl: 'assets/images/card1.png',
              rate: '4.5',
            ),
          ),
        ),
      ],
    );
  }
}

class _SimilarMovieItem extends StatelessWidget {
  final String imageUrl;
  final String rate;

  const _SimilarMovieItem({required this.imageUrl, required this.rate});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Stack(
        children: [
          Image.asset(imageUrl, width: 135, height: 200, fit: BoxFit.cover),
          Positioned(top: 8, right: 8, child: CustomRate(number: rate)),
        ],
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
