import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../core/services/auth_service.dart';

final authServiceProvider = Provider<AuthService>((ref) {
  return AuthService();
});

final authStateProvider = StreamProvider<AuthState>((ref) {
  return ref.read(authServiceProvider).authStateChanges;
});
