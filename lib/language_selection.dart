import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:smart_home/animations/fade_in_slide.dart';
import 'package:smart_home/common/text_style_ext.dart';
import 'package:smart_home/english/common/app_colors.dart';
import 'package:smart_home/english/features/oboarding/onboarding_view.dart'
    as English;
import 'package:smart_home/tamil/features/oboarding/onboarding_view.dart'
    as Tamil;
// Import your router file

class LanguageSelectionBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        // Background image
        ImageFiltered(
          imageFilter: ImageFilter.blur(sigmaY: 7, sigmaX: 7),
          child: Image.asset(
            'assets/images/3047867.jpg',
            fit: BoxFit.cover,
          ),
        ),
        // Blur effect
        Padding(
          padding: const EdgeInsets.only(bottom: 50.0),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      FadeInSlide(
                        duration: .5,
                        child: Text(
                          "Choose your language",
                          textAlign: TextAlign.center,
                          style: context.tm!.copyWith(
                              fontWeight: FontWeight.bold, fontSize: 30),
                        ),
                      ),
                      FadeInSlide(
                        duration: .5,
                        child: Text(
                          " உங்கள் மொழியை தேர்வு செய்யவும்",
                          textAlign: TextAlign.center,
                          style: context.tm!.copyWith(
                              fontWeight: FontWeight.bold, fontSize: 27),
                        ),
                      ),
                      SizedBox(height: 20),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: FadeInSlide(
                    duration: .6,
                    child: ElevatedButton(
                      onPressed: () {
                        // Handle English language selection

                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                              builder: (context) => English.OnboardingView()),
                          (route) => false,
                        );
                        print('English selected');
                      },
                      style: ElevatedButton.styleFrom(
                        fixedSize:
                            Size(MediaQuery.of(context).size.width * 1, 50),
                        backgroundColor: AppColors.primarycream,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Text(
                        "English",
                        style: context.tm!.copyWith(
                            fontWeight: FontWeight.bold,
                            fontSize: 25,
                            color: Colors.black),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: FadeInSlide(
                    duration: .7,
                    child: ElevatedButton(
                      onPressed: () {
                        // Handle Tamil language selection

                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Tamil.OnboardingView()),
                          (route) => false,
                        );
                        print('Tamil selected');
                      },
                      style: ElevatedButton.styleFrom(
                        fixedSize:
                            Size(MediaQuery.of(context).size.width * 1, 50),
                        backgroundColor: AppColors.primarycream,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Text(
                        'தமிழ்',
                        style: context.tm!.copyWith(
                            fontWeight: FontWeight.bold,
                            fontSize: 25,
                            color: Colors.black),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
