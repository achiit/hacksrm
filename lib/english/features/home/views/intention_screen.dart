import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:file_picker/file_picker.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:smart_home/animations/fade_in_slide.dart';
import 'package:smart_home/common/loading_overlay.dart';
import 'package:smart_home/english/features/home/views/emotiondetailspage.dart';
import 'package:smart_home/tamil/common/app_colors.dart';

class IntentionScreen extends StatefulWidget {
  @override
  _IntentionScreenState createState() => _IntentionScreenState();
}

class _IntentionScreenState extends State<IntentionScreen> {
  File? _selectedFile;
  String _startDate = '';
  String _startTime = '';
  String _endDate = '';
  String _endTime = '';
  List<String> _extractedChats = [];
  DateTime? dateTime = DateTime(2022, 1, 1, 0, 0);
  DateTime? dateTime2 = DateTime(2021, 1, 1, 0, 0);
  Future<void> _selectFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['zip'],
    );

    if (result != null) {
      setState(() {
        _selectedFile = File(result.files.single.path!);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final hour = dateTime!.hour.toString().padLeft(2, '0');
    final minutes = dateTime!.minute.toString().padLeft(2, '0');
    final screenWidth = MediaQuery.of(context).size.width * 1.13;
    final screenHeight = MediaQuery.of(context).size.height * 1.13;
    return Scaffold(
      appBar: AppBar(
        title: Text('Intention Detector'),
      ),
      bottomNavigationBar: FilledButton(
        onPressed: () async {
          _selectedFile == null && dateTime!.isAfter(dateTime2!)
              ? Fluttertoast.showToast(
                  msg: "No file is Selected!",
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.CENTER,
                  timeInSecForIosWeb: 1,
                  textColor: Colors.white,
                  fontSize: 16.0)
              : request();
        },
        style: FilledButton.styleFrom(
          fixedSize: Size(screenWidth * 0.6, screenHeight * 0.05),
          backgroundColor:
              _selectedFile == null && dateTime!.isAfter(dateTime2!)
                  ? Colors.grey
                  : AppColors.primarycream,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: const Text(
          "Upload",
          style: TextStyle(
            fontWeight: FontWeight.w900,
            fontSize: 20,
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              FadeInSlide(
                duration: 0.3,
                child: DottedBorder(
                  borderType: BorderType.RRect,
                  radius: Radius.circular(20),
                  dashPattern: [12, 12],
                  color: Colors.grey,
                  strokeWidth: 3,
                  child: Container(
                    padding: EdgeInsets.all(20.0),
                    width: screenWidth * 0.82,
                    height: screenHeight * 0.4,
                    child: _selectedFile == null
                        ? Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              IconButton(
                                onPressed: () {},
                                icon: Icon(Icons.folder_zip),
                                iconSize: screenWidth * 0.15,
                              ),
                              SizedBox(height: screenWidth * 0.05),
                              Text(
                                'Drag and Drop a .zip File Here. ',
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
                                onPressed: _selectFile,
                                child: Text(
                                  'Browse .zip File',
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
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      "Click on upload option below to get the images classified as Pornography or Gore",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 30,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Positioned(
                                top: screenWidth * 0.02,
                                right: screenWidth * 0.02,
                                child: IconButton(
                                  onPressed: () {
                                    // _image = null;
                                    // _detected = false;
                                    _selectedFile = null;
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
              SizedBox(height: 20.0),
              _extractedChats.isNotEmpty &&
                      int.parse(_extractedChats[1].split(': ')[1]) == 0 &&
                      int.parse(_extractedChats[2].split(': ')[1]) == 0
                  ? Text(
                      "The folder doesn't have any pornographic or gore contents",
                      textAlign: TextAlign.center,
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    )
                  : _buildPieChart(
                      _extractedChats.isNotEmpty
                          ? int.parse(_extractedChats[1].split(': ')[1])
                          : 0,
                      _extractedChats.isNotEmpty
                          ? int.parse(_extractedChats[2].split(': ')[1])
                          : 0,
                    ),
              SizedBox(height: 20.0),
            ],
          ),
        ),
      ),
    );
  }

// Inside _IntentionScreenState class
  Widget _buildPieChart(int goreCount, int pornPicsCount) {
    return Container(
      height: 250,
      width: 300,
      child: PieChart(
        PieChartData(
          sections: [
            PieChartSectionData(
              color: AppColors.primarycream,
              value: goreCount.toDouble(),
              title: 'Gore',
              titleStyle: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.bold),
              radius: 80,
            ),
            PieChartSectionData(
              color: AppColors.primaryred,
              value: pornPicsCount.toDouble(),
              title: 'Porn',
              titleStyle: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold),
              radius: 80,
            ),
          ],
          centerSpaceRadius: 40,
          sectionsSpace: 0,
          startDegreeOffset: -90,
        ),
      ),
    );
  }

  void request() async {
    LoadingScreen.instance().show(context: context, text: "Analyzing...");

    // Make sure _selectedFile is not null
    if (_selectedFile != null) {
      try {
        var request = http.MultipartRequest('POST',
            Uri.parse('https://fca5-182-72-145-34.ngrok-free.app/upload'));
        request.files.add(await http.MultipartFile.fromPath(
            'file', _selectedFile!.path)); // Add your file with file field

        var streamedResponse = await request.send();
        var response = await http.Response.fromStream(streamedResponse);

        if (response.statusCode == 200) {
          var responseData = jsonDecode(response.body);
          // Assuming your response structure is similar to the provided example
          print(responseData);
          setState(() {
            _extractedChats.clear(); // Clear previous chats
            _extractedChats
                .add('Annotated Zip: ${responseData['annotated_zip']}');
            _extractedChats
                .add('Gore Count: ${responseData['counts']['gore']}');
            _extractedChats
                .add('Pornpics Count: ${responseData['counts']['pornpics']}');
            _extractedChats.add('Message: ${responseData['message']}');
          });
        } else {
          print('Request failed with status: ${response.statusCode}.');
          // Handle error response
        }
      } catch (e) {
        print('Error: $e');
        // Handle error
      }
    } else {
      Fluttertoast.showToast(
        msg: "No file is Selected!",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    }

    LoadingScreen.instance().hide();
  }

  //FOR SECOND
}
