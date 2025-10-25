import 'package:flutter/material.dart';
import 'package:template_project_flutter/widgets/download_card.dart';
import 'package:template_project_flutter/widgets/app_bar.dart';

class DownloadPage extends StatefulWidget {
  const DownloadPage({super.key});

  @override
  State<DownloadPage> createState() => _DownloadPageState();
}

class _DownloadPageState extends State<DownloadPage> {
  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        CustomAppBar(showBackButton: true, title: "Download",),
        SliverPadding(
          padding: const EdgeInsets.only(left: 24, right: 24, top: 24),
          sliver: SliverList(
            delegate: SliverChildBuilderDelegate((context, index) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: DownloadCard(
                  imageUrl: "assets/images/card2.png",
                  genre: "Action • Adventure",
                  title: "Spider-Man: No Way Home",
                  download: "Downloaded on 12 Dec 2021",
                ),
              );
            }, childCount: 10),
          ),
        ),
      ],
    );
  }
}
