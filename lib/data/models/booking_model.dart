import 'package:z_sports_booking/data/models/pitch_model.dart';

enum BookingStatus { upcoming, completed, cancelled }

class BookingModel {
  const BookingModel({
    required this.id,
    required this.pitch,
    required this.date,
    required this.startTime,
    required this.endTime,
    required this.totalPrice,
    required this.status,
  });

  final String id;
  final PitchModel pitch;
  final DateTime date;
  final String startTime;
  final String endTime;
  final double totalPrice;
  final BookingStatus status;
}
