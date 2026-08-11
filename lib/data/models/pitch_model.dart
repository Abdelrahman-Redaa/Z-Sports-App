class PitchModel {
  final String id;
  final String name;
  final String imageUrl;
  final double rating;
  final int reviewCount;
  final double pricePerHour;
  final String location;
  final String distance;
  final String category;
  final List<String> amenities;
  final String description;
  final bool isPopular;

  const PitchModel({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.rating,
    required this.reviewCount,
    required this.pricePerHour,
    required this.location,
    required this.distance,
    required this.category,
    required this.amenities,
    required this.description,
    this.isPopular = false,
  });

  factory PitchModel.fromJson(Map<String, dynamic> json) {
    final images = json['images'] as List<dynamic>? ?? [];
    final imageUrl = images.isNotEmpty
        ? (images.first['url'] ?? images.first['imageUrl'] ?? '').toString()
        : (json['imageUrl'] ?? json['image'] ?? '').toString();

    final amenitiesRaw = json['amenities'] as List<dynamic>? ?? [];
    final amenities =
        amenitiesRaw.map((a) => (a['name'] ?? a.toString()).toString()).toList();

    return PitchModel(
      id: (json['id'] ?? json['stadiumId'])?.toString() ?? '',
      name: json['name'] ?? json['stadiumName'] ?? '',
      imageUrl: imageUrl,
      rating: (json['rating'] ?? json['averageRating'] ?? 0).toDouble(),
      reviewCount: json['reviewCount'] ?? json['reviewsCount'] ?? 0,
      pricePerHour:
          (json['pricePerHour'] ?? json['price'] ?? json['pricePerSlot'] ?? 0)
              .toDouble(),
      location: json['location'] ?? json['address'] ?? '',
      distance: json['distance'] ?? '',
      category: _parseCategory(json),
      amenities: amenities,
      description: json['description'] ?? '',
      isPopular: json['isPopular'] ?? json['isFeatured'] ?? false,
    );
  }

  static String _parseCategory(Map<String, dynamic> json) {
    final cat = json['category'];
    if (cat is Map) {
      return cat['name']?.toString() ?? '';
    } else if (cat is String) {
      return cat;
    }
    return json['categoryName']?.toString() ?? '';
  }
}
