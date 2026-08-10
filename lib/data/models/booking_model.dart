enum BookingStatus { upcoming, completed, cancelled }

class BookingModel {
  const BookingModel({
    required this.id,
    required this.stadiumId,
    required this.stadiumName,
    required this.stadiumImage,
    required this.category,
    required this.date,
    required this.time,
    required this.durationMinutes,
    required this.totalPrice,
    required this.status,
  });

  final int id;
  final int stadiumId;
  final String stadiumName;
  final String stadiumImage;
  final String category;
  final String date;
  final String time;
  final int durationMinutes;
  final double totalPrice;
  final BookingStatus status;

  factory BookingModel.fromJson(Map<String, dynamic> json) {
    BookingStatus status = BookingStatus.upcoming;
    final rawStatus = (json['status'] ?? json['bookingStatus'] ?? '').toString().toLowerCase();
    if (rawStatus.contains('complet') || rawStatus.contains('done')) {
      status = BookingStatus.completed;
    } else if (rawStatus.contains('cancel')) {
      status = BookingStatus.cancelled;
    }

    final stadium = json['stadium'] as Map<String, dynamic>? ?? {};
    final stadiumImages = stadium['images'] as List<dynamic>? ?? [];
    final firstImage = stadiumImages.isNotEmpty
        ? (stadiumImages.first['imageUrl'] ?? stadiumImages.first['url'] ?? '').toString()
        : '';

    return BookingModel(
      id: json['id'] ?? 0,
      stadiumId: json['stadiumId'] ?? stadium['id'] ?? 0,
      stadiumName: json['stadiumName'] ?? stadium['name'] ?? json['stadium']?.toString() ?? '',
      stadiumImage: firstImage,
      category: json['categoryName'] ?? stadium['categoryName'] ?? '',
      date: json['date'] ?? json['bookingDate'] ?? '',
      time: json['time'] ?? json['bookingTime'] ?? '',
      durationMinutes: json['durationMinutes'] ?? 60,
      totalPrice: (json['totalPrice'] ?? json['price'] ?? 0.0).toDouble(),
      status: status,
    );
  }
}
