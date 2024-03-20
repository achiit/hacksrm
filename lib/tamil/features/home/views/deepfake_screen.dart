import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:dotted_border/dotted_border.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:smart_home/animations/fade_in_slide.dart';
import 'package:smart_home/common/loading_overlay.dart';
import 'package:smart_home/english/common/app_colors.dart';

class DeepfakeScreen extends StatefulWidget {
  @override
  _DeepfakeScreenState createState() => _DeepfakeScreenState();
}

class _DeepfakeScreenState extends State<DeepfakeScreen> {
  File? _image;
  String _prediction = "fake";
  double _fakeConfidence = 0;
  double _realConfidence = 0;
  bool _loading = false;
  bool _detected = false;
  List<dynamic> faceWithMask = [];

  Future<void> _getImage() async {
    final image = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _image = File(image.path);
      });
    }
  }

  Widget pixelArrayToImage(List<dynamic> pixelArray) {
    List<List<int>> flattenedPixels = [];

    for (var pixelList in pixelArray) {
      for (var pixel in pixelList) {
        flattenedPixels.add(pixel.cast<int>());
      }
    }

    Uint8List uint8list =
        Uint8List.fromList(flattenedPixels.expand((x) => x).toList());
    print(uint8list);
    return Image.memory(
      uint8list,
      fit: BoxFit.contain,
    );
  }

  Future<void> _sendRequest() async {
    setState(() {
      _loading = true;
    });
    print("the image is $_image");
    // Prepare request data
    var uri = Uri.parse('https://achisingh06-cyberhack.hf.space/predict');
    var request = http.MultipartRequest('POST', uri)
      ..files.add(await http.MultipartFile.fromPath('file', _image!.path))
      ..fields['true_label'] = 'true';

    // Send request
    var response = await request.send();

    // Handle response
    if (response.statusCode == 200) {
      var responseData = await response.stream.bytesToString();
      var data = jsonDecode(responseData);
      print("the resulut is $data");
      setState(() {
        _prediction = data['prediction'];
        _fakeConfidence = data['confidences']['fake'];
        _realConfidence = data['confidences']['real'];
        _loading = false;
        faceWithMask = data['face_with_mask'];
        _detected = true;
      });
    } else {
      setState(() {
        _loading = false;
      });
      print('Request failed with status: ${response.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width * 1.13;
    final screenHeight = MediaQuery.of(context).size.height * 1.13;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'டீப்ஃபேக் இமேஜ் டிடெக்டர்',
          style: TextStyle(fontSize: 20),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(screenWidth * 0.05),
        child: Center(
          child: Column(
            children: [
              FadeInSlide(
                duration: 0.7,
                child: DottedBorder(
                  borderType: BorderType.RRect,
                  radius: Radius.circular(20),
                  dashPattern: [12, 12],
                  color: Colors.grey,
                  strokeWidth: 3,
                  child: Container(
                    width: screenWidth * 0.82,
                    height: screenHeight * 0.4,
                    child: _image == null
                        ? Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              IconButton(
                                onPressed: () {},
                                icon: Icon(Icons.upload),
                                iconSize: screenWidth * 0.15,
                              ),
                              SizedBox(height: screenWidth * 0.05),
                              Text(
                                'இங்கே ஒரு படத்தை இழுத்து விடவும்',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: screenWidth * 0.0375,
                                    color: Color(0xfffdf9b3)),
                              ),
                              SizedBox(
                                height: screenWidth * 0.05,
                              ),
                              Text(
                                'OR',
                                style: TextStyle(
                                    fontSize: screenWidth * 0.075,
                                    fontWeight: FontWeight.bold),
                              ),
                              SizedBox(
                                height: screenWidth * 0.05,
                              ),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  fixedSize: Size(
                                      screenWidth * 0.5, screenHeight * 0.05),
                                  backgroundColor: Color(0xfffdf9b3),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                onPressed: _getImage,
                                child: Text(
                                  'படங்களை உலாவவும்',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: screenWidth * 0.0375,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black),
                                ),
                              ),
                            ],
                          )
                        : Stack(
                            children: [
                              Align(
                                alignment: Alignment.center,
                                child: ClipRRect(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(20),
                                        child: Image.file(
                                          _image!,
                                          width: screenWidth * 0.75,
                                          height: screenHeight * 0.38,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Positioned(
                                top: screenWidth * 0.02,
                                right: screenWidth * 0.02,
                                child: IconButton(
                                  onPressed: () {
                                    _image = null;
                                    _detected = false;
                                    setState(() {});
                                  },
                                  icon: Icon(
                                    Icons.delete,
                                    size: screenWidth * 0.06,
                                    color: Colors.red,
                                  ),
                                ),
                              ),
                            ],
                          ),
                  ),
                ),
              ),
              _detected == false
                  ? Expanded(
                      child: FadeInSlide(
                        duration: 0.8,
                        child: Align(
                          alignment: Alignment.bottomCenter,
                          child: FilledButton(
                            onPressed: () async {
                              _image == null
                                  ? Fluttertoast.showToast(
                                      msg:
                                          "படம் எதுவும் தேர்ந்தெடுக்கப்படவில்லை!",
                                      toastLength: Toast.LENGTH_SHORT,
                                      gravity: ToastGravity.CENTER,
                                      timeInSecForIosWeb: 1,
                                      textColor: Colors.white,
                                      fontSize: 16.0)
                                  : request();
                            },
                            style: FilledButton.styleFrom(
                              fixedSize:
                                  Size(screenWidth * 0.6, screenHeight * 0.06),
                              backgroundColor: _image == null
                                  ? Colors.grey
                                  : Color(0xfffdf9b3),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: const Text(
                              "பகுப்பாய்வு",
                              style: TextStyle(
                                  fontWeight: FontWeight.w900, fontSize: 20),
                            ),
                          ),
                        ),
                      ),
                    )
                  : Column(
                      children: [
                        SizedBox(height: screenWidth * 0.05),
                        Text(
                          'கணிப்பு: $_prediction',
                          style: TextStyle(
                            fontSize: screenWidth * 0.05,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: screenWidth * 0.05),
                        Text(
                          'போலி நம்பிக்கை: ${(_fakeConfidence * 100).toStringAsFixed(2)}%',
                          style: TextStyle(
                            fontSize: screenWidth * 0.05,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        LinearProgressIndicator(
                          minHeight: screenWidth * 0.03,
                          borderRadius: BorderRadius.circular(2),
                          value: _fakeConfidence,
                          backgroundColor: AppColors.greyColor,
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
                        ),
                        SizedBox(height: screenWidth * 0.05),
                        Text(
                          'உண்மையான நம்பிக்கை: ${(_realConfidence * 100).toStringAsFixed(2)}%',
                          style: TextStyle(
                            fontSize: screenWidth * 0.04,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        LinearProgressIndicator(
                          minHeight: screenWidth * 0.03,
                          borderRadius: BorderRadius.circular(2),
                          value: _realConfidence,
                          backgroundColor: AppColors.greyColor,
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.green),
                        ),
                        SizedBox(height: screenWidth * 0.1),
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: FilledButton(
                            onPressed: () async {},
                            style: FilledButton.styleFrom(
                              fixedSize:
                                  Size(screenWidth * 0.9, screenHeight * 0.06),
                              backgroundColor: _image == null
                                  ? Colors.grey
                                  : Color(0xfffdf9b3),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: Text(
                              "இந்த படத்தின் விரிவான பகுப்பாய்வைப் பார்க்கவும்.",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: screenWidth * 0.035,
                                  color: Colors.black),
                            ),
                          ),
                        )
                      ],
                    ),
            ],
          ),
        ),
      ),
    );
  }

  void request() async {
    LoadingScreen.instance().show(context: context, text: "கண்டறிதல்...");
    await _sendRequest() /* Future.delayed(const Duration(seconds: 5)) */;
    for (var i = 0; i <= 100; i++) {
      LoadingScreen.instance().show(context: context, text: '$i...');
      await Future.delayed(const Duration(milliseconds: 10));
    }
    LoadingScreen.instance()
        .show(context: context, text: "வெற்றிகரமாக கண்டறியப்பட்டது");
    await Future.delayed(const Duration(seconds: 1));
    LoadingScreen.instance().hide();
  }
}
