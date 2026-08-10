import 'package:dio/dio.dart';
import 'package:z_sports_booking/core/network/api_client.dart';
import 'package:z_sports_booking/core/network/api_endpoints.dart';
import 'package:z_sports_booking/data/models/pitch_model.dart';

class FavoritesRepository {
  final ApiClient _apiClient;

  FavoritesRepository(this._apiClient);

  Future<List<PitchModel>> getFavorites() async {
    try {
      final response = await _apiClient.dio.get(ApiEndpoints.getFavorites);
      final List<dynamic> data = response.data as List<dynamic>;
      return data
          .map((e) => PitchModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw Exception(_handleError(e));
    }
  }

  Future<void> addFavorite(int stadiumId) async {
    try {
      await _apiClient.dio.post(ApiEndpoints.toggleFavorite(stadiumId));
    } on DioException catch (e) {
      throw Exception(_handleError(e));
    }
  }

  Future<void> removeFavorite(int stadiumId) async {
    try {
      await _apiClient.dio.delete(ApiEndpoints.toggleFavorite(stadiumId));
    } on DioException catch (e) {
      throw Exception(_handleError(e));
    }
  }

  String _handleError(DioException error) {
    if (error.response != null) {
      final data = error.response?.data;
      if (data is Map) {
        if (data.containsKey('message') && data['message'] != null) {
          return data['message'].toString();
        }
        if (data.containsKey('title') && data['title'] != null) {
          return data['title'].toString();
        }
      } else if (data is String && data.isNotEmpty) {
        return data;
      }
      return 'حدث خطأ (خطأ ${error.response?.statusCode})';
    }
    return 'لا يوجد اتصال بالإنترنت';
  }
}
