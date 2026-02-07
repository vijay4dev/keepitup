import 'dart:io';
import 'dart:ui';

import 'package:external_path/external_path.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class PdfListScreen extends StatefulWidget {
  const PdfListScreen({super.key});

  @override
  State<PdfListScreen> createState() => _PdfListScreenState();
}

class _PdfListScreenState extends State<PdfListScreen> {
  List<File> pdfs = [];
  bool loading = true;
  bool permissionDenied = false;

  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    final granted = await requestPermission();
    if (!granted) {
      setState(() {
        permissionDenied = true;
        loading = false;
      });
      return;
    }

    final files = await scanAllPdfs();
    setState(() {
      pdfs = files;
      loading = false;
    });
  }

  Future<bool> requestPermission() async {
    if (await Permission.manageExternalStorage.isGranted) {
      return true;
    }
    final result = await Permission.manageExternalStorage.request();
    return result.isGranted;
  }

  Future<List<File>> scanAllPdfs() async {
    List<File> pdfFiles = [];

    final downloadsPath =
        await ExternalPath.getExternalStoragePublicDirectory(
            ExternalPath.DIRECTORY_DOWNLOAD);

    final dir = Directory(downloadsPath);
    if (!dir.existsSync()) return pdfFiles;

    final files = dir.listSync(recursive: true);
    for (var file in files) {
      if (file.path.toLowerCase().endsWith('.pdf')) {
        pdfFiles.add(File(file.path));
      }
    }
    return pdfFiles;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("All Device PDFs")),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : permissionDenied
              ? const Center(
                  child: Text(
                    "Storage permission required.\nPlease allow ALL FILES access.",
                    textAlign: TextAlign.center,
                  ),
                )
              : pdfs.isEmpty
                  ? const Center(child: Text("No PDFs Found"))
                  : ListView.builder(
                      itemCount: pdfs.length,
                      itemBuilder: (context, index) {
                        final file = pdfs[index];
                        return ListTile(
                          leading: const Icon(Icons.picture_as_pdf,
                              color: Colors.red),
                          title: Text(file.path.split('/').last),
                        );
                      },
                    ),
    );
  }
}
