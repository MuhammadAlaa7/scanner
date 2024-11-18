import 'package:document_scanner/upload/screens/scan_document_screen.dart';
import 'package:flutter/material.dart';

class UploadOptions extends StatelessWidget {
  const UploadOptions({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ListTile(
          leading: const Icon(Icons.camera_alt),
          title: const Text("تصوير مستند"),
          onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const DocumentScannerScreen())),
        ),
        ListTile(
          leading: const Icon(Icons.videocam),
          title: const Text("تصوير فيديو"),
          //onTap: () => recordVideo(context),
        ),
        ListTile(
          leading: const Icon(Icons.photo_library),
          title: const Text("المعرض"),
          //onTap: () => openGallery(context),
        ),
        ListTile(
          leading: const Icon(Icons.mic),
          title: const Text("تسجيل صوتي"),
          //onTap: () => recordAudio(context),
        ),
      ],
    );
  }
}
