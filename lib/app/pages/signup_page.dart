import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:template_project_flutter/app/core/theme/theme.dart';
import 'package:template_project_flutter/app/data/services/auth_service.dart';
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

  Future<void> _handleSignUp() async {
    if (!validate()) {
      _showError('Please fill all fields');
      return;
    }

    if (passwordController.text != confirmPasswordController.text) {
      _showError('Passwords do not match');
      return;
    }

    setState(() => _isLoading = true);

    try {
      await _authService.signUp(
        email: emailController.text.trim(),
        password: passwordController.text,
        username: nameController.text.trim(),
      );

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
