import 'package:dio/dio.dart';
import 'package:z_sports_booking/core/network/api_client.dart';
import 'package:z_sports_booking/core/network/api_endpoints.dart';
import 'package:z_sports_booking/data/models/pitch_model.dart';

class FavoritesRepository {
  final ApiClient _apiClient;

  FavoritesRepository(this._apiClient);

  Future<List<PitchModel>> getFavorites() async {
    try {
      // ignore: avoid_print
      print('🔵 [Favorites] Calling GET ${ApiEndpoints.getFavorites}');
      final response = await _apiClient.dio.get(ApiEndpoints.getFavorites);
      // ignore: avoid_print
      print('🟢 [Favorites] Response status: ${response.statusCode}');
      // ignore: avoid_print
      print('🟢 [Favorites] Response data: ${response.data}');

      if (response.data == null) return [];

      // API might return a list directly OR wrapped in an object
      List<dynamic> data;
      if (response.data is List) {
        data = response.data as List<dynamic>;
      } else if (response.data is Map) {
        // Try common wrapper keys
        final map = response.data as Map<String, dynamic>;
        data = (map['data'] ?? map['favorites'] ?? map['items'] ?? []) as List<dynamic>;
      } else {
        data = [];
      }

      // ignore: avoid_print
      print('🟢 [Favorites] Parsed ${data.length} favorites');

      return data
          .map((e) => PitchModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (e, st) {
      // ignore: avoid_print
      print('🔴 [Favorites] getFavorites ERROR: $e');
      // ignore: avoid_print
      print('🔴 [Favorites] StackTrace: $st');
      if (e is DioException) {
        // ignore: avoid_print
        print('🔴 [Favorites] DioError response: ${e.response?.data}');
        // ignore: avoid_print
        print('🔴 [Favorites] DioError status: ${e.response?.statusCode}');
        throw Exception(_handleError(e));
      }
      throw Exception(e.toString());
    }
  }

  Future<void> addFavorite(int stadiumId) async {
    try {
      final url = ApiEndpoints.toggleFavorite(stadiumId);
      // ignore: avoid_print
      print('🔵 [Favorites] Calling POST $url');
      final response = await _apiClient.dio.post(url, data: {});
      // ignore: avoid_print
      print('🟢 [Favorites] addFavorite status: ${response.statusCode} data: ${response.data}');
    } catch (e) {
      // ignore: avoid_print
      print('🔴 [Favorites] addFavorite ERROR: $e');
      if (e is DioException) {
        // ignore: avoid_print
        print('🔴 [Favorites] addFavorite response body: ${e.response?.data}');
        // ignore: avoid_print
        print('🔴 [Favorites] addFavorite status code: ${e.response?.statusCode}');
        throw Exception(_handleError(e));
      }
      throw Exception(e.toString());
    }
  }

  Future<void> removeFavorite(int stadiumId) async {
    try {
      final url = ApiEndpoints.toggleFavorite(stadiumId);
      // ignore: avoid_print
      print('🔵 [Favorites] Calling DELETE $url');
      final response = await _apiClient.dio.delete(url);
      // ignore: avoid_print
      print('🟢 [Favorites] removeFavorite status: ${response.statusCode} data: ${response.data}');
    } catch (e) {
      // ignore: avoid_print
      print('🔴 [Favorites] removeFavorite ERROR: $e');
      if (e is DioException) {
        // ignore: avoid_print
        print('🔴 [Favorites] removeFavorite response body: ${e.response?.data}');
        // ignore: avoid_print
        print('🔴 [Favorites] removeFavorite status code: ${e.response?.statusCode}');
        throw Exception(_handleError(e));
      }
      throw Exception(e.toString());
    }
  }

  String _handleError(DioException error) {
    if (error.response != null) {
      final data = error.response?.data;
      if (data is Map) {
        return (data['message'] ?? data['title'] ?? 'حدث خطأ').toString();
      } else if (data is String && data.isNotEmpty) {
        return data;
      }
      return 'حدث خطأ (كود ${error.response?.statusCode})';
    }
    return 'لا يوجد اتصال بالإنترنت';
  }
}
