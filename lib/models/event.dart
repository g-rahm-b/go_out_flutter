import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:go_out_v2/models/custom_user.dart';
import 'package:go_out_v2/models/place.dart';

class Event {
  final String date;
  final String eventName;
  String googleLink;
  final String type;
  String eventId;
  //Might implement the changing of hosts
  CustomUser host;
  final double searchRadius;
  final double lat;
  final double lng;
  final DocumentSnapshot snapshot;
  final DocumentReference reference;
  final String documentID;

  //Lists could potenetially shrink or grow.
  List<CustomUser> invitedUsers;
  List<Place> places;

  Event({
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

  factory Event.fromFirestore(DocumentSnapshot snapshot) {
    if (snapshot == null) return null;

    var map = snapshot.data();
    CustomUser tempHost = new CustomUser.fromMap(map['host']);

    var invUsersJson = map['invitedUsers'] as List;
    List<CustomUser> invitedUsersTemp = [];
    invUsersJson.forEach((element) {
      CustomUser userAdd = new CustomUser();
      userAdd = CustomUser.fromMap(element);
      invitedUsersTemp.add(userAdd);
    });

    var placesJson = map['places'] as List;
    List<Place> placesTemp = [];
    placesJson.forEach((element) {
      Place placeAdd = new Place();
      placeAdd = Place.fromMap(element);
      placesTemp.add(placeAdd);
    });

    return Event(
      date: map['date'],
      eventName: map['eventName'],
      googleLink: map['googleLink'],
      type: map['type'],
      eventId: map['eventId'],
      host: map['host'] != null ? tempHost : null,
      searchRadius: map['searchRadius'],
      lat: map['lat'],
      lng: map['lng'],
      invitedUsers: invitedUsersTemp,
      places: map['places'] != null ? placesTemp : null,
      snapshot: snapshot,
      reference: snapshot.reference,
      documentID: snapshot.id,
    );
  }

  factory Event.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return Event(
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

  Map<String, dynamic> toMap() {
    List<Map> invUsersTemp = this.invitedUsers != null
        ? this.invitedUsers.map((user) => user.toMap()).toList()
        : null;

    //Will need to map all of the listed Invited Users.
    List<Map> placesTemp = this.places != null
        ? this.places.map((place) => place.toMap()).toList()
        : null;

    return {
      'date': date,
      'eventName': eventName,
      'googleLink': googleLink,
      'type': type,
      'eventId': eventId,
      'host': host.toMap(),
      'searchRadius': searchRadius,
      'lat': lat,
      'lng': lng,
      'invitedUsers': invUsersTemp,
      'places': placesTemp,
    };
  }

  Event copyWith({
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
    return Event(
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
  bool operator ==(other) => other is Event && documentID == other.documentID;

  int get hashCode => documentID.hashCode;
}
