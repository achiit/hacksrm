import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:smart_home/animations/fade_in_slide.dart';
import 'package:smart_home/english/common/loading_overlay.dart';
import 'package:smart_home/english/common/text_style_ext.dart';
import 'package:smart_home/tamil/features/auth/views/sign_in_view.dart';
import 'package:smart_home/tamil/features/auth/widgets/widgets.dart';

class SignUpView extends StatefulWidget {
  const SignUpView({super.key});

  @override
  State<SignUpView> createState() => _SignUpViewState();
}

class _SignUpViewState extends State<SignUpView> {
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
            duration: .1,
            child: Text(
              "காவலர் கண் பதிவு",
              style: context.hm!.copyWith(fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 15),
          FadeInSlide(
            duration: .2,
            child: Text(
              "அனைத்து சைபர் கருவிகளுக்கும் ஒரு நிறுத்த தீர்வு",
              style: context.tm,
            ),
          ),
          const SizedBox(height: 25),
          FadeInSlide(
            duration: .3,
            child: Text(
              "மின்னஞ்சல்",
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
              "கடவுச்சொல்",
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
                    text1: "நான் ஒப்புக்கொள்கிறேன் ",
                    text2: "விதிமுறை",
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
              text1: "ஏற்கனவே ஒரு கணக்கு உள்ளதா?",
              text2: "உள்நுழையவும்",
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
              text: "Google உடன் தொடரவும்",
              onPressed: () {},
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
                  .show(context: context, text: "பதிவு செய்யவும்...");
              await Future.delayed(const Duration(seconds: 1));
              for (var i = 0; i <= 100; i++) {
                LoadingScreen.instance().show(context: context, text: '$i...');
                await Future.delayed(const Duration(milliseconds: 10));
              }
              LoadingScreen.instance().show(
                  context: context, text: "புதிய பயனர் பதிவு செய்துள்ளார்");
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
              "பதிவு செய்யவும்",
              style: TextStyle(fontWeight: FontWeight.w900),
            ),
          ),
        ),
      ),
    );
  }
}
