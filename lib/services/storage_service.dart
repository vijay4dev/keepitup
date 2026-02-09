import 'dart:io';

import 'package:path_provider/path_provider.dart';

class StorageService {
  /// Recursively calculate directory size
  static Future<int> _getDirectorySize(Directory dir) async {
    int size = 0;

    if (!dir.existsSync()) return 0;

    final entities = dir.listSync(recursive: true);

    for (final entity in entities) {
      if (entity is File) {
        size += await entity.length();
      }
    }
    return size; // bytes
  }
  

static Future<int> getAppStorageUsage() async {
  int total = 0;

  // 📁 App documents (OCR, saved data)
  final docsDir = await getApplicationDocumentsDirectory();
  total += await _getDirectorySize(docsDir);

  // 📁 Cache (thumbnails, temp files)
  final cacheDir = await getTemporaryDirectory();
  total += await _getDirectorySize(cacheDir);

  return total;
}
}
