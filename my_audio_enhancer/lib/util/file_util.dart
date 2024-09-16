import 'dart:developer';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

final class FileUtil {
  const FileUtil._();

  /// Creates a file path in the temporary directory with the given file name.
  ///
  /// [fileName] is the name of the file to create the path for.
  /// Returns the full file path as a string.
  static Future<String> createFilePath({required String fileName}) async {
    final directory = await getTemporaryDirectory();
    return '${directory.path}/$fileName';
  }

  /// Clears all files and directories in the temporary directory.
  ///
  /// Deletes both files and subdirectories recursively if present.
  /// Logs success or failure.
  static Future<void> clearTemporaryFiles() async {
    try {
      final directory = await getTemporaryDirectory();

      final List<FileSystemEntity> files = directory.listSync();

      for (var file in files) {
        if (file is File) {
          await file.delete();
        } else if (file is Directory) {
          await file.delete(recursive: true);
        }
      }
      log('Temp dir cleared successfully');
    } catch (e) {
      log('Error while clearing temp dir $e');
    }
  }

  /// Deletes a specific file by its name in the temporary directory.
  ///
  /// [fileName] is the name of the file to delete.
  /// Logs success or failure.
  static Future<void> deleteFileByName(String fileName) async {
    try {
      final directory = await getTemporaryDirectory();

      final filePath = '${directory.path}/$fileName';

      final file = File(filePath);
      if (await file.exists()) {
        await file.delete();
        log('File deleted successfully: $filePath');
      } else {
        log('File not found: $filePath');
      }
    } catch (e) {
      log('Error while deleting file: $e');
    }
  }

  /// Loads an XFile and writes its contents to a new file.
  ///
  /// [xFile] is the video file selected by the user.
  /// [fileInputPath] is the path where the file should be saved.
  static Future<void> loadAndWriteFile({required XFile xFile, required String fileInputPath}) async {
    final byteData = await xFile.readAsBytes();
    final file = File(fileInputPath);
    await file.writeAsBytes(byteData.buffer.asUint8List());
  }

  /// Opens the gallery for video selection and returns the selected XFile.
  ///
  /// The video selection is limited to 5 minutes. Returns null if no file is selected.
  static Future<XFile?> pickVideoFromGallery() async {
    try {
      final picker = ImagePicker();
      final xFile = await picker.pickVideo(
        source: ImageSource.gallery,
        maxDuration: const Duration(seconds: 60 * 5),
      );

      if (xFile == null) return null;

      return xFile;
    } catch (e) {
      log(e.toString());
      return null;
    }
  }
}
