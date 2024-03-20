import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:smart_home/animations/fade_in_slide.dart';
import 'package:smart_home/common/loading_overlay.dart';
import 'package:smart_home/english/features/home/views/emotiondetailspage.dart';
import 'package:smart_home/tamil/common/app_colors.dart';

class ChatAnalyzerScreen extends StatefulWidget {
  @override
  _ChatAnalyzerScreenState createState() => _ChatAnalyzerScreenState();
}

class _ChatAnalyzerScreenState extends State<ChatAnalyzerScreen> {
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
      allowedExtensions: ['txt'],
    );

    if (result != null) {
      setState(() {
        _selectedFile = File(result.files.single.path!);
      });
    }
  }

  Future<void> _extractChats() async {
    print("started the extraction");
    if (_selectedFile == null ||
        dateTime == null ||
        dateTime2 == null ||
        dateTime!.isAfter(dateTime2!)) {
      Fluttertoast.showToast(
          msg:
              "oops! The start date and time can't be smaller than the end date and time. Try changing the values.",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          textColor: Colors.white,
          fontSize: 16.0);
      return;
    }

    // Extract start and end date
    String startDate = '${dateTime!.day}/${dateTime!.month}/${dateTime!.year}';
    String endDate = '${dateTime2!.day}/${dateTime2!.month}/${dateTime2!.year}';

    // Extract start and end time
    String startTime =
        '${dateTime!.hour.toString().padLeft(2, '0')}:${dateTime!.minute.toString().padLeft(2, '0')}';
    String endTime =
        '${dateTime2!.hour.toString().padLeft(2, '0')}:${dateTime2!.minute.toString().padLeft(2, '0')}';
    print("start date: $startDate");
    print("end date: $endDate");
    print("start time: $startTime");
    print("end time: $endTime");
    // Prepare the request body
    var request = http.MultipartRequest(
      'POST',
      Uri.parse('https://textextractor.onrender.com/upload'),
    );
    request.fields['start_date'] = startDate;
    request.fields['start_time'] = startTime;
    request.fields['end_date'] = endDate;
    request.fields['end_time'] = endTime;

    // Attach the file to the request
    var fileStream = http.ByteStream(_selectedFile!.openRead());
    var length = await _selectedFile!.length();
    var multipartFile = http.MultipartFile(
      'file',
      fileStream,
      length,
      filename: 'chat_file.txt',
    );
    request.files.add(multipartFile);

    // Send the request
    var response = await request.send();

    // Read and print the response
    var responseBody = await response.stream.bytesToString();

    print('Response: $responseBody');
    Map<String, dynamic> parsedResponse = json.decode(responseBody);

    // Navigate to EmotionDetailsPage with emotion data
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            EmotionDetailsPage(emotionData: parsedResponse['emotion']),
      ),
    );
  }

  Future<String> _getFileContent() async {
    if (_selectedFile == null) {
      return 'No file selected';
    }
    // Read the content of the file
    try {
      final content = await _selectedFile!.readAsString();
      // Display only the first few characters, adjust the length as needed
      return content.length > 50 ? content.substring(0, 400) + "..." : content;
    } catch (e) {
      return 'Error reading file: $e';
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
        title: Text('Emotion Detector'),
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
          "Analyze Chats",
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
                                icon: Icon(Icons.upload),
                                iconSize: screenWidth * 0.15,
                              ),
                              SizedBox(height: screenWidth * 0.05),
                              Text(
                                'Drag and Drop a .txt File Here. You can export your chats from WhatsApp.',
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
                                  'Browse .txt File',
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
                                      "Preview of the file content",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 30,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    FutureBuilder<String>(
                                      future:
                                          _getFileContent(), // Function to get file content
                                      builder: (context, snapshot) {
                                        if (snapshot.connectionState ==
                                            ConnectionState.waiting) {
                                          return CircularProgressIndicator(); // Display a loader while reading the file
                                        }
                                        if (snapshot.hasError) {
                                          return Text(
                                              'Error: ${snapshot.error}');
                                        }
                                        return Text(
                                          snapshot.data ??
                                              'No file selected', // Display file content or default message
                                        );
                                      },
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
              FadeInSlide(
                duration: 0.4,
                child: Text(
                  "Select the start date and start time to analyze the chats",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(height: 10.0),
              FadeInSlide(
                duration: 0.5,
                child: FilledButton(
                  onPressed: pickdatetime,
                  child: Text(
                    dateTime == null
                        ? "Select Date"
                        : " ${dateTime!.day}/${dateTime!.month}/${dateTime!.year} ${dateTime!.hour}:${dateTime!.minute}",
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20.0),
              FadeInSlide(
                duration: 0.6,
                child: Text(
                  "Select the end date and end time to analyze the chats",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(height: 10.0),
              FadeInSlide(
                duration: 0.7,
                child: FilledButton(
                  onPressed: pickdatetime2,
                  child: Text(
                    dateTime == null
                        ? "Select Date"
                        : " ${dateTime2!.day}/${dateTime2!.month}/${dateTime2!.year} ${dateTime2!.hour}:${dateTime2!.minute}",
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20.0),
            ],
          ),
        ),
      ),
    );
  }

  Future<DateTime?> pickDate() => showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(1990, 8),
        lastDate: DateTime.now(),
      );

  Future<TimeOfDay?> pickTime() => showTimePicker(
        context: context,
        initialTime: TimeOfDay(hour: dateTime!.hour, minute: dateTime!.minute),
      );

  Future pickdatetime() async {
    DateTime? date = await pickDate();
    if (date == null) return;
    TimeOfDay? time = await pickTime();
    if (time == null) return;
    final dateTime = DateTime(
      date.year,
      date.month,
      date.day,
      time.hour,
      time.minute,
    );
    setState(
      () => this.dateTime = dateTime,
    );
  }

  void request() async {
    LoadingScreen.instance().show(context: context, text: "Analyzing...");
    await _extractChats() /* Future.delayed(const Duration(seconds: 5)) */;
    for (var i = 0; i <= 100; i++) {
      LoadingScreen.instance().show(context: context, text: '$i...');
      await Future.delayed(const Duration(milliseconds: 10));
    }
    LoadingScreen.instance()
        .show(context: context, text: "Extracted Successfully");
    await Future.delayed(const Duration(seconds: 1));
    LoadingScreen.instance().hide();
  }

  //FOR SECOND
  Future<DateTime?> pickDate2() => showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(1990, 8),
        lastDate: DateTime.now(),
      );

  Future<TimeOfDay?> pickTime2() => showTimePicker(
        context: context,
        initialTime:
            TimeOfDay(hour: dateTime2!.hour, minute: dateTime2!.minute),
      );

  Future pickdatetime2() async {
    DateTime? date = await pickDate2();
    if (date == null) return;
    TimeOfDay? time = await pickTime2();
    if (time == null) return;
    final dateTime1 = DateTime(
      date.year,
      date.month,
      date.day,
      time.hour,
      time.minute,
    );
    setState(
      () => dateTime2 = dateTime1,
    );
  }
}
