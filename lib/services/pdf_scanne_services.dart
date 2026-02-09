import 'dart:io';
import 'package:external_path/external_path.dart';

class PdfScanService {
  static Future<List<File>> scanAllPdfs() async {
    final List<File> pdfFiles = [];

    final downloadsPath =
        await ExternalPath.getExternalStoragePublicDirectory(
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
}
