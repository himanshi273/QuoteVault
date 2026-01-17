import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/widgets/custom_textfield.dart';
import '../../core/widgets/gradient_button.dart';
import '../../utils/validators.dart';
import 'auth_controller.dart';
import 'signup_screen.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void _showError(String message, {int durationSeconds = 3}) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Colors.red,
          duration: Duration(seconds: durationSeconds),
        ),
      );
    }
  }

  void _showSuccess(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Colors.green,
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  Future<void> _handleLogin() async {
    // Validate form
    if (!_formKey.currentState!.validate()) {
      return;
    }

    try {
      await ref.read(authControllerProvider.notifier).login(
            emailController.text.trim(),
            passwordController.text.trim(),
          );

      if (mounted) {
        _showSuccess('Login successful!');
        // Navigation will be handled by AuthGate based on auth state
      }
    } catch (e) {
      // Handle different types of errors
      String errorMessage = 'Failed to sign in. Please try again.';
      
      // Check for rate limit errors
      if (e.toString().contains('rate limit') || 
          e.toString().contains('429') ||
          e.toString().contains('over_email_send_rate_limit')) {
        errorMessage = 'Too many login attempts. Please wait a few minutes before trying again.';
        _showError(errorMessage, durationSeconds: 5);
        return;
      } else if (e.toString().contains('Invalid login credentials') ||
          e.toString().contains('invalid_credentials') ||
          e.toString().contains('Invalid email or password')) {
        errorMessage = 'Invalid email or password. Please check your credentials and try again.';
      } else if (e.toString().contains('Email not confirmed') ||
          e.toString().contains('email_not_confirmed')) {
        errorMessage = 'Please verify your email address before signing in.';
      } else if (e.toString().contains('User not found')) {
        errorMessage = 'No account found with this email. Please sign up instead.';
      } else if (e.toString().isNotEmpty) {
        // Clean up the error message for display
        errorMessage = e.toString()
            .replaceAll('Exception: ', '')
            .replaceAll('AuthApiException(message: ', '')
            .trim();
      }

      _showError(errorMessage);
    }
  }

  @override
  Widget build(BuildContext context) {
    final loading = ref.watch(authControllerProvider);

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 40),
                  const Icon(Icons.auto_awesome, size: 64),
                  const SizedBox(height: 16),
                  const Text(
                    "Welcome Back",
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  const Text("Sign in to continue your journey"),

                  const SizedBox(height: 32),
                  CustomTextField(
                    hint: "Email",
                    icon: Icons.email,
                    controller: emailController,
                    keyboardType: TextInputType.emailAddress,
                    validator: Validators.email,
                  ),
                  const SizedBox(height: 16),
                  CustomTextField(
                    hint: "Password",
                    icon: Icons.lock,
                    isPassword: true,
                    controller: passwordController,
                    validator: Validators.password,
                  ),

                  const SizedBox(height: 12),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {
                        // TODO: Implement forgot password functionality
                        _showError('Forgot password feature coming soon!');
                      },
                      child: const Text("Forgot password?"),
                    ),
                  ),

                  const SizedBox(height: 24),
                  GradientButton(
                    title: "Sign In",
                    loading: loading,
                    onTap: _handleLogin,
                  ),

                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Don't have an account? "),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const SignupScreen(),
                            ),
                          );
                        },
                        child: const Text(
                          "Sign up",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
