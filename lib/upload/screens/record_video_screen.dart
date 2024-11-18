// import 'dart:io';

// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:video_player/video_player.dart';

// class VideoRecorderScreen extends StatefulWidget {
//   const VideoRecorderScreen({Key? key}) : super(key: key);

//   @override
//   _VideoRecorderScreenState createState() => _VideoRecorderScreenState();
// }

// class _VideoRecorderScreenState extends State<VideoRecorderScreen> {
 

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Video Recorder'),
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             if (_videoFile != null && _videoPlayerController != null)
//               Column(
//                 children: [
//                   const Text(
//                     'Recorded Video:',
//                     style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//                   ),
//                   const SizedBox(height: 10),
//                   _videoPlayerController!.value.isInitialized
//                       ? AspectRatio(
//                           aspectRatio:
//                               _videoPlayerController!.value.aspectRatio,
//                           child: VideoPlayer(_videoPlayerController!),
//                         )
//                       : const CircularProgressIndicator(),
//                   ElevatedButton(
//                     onPressed: () {
//                       setState(() {
//                         _videoPlayerController!.value.isPlaying
//                             ? _videoPlayerController!.pause()
//                             : _videoPlayerController!.play();
//                       });
//                     },
//                     child: Icon(
//                       _videoPlayerController!.value.isPlaying
//                           ? Icons.pause
//                           : Icons.play_arrow,
//                     ),
//                   ),
//                 ],
//               )
//             else
//               const Text(
//                 'No video recorded yet.',
//                 style: TextStyle(fontSize: 16),
//               ),
//             const SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: _getVideo,
//               child: const Text('Record Video'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
