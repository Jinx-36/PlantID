import 'dart:io';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:uuid/uuid.dart';

class ImageService {
  static Future<XFile?> compressImage(String path) async {
    final file = File(path);
    final targetPath = p.join((await getTemporaryDirectory()).path, '${const Uuid().v4()}.jpg');

    return await FlutterImageCompress.compressAndGetFile(
      file.absolute.path,
      targetPath,
      quality: 85,
      minWidth: 1024,
      minHeight: 1024,
    );
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
