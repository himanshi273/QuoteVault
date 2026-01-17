import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quote_vault/core/config/supabase_config.dart';
import 'package:quote_vault/screens/auth/auth_gate.dart';
import 'package:quote_vault/screens/splash/splash_screen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'core/theme/theme_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: SupabaseConfig.url,
    anonKey: SupabaseConfig.anonKey,
  );

  runApp(const ProviderScope(child: QuoteVaultApp()));
}

class QuoteVaultApp extends ConsumerWidget {
  const QuoteVaultApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = ref.watch(themeProvider);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      themeMode: theme.mode,
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,
        colorScheme: ColorScheme.fromSeed(
          seedColor: theme.accentColor,
        ),
        textTheme: TextTheme(
          bodyLarge: TextStyle(fontSize: theme.fontSize),
          bodyMedium: TextStyle(fontSize: theme.fontSize - 2),
        ),
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        colorScheme: ColorScheme.fromSeed(
          seedColor: theme.accentColor,
          brightness: Brightness.dark,
        ),
        textTheme: TextTheme(
          bodyLarge: TextStyle(fontSize: theme.fontSize),
          bodyMedium: TextStyle(fontSize: theme.fontSize - 2),
        ),
      ),
      home: const AuthGate(),
    );
  }
}
