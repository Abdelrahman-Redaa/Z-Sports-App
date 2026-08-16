import 'package:dio/dio.dart';
import 'package:z_sports_booking/core/network/api_client.dart';
import 'package:z_sports_booking/core/network/api_endpoints.dart';
import 'package:z_sports_booking/core/network/error_message_mapper.dart';

class BookingRepository {
  final ApiClient _apiClient;

  BookingRepository(this._apiClient);

  Future<List<String>> getAvailableSlots(int stadiumId, String date) async {
    try {
      final response = await _apiClient.dio.get(
        ApiEndpoints.stadiumSlots(stadiumId),
        queryParameters: {'date': date}, // Some backends expect it in query
        data: {'date': date}, // Some backends expect it in body for GET
      );
      final List<dynamic> data = response.data as List<dynamic>;
      return data.map((e) => e.toString()).toList();
    } on DioException catch (e) {
      throw Exception(_handleError(e));
    }
  }

  Future<void> bookStadium({
    required int stadiumId,
    required String date,
    required String time,
    required int durationMinutes,
  }) async {
    try {
      await _apiClient.dio.post(
        ApiEndpoints.bookings,
        data: {
          'stadiumId': stadiumId,
          'date': date,
          'time': time,
          'durationMinutes': durationMinutes,
        },
      );
    } on DioException catch (e) {
      throw Exception(_handleError(e));
    }
  }

  String _handleError(DioException error) {
    return friendlyDioError(error, fallbackMessage: 'تعذر إتمام الحجز.');
  }
}
