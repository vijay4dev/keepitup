import 'dart:io';
import 'package:flutter/material.dart';
import 'package:keepitup/utils/Appcolors.dart';
import 'package:keepitup/utils/extensions.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:share_plus/share_plus.dart';

class PdfDetailScreen extends StatefulWidget {
  final File file;
  const PdfDetailScreen({super.key, required this.file});

  @override
  State<PdfDetailScreen> createState() => _PdfDetailScreenState();
}

class _PdfDetailScreenState extends State<PdfDetailScreen> {
  late TextEditingController nameController;
  List<String> tags = ["Work", "Invoice"];

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(
      text: widget.file.path.split('/').last,
    );
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: Icon(Icons.arrow_back_ios),
        surfaceTintColor: Colors.transparent,
        backgroundColor: Colors.white,
        actions: [
          IconButton(
            onPressed: () {
              Share.shareXFiles([XFile(widget.file.path)]);
            },
            icon: Icon(Icons.ios_share),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // 🔹 PDF VIEW (60%)
            Container(
              height: height * 0.6,
              
              child: SfPdfViewer.file(
                widget.file,
                canShowScrollStatus: false,
                pageLayoutMode: PdfPageLayoutMode.continuous,
              ),
            ),
        
            // 🔹 CONTENT
            SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // PDF NAME
                  TextField(
                    controller: nameController,
                    decoration: InputDecoration(
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          width: 0,
                          color: Colors.black.withOpacity(0.5)
                        ),
                        borderRadius: BorderRadius.circular(50),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          width: 0,
                          color: Colors.black.withOpacity(0.5)
                        ),
                        borderRadius: BorderRadius.circular(50),
                      ),
                      border: OutlineInputBorder(
                        borderSide: BorderSide(
                          width: 0,
                          color: Colors.black.withOpacity(0.5)
                        ),
                        borderRadius: BorderRadius.circular(50),
                      ),
                    ),
                  ),
                  5.hh,

                  
                    
                  16.hh,
                  
                  Text("Tags", 
                    style: TextStyle(
                      color: Colors.black,
                      fontFamily: "Poppins",
                      fontSize: 18,
                      fontWeight: FontWeight.w500
                    ),
                  ),
                  12.hh,
                  // TAGS
                  Wrap(
                    spacing: 8,
                    children: [
                      ...tags.map(
                        (tag) => Chip(
                          backgroundColor: Appcolors.tag_bg_color,
                          deleteIconColor: Appcolors.tag_text_color.withOpacity(
                            0.5,
                          ),
                    
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadiusGeometry.circular(50),
                            side: BorderSide(
                              width: 0,
                              color: Colors.transparent,
                            ),
                          ),
                          label: Text(
                            tag,
                            style: TextStyle(
                              color: Appcolors.tag_text_color,
                              fontWeight: FontWeight.w500,
                              fontSize: 14,
                            ),
                          ),
                          onDeleted: () {
                            setState(() {
                              tags.remove(tag);
                            });
                          },
                        ),
                      ),
                      ActionChip(
                        surfaceTintColor: Colors.transparent,
                        elevation: 0,
                        
                        backgroundColor: Appcolors.grey_color,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadiusGeometry.circular(50),
                          side: BorderSide(width: 0, color: Colors.black38)
                        ),
                        label: const Text("+ Add Tag"),
                        onPressed: () {
                          setState(() {
                            tags.add("New");
                          });
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
