import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:z_sports_booking/features/my_bookings/data/repositories/my_bookings_repository.dart';
import 'package:z_sports_booking/features/my_bookings/presentation/cubit/my_bookings_state.dart';

class MyBookingsCubit extends Cubit<MyBookingsState> {
  final MyBookingsRepository _repository;

  MyBookingsCubit(this._repository) : super(MyBookingsInitial());

  Future<void> loadMyBookings() async {
    emit(MyBookingsLoading());
    try {
      final bookings = await _repository.getMyBookings();
      emit(MyBookingsLoaded(bookings));
    } catch (e) {
      emit(MyBookingsError(e.toString().replaceAll('Exception: ', '')));
    }
  }

  Future<void> cancelBooking(int bookingId) async {
    final current = state;
    if (current is! MyBookingsLoaded) return;

    emit(BookingCancelLoading(current.bookings));
    try {
      await _repository.cancelBooking(bookingId);
      final updated = current.bookings.where((b) => b.id != bookingId).toList();
      emit(BookingCancelSuccess(updated));
    } catch (e) {
      emit(MyBookingsError(e.toString().replaceAll('Exception: ', '')));
      await Future.delayed(const Duration(milliseconds: 100));
      emit(MyBookingsLoaded(current.bookings));
    }
  }
}
