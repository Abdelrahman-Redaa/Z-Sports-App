import 'package:dio/dio.dart';
import 'package:z_sports_booking/core/network/api_client.dart';
import 'package:z_sports_booking/core/network/api_endpoints.dart';
import 'package:z_sports_booking/core/network/error_message_mapper.dart';
import 'package:z_sports_booking/data/models/pitch_model.dart';

class FavoritesRepository {
  final ApiClient _apiClient;

  FavoritesRepository(this._apiClient);

  Future<List<PitchModel>> getFavorites() async {
    try {
      final response = await _apiClient.dio.get(ApiEndpoints.getFavorites);

      if (response.data == null) return [];

      // API might return a list directly OR wrapped in an object
      List<dynamic> data;
      if (response.data is List) {
        data = response.data as List<dynamic>;
      } else if (response.data is Map) {
        final map = response.data as Map<String, dynamic>;
        data =
            (map['data'] ?? map['favorites'] ?? map['items'] ?? [])
                as List<dynamic>;
      } else {
        data = [];
      }

      return data
          .map((e) => PitchModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (e) {
      if (e is DioException) {
        throw Exception(_handleError(e));
      }
      throw Exception(e.toString());
    }
  }

  Future<void> addFavorite(int stadiumId) async {
    try {
      final url = ApiEndpoints.toggleFavorite(stadiumId);
      await _apiClient.dio.post(url, data: {});
    } catch (e) {
      if (e is DioException) {
        throw Exception(_handleError(e));
      }
      throw Exception(e.toString());
    }
  }

  Future<void> removeFavorite(int stadiumId) async {
    try {
      final url = ApiEndpoints.toggleFavorite(stadiumId);
      await _apiClient.dio.delete(url);
    } catch (e) {
      if (e is DioException) {
        throw Exception(_handleError(e));
      }
      throw Exception(e.toString());
    }
  }

  String _handleError(DioException error) {
    return friendlyDioError(
      error,
      fallbackMessage: 'تعذر تحديث المفضلة، حاول مرة أخرى.',
    );
  }
}
