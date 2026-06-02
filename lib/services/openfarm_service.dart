import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:plantid/core/constants.dart';
import 'package:plantid/models/care_advice.dart';

class OpenFarmService {
  final Dio _dio;

  OpenFarmService({Dio? dio}) : _dio = dio ?? Dio(BaseOptions(
    connectTimeout: const Duration(seconds: 15),
    receiveTimeout: const Duration(seconds: 15),
  ));

  Future<CareAdvice> getCareAdvice(String plantName) async {
    try {
      final response = await _dio.get(
        '${AppConstants.openFarmApiUrl}?filter=$plantName',
      );

      if (response.statusCode == 200) {
        final List data = response.data['data'];
        if (data.isNotEmpty) {
          return CareAdvice.fromJson(data[0]);
        }
      }
      return CareAdvice.fallback();
    } on DioException catch (e) {
      debugPrint('OpenFarm API Error: ${e.message}');
      return CareAdvice.fallback();
    } catch (e) {
      debugPrint('General Error: $e');
      return CareAdvice.fallback();
    }
  }
}
