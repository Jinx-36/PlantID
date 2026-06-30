import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:plantid/core/constants.dart';
import 'package:plantid/models/care_advice.dart';

class GeminiApiService {
  final Dio _dio;

  GeminiApiService({Dio? dio}) : _dio = dio ?? Dio(BaseOptions(
    connectTimeout: const Duration(seconds: 15),
    receiveTimeout: const Duration(seconds: 15),
  ));

  Future<CareAdvice> getCareAdvice(String plantName) async {
    try {
      final prompt = '''
        Provide plant care advice for "$plantName".
        Respond strictly with a JSON object containing these keys:
        "name", "description", "watering", "sunlight", "soil".
      ''';

      final response = await _dio.post(
        '${AppConstants.geminiApiUrl}?key=${AppConstants.geminiApiKey}',
        data: {
          "contents": [{
            "parts": [{"text": prompt}]
          }],
          "generationConfig": {
            "responseMimeType": "application/json",
          }
        },
      );

      if (response.statusCode == 200) {
        final text = response.data['candidates'][0]['content']['parts'][0]['text'];
        final Map<String, dynamic> json = jsonDecode(text);
        return CareAdvice(
          name: json['name'] ?? plantName,
          description: json['description'] ?? 'No description available.',
          watering: json['watering'] ?? 'Not specified',
          sunlight: json['sunlight'] ?? 'Not specified',
          soil: json['soil'] ?? 'Not specified',
        );
      }
      return CareAdvice.fallback();
    } on DioException catch (e) {
      debugPrint('Gemini API Error: ${e.message}');
      return CareAdvice.fallback();
    } catch (e) {
      debugPrint('General Error: $e');
      return CareAdvice.fallback();
    }
  }
}
