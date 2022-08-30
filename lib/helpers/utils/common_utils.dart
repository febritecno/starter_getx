import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:timeago/timeago.dart' as timeago;

class Utils {
  static removeTimezone(String datetime) {
    // Remove [String] Timezone
    // yyyy-mm-dd hh:m:ss.000 -> 2015-02-01 12:02:00
    RegExp _findTimezoneCode = RegExp(r"([.]*000)(?!.*\d)");
    return datetime.toString().replaceAll(_findTimezoneCode, '');
  }

// convert date to time ago
  static timeAgo(String text) {
    return timeago.format(DateTime.parse("${text}"));
  }

  static picker(List<String> ext) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ext,
    );
    if (result != null) {
      PlatformFile file = result.files.first;
      // print(file.name);
      // print(file.bytes);
      // print(file.size);
      // print(file.extension);
      print(file.path);
      return file;
    }
  }

// get universal path download for FlutterDownloader
  Future<String?> findLocalPath() async {
    var externalStorageDirPath;
    if (Platform.isAndroid) {
      try {
        final directory = await getExternalStorageDirectory();
        externalStorageDirPath = directory?.path;
      } catch (e) {
        final directory = await getExternalStorageDirectory();
        externalStorageDirPath = directory?.path;
      }
    } else if (Platform.isIOS) {
      externalStorageDirPath =
          (await getApplicationDocumentsDirectory()).absolute.path;
    }

    String _localPath = externalStorageDirPath!;
    final savedDir = Directory(_localPath);
    bool hasExisted = await savedDir.exists();
    if (!hasExisted) {
      savedDir.create();
    }
    return externalStorageDirPath;
  }
}
