import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:smart_home/animations/fade_in_slide.dart';
import 'package:smart_home/english/common/app_colors.dart';
import 'package:smart_home/tamil/features/auth/views/sign_in_view.dart';
import 'package:smart_home/tamil/features/auth/views/sign_up_view.dart';
import 'package:smart_home/tamil/features/auth/widgets/widgets.dart';

class GetStartedView extends StatelessWidget {
  const GetStartedView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.sizeOf(context);
    final isDark = MediaQuery.platformBrightnessOf(context) == Brightness.dark;
    final height = size.height;
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
                "assets/images/logo.png",
                height: 100,
              ),
            ),
            const Spacer(),
            FadeInSlide(
              duration: .5,
              child: Text(
                "தொடங்குவோம்",
                style: theme.textTheme.headlineMedium!
                    .copyWith(fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(height: height * 0.015),
            const FadeInSlide(
              duration: .6,
              child: Text(
                "உங்கள் கணக்கில் நுழைவோம்",
                textAlign: TextAlign.center,
              ),
            ),
            const Spacer(),
            FadeInSlide(
              duration: .7,
              child: LoginButton(
                icon: Brand(Brands.google, size: 25),
                text: "Google உடன் தொடரவும்",
                onPressed: () {},
              ),
            ),
            SizedBox(height: height * 0.02),
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
                  "பதிவு செய்யவும்",
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
                  "உள்நுழையவும்",
                  style: TextStyle(
                    fontWeight: FontWeight.w900,
                    color: isDark ? Colors.white : AppColors.seedColor,
                  ),
                ),
              ),
            ),
            const Spacer(),
            const FadeInSlide(
              duration: 1.0,
              direction: FadeSlideDirection.btt,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("தனியுரிமைக் கொள்கை"),
                  Text("   -   "),
                  Text("சேவை விதிமுறைகள்"),
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
