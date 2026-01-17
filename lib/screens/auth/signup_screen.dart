import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/widgets/custom_textfield.dart';
import '../../core/widgets/gradient_button.dart';
import '../../utils/validators.dart';
import 'auth_controller.dart';

class SignupScreen extends ConsumerStatefulWidget {
  const SignupScreen({super.key});

  @override
  ConsumerState<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends ConsumerState<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void dispose() {
    nameController.dispose();
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

  Future<void> _handleSignUp() async {
    // Validate form
    if (!_formKey.currentState!.validate()) {
      return;
    }

    try {
      await ref.read(authControllerProvider.notifier).signUp(
            nameController.text.trim(),
            emailController.text.trim(),
            passwordController.text.trim(),
          );

      if (mounted) {
        _showSuccess('Account created successfully!');
        // Wait a bit before navigating back
        await Future.delayed(const Duration(milliseconds: 500));
        if (mounted) {
          Navigator.pop(context);
        }
      }
    } catch (e) {
      // Handle different types of errors
      String errorMessage = 'Failed to create account. Please try again.';
      
      // Check for rate limit errors
      if (e.toString().contains('rate limit') || 
          e.toString().contains('429') ||
          e.toString().contains('over_email_send_rate_limit')) {
        errorMessage = 'Too many signup attempts. Please wait a few minutes before trying again.';
        _showError(errorMessage, durationSeconds: 5);
        return; // Return early to avoid showing error twice
      } else if (e.toString().contains('row-level security policy') || 
          e.toString().contains('RLS') ||
          e.toString().contains('42501')) {
        errorMessage = 'Database configuration error. Please run the SQL from supabase_rls_policy.sql in your Supabase SQL Editor.';
        print('Database Setup Required: Run the SQL trigger from supabase_rls_policy.sql file in Supabase SQL Editor.');
      } else if (e.toString().contains('User already registered') ||
          e.toString().contains('already registered')) {
        errorMessage = 'This email is already registered. Please sign in instead.';
      } else if (e.toString().contains('Invalid email')) {
        errorMessage = 'Please enter a valid email address.';
      } else if (e.toString().contains('Password')) {
        errorMessage = 'Password does not meet requirements.';
      } else if (e.toString().contains('duplicate key')) {
        errorMessage = 'This email is already registered.';
      } else if (e.toString().isNotEmpty) {
        // Clean up the error message for display
        errorMessage = e.toString()
            .replaceAll('Exception: ', '')
            .replaceAll('AuthApiException(message: ', '')
            .replaceAll(', statusCode: 429, code: over_email_send_rate_limit)', '')
            .trim();
      }

      _showError(errorMessage);
    }
  }

  @override
  Widget build(BuildContext context) {
    final loading = ref.watch(authControllerProvider);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: const BackButton(),
      ),
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
                  const Icon(Icons.person_add_alt_1, size: 64),
                  const SizedBox(height: 16),
                  const Text(
                    "Create Account",
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  const Text("Start building your personal quote vault"),

                  const SizedBox(height: 32),
                  CustomTextField(
                    hint: "Full Name",
                    icon: Icons.person,
                    controller: nameController,
                    validator: Validators.name,
                  ),
                  const SizedBox(height: 16),
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

                  const SizedBox(height: 32),
                  GradientButton(
                    title: "Create Account",
                    loading: loading,
                    onTap: _handleSignUp,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
