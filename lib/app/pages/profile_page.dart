import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:template_project_flutter/app/core/theme/theme.dart';
import 'package:template_project_flutter/app/data/services/auth_service.dart';
import 'package:template_project_flutter/widgets/buttons.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final AuthService _authService = AuthService();

  String userName = 'User';
  String userEmail = '';
  String? userAvatarUrl;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    try {
      final user = _authService.currentUser;
      if (user != null) {
        final profile = await _authService.getUserProfile();
        if (mounted) {
          setState(() {
            userEmail = user.email ?? '';
            userName =
                profile?['full_name'] ??
                profile?['username'] ??
                user.userMetadata?['username'] ??
                user.email?.split('@')[0] ??
                'User';
            userAvatarUrl = profile?['avatar_url'];
            isLoading = false;
          });
        }
      }
    } catch (e) {
      print('Error loading user data: $e');
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  Future<void> _handleLogout(BuildContext context) async {
    try {
      await _authService.signOut();

      if (context.mounted) {
        Navigator.pushNamedAndRemoveUntil(
          context,
          '/sign-in',
          (route) => false,
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Logout failed: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Profile",
          style: whiteTextStyle.copyWith(fontSize: 16, fontWeight: semiBold),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        children: [
          buildProfile(),
          buildContainer(),
          buildAccount(),
          buildGeneral(),
          buildMore(),
          SizedBox(height: 40),
          CustomButton.outlined(
            title: "Log Out",
            width: double.infinity,
            onPressed: () => _handleLogout(context),
          ),
          SizedBox(height: 50),
        ],
      ),
    );
  }

  Widget buildProfile() {
    return Container(
      margin: const EdgeInsets.only(top: 24),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(color: softColor, width: 1),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Row(
                children: [
                  userAvatarUrl != null && userAvatarUrl!.isNotEmpty
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: CachedNetworkImage(
                            imageUrl: userAvatarUrl!,
                            height: 40,
                            width: 40,
                            fit: BoxFit.cover,
                            placeholder: (context, url) => Container(
                              height: 40,
                              width: 40,
                              decoration: BoxDecoration(
                                color: darkGreyColor,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Center(
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: darkBlueAccent,
                                ),
                              ),
                            ),
                            errorWidget: (context, url, error) => Image.asset(
                              "assets/images/ic-profile-image.png",
                              height: 40,
                            ),
                          ),
                        )
                      : Image.asset(
                          "assets/images/ic-profile-image.png",
                          height: 40,
                        ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          userName,
                          style: whiteTextStyle.copyWith(
                            fontSize: 16,
                            fontWeight: semiBold,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          userEmail,
                          style: greyTextStyle.copyWith(
                            fontSize: 12,
                            fontWeight: medium,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Center(
              child: SvgPicture.asset(
                'assets/icons-white/edit1.svg',
                width: 24,
                height: 24,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildContainer() {
    return Container(
      width: double.infinity,
      height: 120,
      margin: const EdgeInsets.only(top: 24),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        image: const DecorationImage(
          fit: BoxFit.cover,
          image: AssetImage("assets/images/profile_banner.png"),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 36,
            width: 36,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: whiteColor.withAlpha(50),
            ),
            child: Center(
              child: SvgPicture.asset(
                'assets/icons-white/champ.svg',
                width: 24,
                height: 24,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "Premium Member",
                  style: whiteTextStyle.copyWith(
                    fontSize: 16,
                    fontWeight: semiBold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  "New movies are coming for you, Download Now!",
                  style: whiteTextStyle.copyWith(
                    fontSize: 14,
                    fontWeight: regular,
                    overflow: TextOverflow.ellipsis,
                  ),
                  maxLines: 2,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildAccount() {
    return Container(
      margin: const EdgeInsets.only(top: 24),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(color: softColor, width: 1),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Account",
              style: whiteTextStyle.copyWith(
                fontSize: 18,
                fontWeight: semiBold,
              ),
            ),
            const SizedBox(height: 24),
            Column(
              spacing: 6,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          height: 36,
                          width: 36,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                            color: whiteColor.withAlpha(50),
                          ),
                          child: Center(
                            child: SvgPicture.asset(
                              'assets/icons-white/person.svg',
                              width: 24,
                              height: 24,
                            ),
                          ),
                        ),
                        SizedBox(width: 16),
                        Text(
                          "Member",
                          style: whiteTextStyle.copyWith(
                            fontSize: 14,
                            fontWeight: medium,
                          ),
                        ),
                      ],
                    ),
                    Icon(Icons.arrow_forward_ios_rounded, color: whiteColor),
                  ],
                ),

                Divider(
                  color: softColor,
                  thickness: 2,
                  indent: 1,
                  endIndent: 1,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          height: 36,
                          width: 36,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                            color: whiteColor.withAlpha(50),
                          ),
                          child: Center(
                            child: SvgPicture.asset(
                              'assets/icons-white/padlock 1.svg',
                              width: 24,
                              height: 24,
                            ),
                          ),
                        ),
                        SizedBox(width: 16),
                        Text(
                          "Change Password",
                          style: whiteTextStyle.copyWith(
                            fontSize: 14,
                            fontWeight: medium,
                          ),
                        ),
                      ],
                    ),
                    Icon(Icons.arrow_forward_ios_rounded, color: whiteColor),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget buildGeneral() {
    return Container(
      margin: const EdgeInsets.only(top: 24),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(color: softColor, width: 1),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "General",
              style: whiteTextStyle.copyWith(
                fontSize: 18,
                fontWeight: semiBold,
              ),
            ),
            const SizedBox(height: 24),
            Column(
              spacing: 6,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          height: 36,
                          width: 36,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                            color: whiteColor.withAlpha(50),
                          ),
                          child: Center(
                            child: SvgPicture.asset(
                              'assets/icons-white/notification.svg',
                              width: 24,
                              height: 24,
                            ),
                          ),
                        ),
                        SizedBox(width: 16),
                        Text(
                          "Notification",
                          style: whiteTextStyle.copyWith(
                            fontSize: 14,
                            fontWeight: medium,
                          ),
                        ),
                      ],
                    ),
                    Icon(Icons.arrow_forward_ios_rounded, color: whiteColor),
                  ],
                ),
                Divider(
                  color: softColor,
                  thickness: 2,
                  indent: 1,
                  endIndent: 1,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          height: 36,
                          width: 36,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                            color: whiteColor.withAlpha(50),
                          ),
                          child: Center(
                            child: SvgPicture.asset(
                              'assets/icons-white/globe.svg',
                              width: 24,
                              height: 24,
                            ),
                          ),
                        ),
                        SizedBox(width: 16),
                        Text(
                          "Language",
                          style: whiteTextStyle.copyWith(
                            fontSize: 14,
                            fontWeight: medium,
                          ),
                        ),
                      ],
                    ),
                    Icon(Icons.arrow_forward_ios_rounded, color: whiteColor),
                  ],
                ),
                Divider(
                  color: softColor,
                  thickness: 2,
                  indent: 1,
                  endIndent: 1,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          height: 36,
                          width: 36,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                            color: whiteColor.withAlpha(50),
                          ),
                          child: Center(
                            child: SvgPicture.asset(
                              'assets/icons-white/finish.svg',
                              width: 24,
                              height: 24,
                            ),
                          ),
                        ),
                        SizedBox(width: 16),
                        Text(
                          "Country",
                          style: whiteTextStyle.copyWith(
                            fontSize: 14,
                            fontWeight: medium,
                          ),
                        ),
                      ],
                    ),
                    Icon(Icons.arrow_forward_ios_rounded, color: whiteColor),
                  ],
                ),
                Divider(
                  color: softColor,
                  thickness: 2,
                  indent: 1,
                  endIndent: 1,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          height: 36,
                          width: 36,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                            color: whiteColor.withAlpha(50),
                          ),
                          child: Center(
                            child: SvgPicture.asset(
                              'assets/icons-white/trash.svg',
                              width: 24,
                              height: 24,
                            ),
                          ),
                        ),
                        SizedBox(width: 16),
                        Text(
                          "Clear Cache",
                          style: whiteTextStyle.copyWith(
                            fontSize: 14,
                            fontWeight: medium,
                          ),
                        ),
                      ],
                    ),
                    Icon(Icons.arrow_forward_ios_rounded, color: whiteColor),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget buildMore() {
    return Container(
      margin: const EdgeInsets.only(top: 24),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(color: softColor, width: 1),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "More",
              style: whiteTextStyle.copyWith(
                fontSize: 18,
                fontWeight: semiBold,
              ),
            ),
            const SizedBox(height: 24),
            Column(
              spacing: 6,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          height: 36,
                          width: 36,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                            color: whiteColor.withAlpha(50),
                          ),
                          child: Center(
                            child: SvgPicture.asset(
                              'assets/icons-white/shield.svg',
                              width: 24,
                              height: 24,
                            ),
                          ),
                        ),
                        SizedBox(width: 16),
                        Text(
                          "Legal and Policies",
                          style: whiteTextStyle.copyWith(
                            fontSize: 14,
                            fontWeight: medium,
                          ),
                        ),
                      ],
                    ),
                    Icon(Icons.arrow_forward_ios_rounded, color: whiteColor),
                  ],
                ),
                Divider(
                  color: softColor,
                  thickness: 2,
                  indent: 1,
                  endIndent: 1,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          height: 36,
                          width: 36,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                            color: whiteColor.withAlpha(50),
                          ),
                          child: Center(
                            child: SvgPicture.asset(
                              'assets/icons-white/question.svg',
                              width: 24,
                              height: 24,
                            ),
                          ),
                        ),
                        SizedBox(width: 16),
                        Text(
                          "Help & Feedback",
                          style: whiteTextStyle.copyWith(
                            fontSize: 14,
                            fontWeight: medium,
                          ),
                        ),
                      ],
                    ),
                    Icon(Icons.arrow_forward_ios_rounded, color: whiteColor),
                  ],
                ),
                Divider(
                  color: softColor,
                  thickness: 2,
                  indent: 1,
                  endIndent: 1,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          height: 36,
                          width: 36,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                            color: whiteColor.withAlpha(50),
                          ),
                          child: Center(
                            child: SvgPicture.asset(
                              'assets/icons-white/alert.svg',
                              width: 24,
                              height: 24,
                            ),
                          ),
                        ),
                        SizedBox(width: 16),
                        Text(
                          "About Us",
                          style: whiteTextStyle.copyWith(
                            fontSize: 14,
                            fontWeight: medium,
                          ),
                        ),
                      ],
                    ),
                    Icon(Icons.arrow_forward_ios_rounded, color: whiteColor),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
