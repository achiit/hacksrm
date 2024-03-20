import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:smart_home/animations/fade_in_slide.dart';
import 'package:smart_home/english/common/loading_overlay.dart';
import 'package:smart_home/english/common/text_style_ext.dart';
import 'package:smart_home/english/features/auth/views/forgot_password_view.dart';
import 'package:smart_home/english/features/home/views/mainscreen.dart';
import 'package:smart_home/tamil/features/auth/widgets/widgets.dart';
import 'package:smart_home/tamil/features/home/views/deepfake_screen.dart';

class SignInView extends StatefulWidget {
  const SignInView({super.key});

  @override
  State<SignInView> createState() => _SignInViewState();
}

class _SignInViewState extends State<SignInView> {
  ValueNotifier<bool> termsCheck = ValueNotifier(false);

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
              duration: .4,
              child: Text(
                "Welcome Back! 👋",
                style: context.hm!.copyWith(fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 15),
            FadeInSlide(
              duration: .5,
              child: Text(
                "Kavalar Eye",
                style: context.tm,
              ),
            ),
            const SizedBox(height: 25),
            FadeInSlide(
              duration: .6,
              child: Text(
                "E-Mail",
                style: context.tm!.copyWith(fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 10),
            const FadeInSlide(duration: .6, child: EmailField()),
            const SizedBox(height: 20),
            FadeInSlide(
              duration: .7,
              child: Text(
                "Password",
                style: context.tm!.copyWith(fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 10),
            const FadeInSlide(duration: .7, child: PasswordField()),
            const SizedBox(height: 20),
            FadeInSlide(
              duration: .8,
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
                  Text("Remember Me", style: context.tm),
                  const Spacer(),
                  TextButton(
                    onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ForgotPasswordView())),
                    child: const Text("Forgot Password?"),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
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
              duration: 1,
              child: LoginButton(
                icon: Brand(Brands.google, size: 25),
                text: "Continue With Google",
                onPressed: () {},
              ),
            ),
            SizedBox(height: height * 0.02),
          ]
          // .animate(interval: 10.ms).slide(
          //     begin: const Offset(0, -40),
          //     end: Offset.zero,
          //     // curve: Curves.easeOut,
          //     duration: 1200.ms,
          //     delay: 200.ms),
          ),
      bottomNavigationBar: FadeInSlide(
        duration: 1,
        direction: FadeSlideDirection.btt,
        child: Container(
          padding:
              const EdgeInsets.only(bottom: 40, left: 20, right: 20, top: 30),
          decoration: const BoxDecoration(
            border: Border(
              top: BorderSide(width: .2, color: Colors.grey),
            ),
          ),
          child: FilledButton(
            onPressed: () async {
              print("hello");
              LoadingScreen.instance()
                  .show(context: context, text: "Sign In...");
              await Future.delayed(const Duration(seconds: 1));
              for (var i = 0; i <= 100; i++) {
                LoadingScreen.instance().show(context: context, text: '$i...');
                await Future.delayed(const Duration(milliseconds: 10));
              }
              LoadingScreen.instance()
                  .show(context: context, text: "Signed In Successfully");
              await Future.delayed(const Duration(seconds: 1));
              LoadingScreen.instance().hide();

              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => MyHomePage()));
            },
            style: FilledButton.styleFrom(
              fixedSize: const Size(double.infinity, 50),
            ),
            child: const Text(
              "Sign In",
              style: TextStyle(fontWeight: FontWeight.w900),
            ),
          ),
        ),
      ),
    );
  }
}
