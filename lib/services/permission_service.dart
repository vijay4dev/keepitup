import 'package:permission_handler/permission_handler.dart';

class PermissionService {
  static Future<bool> requestStorage() async {
    if (await Permission.manageExternalStorage.isGranted) {
      return true;
    }
    final result = await Permission.manageExternalStorage.request();
    return result.isGranted;
  }
}
