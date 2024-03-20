// import 'package:flutter/material.dart';
// import 'package:icons_plus/icons_plus.dart';
// import 'package:smart_home/animations/fade_in_slide.dart';
// import 'package:smart_home/english/common/app_colors.dart';
// import 'package:smart_home/english/features/auth/views/sign_in_view.dart';
// import 'package:smart_home/english/features/auth/views/sign_up_view.dart';
// import 'package:smart_home/tamil/features/auth/widgets/widgets.dart';

// class GetStartedView extends StatelessWidget {
//   const GetStartedView({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final theme = Theme.of(context);
//     final size = MediaQuery.sizeOf(context);
//     final isDark = MediaQuery.platformBrightnessOf(context) == Brightness.dark;
//     final height = size.height;
//     return Scaffold(
//       body: SafeArea(
//         minimum: const EdgeInsets.symmetric(horizontal: 20),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           crossAxisAlignment: CrossAxisAlignment.stretch,
//           children: [
//             const Spacer(),
//             FadeInSlide(
//               duration: .4,
//               child: Image.asset(
//                 "assets/images/logo2.png",
//                 height: 200,
//               ),
//             ),
//             const Spacer(),
//             FadeInSlide(
//               duration: .5,
//               child: Text(
//                 "Let's get started",
//                 style: theme.textTheme.headlineMedium!
//                     .copyWith(fontWeight: FontWeight.bold),
//                 textAlign: TextAlign.center,
//               ),
//             ),
//             SizedBox(height: height * 0.015),
//             const FadeInSlide(
//               duration: .6,
//               child: Text(
//                 "Authenticate yourself to continue",
//                 textAlign: TextAlign.center,
//               ),
//             ),
//             const Spacer(),
//             FadeInSlide(
//               duration: .7,
//               child: LoginButton(
//                 icon: Brand(Brands.google, size: 25),
//                 text: "Continue with Google",
//                 onPressed: () {},
//               ),
//             ),
//             SizedBox(height: height * 0.02),
//             const Spacer(),
//             FadeInSlide(
//               duration: 1.1,
//               child: FilledButton(
//                 onPressed: () => Navigator.push(context,
//                     MaterialPageRoute(builder: (context) => SignUpView())),
//                 style: FilledButton.styleFrom(
//                   fixedSize: const Size.fromHeight(50),
//                 ),
//                 child: const Text(
//                   "Sign Up",
//                   style: TextStyle(fontWeight: FontWeight.w900),
//                 ),
//               ),
//             ),
//             SizedBox(height: height * 0.02),
//             FadeInSlide(
//               duration: 1.2,
//               child: FilledButton(
//                 onPressed: () => Navigator.push(context,
//                     MaterialPageRoute(builder: (context) => SignInView())),
//                 style: FilledButton.styleFrom(
//                   fixedSize: const Size.fromHeight(50),
//                   backgroundColor: isDark
//                       ? AppColors.greyColor
//                       : theme.colorScheme.primaryContainer,
//                 ),
//                 child: Text(
//                   "Sign In",
//                   style: TextStyle(
//                     fontWeight: FontWeight.w900,
//                     color: isDark ? Colors.white : AppColors.seedColor,
//                   ),
//                 ),
//               ),
//             ),
//             const Spacer(),
//             const FadeInSlide(
//               duration: 1.0,
//               direction: FadeSlideDirection.btt,
//               child: Column(
//                 mainAxisSize: MainAxisSize.min,
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Text("Privacy Policy"),
//                   Text("   -   "),
//                   Text("Terms of Service"),
//                 ],
//               ),
//             ),
//             SizedBox(height: height * 0.02),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_home/animations/fade_in_slide.dart';
import 'package:smart_home/english/common/app_colors.dart';
import 'package:smart_home/english/features/auth/views/sign_in_view.dart';
import 'package:smart_home/english/features/auth/views/sign_up_view.dart';
import 'package:smart_home/tamil/features/auth/widgets/widgets.dart';

class GetStartedView extends StatelessWidget {
  const GetStartedView({Key? key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;
    final isDark = MediaQuery.of(context).platformBrightness == Brightness.dark;
    final height = size.height;

// Future<void> _handleSignIn() async {
//   final GoogleSignIn googleSignIn = GoogleSignIn();
//   final GoogleSignInAccount? googleUser = await googleSignIn.signIn();

//   if (googleUser != null) {
//     try {
//       // Get Google Sign-In authentication credentials
//       final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

//       // Create Firebase credential with Google Sign-In authentication token
//       final AuthCredential credential = GoogleAuthProvider.credential(
//         accessToken: googleAuth.accessToken,
//         idToken: googleAuth.idToken,
//       );

//       // Sign in to Firebase with the Google credential
//       final UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(credential);

//       // Save login state
//       SharedPreferences prefs = await SharedPreferences.getInstance();
//       await prefs.setBool('isLoggedIn', true);

//       // Navigate to sign-up view
//       Navigator.push(
//         context,
//         MaterialPageRoute(builder: (context) => SignUpView()),
//       );

//       print('User signed in: ${userCredential.user!.displayName}');
//     } catch (e) {
//       print('Error signing in with Google: $e');
//     }
//   }
// }

    return Scaffold(
      body: SafeArea(
        minimum: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Spacer(),
            FadeInSlide(
              duration: .4,
              child: Image.asset(
                "assets/images/logo2.png",
                height: 200,
              ),
            ),
            const Spacer(),
            FadeInSlide(
              duration: .5,
              child: Text(
                "Let's get started",
                style: theme.textTheme.headline6!
                    .copyWith(fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(height: height * 0.015),
            const FadeInSlide(
              duration: .6,
              child: Text(
                "Authenticate yourself to continue",
                textAlign: TextAlign.center,
              ),
            ),
            const Spacer(),
            // FadeInSlide(
            //   duration: .7,
            //   child: LoginButton(
            //     icon: Brand(Brands.google, size: 25),
            //     text: "Continue with Google",
            //     onPressed: () {
            //       // _handleSignIn();
            //     },
            //   ),
            // ),
            // SizedBox(height: height * 0.02),
            const Spacer(),
            FadeInSlide(
              duration: 1.1,
              child: FilledButton(
                onPressed: () => Navigator.push(context,
                    MaterialPageRoute(builder: (context) => SignUpView())),
                style: FilledButton.styleFrom(
                  fixedSize: const Size.fromHeight(50),
                ),
                child: const Text(
                  "Sign Up",
                  style: TextStyle(fontWeight: FontWeight.w900),
                ),
              ),
            ),
            SizedBox(height: height * 0.02),
            FadeInSlide(
              duration: 1.2,
              child: FilledButton(
                onPressed: () => Navigator.push(context,
                    MaterialPageRoute(builder: (context) => SignInView())),
                style: FilledButton.styleFrom(
                  fixedSize: const Size.fromHeight(50),
                  backgroundColor: isDark
                      ? AppColors.greyColor
                      : theme.colorScheme.primaryContainer,
                ),
                child: Text(
                  "Sign In",
                  style: TextStyle(
                    fontWeight: FontWeight.w900,
                    color: isDark ? Colors.white : AppColors.seedColor,
                  ),
                ),
              ),
            ),
            const Spacer(),
            const FadeInSlide(
              duration: 1.3,
              direction: FadeSlideDirection.btt,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Privacy Policy"),
                  Text("   -   "),
                  Text("Terms of Service"),
                ],
              ),
            ),
            SizedBox(height: height * 0.02),
          ],
        ),
      ),
    );
  }
}
