class UserModel {
  final String id;
  final String displayName;
  final String email;
  final String? phoneNumber;
  final String? profilePictureUrl;
  final int bookingsCount;
  final int pitchesCount;
  final int points;

  const UserModel({
    required this.id,
    required this.displayName,
    required this.email,
    this.phoneNumber,
    this.profilePictureUrl,
    this.bookingsCount = 0,
    this.pitchesCount = 0,
    this.points = 0,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id']?.toString() ?? '',
      displayName: json['displayName'] ?? json['name'] ?? '',
      email: json['email'] ?? '',
      phoneNumber: json['phoneNumber'] ?? json['phone'],
      profilePictureUrl: json['profilePictureUrl'] ?? json['avatarUrl'] ?? json['image'],
      bookingsCount: json['bookingsCount'] ?? json['bookings_count'] ?? 0,
      pitchesCount: json['pitchesCount'] ?? json['pitches_count'] ?? json['stadiumsCount'] ?? 0,
      points: json['points'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'displayName': displayName,
      'email': email,
      'phoneNumber': phoneNumber,
      'profilePictureUrl': profilePictureUrl,
      'bookingsCount': bookingsCount,
      'pitchesCount': pitchesCount,
      'points': points,
    };
  }

  UserModel copyWith({
    String? id,
    String? displayName,
    String? email,
    String? phoneNumber,
    String? profilePictureUrl,
    int? bookingsCount,
    int? pitchesCount,
    int? points,
  }) {
    return UserModel(
      id: id ?? this.id,
      displayName: displayName ?? this.displayName,
      email: email ?? this.email,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      profilePictureUrl: profilePictureUrl ?? this.profilePictureUrl,
      bookingsCount: bookingsCount ?? this.bookingsCount,
      pitchesCount: pitchesCount ?? this.pitchesCount,
      points: points ?? this.points,
    );
  }
}
