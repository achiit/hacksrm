import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class CustomLottieWidget extends StatelessWidget {
  final String animationPath;
  final String imagePath;
  final String text;
  final void Function()? onPressed;
  const CustomLottieWidget({
    Key? key,
    required this.onPressed,
    required this.imagePath,
    required this.animationPath,
    required this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.0),
        border: Border.all(
          color: Colors.white,
          width: 1,
        ),
      ),
      width: 130,
      height: 170,
      child: FilledButton(
        style: FilledButton.styleFrom(
          //fixedSize: Size(170, 170),

          padding: EdgeInsets.all(10),
          backgroundColor:
              Color.fromARGB(255, 80, 63, 237), // Change color as needed
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
        ),
        onPressed: onPressed,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Stack(
              children: [
                Center(
                    child: ClipRRect(
                  borderRadius: BorderRadius.circular(20.0),
                  child: Image.asset(
                    imagePath,
                    height: 100,
                  ),
                )),
                Lottie.asset(
                  animationPath,
                  //height: 1200,
                  fit: BoxFit.cover,
                ),
              ],
            ),
            Flexible(
              child: Text(
                text,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white, 
                ), // Adjust font size as needed
              ),
            ),
          ],
        ),
      ),
    );
  }
}
