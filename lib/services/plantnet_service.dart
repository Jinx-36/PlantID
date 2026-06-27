import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:plantid/core/constants.dart';
import 'package:plantid/models/plant_result.dart';
import 'package:plantid/services/image_service.dart';

class PlantNetService {
  final Dio _dio;

  PlantNetService({Dio? dio}) : _dio = dio ?? Dio(BaseOptions(
    connectTimeout: const Duration(seconds: 15),
    receiveTimeout: const Duration(seconds: 15),
  ));

  Future<PlantResult?> identifyPlant(String imagePath) async {
    try {
      final compressedImage = await ImageService.compressImage(imagePath);
      if (compressedImage == null) return null;

      final formData = FormData.fromMap({
        'organs': 'leaf',
        'images': await MultipartFile.fromFile(compressedImage.path),
      });

      final response = await _dio.post(
        '${AppConstants.plantNetApiUrl}?api-key=${AppConstants.plantNetApiKey}',
        data: formData,
      );

      if (response.statusCode == 200) {
        final List results = response.data['results'];
        if (results.isEmpty) {
          throw Exception("We couldn't identify this plant. Try a clearer photo.");
        }
        return PlantResult.fromJson(results[0]);
      } else if (response.statusCode == 429) {
        throw Exception("Too many requests. Please wait a moment and try again.");
      }
      return null;
    } on DioException catch (e) {
      debugPrint('PlantNet API Error: ${e.message}');
      if (e.response?.statusCode == 429) {
        throw Exception("Too many requests. Please wait a moment and try again.");
      }
      rethrow;
    } catch (e) {
      debugPrint('General Error: $e');
      rethrow;
    }
  }
}
