import 'dart:convert';
import 'dart:ui';


import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;
import 'package:smart_home/tamil/common/app_colors.dart';

class ChromeExtensionScreen extends StatefulWidget {
  @override
  _ChromeExtensionScreenState createState() => _ChromeExtensionScreenState();
}

class _ChromeExtensionScreenState extends State<ChromeExtensionScreen> {
  List<Map<String, dynamic>> data = [];
  bool isLoading = true; // Track loading state

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    try {
      final response = await http
          .get(Uri.parse('https://extension-j14g.onrender.com/api/data'));
      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        setState(() {
          data = List<Map<String, dynamic>>.from(
              jsonData.map((item) => Map<String, dynamic>.from(item)));
          isLoading = false; // Data loaded, set loading state to false
        });
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      print('Error: $e');
      setState(() {
        isLoading = false; // Error occurred, set loading state to false
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Data from Chrome Extension'),
      ),
      body: isLoading
          ? Center(
              child:
                  SpinKitFadingCircle(color: AppColors.primarycream, size: 60),
            ) // Show loading indicator while data is loading
          : Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 35.0, vertical: 20),
              child: ListView.builder(
                itemCount: data.length,
                itemBuilder: (context, index) {
                  final imageUrl = data[index]['url'];
                  final imageClass = data[index]['class'] ?? 'Unknown';
                  final isBlur = data[index]['isBlur'] ?? true;

                  return Column(
                    children: <Widget>[
                      Stack(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(15),
                            child: isBlur
                                ? ImageFiltered(
                                    imageFilter:
                                        ImageFilter.blur(sigmaY: 7, sigmaX: 7),
                                    child: Image.network(
                                      imageUrl,
                                    ),
                                  )
                                : Image.network(
                                    imageUrl,
                                  ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Align(
                                alignment: Alignment.center,
                                child: IconButton(
                                    onPressed: () {
                                      setState(() {
                                        data[index]['isBlur'] = !isBlur;
                                      });
                                    },
                                    icon: Icon(
                                      Icons.remove_red_eye,
                                      size: 30,
                                      color: AppColors.primarycream,
                                    )),
                              ),
                              Align(
                                alignment: Alignment.center,
                                child: IconButton(
                                    onPressed: () {
                                      Clipboard.setData(
                                          ClipboardData(text: imageUrl));
                                    },
                                    icon: Icon(
                                      Icons.copy,
                                      size: 30,
                                      color: AppColors.primarycream,
                                    )),
                              ),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(height: 20),
                      Text(
                        imageClass == "gore"
                            ? 'The content has high violence and gore'
                            : 'The content involves pornography',
                        style: TextStyle(fontSize: 20),
                      ),
                      Divider(),
                    ],
                  );
                },
              ),
            ),
    );
  }
}
