import 'dart:convert';

class CustomUser {
  //ToDo: Will need to add the user's friends and events lists to this model
  String uid;
  String name;
  String country;
  String state;
  String city;
  String imageUrl;
  bool isInvited;
  bool acceptedInvite;
  bool voteStatus;
  String friendRequestTimeStamp;
  List<String> friendRequestsReceived;
  List<String> friendRequestsSent;
  List<String> friends;
  List<String> eventInvites;
  List<String> events;

  CustomUser(
      {this.uid,
      this.name,
      this.city,
      this.country,
      this.state,
      this.imageUrl,
      this.friendRequestTimeStamp,
      this.friendRequestsReceived,
      this.friendRequestsSent,
      this.friends,
      this.eventInvites,
      this.events,
      this.isInvited,
      this.acceptedInvite,
      this.voteStatus});

  Map toJson() => {
        'uid': uid,
        'name': name,
        'city': city,
        'country': country,
        'state': state,
        'imageUrl': imageUrl,
        'friendRequestTimeStamp': friendRequestTimeStamp.toString(),
        'isInvited': isInvited.toString(),
        'acceptedInvite': acceptedInvite.toString(),
        'voteStatus': voteStatus.toString(),
        'friendRequestsReceived': jsonEncode(friendRequestsReceived),
        'friendRequestsSent': jsonEncode(friendRequestsSent),
        'friends': jsonEncode(friends),
        'eventInvites': jsonEncode(eventInvites),
        'events': jsonEncode(events),
      };

//When pulling an event out of the database
  CustomUser.fromJson(Map parsedJson) {
    uid = parsedJson['uid'] ?? 'Failed to load UID';
    name = parsedJson['name'] ?? 'Failed to load name';
    city = parsedJson['city'] ?? 'Failed to load city';
    country = parsedJson['country'] ?? 'country Unknown';
    state = parsedJson['state'] ?? 'state Unknown';
    imageUrl = parsedJson['imageUrl'] ?? 'assets/default_user_image.png';
    friendRequestTimeStamp = parsedJson['friendRequestTimeStamp'] ?? null;
    if (parsedJson['friendRequestsReceived'] != 'null') {
      friendRequestsReceived = <String>[];
      parsedJson['friendRequestsReceived'].forEach((v) {
        friendRequestsReceived.add(v);
      });
    } else {
      friendRequestsReceived = null;
    }
    if (parsedJson['friendRequestsSent'] != 'null') {
      friendRequestsSent = <String>[];
      parsedJson['friendRequestsSent'].forEach((v) {
        friendRequestsSent.add(v);
      });
    } else {
      friendRequestsSent = null;
    }
    if (parsedJson['friends'] != 'null') {
      friendRequestsSent = <String>[];
      parsedJson['friends'].forEach((v) {
        friends.add(v);
      });
    } else {
      friends = null;
    }
    if (parsedJson['eventInvites'] != 'null') {
      eventInvites = <String>[];
      parsedJson['eventInvites'].forEach((v) {
        eventInvites.add(v);
      });
    } else {
      eventInvites = null;
    }
    if (parsedJson['acceptedInvite'] == "true") {
      acceptedInvite = true;
    } else {
      acceptedInvite = false;
    }
    if (parsedJson['isInvited'] == "true") {
      isInvited = true;
    } else {
      isInvited = false;
    }
    if (parsedJson['voteStatus'] == "true") {
      voteStatus = true;
    } else {
      voteStatus = false;
    }
  }
}

//ToDo: I doubt I'll need userData, as the CustomUser is what's primarily used.
class UserData {
  final String uid;
  final String sugars;
  final int strength;

  String name;
  String country;
  String state;
  String city;

  UserData(
      {this.uid,
      this.sugars,
      this.strength,
      this.name,
      this.city,
      this.country,
      this.state});
}
