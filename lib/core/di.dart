import 'package:z_sports_booking/core/network/api_client.dart';
import 'package:z_sports_booking/features/auth/data/repositories/auth_repository.dart';
import 'package:z_sports_booking/features/booking/data/repositories/booking_repository.dart';
import 'package:z_sports_booking/features/home/data/repositories/stadium_repository.dart';
import 'package:z_sports_booking/features/my_bookings/data/repositories/my_bookings_repository.dart';
import 'package:z_sports_booking/features/profile/data/repositories/profile_repository.dart';
import 'package:z_sports_booking/features/favorites/data/repositories/favorites_repository.dart';

class DI {
  static final ApiClient apiClient = ApiClient();
  static final AuthRepository authRepository = AuthRepository(apiClient);
  static final ProfileRepository profileRepository = ProfileRepository(apiClient);
  static final StadiumRepository stadiumRepository = StadiumRepository(apiClient);
  static final BookingRepository bookingRepository = BookingRepository(apiClient);
  static final MyBookingsRepository myBookingsRepository = MyBookingsRepository(apiClient);
  static final FavoritesRepository favoritesRepository = FavoritesRepository(apiClient);
}
