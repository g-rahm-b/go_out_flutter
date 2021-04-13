class Place {
  String name;
  String address;
  double latitude;
  double longitude;
  String photoReference;
  int pricing;
  double rating;
  int vote;

  Place(
      {this.name,
      this.address,
      this.latitude,
      this.longitude,
      this.photoReference,
      this.pricing,
      this.rating,

      //Vote will only be used when a user is voting on places.
      //Just adding this in here to ensure the places and votes don't get mixed up
      this.vote});

  Map toJson() => {
        'name': name,
        'address': address,
        'latitude': latitude.toString(),
        'longitude': longitude.toString(),
        'photoReference': photoReference,
        'pricing': pricing.toString(),
        'rating': rating.toString(),
      };

  //When pulling an event out of the database
  Place.fromJson(Map parsedJson) {
    name = parsedJson['name'] ?? 'name Unknown';
    address = parsedJson['address'] ?? 'address unknown';
    latitude = parsedJson['latitude'] is String
        ? double.parse(parsedJson['latitude'])
        : parsedJson['latitude'];
    longitude = parsedJson['longitude'] is String
        ? double.parse(parsedJson['longitude'])
        : parsedJson['longitude'];
    photoReference = parsedJson['host'] ?? 'assets/default_user_image.png';
    pricing = parsedJson['pricing'] is String
        ? int.parse(parsedJson['pricing'])
        : parsedJson['pricing'];
    rating = parsedJson['rating'] is String
        ? double.parse(parsedJson['rating'])
        : parsedJson['rating'];
  }
}
