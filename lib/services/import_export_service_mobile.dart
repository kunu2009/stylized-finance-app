class ImportExportHelper {
  static void downloadJsonFile(String jsonString, String fileName) {
    // Not supported on mobile
    throw UnsupportedError('File download is only supported on web');
  }

  static Future<String?> pickJsonFile() async {
    // Not supported on mobile
    throw UnsupportedError('File picking is only supported on web');
  }
}
