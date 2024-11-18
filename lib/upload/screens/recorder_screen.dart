import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:record/record.dart';
import 'package:audioplayers/audioplayers.dart';
import 'dart:async';
import 'package:path_provider/path_provider.dart';

class AudioRecorderDialog extends StatefulWidget {
  const AudioRecorderDialog({super.key});

  @override
  AudioRecorderDialogState createState() => AudioRecorderDialogState();
}

class AudioRecorderDialogState extends State<AudioRecorderDialog> {
  final AudioRecorder recorder = AudioRecorder();
  final AudioPlayer player = AudioPlayer();

  bool isRecording = false;
  bool isRecordingComplete = false;
  bool isPlaying = false;
  String? recordedFilePath;
  int recordDuration = 0;
  Timer? timer;
  Timer? playbackTimer;

  Future<void> startRecording() async {
    try {
      final directory = await getTemporaryDirectory();
      final path =
          '${directory.path}/recording_${DateTime.now().millisecondsSinceEpoch}.m4a';

      await recorder.start(const RecordConfig(), path: path);

      timer = Timer.periodic(const Duration(seconds: 1), (Timer timer) {
        setState(() {
          recordDuration++;
        });
      });

      setState(() {
        isRecording = true;
        recordedFilePath = path;
        isRecordingComplete = false;
      });
    } catch (e) {
      log('Recording error: $e');
    }
  }

  Future<void> stopRecording() async {
    timer?.cancel();
    final path = await recorder.stop();

    setState(() {
      isRecording = false;
      isRecordingComplete = true;
      recordedFilePath = path;
    });
  }

  Future<void> playRecording() async {
    if (recordedFilePath != null) {
      //*******  Reset record duration to 0 before playback
      setState(() {
        recordDuration = 0;
      });

      // **** Start playback timer
      playbackTimer = Timer.periodic(const Duration(seconds: 1), (Timer t) {
        setState(() {
          recordDuration++;
        });
      });

      await player.play(DeviceFileSource(recordedFilePath!));
      setState(() {
        isPlaying = true;
      });
// *******  Reset record duration to 0 after playback ends
      player.onPlayerComplete.listen((_) {
        playbackTimer?.cancel();
        setState(() {
          isPlaying = false;
          recordDuration = 0;
        });
      });
    }
  }

// *******  stop the playback while listening to the audio
  Future<void> stopPlaying() async {
    playbackTimer?.cancel();
    await player.stop();
    setState(() {
      isPlaying = false;
      recordDuration = 0;
    });
  }

  // *******  confirm the recording ( Done button )
  void confirmRecording() {
    if (recordedFilePath != null) {
      Navigator.of(context).pop(recordedFilePath);
      log('Recorded file successfully saved at path: $recordedFilePath');
      
    }
  }

  String formatDuration(int seconds) {
    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  @override
  void dispose() {
    recorder.dispose();
    player.dispose();
    timer?.cancel();
    playbackTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        padding: const EdgeInsets.all(20),
        margin: const EdgeInsets.symmetric(horizontal: 30),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              isRecording
                  ? 'Recording...'
                  : (isRecordingComplete
                      ? 'Recording Complete'
                      : 'Ready to Record'),
              style: TextStyle(
                fontSize: 20,
                color: isRecording
                    ? Colors.red
                    : (isRecordingComplete ? Colors.green : Colors.black),
              ),
            ),
            const SizedBox(height: 10),
            Text(
              formatDuration(recordDuration),
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 5,
              runSpacing: 5,
              children: [
                ElevatedButton(
                  onPressed: isRecording ? stopRecording : startRecording,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isRecording ? Colors.red : Colors.blue,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 15),
                  ),
                  child: Icon(
                    isRecording ? Icons.stop : Icons.mic,
                    size: 20,
                    color: Colors.white,
                  ),
                ),
                if (isRecordingComplete) ...[
                  // const SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: isPlaying ? stopPlaying : playRecording,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isPlaying ? Colors.grey : Colors.green,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 15),
                    ),
                    child: Icon(
                      isPlaying ? Icons.stop : Icons.play_arrow,
                      size: 20,
                      color: Colors.white,
                    ),
                  ),
                  //    const SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: confirmRecording,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 15),
                    ),
                    child: const Icon(
                      Icons.check,
                      size: 20,
                      color: Colors.white,
                    ),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }
}
