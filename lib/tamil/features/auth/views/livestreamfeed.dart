// import 'package:flutter/material.dart';
// import 'package:flutter_inappwebview/flutter_inappwebview.dart';

// class LivestreamPage extends StatelessWidget {
//   const LivestreamPage({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Livestream'),
//       ),
//       body: InAppWebView(
//         initialUrlRequest: URLRequest(url: WebUri.uri(Uri.parse('https://118c-115-241-201-77.ngrok-free.app/'))),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class LivestreamPage extends StatelessWidget {
  const LivestreamPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Create a VideoPlayerController for the live stream.
    final videoPlayerController = VideoPlayerController.network(
      'https://118c-115-241-201-77.ngrok-free.app/',
    );

    // Initialize the VideoPlayerController.
    videoPlayerController.initialize();

    // Create a VideoPlayer widget and pass the VideoPlayerController to it.
    final videoPlayer = VideoPlayer(videoPlayerController);

    // Build the UI for the LivestreamPage.
    return Scaffold(
      appBar: AppBar(
        title: const Text('Livestream'),
      ),
      body: Center(
        child: videoPlayer,
      ),
    );
  }
}