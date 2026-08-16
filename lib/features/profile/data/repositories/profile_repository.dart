import 'dart:io';
import 'package:dio/dio.dart';
import 'package:z_sports_booking/core/network/api_client.dart';
import 'package:z_sports_booking/core/network/api_endpoints.dart';
import 'package:z_sports_booking/core/network/error_message_mapper.dart';
import 'package:z_sports_booking/data/models/user_model.dart';

class ProfileRepository {
  final ApiClient _apiClient;

  ProfileRepository(this._apiClient);

  Future<UserModel> getProfile() async {
    try {
      final response = await _apiClient.dio.get(ApiEndpoints.getProfile);
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
      await _apiClient.dio.post(
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
    return friendlyDioError(
      error,
      fallbackMessage: 'تعذر تحديث بيانات الحساب.',
    );
  }
}
