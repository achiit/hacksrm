import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_home/english/common/app_theme.dart';
import 'package:smart_home/english/features/auth/views/get_started_view.dart';
import 'package:smart_home/english/features/home/views/mainscreen.dart';
import 'package:smart_home/english/features/oboarding/onboarding_view.dart';
import 'package:smart_home/language_selection.dart';
import 'package:smart_home/tamil/features/auth/views/livestreamfeed.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({Key? key});

  Future<Widget> _checkLoggedIn() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
    if (!isLoggedIn) {
      // Navigate to onboarding page
      return OnboardingView();
    } else {
      // Navigate to home page
      return /* MyHomePage() */ LivestreamPage();
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.system,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      // home: LanguageSelectionBody(),
      home: FutureBuilder<Widget>(
        future: _checkLoggedIn(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          } else if (snapshot.hasError) {
            return Scaffold(
              body: Center(
                child: Text('Error: ${snapshot.error}'),
              ),
            );
          } else {
            return snapshot.data ?? Container();
          }
        },
      ),
    );
  }
}
