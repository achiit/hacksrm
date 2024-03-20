import 'package:flutter/material.dart';
import 'package:smart_home/animations/fade_in_slide.dart';
import 'package:smart_home/common/carousel.dart';
import 'package:smart_home/common/customwidgettool.dart';
import 'package:smart_home/english/features/home/views/chromscreen.dart';
import 'package:smart_home/tamil/features/home/views/emotionscreen.dart';
import 'package:smart_home/tamil/features/home/views/deepfake_screen.dart';

class ServicesPage extends StatelessWidget {
  final List<Map<String, dynamic>> itemList = [
    {
      'imagePath': "assets/images/onboard1Dark1 (2).png",
      'animationPath': "assets/images/search.json",
      'text': "Deepfake Detection",
      'onPressed': (BuildContext context) {
        // Navigation example
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => DeepfakeScreen()),
        );
      },
    },
    {
      'imagePath': "assets/images/second.png",
      'animationPath': "assets/images/emotion.json",
      'text': "Emotion Extraction",
      'onPressed': (BuildContext context) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ChatAnalyzerScreen()),
        );
      },
    },
    {
      'imagePath': "assets/images/obscene.png",
      'animationPath': "assets/images/content block4.json",
      'text': "Chrome Extension",
      'onPressed': (BuildContext context) {
       
        // Navigator.push(
        //   context,
        //   MaterialPageRoute(builder: (context) => ChromeExtensionScreen()),
        // );
      },
    },
    // Add more items as needed
  ];
  final List<String> photoUrls = [
    'assets/carousel1.png',
    'assets/carousel2.png',
    'assets/carousel3.png',
  ];
  List<Widget> widgetList = [
    Image.asset(
      'assets/images/carousel1.png', // Replace with your image URL
      fit: BoxFit.cover,
      width: double.infinity,
      height: double.infinity,
    ),
    Image.asset(
      'assets/images/carousel2.png', // Replace with your image URL
      fit: BoxFit.cover,
      width: double.infinity,
      height: double.infinity,
    ),
    Image.asset(
      'assets/images/carousel3.png', // Replace with your image URL
      fit: BoxFit.cover,
      width: double.infinity,
      height: double.infinity,
    ),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 2,
        leading: Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.asset('assets/images/logo2.png')),
        ),
        title: Text(
          'காவலர் கண்',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 30,
          ),
        ),
        automaticallyImplyLeading: false,
      ),
      body: Column(
        children: [
          SizedBox(height: 10),
          FadeInSlide(
              duration: 1,
              child: AutoRotatingCarousel(
                  widgetList: widgetList, photoUrls: photoUrls)),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              children: [
                Row(
                  children: [
                    FadeInSlide(
                      duration: 1.4,
                      child: Text(
                        "சைபர் கருவிகள்",
                        textAlign: TextAlign.start,
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 7),
            child: SizedBox(
              height: 170,
              child: ListView.separated(
                separatorBuilder: (context, index) => const SizedBox(width: 12),
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                itemCount: itemList.length, // Number of items in the list
                itemBuilder: (context, index) {
                  final item = itemList[index];
                  // Return the CustomLottieWidget for each item
                  return CustomLottieWidget(
                    imagePath: item['imagePath']!,
                    animationPath: item['animationPath']!,
                    text: item['text']!,
                    onPressed: () {
                      item['onPressed'](
                          context); // Pass context to onPressed function
                    },
                  );
                },
              ),
            ),
          )
        ],
      ),
    );
  }
}
