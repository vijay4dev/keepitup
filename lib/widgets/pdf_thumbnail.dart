import 'dart:io';
import 'package:flutter/material.dart';
import 'package:pdfx/pdfx.dart';

class PdfThumbnail extends StatefulWidget {
  final File file;
  const PdfThumbnail({super.key, required this.file});

  @override
  State<PdfThumbnail> createState() => _PdfThumbnailState();
}

class _PdfThumbnailState extends State<PdfThumbnail> {
  PdfPageImage? _pageImage;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadThumbnail();
  }

  Future<void> _loadThumbnail() async {
    try {
      final document = await PdfDocument.openFile(widget.file.path);

      final page = await document.getPage(1);

      final pageImage = await page.render(
        width: 80,
        height: 80,
        format: PdfPageImageFormat.png,
        backgroundColor: '#FFFFFF',
      );

      await page.close();
      await document.close();

      if (!mounted) return;

      setState(() {
        _pageImage = pageImage;
        _loading = false;
      });
    } catch (e) {
      debugPrint("PDFX thumbnail error: $e");
      if (!mounted) return;
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading || _pageImage == null) {
      return _placeholder();
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Image.memory(
        _pageImage!.bytes,
        fit: BoxFit.cover,
        width: 80,
      ),
    );
  }

  Widget _placeholder() {
    return Container(
      height: 56,
      width: 56,
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Icon(
        Icons.picture_as_pdf,
        color: Colors.red,
      ),
    );
  }
}
