import 'dart:io';
import 'dart:ui';

import 'package:external_path/external_path.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:keepitup/screens/pdfviewscreen.dart';
import 'package:keepitup/utils/Appcolors.dart';
import 'package:keepitup/utils/extensions.dart';
import 'package:keepitup/widgets/fab_button.dart';
import 'package:keepitup/widgets/pdf_list_item.dart';
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

    final downloadsPath = await ExternalPath.getExternalStoragePublicDirectory(
      ExternalPath.DIRECTORY_DOWNLOAD,
    );

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
      backgroundColor: Appcolors.app_bg_color,
      appBar: AppBar(
        title: Text(
          "Documents",
          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 34),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.add),
            style: ElevatedButton.styleFrom(
              elevation: 5,
              shadowColor: Appcolors.app_blue_color.withOpacity(0.3),
              iconColor: Colors.white,
              padding: EdgeInsets.all(5),
              backgroundColor: Appcolors.app_blue_color,
            ),
          ),
          10.ww,
          IconButton(
            onPressed: () {},
            icon: Icon(CupertinoIcons.gear),
            style: ElevatedButton.styleFrom(
              iconColor: Colors.black,
              padding: EdgeInsets.all(5),
              backgroundColor: const Color.fromARGB(234, 243, 244, 246),
            ),
          ),
        ],
      ),
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
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: pdfs.length,
                    itemBuilder: (context, index) {
                      final file = pdfs[index];

                      return PdfListItem(
                        file: file,
                        subtitle: "This document contains the ...",
                        tags: const ["Work", "Invoice"],
                        date: "Jan 28, 2026",
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => PdfDetailScreen(file: file),
                            ),
                          );
                        },
                        onMoreTap: () {
                          // TODO: show bottom sheet
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
      floatingActionButton: RotatingFab(
        onTap: () async {
          setState(() => loading = true);
          final files = await scanAllPdfs();
          setState(() {
            pdfs = files;
            loading = false;
          });
        },
      ),
    );
  }
}
