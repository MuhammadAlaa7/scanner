import 'package:document_scanner/upload/widgets/upload_options.dart';
import 'package:flutter/material.dart';

class UploadFileScreen extends StatelessWidget {
  const UploadFileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Upload File Feature"),
        centerTitle: true,
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () => showUploadOptions(context),
          child: const Text("Upload File"),
        ),
      ),
    );
  }
}






void showUploadOptions(BuildContext context) {
  showModalBottomSheet(
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
    ),
    builder: (BuildContext context) {
      return const UploadOptions();
    },
  );
}
