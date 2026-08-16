import 'package:dio/dio.dart';
import 'package:z_sports_booking/core/network/api_client.dart';
import 'package:z_sports_booking/core/network/api_endpoints.dart';
import 'package:z_sports_booking/core/network/error_message_mapper.dart';
import 'package:z_sports_booking/data/models/category_model.dart';
import 'package:z_sports_booking/data/models/pitch_model.dart';

class StadiumRepository {
  final ApiClient _apiClient;

  StadiumRepository(this._apiClient);

  Future<List<PitchModel>> getAllStadiums() async {
    try {
      final response = await _apiClient.dio.get(ApiEndpoints.getAllStadiums);
      final List<dynamic> data = response.data as List<dynamic>;
      return data
          .map((item) => PitchModel.fromJson(item as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw Exception(_handleError(e));
    }
  }

  Future<PitchModel> getStadiumById(int id) async {
    try {
      final response = await _apiClient.dio.get(ApiEndpoints.stadiumById(id));
      return PitchModel.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw Exception(_handleError(e));
    }
  }

  Future<List<PitchModel>> searchStadiums({int? categoryId}) async {
    try {
      final response = await _apiClient.dio.get(
        ApiEndpoints.searchStadiums,
        queryParameters: categoryId != null ? {'CategoryId': categoryId} : null,
      );
      final List<dynamic> data = response.data as List<dynamic>;
      return data
          .map((item) => PitchModel.fromJson(item as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw Exception(_handleError(e));
    }
  }

  Future<List<CategoryModel>> getCategories() async {
    try {
      final response = await _apiClient.dio.get(ApiEndpoints.categories);
      final List<dynamic> data = response.data as List<dynamic>;
      return data
          .map((item) => CategoryModel.fromJson(item as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw Exception(_handleError(e));
    }
  }

  String _handleError(DioException error) {
    return friendlyDioError(error, fallbackMessage: 'تعذر تحميل البيانات.');
  }
}
