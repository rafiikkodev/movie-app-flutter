import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:template_project_flutter/app/core/theme/theme.dart';
import 'package:template_project_flutter/app/data/services/auth_service.dart';
import 'package:template_project_flutter/app/data/services/storage_service.dart';
import 'package:template_project_flutter/widgets/buttons.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final nameController = TextEditingController(text: "");
  final emailController = TextEditingController(text: "");
  final passwordController = TextEditingController(text: "");
  final confirmPasswordController = TextEditingController(text: "");
  final AuthService _authService = AuthService();
  final StorageService _storageService = StorageService();
  final ImagePicker _imagePicker = ImagePicker();

  File? _selectedImage;
  bool _isLoading = false;

  bool validate() {
    if (nameController.text.isEmpty ||
        emailController.text.isEmpty ||
        passwordController.text.isEmpty ||
        confirmPasswordController.text.isEmpty) {
      return false;
    }
    return true;
  }

  // Pick image from gallery
  Future<void> _pickImage() async {
    try {
      final XFile? pickedFile = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 85,
      );

      if (pickedFile != null) {
        setState(() {
          _selectedImage = File(pickedFile.path);
        });
      }
    } catch (e) {
      _showError('Failed to pick image: $e');
    }
  }

  Future<void> _handleSignUp() async {
    if (!validate()) {
      _showError('Please fill all fields');
      return;
    }

    if (passwordController.text != confirmPasswordController.text) {
      _showError('Passwords do not match');
      return;
    }

    // VALIDASI WAJIB UPLOAD FOTO
    if (_selectedImage == null) {
      _showError('Please select a profile picture');
      return;
    }

    setState(() => _isLoading = true);

    try {
      // 1. Signup user dulu untuk dapat user ID
      final authResponse = await _authService.signUp(
        email: emailController.text.trim(),
        password: passwordController.text,
        username: nameController.text.trim(),
      );

      if (authResponse.user == null) {
        throw Exception('Failed to create user');
      }

      final userId = authResponse.user!.id;

      // 2. Upload foto profil ke Supabase Storage
      final avatarUrl = await _storageService.uploadAvatar(
        userId: userId,
        imageFile: _selectedImage!,
      );

      // 3. Update profile dengan avatar URL
      await Supabase.instance.client
          .from('profiles')
          .update({
            'avatar_url': avatarUrl,
            'updated_at': DateTime.now().toIso8601String(),
          })
          .eq('id', userId);

      if (mounted) {
        _showSuccess('Account created successfully!');
        Navigator.pushReplacementNamed(context, '/sign-in');
      }
    } on AuthException catch (e) {
      _showError(e.message);
    } catch (e) {
      _showError('An error occurred. Please try again.');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }

  void _showSuccess(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.green),
    );
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: darkBackgroundColor,
      body: _isLoading
          ? Center(child: CircularProgressIndicator(color: darkBlueAccent))
          : SafeArea(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                children: [
                  const SizedBox(height: 60),
                  // Logo/Title
                  Text(
                    'MOVIE APP',
                    style: whiteTextStyle.copyWith(
                      fontSize: 32,
                      fontWeight: bold,
                      letterSpacing: 2,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 60),
                  Text(
                    'Create Account',
                    style: whiteTextStyle.copyWith(
                      fontSize: 24,
                      fontWeight: semiBold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Join us to discover amazing movies',
                    style: greyTextStyle.copyWith(
                      fontSize: 14,
                      fontWeight: medium,
                    ),
                  ),
                  const SizedBox(height: 30),
                  // Form Container
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: softColor,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // PROFILE PICTURE PICKER
                        Center(
                          child: Column(
                            children: [
                              Text(
                                'Profile Picture',
                                style: whiteTextStyle.copyWith(
                                  fontSize: 14,
                                  fontWeight: medium,
                                ),
                              ),
                              const SizedBox(height: 12),
                              GestureDetector(
                                onTap: _pickImage,
                                child: Container(
                                  width: 120,
                                  height: 120,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: darkGreyColor,
                                    border: Border.all(
                                      color: _selectedImage == null
                                          ? greyColor
                                          : darkBlueAccent,
                                      width: 2,
                                    ),
                                    image: _selectedImage != null
                                        ? DecorationImage(
                                            image: FileImage(_selectedImage!),
                                            fit: BoxFit.cover,
                                          )
                                        : null,
                                  ),
                                  child: _selectedImage == null
                                      ? Icon(
                                          Icons.add_a_photo,
                                          size: 40,
                                          color: greyColor,
                                        )
                                      : null,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                _selectedImage == null
                                    ? 'Tap to select photo *'
                                    : 'Tap to change photo',
                                style: greyTextStyle.copyWith(fontSize: 12),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 24),
                        _buildFormField(
                          title: 'Full Name',
                          controller: nameController,
                        ),
                        const SizedBox(height: 16),
                        _buildFormField(
                          title: 'Email',
                          controller: emailController,
                          keyboardType: TextInputType.emailAddress,
                        ),
                        const SizedBox(height: 16),
                        _buildFormField(
                          title: 'Password',
                          controller: passwordController,
                          obscureText: true,
                        ),
                        const SizedBox(height: 16),
                        _buildFormField(
                          title: 'Confirm Password',
                          controller: confirmPasswordController,
                          obscureText: true,
                        ),
                        const SizedBox(height: 30),
                        CustomButton.primary(
                          title: 'Sign Up',
                          width: double.infinity,
                          fontSize: 16,
                          onPressed: _handleSignUp,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 30),
                  // Sign In Link
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Already have an account? ',
                        style: greyTextStyle.copyWith(fontSize: 14),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.pushReplacementNamed(context, '/sign-in');
                        },
                        child: Text(
                          'Sign In',
                          style: darkBlueTextStyle.copyWith(
                            fontSize: 14,
                            fontWeight: semiBold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),
                ],
              ),
            ),
    );
  }

  Widget _buildFormField({
    required String title,
    required TextEditingController controller,
    bool obscureText = false,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: whiteTextStyle.copyWith(fontSize: 14, fontWeight: medium),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          obscureText: obscureText,
          keyboardType: keyboardType,
          style: whiteTextStyle.copyWith(fontSize: 14),
          decoration: InputDecoration(
            filled: true,
            fillColor: darkGreyColor,
            hintText: 'Enter your $title',
            hintStyle: greyTextStyle.copyWith(fontSize: 14),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ),
          ),
        ),
      ],
    );
  }
}
