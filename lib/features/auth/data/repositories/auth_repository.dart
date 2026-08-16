import 'package:dio/dio.dart';
import 'package:z_sports_booking/core/network/api_client.dart';
import 'package:z_sports_booking/core/network/api_endpoints.dart';
import 'package:z_sports_booking/core/network/error_message_mapper.dart';

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
    final data = {
      'email': email,
      'otp': otp,
      'newPassword': newPassword,
      'confirmNewPassword': confirmNewPassword,
    };

    try {
      final response = await _apiClient.dio.post(
        ApiEndpoints.resetPassword,
        data: data,
      );
      final statusCode = response.statusCode ?? 0;
      return statusCode >= 200 && statusCode < 300;
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        try {
          final response = await _apiClient.dio.post(
            '/Api/Account/ResetPassword',
            data: data,
          );
          final statusCode = response.statusCode ?? 0;
          return statusCode >= 200 && statusCode < 300;
        } on DioException catch (fallbackError) {
          throw Exception(_handleDioError(fallbackError));
        }
      }
      throw Exception(_handleDioError(e));
    } catch (e) {
      throw Exception('حدث خطأ غير متوقع');
    }
  }

  String _handleDioError(DioException error) {
    return friendlyDioError(
      error,
      fallbackMessage: 'تعذر إتمام العملية، حاول مرة أخرى.',
    );
  }
}
