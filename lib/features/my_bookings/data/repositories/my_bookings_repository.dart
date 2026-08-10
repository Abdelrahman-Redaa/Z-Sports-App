import 'package:dio/dio.dart';
import 'package:z_sports_booking/core/network/api_client.dart';
import 'package:z_sports_booking/core/network/api_endpoints.dart';
import 'package:z_sports_booking/data/models/booking_model.dart';

class MyBookingsRepository {
  final ApiClient _apiClient;

  MyBookingsRepository(this._apiClient);

  Future<List<BookingModel>> getMyBookings() async {
    try {
      final response = await _apiClient.dio.get(ApiEndpoints.myBookings);
      final List<dynamic> data = response.data as List<dynamic>;
      return data
          .map((e) => BookingModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw Exception(_handleError(e));
    }
  }

  Future<BookingModel> getBookingById(int id) async {
    try {
      final response = await _apiClient.dio.get(ApiEndpoints.bookingById(id));
      return BookingModel.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw Exception(_handleError(e));
    }
  }

  Future<void> cancelBooking(int id) async {
    try {
      await _apiClient.dio.delete(
        ApiEndpoints.bookingById(id),
        data: {'reason': 'إلغاء بواسطة المستخدم'},
      );
    } on DioException catch (e) {
      throw Exception(_handleError(e));
    }
  }

  String _handleError(DioException error) {
    if (error.response != null) {
      final data = error.response?.data;
      
      if (data is Map) {
        // 1. Check for standard 'message' field
        if (data.containsKey('message') && data['message'] != null && data['message'].toString().isNotEmpty) {
          return data['message'].toString();
        }
        
        // 2. Check for ASP.NET Core ValidationProblemDetails 'errors' object
        if (data.containsKey('errors') && data['errors'] is Map) {
          final errorsMap = data['errors'] as Map;
          if (errorsMap.isNotEmpty) {
            // Extract the first error message from the validation errors
            final firstErrorList = errorsMap.values.first;
            if (firstErrorList is List && firstErrorList.isNotEmpty) {
              return firstErrorList.first.toString();
            }
          }
        }
        
        // 3. Check for general ASP.NET Core error 'title'
        if (data.containsKey('title') && data['title'] != null && data['title'].toString().isNotEmpty) {
          return data['title'].toString();
        }
      } else if (data is String && data.isNotEmpty) {
        // 4. Fallback if the backend returned a plain string
        return data;
      }
      
      // 5. Absolute fallback with status code
      return 'تعذر الإلغاء (خطأ ${error.response?.statusCode})';
    }
    return 'لا يوجد اتصال بالإنترنت';
  }
}
