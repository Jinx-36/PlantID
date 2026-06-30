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
            "responseSchema": {
              "type": "OBJECT",
              "properties": {
                "name": {"type": "STRING"},
                "description": {"type": "STRING"},
                "watering": {"type": "STRING"},
                "sunlight": {"type": "STRING"},
                "soil": {"type": "STRING"}
              },
              "required": ["name", "description", "watering", "sunlight", "soil"]
            }
          }
        },
      );

      if (response.statusCode == 200) {
        final text = response.data['candidates'][0]['content']['parts'][0]['text'] as String;
        // Clean markdown formatting if present
        final cleanText = text.replaceAll(RegExp(r'```json\n?'), '').replaceAll('```', '').trim();

        debugPrint('Gemini Raw Output: $cleanText');

        final Map<String, dynamic> json = jsonDecode(cleanText);
        return CareAdvice(
          name: json['name'] ?? plantName,
          description: json['description'] ?? 'No description available.',
          watering: json['watering'] ?? 'Not specified',
          sunlight: json['sunlight'] ?? 'Not specified',
          soil: json['soil'] ?? 'Not specified',
        );
      }
      throw Exception('Failed to get care advice from Gemini');
    } on DioException catch (e) {
      final errorData = e.response?.data;
      debugPrint('Gemini API Error: $errorData');

      String message = 'API Error';
      if (errorData != null && errorData is Map) {
        final error = errorData['error'];
        if (error != null && error is Map) {
          message = error['message'] ?? 'API Error';
        }
      } else if (e.type == DioExceptionType.connectionTimeout) {
        message = 'Connection timed out';
      }

      throw Exception('Gemini API Error: $message');
    } catch (e) {
      debugPrint('Parsing Error: $e');
      throw Exception('Gemini Parsing Error: $e');
    }
  }
}
