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
        if (data['message'] != null && data['message'].toString().isNotEmpty) {
          if (data['errors'] != null) {
            return '${data['message']}\n${data['errors']}';
          }
          return data['message'].toString();
        }
      }
      return 'حدث خطأ: ${error.response?.statusCode}\n$data';
    }
    return 'لا يوجد اتصال بالإنترنت';
  }
}
