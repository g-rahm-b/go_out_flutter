import 'package:go_out_v2/models/custom_user.dart';
import 'package:go_out_v2/models/place.dart';

class Event {
  String date;
  String eventName;
  String googleLink;
  String type;
  String eventId;
  CustomUser host;
  double searchRadius;
  double lat;
  double lng;
  List<CustomUser> invitedUsers;
  List<Place> places;

  Event(
      {this.date,
      this.eventName,
      this.googleLink,
      this.host,
      this.type,
      this.eventId,
      this.lat,
      this.lng,
      this.searchRadius,
      this.invitedUsers,
      this.places});

  //toJson setup for pushing events to the database
  Map toJson() {
    //Will need to map all of the listed Custom Users.
    // this.invitedUsers.add(this.host);
    List<Map> invitedUsers = this.invitedUsers != null
        ? this.invitedUsers.map((user) => user.toJson()).toList()
        : null;

    //Will need to map all of the listed Invited Users.
    List<Map> places = this.places != null
        ? this.places.map((place) => place.toJson()).toList()
        : null;

    return {
      'date': date,
      'eventName': eventName,
      'eventId': eventId,
      'googleLink': googleLink,
      'type': type,
      'host': host.toJson(),
      'searchRadius': searchRadius.toString(),
      'lat': lat.toString(),
      'lng': lng.toString(),
      'places': places,
      'invitedUsers': invitedUsers,
    };
  }

  //When pulling an event out of the database
  Event.fromJson(Map parsedJson) {
    var invUsersJson = parsedJson['invitedUsers'] as List;
    List<CustomUser> invitedUsersTemp = [];
    invUsersJson.forEach((element) {
      CustomUser userAdd = new CustomUser();
      userAdd = CustomUser.fromJson(element);
      invitedUsersTemp.add(userAdd);
    });

    var placesJson = parsedJson['places'] as List;
    List<Place> placesTemp = [];
    placesJson.forEach((element) {
      Place placeAdd = new Place();
      placeAdd = Place.fromJson(element);
      placesTemp.add(placeAdd);
    });

    invitedUsers = invitedUsersTemp;
    places = placesTemp;
    var hostData = parsedJson['host'];
    host = CustomUser.fromJson(hostData);
    date = parsedJson['date'] ?? 'Date Unknown';
    eventId = parsedJson['eventId'] ?? null;
    eventName = parsedJson['eventName'] ?? '';
    googleLink = parsedJson['googleLink'] ?? 'Date Unknown';
    type = parsedJson['type'] ?? '';
    searchRadius = double.parse(parsedJson['searchRadius']) ?? 0.0;
    lat = double.parse(parsedJson['lat']) ?? 0.0;
    lng = double.parse(parsedJson['lng']) ?? 0.0;
  }
}
