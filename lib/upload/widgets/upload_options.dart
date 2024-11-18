import 'dart:developer';
import 'dart:io';
import 'package:cunning_document_scanner/cunning_document_scanner.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

class UploadOptions extends StatefulWidget {
  const UploadOptions({super.key});

  @override
  State<UploadOptions> createState() => _UploadOptionsState();
}

class _UploadOptionsState extends State<UploadOptions> {
  bool isLoading = false;
  //====>>>>> this is the list that holds the paths of the scanned images after they are saved
  List<String> scannedImagePaths = [];

  Future<void> scanDocument() async {
    try {
      log('Scanning document...');

      List<String>? scannedDocs = await CunningDocumentScanner.getPictures();

      if (scannedDocs != null && scannedDocs.isNotEmpty) {
        setState(() {
          isLoading = true;
        });

        // Get the directory
        Directory? dcimDir = await getExternalStorageDirectory();
        String dcimPath =
            '${dcimDir!.parent.parent.parent.parent.path}/DCIM/ScannedDocuments';

        // Create the directory if it doesn't exist
        Directory(dcimPath).createSync(recursive: true);

        for (var i = 0; i < scannedDocs.length; i++) {
          String fileName =
              'Scanned_Document_${DateTime.now().millisecondsSinceEpoch}_${i + 1}.jpg';
          String filePath = '$dcimPath/$fileName';
          File file = File(scannedDocs[i]);
          await file.copy(filePath);

          log('Document saved at $filePath');

          scannedImagePaths.add(filePath);
        }
      }
    } catch (e) {
      log('Error scanning document: $e');
    } finally {
      setState(() {
        isLoading = false;
        log(scannedImagePaths.toString());
      });
    }
  }
//
//

// --- video recorder ---
  final ImagePicker picker = ImagePicker();

  Future<void> getVideo() async {
    final XFile? video = await picker.pickVideo(source: ImageSource.camera);

    if (video != null) {
      log('Video selected successfully: ${video.path}');
    }
  }

// get gallery
  Future<void> openGallery() async {
    final XFile? pickedFile =
        await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      log('Image selected successfully: ${pickedFile.path}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ListTile(
          leading: const Icon(Icons.camera_alt),
          title: const Text("تصوير مستند"),
          onTap: () => scanDocument(),
        ),
        ListTile(
          leading: const Icon(Icons.videocam),
          title: const Text("تصوير فيديو"),
          onTap: () => getVideo(),
        ),
        ListTile(
          leading: const Icon(Icons.photo_library),
          title: const Text("المعرض"),
          onTap: () => openGallery(),
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
