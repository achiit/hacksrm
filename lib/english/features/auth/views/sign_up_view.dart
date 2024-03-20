import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:path/path.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_home/animations/fade_in_slide.dart';
import 'package:smart_home/english/common/loading_overlay.dart';
import 'package:smart_home/english/common/text_style_ext.dart';
import 'package:smart_home/english/features/auth/views/sign_in_view.dart';
import 'package:smart_home/english/features/auth/views/test.dart';
import 'package:smart_home/english/features/home/views/mainscreen.dart';
import 'package:smart_home/tamil/features/auth/widgets/widgets.dart';
import 'package:sqflite/sqflite.dart';

class SignUpView extends StatefulWidget {
  const SignUpView({super.key});

  @override
  State<SignUpView> createState() => _SignUpViewState();
}

class _SignUpViewState extends State<SignUpView> {
  ValueNotifier<bool> termsCheck = ValueNotifier(false);
  Future<void> _handleSignIn(BuildContext context) async {
    final GoogleSignIn googleSignIn = GoogleSignIn();
    final GoogleSignInAccount? googleUser = await googleSignIn.signIn();

    if (googleUser != null) {
      try {
        // Get Google Sign-In authentication credentials
        final GoogleSignInAuthentication googleAuth =
            await googleUser.authentication;

        // Create Firebase credential with Google Sign-In authentication token
        final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );

        // Sign in to Firebase with the Google credential
        final UserCredential userCredential =
            await FirebaseAuth.instance.signInWithCredential(credential);

        // Save login state
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setBool('isLoggedIn', true);

        // Save user data to Sqflite
        await _saveUserData(userCredential.user!.displayName!);

        // Navigate to sign-up view
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => /*  SignUpView() */ /* UserDataScreen() */
                  MyHomePage()),
        );

        print('User signed in: ${userCredential.user!.displayName}');
      } catch (e) {
        print('Error signing in with Google: $e');
      }
    }
  }

  Future<void> _saveUserData(String name) async {
    // Open database
    final database = openDatabase(
      // Set the path to the database
      join(await getDatabasesPath(), 'user_database.db'),
      // When the database is first created, create a table to store user data
      onCreate: (db, version) {
        return db.execute(
          "CREATE TABLE users(id INTEGER PRIMARY KEY, name TEXT)",
        );
      },
      // Set the version. This executes the onCreate function and provides a path
      version: 1,
    );

    // Insert the user data into the database
    final db = await database;
    await db.insert(
      'users',
      {'name': name},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }
  // Future<void> _handleSignIn() async {
  //   final GoogleSignIn googleSignIn = GoogleSignIn();
  //   final GoogleSignInAccount? googleUser = await googleSignIn.signIn();

  //   if (googleUser != null) {
  //     try {
  //       // Get Google Sign-In authentication credentials
  //       final GoogleSignInAuthentication googleAuth =
  //           await googleUser.authentication;

  //       // Create Firebase credential with Google Sign-In authentication token
  //       final AuthCredential credential = GoogleAuthProvider.credential(
  //         accessToken: googleAuth.accessToken,
  //         idToken: googleAuth.idToken,
  //       );

  //       // Sign in to Firebase with the Google credential
  //       final UserCredential userCredential =
  //           await FirebaseAuth.instance.signInWithCredential(credential);

  //       // Save login state
  //       SharedPreferences prefs = await SharedPreferences.getInstance();
  //       await prefs.setBool('isLoggedIn', true);

  //       // Navigate to sign-up view
  //       Navigator.push(
  //         context,
  //         MaterialPageRoute(builder: (context) => MyHomePage()),
  //       );

  //       print('User signed in: ${userCredential.user!.displayName}');
  //     } catch (e) {
  //       print('Error signing in with Google: $e');
  //     }
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.sizeOf(context).height;
    final isDark = MediaQuery.platformBrightnessOf(context) == Brightness.dark;

    return Scaffold(
      appBar: AppBar(),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        children: [
          const SizedBox(height: 20),
          FadeInSlide(
            duration: .1,
            child: Text(
              "Kavalar Eye",
              style: context.hm!.copyWith(fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 15),
          FadeInSlide(
            duration: .2,
            child: Text(
              "One stop solution for all cyber tools",
              style: context.tm,
            ),
          ),
          const SizedBox(height: 25),
          FadeInSlide(
            duration: .3,
            child: Text(
              "E-Mail",
              style: context.tm!.copyWith(fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 10),
          const FadeInSlide(
            duration: .4,
            child: EmailField(),
          ),
          const SizedBox(height: 20),
          FadeInSlide(
            duration: .5,
            child: Text(
              "Password",
              style: context.tm!.copyWith(fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 10),
          const FadeInSlide(
            duration: .6,
            child: PasswordField(),
          ),
          const SizedBox(height: 20),
          FadeInSlide(
            duration: .7,
            child: Row(
              children: [
                ValueListenableBuilder(
                  valueListenable: termsCheck,
                  builder: (context, value, child) {
                    return CupertinoCheckbox(
                      inactiveColor: isDark ? Colors.white : Colors.black87,
                      value: value,
                      onChanged: (_) {
                        termsCheck.value = !termsCheck.value;
                      },
                    );
                  },
                ),
                Expanded(
                  child: RichTwoPartsText(
                    text1: "I agree to the ",
                    text2: "terms.",
                    onTap: () {},
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          FadeInSlide(
            duration: .8,
            child: RichTwoPartsText(
              text1: "Don't have an Account?",
              text2: " Sign In.",
              onTap: () {
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => SignInView()),
                    (route) => false);
              },
            ),
          ),
          const SizedBox(height: 30),
          FadeInSlide(
            duration: .9,
            child: Row(
              children: [
                const Expanded(
                    child: Divider(
                  thickness: .3,
                )),
                Text(
                  "   or   ",
                  style: context.tm,
                ),
                const Expanded(
                    child: Divider(
                  thickness: .3,
                )),
              ],
            ),
          ),
          const SizedBox(height: 20),
          FadeInSlide(
            duration: 1.0,
            child: LoginButton(
              icon: Brand(Brands.google, size: 25),
              text: "Continue with Google",
              onPressed: () {
                _handleSignIn(context);
              },
            ),
          ),
          SizedBox(height: height * 0.02),
        ],
      ),
      // persistentFooterAlignment: AlignmentDirectional.center,
      bottomNavigationBar: FadeInSlide(
        duration: 1,
        direction: FadeSlideDirection.btt,
        child: Container(
          padding:
              const EdgeInsets.only(bottom: 40, left: 20, right: 20, top: 30),
          decoration: const BoxDecoration(
            border: Border(
              top: BorderSide(width: .2, color: Colors.white),
            ),
          ),
          child: FilledButton(
            onPressed: () async {
              LoadingScreen.instance()
                  .show(context: context, text: "Creating Account...");
              await Future.delayed(const Duration(seconds: 1));
              for (var i = 0; i <= 100; i++) {
                LoadingScreen.instance().show(context: context, text: '$i...');
                await Future.delayed(const Duration(milliseconds: 10));
              }
              LoadingScreen.instance()
                  .show(context: context, text: "Making things ready.");
              await Future.delayed(const Duration(seconds: 1));
              LoadingScreen.instance().hide();
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => SignInView()),
                  (route) => false);
            },
            style: FilledButton.styleFrom(
              fixedSize: const Size(double.infinity, 50),
            ),
            child: const Text(
              "Sign Up",
              style: TextStyle(fontWeight: FontWeight.w900),
            ),
          ),
        ),
      ),
    );
  }
}
