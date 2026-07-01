import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:wealthwise/providers/news_provider.dart';

import 'providers/asset_provider.dart';
import 'screens/splash_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: "https://wicgbqzoazarxzlnwsme.supabase.co",
    anonKey:
        "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6IndpY2dicXpvYXphcnh6bG53c21lIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDc4MjgwMzIsImV4cCI6MjA2MzQwNDAzMn0.-n-d39F4HKsYEs_L-WWb84SCONiNoQw1OpXtoo5NRws",
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AssetProvider()..loadAssets()),
        ChangeNotifierProvider(create: (_) => NewsProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'WealthWise',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF4D6B43)),
          useMaterial3: true,
        ),
        home: const SplashWidget(),
      ),
    );
  }
}
