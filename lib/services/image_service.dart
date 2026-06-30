import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:uuid/uuid.dart';

class ImageService {
  static Future<XFile?> compressImage(String path) async {
    try {
      final file = File(path);
      if (!await file.exists()) {
        debugPrint('Image file does not exist at path: $path');
        return null;
      }

      final targetPath = p.join((await getTemporaryDirectory()).path, '${const Uuid().v4()}.jpg');

      final result = await FlutterImageCompress.compressAndGetFile(
        file.absolute.path,
        targetPath,
        quality: 80,
        minWidth: 1024,
        minHeight: 1024,
      );

      if (result == null) {
        debugPrint('Compression failed for path: $path');
      }
      return result;
    } catch (e) {
      debugPrint('Error during image compression: $e');
      return null;
    }
  }

  static Future<String> saveImageToDocs(String sourcePath) async {
    final docsDir = await getApplicationDocumentsDirectory();
    final fileName = '${const Uuid().v4()}${p.extension(sourcePath)}';
    final destinationPath = p.join(docsDir.path, fileName);

    final sourceFile = File(sourcePath);
    await sourceFile.copy(destinationPath);

    return destinationPath;
  }
}
