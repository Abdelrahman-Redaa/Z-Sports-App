import 'dart:io';
import 'package:dio/dio.dart';
import 'package:z_sports_booking/core/network/api_client.dart';
import 'package:z_sports_booking/core/network/api_endpoints.dart';
import 'package:z_sports_booking/data/models/user_model.dart';

class ProfileRepository {
  final ApiClient _apiClient;

  ProfileRepository(this._apiClient);

  Future<UserModel> getProfile() async {
    try {
      final response = await _apiClient.dio.get(ApiEndpoints.getProfile);
      // ignore: avoid_print
      print('🟢 [Profile] JSON: ${response.data}');
      return UserModel.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw Exception(_handleError(e));
    }
  }

  Future<UserModel> updateProfile({
    required String displayName,
    required String phoneNumber,
  }) async {
    try {
      final response = await _apiClient.dio.put(
        ApiEndpoints.getProfile,
        data: {'displayName': displayName, 'phoneNumber': phoneNumber},
      );
      return UserModel.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw Exception(_handleError(e));
    }
  }

  Future<void> updateAvatar(File imageFile) async {
    try {
      final formData = FormData.fromMap({
        'Image': await MultipartFile.fromFile(
          imageFile.path,
          filename: imageFile.path.split('/').last,
        ),
      });
      await _apiClient.dio.post(ApiEndpoints.setAvatar, data: formData);
    } on DioException catch (e) {
      throw Exception(_handleError(e));
    }
  }

  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
    required String confirmNewPassword,
  }) async {
    try {
      await _apiClient.dio.put(
        ApiEndpoints.changePassword,
        data: {
          'currentPassword': currentPassword,
          'newPassword': newPassword,
          'confirmNewPassword': confirmNewPassword,
        },
      );
    } on DioException catch (e) {
      throw Exception(_handleError(e));
    }
  }

  String _handleError(DioException error) {
    if (error.response != null) {
      final data = error.response?.data;
      if (data is Map) {
        if (data['message'] != null) return data['message'];
        if (data['errors'] != null) {
          final errors = data['errors'];
          if (errors is Map && errors.isNotEmpty) {
            final firstVal = errors.values.first;
            if (firstVal is List && firstVal.isNotEmpty) {
              return firstVal.first.toString();
            }
          }
        }
      }
      return 'خطأ في الخادم: ${error.response?.statusCode}';
    }
    return 'لا يوجد اتصال بالإنترنت';
  }
}
