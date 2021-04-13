import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:go_out_v2/models/custom_user.dart';
import 'package:go_out_v2/models/place.dart';

class EventTwo {
  final String date;
  final String eventName;
  final String googleLink;
  final String type;
  final String eventId;
  final CustomUser host;
  final double searchRadius;
  final double lat;
  final double lng;
  final List<CustomUser> invitedUsers;
  final List<Place> places;
  final DocumentSnapshot snapshot;
  final DocumentReference reference;
  final String documentID;

  EventTwo({
    this.date,
    this.eventName,
    this.googleLink,
    this.type,
    this.eventId,
    this.host,
    this.searchRadius,
    this.lat,
    this.lng,
    this.invitedUsers,
    this.places,
    this.snapshot,
    this.reference,
    this.documentID,
  });

  factory EventTwo.fromFirestore(DocumentSnapshot snapshot) {
    if (snapshot == null) return null;
    var map = snapshot.data();

    return EventTwo(
      date: map['date'],
      eventName: map['eventName'],
      googleLink: map['googleLink'],
      type: map['type'],
      eventId: map['eventId'],
      host: map['host'] != null ? CustomUser.fromMap(map['host']) : null,
      searchRadius: map['searchRadius'],
      lat: map['lat'],
      lng: map['lng'],
      invitedUsers: map['invitedUsers'] != null
          ? List<CustomUser>.from(map['invitedUsers'])
          : null,
      places: map['places'] != null ? List<Place>.from(map['places']) : null,
      snapshot: snapshot,
      reference: snapshot.reference,
      documentID: snapshot.id,
    );
  }

  factory EventTwo.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return EventTwo(
      date: map['date'],
      eventName: map['eventName'],
      googleLink: map['googleLink'],
      type: map['type'],
      eventId: map['eventId'],
      host: map['host'] != null ? CustomUser.fromMap(map['host']) : null,
      searchRadius: map['searchRadius'],
      lat: map['lat'],
      lng: map['lng'],
      invitedUsers: map['invitedUsers'] != null
          ? List<CustomUser>.from(map['invitedUsers'])
          : null,
      places: map['places'] != null ? List<Place>.from(map['places']) : null,
    );
  }

  Map<String, dynamic> toMap() => {
        'date': date,
        'eventName': eventName,
        'googleLink': googleLink,
        'type': type,
        'eventId': eventId,
        'host': host,
        'searchRadius': searchRadius,
        'lat': lat,
        'lng': lng,
        'invitedUsers': invitedUsers,
        'places': places,
      };

  EventTwo copyWith({
    String date,
    String eventName,
    String googleLink,
    String type,
    String eventId,
    CustomUser host,
    double searchRadius,
    double lat,
    double lng,
    List<CustomUser> invitedUsers,
    List<Place> places,
  }) {
    return EventTwo(
      date: date ?? this.date,
      eventName: eventName ?? this.eventName,
      googleLink: googleLink ?? this.googleLink,
      type: type ?? this.type,
      eventId: eventId ?? this.eventId,
      host: host ?? this.host,
      searchRadius: searchRadius ?? this.searchRadius,
      lat: lat ?? this.lat,
      lng: lng ?? this.lng,
      invitedUsers: invitedUsers ?? this.invitedUsers,
      places: places ?? this.places,
    );
  }

  @override
  String toString() {
    return '${date.toString()}, ${eventName.toString()}, ${googleLink.toString()}, ${type.toString()}, ${eventId.toString()}, ${host.toString()}, ${searchRadius.toString()}, ${lat.toString()}, ${lng.toString()}, ${invitedUsers.toString()}, ${places.toString()}, ';
  }

  @override
  bool operator ==(other) =>
      other is EventTwo && documentID == other.documentID;

  int get hashCode => documentID.hashCode;
}
