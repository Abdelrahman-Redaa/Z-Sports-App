import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:z_sports_booking/features/booking/data/repositories/booking_repository.dart';
import 'package:z_sports_booking/features/booking/presentation/cubit/booking_state.dart';

class BookingCubit extends Cubit<BookingState> {
  final BookingRepository _repository;

  BookingCubit(this._repository) : super(BookingInitial());

  Future<void> loadAvailableSlots(int stadiumId, String date) async {
    emit(BookingSlotsLoading());
    try {
      final slots = await _repository.getAvailableSlots(stadiumId, date);
      emit(BookingSlotsLoaded(slots));
    } catch (e) {
      emit(BookingSlotsError(e.toString().replaceAll('Exception: ', '')));
    }
  }

  Future<void> submitBooking({
    required int stadiumId,
    required String date,
    required String time,
    required int durationMinutes,
  }) async {
    emit(BookingSubmitLoading());
    try {
      await _repository.bookStadium(
        stadiumId: stadiumId,
        date: date,
        time: time,
        durationMinutes: durationMinutes,
      );
      emit(BookingSubmitSuccess());
    } catch (e) {
      emit(BookingSubmitError(e.toString().replaceAll('Exception: ', '')));
    }
  }
}
