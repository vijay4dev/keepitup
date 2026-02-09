import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:keepitup/screens/pdfviewscreen.dart';
import 'package:keepitup/screens/settings_screen.dart';
import 'package:keepitup/services/navigation_service.dart';
import 'package:keepitup/services/pdf_scanne_services.dart';
import 'package:keepitup/utils/Appcolors.dart';
import 'package:keepitup/utils/extensions.dart';
import 'package:keepitup/widgets/fab_button.dart';
import 'package:keepitup/widgets/pdf_list_item.dart';
import 'package:keepitup/widgets/tag_chips.dart';

class PdfListScreen extends StatefulWidget {
  final List<File> initialPdfs;
  final bool permissionDenied;

  const PdfListScreen({
    super.key,
    required this.initialPdfs,
    required this.permissionDenied,
  });

  @override
  State<PdfListScreen> createState() => _PdfListScreenState();
}

class _PdfListScreenState extends State<PdfListScreen> {
  late List<File> pdfs;
  bool loading = false;

  @override
  void initState() {
    super.initState();
    pdfs = widget.initialPdfs;
  }

  Future<void> refreshScan() async {
    setState(() => loading = true);
    final files = await PdfScanService.scanAllPdfs();
    setState(() {
      pdfs = files;
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Appcolors.app_bg_color,
      appBar: AppBar(
        actionsPadding: const EdgeInsets.all(10),
        title: const Text(
          "Documents",
          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 34),
        ),
        actions: [
          IconButton(
            onPressed: () => NavigationService.push(SettingsScreen(onBack: NavigationService.pop)),
            icon: const Icon(CupertinoIcons.gear_solid , size: 25,),
            style: ElevatedButton.styleFrom(
              iconColor: Colors.black,
              padding: const EdgeInsets.all(5),
              backgroundColor: Color.fromARGB(234, 243, 244, 246),
              shape: CircleBorder()
            ),
          ),
        ],
      ),

      body: loading
          ? const Center(child: CircularProgressIndicator())
          : widget.permissionDenied
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
                        /// 🔍 Search + Tags
                        Container(
                          padding: const EdgeInsets.all(15),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border(
                              bottom: BorderSide(
                                width: 0.5,
                                color: Colors.black.withOpacity(0.1),
                              ),
                            ),
                          ),
                          child: Column(
                            children: [
                             SearchBar(
                        hintText: "Search Documents.....",
                        constraints: BoxConstraints(minHeight: 50),
                        hintStyle: WidgetStatePropertyAll(
                          TextStyle(color: Colors.black.withOpacity(0.5)),
                        ),
                        leading: Icon(
                          Icons.search,
                          color: Colors.black.withOpacity(0.5),
                        ),
                        backgroundColor: WidgetStatePropertyAll(
                          const Color.fromARGB(255, 241, 241, 241),
                        ),
                        elevation: WidgetStatePropertyAll(0),
                        padding: WidgetStatePropertyAll(
                          EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                        ),
                        shape: WidgetStatePropertyAll(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadiusGeometry.all(
                              Radius.circular(10),
                            ),
                          ),
                        ),
                      ),
                              15.hh,
                              TagChips(
                                tags: const ["All", "Work", "Invoice"],
                                onChanged: (tag) {},
                              ),
                            ],
                          ),
                        ),

                        /// 📄 PDF List
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
                                  NavigationService.push(PdfDetailScreen(file: file));
                                },
                                onMoreTap: () {},
                              );
                            },
                          ),
                        ),
                      ],
                    ),

      floatingActionButton: RotatingFab(onTap: refreshScan),
    );
  }
}
