import 'dart:convert';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

class ImportExportHelper {
  static Future<void> downloadJsonFile(String jsonString, String fileName) async {
    try {
      // Get the downloads directory
      final directory = await getExternalStorageDirectory();
      if (directory == null) {
        throw Exception('Could not access storage');
      }

      // Create file in Downloads folder
      final downloadsPath = directory.path.replaceAll('Android/data/com.financetracker.finance_tracker_app/files', 'Download');
      final file = File('$downloadsPath/$fileName');
      
      // Write the JSON string to file
      await file.writeAsString(jsonString);
      
      // Share the file using share_plus
      await Share.shareXFiles(
        [XFile(file.path)],
        subject: 'Finance Tracker Backup',
        text: 'Your finance data backup',
      );
    } catch (e) {
      // If above fails, try saving to app directory and sharing
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/$fileName');
      await file.writeAsString(jsonString);
      
      await Share.shareXFiles(
        [XFile(file.path)],
        subject: 'Finance Tracker Backup',
      );
    }
  }

  static Future<String?> pickJsonFile() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['json'],
      );

      if (result != null && result.files.single.path != null) {
        final file = File(result.files.single.path!);
        final contents = await file.readAsString();
        return contents;
      }
      
      return null;
    } catch (e) {
      print('Error picking file: $e');
      return null;
    }
  }
}
