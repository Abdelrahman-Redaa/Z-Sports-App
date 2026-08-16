enum BookingStatus { upcoming, pendingPayment, completed, cancelled }

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

  static BookingStatus _parseStatus(String raw) {
    final s = raw.toLowerCase();
    if (s.contains('cancel')) {
      return BookingStatus.cancelled;
    }
    if (s.contains('complet') || s.contains('done')) {
      return BookingStatus.completed;
    }
    if (s.contains('pending') || s.contains('payment')) {
      return BookingStatus.pendingPayment;
    }
    return BookingStatus.upcoming;
  }

  static double _parsePrice(Map<String, dynamic> json) {
    for (final key in [
      'totalPrice',
      'total',
      'price',
      'amount',
      'totalAmount',
      'cost',
      'bookingPrice',
      'bookingCost',
      'pricePerHour',
      'TotalPrice',
      'Total',
      'Price',
      'Amount',
    ]) {
      final val = json[key];
      if (val != null) {
        final parsed = double.tryParse(val.toString());
        if (parsed != null && parsed > 0) return parsed;
      }
    }

    for (final parentKey in ['stadium', 'pitch', 'playground', 'field']) {
      final parent = json[parentKey];
      if (parent is! Map<String, dynamic>) continue;

      for (final key in [
        'pricePerHour',
        'pricePerSlot',
        'hourPrice',
        'hourlyPrice',
        'price',
        'Price',
      ]) {
        final val = parent[key];
        if (val != null) {
          final parsed = double.tryParse(val.toString());
          if (parsed != null && parsed > 0) return parsed;
        }
      }
    }

    return 0.0;
  }

  static String _parseImage(Map<String, dynamic> json) {
    for (final key in [
      'imageUrl',
      'image',
      'stadiumImage',
      'coverImage',
      'thumbnail',
      'photo',
      'ImageUrl',
      'Image',
    ]) {
      final val = json[key];
      if (val != null && val.toString().isNotEmpty) return val.toString();
    }

    final stadium = json['stadium'] as Map<String, dynamic>? ?? {};

    for (final key in [
      'imageUrl',
      'image',
      'coverImage',
      'thumbnail',
      'photo',
    ]) {
      final val = stadium[key];
      if (val != null && val.toString().isNotEmpty) return val.toString();
    }

    for (final arrKey in ['images', 'Images', 'photos']) {
      final images = stadium[arrKey] as List<dynamic>?;
      if (images != null && images.isNotEmpty) {
        final first = images.first;
        if (first is Map) {
          for (final k in [
            'imageUrl',
            'url',
            'path',
            'src',
            'ImageUrl',
            'Url',
          ]) {
            final v = first[k];
            if (v != null && v.toString().isNotEmpty) return v.toString();
          }
        } else if (first is String && first.isNotEmpty) {
          return first;
        }
      }
    }

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
    final rawStatus = (json['status'] ?? json['bookingStatus'] ?? '')
        .toString();
    final stadium = json['stadium'] as Map<String, dynamic>? ?? {};

    return BookingModel(
      id: json['id'] ?? 0,
      stadiumId: json['stadiumId'] ?? stadium['id'] ?? 0,
      stadiumName: json['stadiumName'] ?? stadium['name'] ?? '',
      stadiumImage: _parseImage(json),
      category:
          json['categoryName'] ??
          stadium['categoryName'] ??
          stadium['category'] ??
          '',
      date: json['date'] ?? json['bookingDate'] ?? '',
      time: json['time'] ?? json['bookingTime'] ?? json['startTime'] ?? '',
      durationMinutes: json['durationMinutes'] ?? json['duration'] ?? 60,
      totalPrice: _parsePrice(json),
      status: _parseStatus(rawStatus),
    );
  }
}
