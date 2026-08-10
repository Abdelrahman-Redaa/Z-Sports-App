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

  static double _parsePrice(Map<String, dynamic> json) {
    // Try every possible field name the backend might use
    for (final key in ['totalPrice', 'total', 'price', 'amount', 'totalAmount',
                       'cost', 'bookingPrice', 'bookingCost', 'pricePerHour',
                       'TotalPrice', 'Total', 'Price', 'Amount']) {
      final val = json[key];
      if (val != null) {
        final parsed = double.tryParse(val.toString());
        if (parsed != null && parsed > 0) return parsed;
      }
    }
    return 0.0;
  }

  static String _parseImage(Map<String, dynamic> json) {
    // 1. Check top-level imageUrl fields
    for (final key in ['imageUrl', 'image', 'stadiumImage', 'coverImage',
                       'thumbnail', 'photo', 'ImageUrl', 'Image']) {
      final val = json[key];
      if (val != null && val.toString().isNotEmpty) return val.toString();
    }

    // 2. Check inside nested 'stadium' object
    final stadium = json['stadium'] as Map<String, dynamic>? ?? {};

    // 2a. Try direct image fields on stadium
    for (final key in ['imageUrl', 'image', 'coverImage', 'thumbnail',
                       'photo', 'ImageUrl']) {
      final val = stadium[key];
      if (val != null && val.toString().isNotEmpty) return val.toString();
    }

    // 2b. Try images array on stadium
    for (final arrKey in ['images', 'Images', 'photos', 'Photos']) {
      final images = stadium[arrKey] as List<dynamic>?;
      if (images != null && images.isNotEmpty) {
        final first = images.first;
        if (first is Map) {
          for (final k in ['imageUrl', 'url', 'path', 'src', 'ImageUrl', 'Url']) {
            final v = first[k];
            if (v != null && v.toString().isNotEmpty) return v.toString();
          }
        } else if (first is String && first.isNotEmpty) {
          return first;
        }
      }
    }

    // 2c. Try images array at top level
    for (final arrKey in ['images', 'Images', 'photos']) {
      final images = json[arrKey] as List<dynamic>?;
      if (images != null && images.isNotEmpty) {
        final first = images.first;
        if (first is Map) {
          for (final k in ['imageUrl', 'url', 'path', 'src', 'ImageUrl']) {
            final v = first[k];
            if (v != null && v.toString().isNotEmpty) return v.toString();
          }
        } else if (first is String && first.isNotEmpty) {
          return first;
        }
      }
    }

    return '';
  }

  factory BookingModel.fromJson(Map<String, dynamic> json) {
    BookingStatus status = BookingStatus.upcoming;
    final rawStatus = (json['status'] ?? json['bookingStatus'] ?? '').toString().toLowerCase();
    if (rawStatus.contains('complet') || rawStatus.contains('done')) {
      status = BookingStatus.completed;
    } else if (rawStatus.contains('cancel')) {
      status = BookingStatus.cancelled;
    }

    final stadium = json['stadium'] as Map<String, dynamic>? ?? {};

    return BookingModel(
      id: json['id'] ?? 0,
      stadiumId: json['stadiumId'] ?? stadium['id'] ?? 0,
      stadiumName: json['stadiumName'] ?? stadium['name'] ?? '',
      stadiumImage: _parseImage(json),
      category: json['categoryName'] ?? stadium['categoryName'] ?? stadium['category'] ?? '',
      date: json['date'] ?? json['bookingDate'] ?? '',
      time: json['time'] ?? json['bookingTime'] ?? json['startTime'] ?? '',
      durationMinutes: json['durationMinutes'] ?? json['duration'] ?? 60,
      totalPrice: _parsePrice(json),
      status: status,
    );
  }
}
