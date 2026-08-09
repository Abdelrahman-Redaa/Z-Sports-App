import 'package:dio/dio.dart';
import 'package:z_sports_booking/core/network/api_client.dart';
import 'package:z_sports_booking/core/network/api_endpoints.dart';

class AuthRepository {
  final ApiClient _apiClient;

  AuthRepository(this._apiClient);

  Future<String> signIn(String email, String password) async {
    try {
      final response = await _apiClient.dio.post(
        ApiEndpoints.signIn,
        data: {'email': email, 'password': password},
      );
      if (response.data != null && response.data['token'] != null) {
        return response.data['token'];
      }
      return '';
    } on DioException catch (e) {
      throw Exception(_handleDioError(e));
    } catch (e) {
      throw Exception('حدث خطأ غير متوقع');
    }
  }

  Future<bool> signUp(String name, String email, String password) async {
    try {
      final response = await _apiClient.dio.post(
        ApiEndpoints.signUp,
        data: {'name': name, 'email': email, 'password': password},
      );
      return response.statusCode == 200 || response.statusCode == 201;
    } on DioException catch (e) {
      throw Exception(_handleDioError(e));
    } catch (e) {
      throw Exception('حدث خطأ غير متوقع');
    }
  }

  Future<bool> confirmEmail(String email, String otp) async {
    try {
      final response = await _apiClient.dio.post(
        ApiEndpoints.confirmEmail,
        data: {'email': email, 'otp': otp},
      );
      return response.statusCode == 200 || response.statusCode == 201;
    } on DioException catch (e) {
      throw Exception(_handleDioError(e));
    } catch (e) {
      throw Exception('حدث خطأ غير متوقع');
    }
  }

  Future<bool> resendEmail(String email) async {
    try {
      final response = await _apiClient.dio.post(
        ApiEndpoints.resendEmail,
        data: {'email': email},
      );
      return response.statusCode == 200 || response.statusCode == 201;
    } on DioException catch (e) {
      throw Exception(_handleDioError(e));
    } catch (e) {
      throw Exception('حدث خطأ غير متوقع');
    }
  }

  Future<bool> forgetPassword(String email) async {
    try {
      final response = await _apiClient.dio.post(
        ApiEndpoints.forgetPassword,
        data: {'email': email},
      );
      return response.statusCode == 200 || response.statusCode == 201;
    } on DioException catch (e) {
      throw Exception(_handleDioError(e));
    } catch (e) {
      throw Exception('حدث خطأ غير متوقع');
    }
  }

  Future<bool> resetPassword(
    String email,
    String otp,
    String newPassword,
    String confirmNewPassword,
  ) async {
    try {
      final response = await _apiClient.dio.post(
        ApiEndpoints.resetPassword,
        data: {
          'email': email,
          'otp': otp,
          'newPassword': newPassword,
          'confirmNewPassword': confirmNewPassword,
        },
      );
      return response.statusCode == 200 || response.statusCode == 201;
    } on DioException catch (e) {
      throw Exception(_handleDioError(e));
    } catch (e) {
      throw Exception('حدث خطأ غير متوقع');
    }
  }

  String _handleDioError(DioException error) {
    if (error.response != null) {
      final data = error.response?.data;
      if (data is Map) {
        if (data['message'] != null) return data['message'];
        if (data['errors'] != null) {
          final errors = data['errors'];
          if (errors is Map) {
            final firstKey = errors.keys.first;
            final firstVal = errors[firstKey];
            if (firstVal is List && firstVal.isNotEmpty)
              return firstVal.first.toString();
          }
        }
      }
      if (data is String && data.isNotEmpty) return data;
      return 'خطأ في الخادم: ${error.response?.statusCode}';
    }
    return 'لا يوجد اتصال بالإنترنت';
  }
}
