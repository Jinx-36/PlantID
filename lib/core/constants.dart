class AppConstants {
  static const String plantNetApiUrl = 'https://my-api.plantnet.org/v2/identify/all';
  static const String plantNetApiKey = '2b10O6MBNnCZFkFaqjqFDqVdh';
  static const String geminiApiUrl = 'https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash:generateContent';
  static const String geminiApiKey = 'YOUR_GEMINI_API_KEY_HERE';

  static const double borderRadius = 16.0;
  static const double buttonHeight = 54.0;

  static const String dbName = 'plant_id.db';
  static const String tableScanHistory = 'scan_history';
  static const String tableCareCache = 'care_cache';
}
