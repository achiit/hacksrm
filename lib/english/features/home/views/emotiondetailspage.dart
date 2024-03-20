import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:smart_home/animations/fade_in_slide.dart';

class EmotionDetailsPage extends StatelessWidget {
  final Map<String, dynamic> emotionData;

  EmotionDetailsPage({required this.emotionData});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Emotion Details'),
      ),
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: emotionData.entries.map((entry) {
            String user = entry.key;
            String emotionDetails = entry.value;

            // Parse emotion details
            List<String> emotions = emotionDetails.split('\n');
            List<Widget> progressBars = [];

            // Build progress bars for each emotion
            for (String emotion in emotions) {
              // Split emotion name and percentage
              List<String> parts = emotion.split('-');
              String emotionName = parts[0].trim();
              double percentage =
                  double.parse(parts[1].replaceAll('%', '').trim()) / 100;

              // Add linear progress bar
              progressBars.add(
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                          '$emotionName: ${(percentage * 100).toStringAsFixed(0)}%'),
                      LinearProgressIndicator(
                        value: percentage,
                        backgroundColor: Colors.grey[300],
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                      ),
                    ],
                  ),
                ),
              );
            }

            return FadeInSlide(
              duration: 0.7,
              child: Card(
                elevation: 4.0,
                margin: EdgeInsets.symmetric(vertical: 8.0),
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'User: $user',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 8.0),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: progressBars,
                      ),
                    ],
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
