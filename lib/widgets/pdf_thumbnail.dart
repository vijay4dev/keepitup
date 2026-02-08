import 'dart:io';
import 'package:flutter/material.dart';
import 'package:pdf_render/pdf_render.dart';

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
      final doc = await PdfDocument.openFile(widget.file.path);
      final page = await doc.getPage(1);

      final pageImage = await page.render(
        width: 200,
        height: 280,
        fullWidth: 200,
        fullHeight: 280,
      );

      // 🔥 THIS IS THE KEY LINE
      await pageImage.createImageIfNotAvailable();

      doc.dispose();

      if (!mounted) return;

      setState(() {
        _pageImage = pageImage;
        _loading = false;
      });
    } catch (e) {
      debugPrint("PDF thumbnail error: $e");
      if (!mounted) return;
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading || _pageImage?.imageIfAvailable == null) {
      return _placeholder();
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: RawImage(
        image: _pageImage!.imageIfAvailable,
        fit: BoxFit.cover,
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
