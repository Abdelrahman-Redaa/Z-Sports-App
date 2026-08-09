abstract class BookingState {}

class BookingInitial extends BookingState {}

class BookingSlotsLoading extends BookingState {}

class BookingSlotsLoaded extends BookingState {
  final List<String> availableSlots;
  BookingSlotsLoaded(this.availableSlots);
}

class BookingSlotsError extends BookingState {
  final String message;
  BookingSlotsError(this.message);
}

class BookingSubmitLoading extends BookingState {}

class BookingSubmitSuccess extends BookingState {}

class BookingSubmitError extends BookingState {
  final String message;
  BookingSubmitError(this.message);
}
