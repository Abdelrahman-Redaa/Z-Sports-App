import 'package:z_sports_booking/data/models/booking_model.dart';

abstract class MyBookingsState {}

class MyBookingsInitial extends MyBookingsState {}

class MyBookingsLoading extends MyBookingsState {}

class MyBookingsLoaded extends MyBookingsState {
  final List<BookingModel> bookings;
  MyBookingsLoaded(this.bookings);
}

class MyBookingsError extends MyBookingsState {
  final String message;
  MyBookingsError(this.message);
}

class BookingCancelLoading extends MyBookingsState {
  final List<BookingModel> bookings;
  BookingCancelLoading(this.bookings);
}

class BookingCancelSuccess extends MyBookingsState {
  final List<BookingModel> bookings;
  BookingCancelSuccess(this.bookings);
}
