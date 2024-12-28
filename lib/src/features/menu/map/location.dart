class Location {
  final String address;
  final double lat;
  final double lng;

  Location({required this.address, required this.lat, required this.lng});

  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
      address: json['address'] as String,
      lat: (json['lat'] as num).toDouble(),
      lng: (json['lng'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'address': address,
      'lat': lat,
      'lng': lng,
    };
  }
}
