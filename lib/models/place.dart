import 'package:cloud_firestore/cloud_firestore.dart';

class Place {
  String name;
  String address;
  double latitude;
  double longitude;
  String photoReference;
  double pricing;
  double rating;
  int vote;
  DocumentSnapshot snapshot;
  DocumentReference reference;
  String documentID;

  Place({
    this.name,
    this.address,
    this.latitude,
    this.longitude,
    this.photoReference,
    this.pricing,
    this.rating,
    this.vote,
    this.snapshot,
    this.reference,
    this.documentID,
  });

  factory Place.fromFirestore(DocumentSnapshot snapshot) {
    if (snapshot == null) return null;
    var map = snapshot.data();

    return Place(
      name: map['name'],
      address: map['address'],
      latitude: map['latitude'],
      longitude: map['longitude'],
      photoReference: map['photoReference'],
      pricing: map['pricing'],
      rating: map['rating'],
      vote: map['vote'],
      snapshot: snapshot,
      reference: snapshot.reference,
      documentID: snapshot.id,
    );
  }

  factory Place.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return Place(
      name: map['name'],
      address: map['address'],
      latitude: map['latitude'],
      longitude: map['longitude'],
      photoReference: map['photoReference'],
      pricing: map['pricing'],
      rating: map['rating'],
      vote: map['vote'],
    );
  }

  Map<String, dynamic> toMap() => {
        'name': name,
        'address': address,
        'latitude': latitude,
        'longitude': longitude,
        'photoReference': photoReference,
        'pricing': pricing,
        'rating': rating,
        'vote': vote,
      };

  Place copyWith({
    String name,
    String address,
    double latitude,
    double longitude,
    String photoReference,
    double pricing,
    double rating,
    int vote,
  }) {
    return Place(
      name: name ?? this.name,
      address: address ?? this.address,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      photoReference: photoReference ?? this.photoReference,
      pricing: pricing ?? this.pricing,
      rating: rating ?? this.rating,
      vote: vote ?? this.vote,
    );
  }

  @override
  String toString() {
    return '${name.toString()}, ${address.toString()}, ${latitude.toString()}, ${longitude.toString()}, ${photoReference.toString()}, ${pricing.toString()}, ${rating.toString()}, ${vote.toString()}, ';
  }

  @override
  bool operator ==(other) => other is Place && documentID == other.documentID;

  int get hashCode => documentID.hashCode;
}
