import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final authControllerProvider = StateNotifierProvider<AuthController, bool>(
  (ref) => AuthController(),
);

class AuthController extends StateNotifier<bool> {
  AuthController() : super(false);

  final _client = Supabase.instance.client;

  Future<void> login(String email, String password) async {
    state = true;
    try {
      await _client.auth.signInWithPassword(email: email, password: password);
    } on AuthException catch (e) {
      throw Exception(e.message);
    } finally {
      state = false;
    }
  }

  Future<void> signUp(String name, String email, String password) async {
    state = true;
    try {
      await _client.auth.signUp(
        email: email,
        password: password,
        data: {'full_name': name},
      );
    } on AuthException catch (e) {
      throw Exception(e.message);
    } finally {
      state = false;
    }
  }

  Future<void> logout() async {
    await _client.auth.signOut();
  }
}
