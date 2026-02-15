/// Model class for location data
/// Contains address, latitude, and longitude information
class LocationData {
  final String address;
  final double latitude;
  final double longitude;

  const LocationData({
    required this.address,
    required this.latitude,
    required this.longitude,
  });

  /// Creates LocationData from JSON
  factory LocationData.fromJson(Map<String, dynamic> json) {
    return LocationData(
      address: json['address'] as String,
      latitude: json['latitude'] as double,
      longitude: json['longitude'] as double,
    );
  }

  /// Converts LocationData to JSON
  Map<String, dynamic> toJson() {
    return {'address': address, 'latitude': latitude, 'longitude': longitude};
  }

  /// Creates a copy with modified fields
  LocationData copyWith({
    String? address,
    double? latitude,
    double? longitude,
  }) {
    return LocationData(
      address: address ?? this.address,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
    );
  }

  @override
  String toString() {
    return 'LocationData(address: $address, latitude: $latitude, longitude: $longitude)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is LocationData &&
        other.address == address &&
        other.latitude == latitude &&
        other.longitude == longitude;
  }

  @override
  int get hashCode => Object.hash(address, latitude, longitude);
}
