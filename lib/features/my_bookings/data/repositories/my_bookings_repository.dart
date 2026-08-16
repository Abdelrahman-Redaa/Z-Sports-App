import 'package:dio/dio.dart';
import 'package:z_sports_booking/core/network/api_client.dart';
import 'package:z_sports_booking/core/network/api_endpoints.dart';
import 'package:z_sports_booking/core/network/error_message_mapper.dart';
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
    return friendlyDioError(error, fallbackMessage: 'تعذر تنفيذ الطلب.');
  }
}
