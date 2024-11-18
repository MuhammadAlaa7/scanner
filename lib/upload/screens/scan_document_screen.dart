import 'dart:developer';
import 'dart:io';

import 'package:cunning_document_scanner/cunning_document_scanner.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class DocumentScannerScreen extends StatefulWidget {
  const DocumentScannerScreen({super.key});

  @override
  State<DocumentScannerScreen> createState() => _DocumentScannerScreenState();
}

class _DocumentScannerScreenState extends State<DocumentScannerScreen> {
  bool isLoading = false;
  List<String> scannedImagePaths = [];

  Future<void> requestPermissions() async {
    if (await Permission.camera.request().isGranted) {
      log('Permissions allowed successfully.');
    } else {
      log('Permissions denied.');
    }
  }

  Future<void> scanDocument() async {
    try {
      log('Scanning document...');
      await requestPermissions();

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

          // Add the saved file path to the list
          scannedImagePaths.add(filePath);
        }
      }
    } catch (e) {
      log('Error scanning document: $e');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Scan Document"),
        centerTitle: true,
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Column(
              children: [
                ElevatedButton(
                  onPressed: () => scanDocument(),
                  child: const Text("Scan Document"),
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: scannedImagePaths.isEmpty
                      ? const Center(child: Text("No scanned images yet."))
                      : ListView.builder(
                          itemCount: scannedImagePaths.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Image.file(
                                File(scannedImagePaths[index]),
                                fit: BoxFit.cover,
                                height: 200,
                              ),
                            );
                          },
                        ),
                ),
              ],
            ),
    );
  }
}
