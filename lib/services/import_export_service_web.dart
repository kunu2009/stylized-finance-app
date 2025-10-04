import 'dart:convert';
import 'dart:html' as html;
import 'dart:async';

class ImportExportHelper {
  static Future<void> downloadJsonFile(String jsonString, String fileName) async {
    final bytes = utf8.encode(jsonString);
    final blob = html.Blob([bytes]);
    final url = html.Url.createObjectUrlFromBlob(blob);
    final anchor = html.document.createElement('a') as html.AnchorElement
      ..href = url
      ..style.display = 'none'
      ..download = fileName;
    html.document.body!.children.add(anchor);
    anchor.click();
    html.document.body!.children.remove(anchor);
    html.Url.revokeObjectUrl(url);
  }

  static Future<String?> pickJsonFile() async {
    final completer = Completer<String?>();
    final uploadInput = html.FileUploadInputElement();
    uploadInput.accept = '.json';
    uploadInput.click();
    
    uploadInput.onChange.listen((e) {
      final files = uploadInput.files;
      if (files == null || files.isEmpty) {
        completer.complete(null);
        return;
      }

      final reader = html.FileReader();
      reader.readAsText(files[0]);
      reader.onLoad.listen((e) {
        completer.complete(reader.result as String?);
      });
      reader.onError.listen((e) {
        completer.complete(null);
      });
    });

    return completer.future;
  }
}
