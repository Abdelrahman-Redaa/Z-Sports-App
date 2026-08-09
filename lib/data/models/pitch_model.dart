class PitchModel {
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
}
