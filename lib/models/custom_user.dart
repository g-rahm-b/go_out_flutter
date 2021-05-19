import 'package:cloud_firestore/cloud_firestore.dart';

class CustomUser {
  final String uid;
  final String name;
  final String country;
  final String state;
  final String city;
  final String imageUrl;
  bool isInvited;
  bool acceptedInvite;
  bool voteStatus;
  final String friendRequestTimeStamp;
  final List<String> friendRequestsReceived;
  final List<String> friendRequestsSent;
  final List<String> friends;
  final List<String> eventInvites;
  final List<String> events;
  final DocumentSnapshot snapshot;
  final DocumentReference reference;
  final String documentID;

  CustomUser({
    this.uid,
    this.name,
    this.country,
    this.state,
    this.city,
    this.imageUrl,
    this.isInvited,
    this.acceptedInvite,
    this.voteStatus,
    this.friendRequestTimeStamp,
    this.friendRequestsReceived,
    this.friendRequestsSent,
    this.friends,
    this.eventInvites,
    this.events,
    this.snapshot,
    this.reference,
    this.documentID,
  });

  factory CustomUser.fromFirestore(DocumentSnapshot snapshot) {
    if (snapshot == null) return null;
    var map = snapshot.data();
    return CustomUser(
      uid: map['uid'],
      name: map['name'],
      country: map['country'],
      state: map['state'],
      city: map['city'],
      imageUrl: map['imageUrl'],
      isInvited: map['isInvited'],
      acceptedInvite: map['acceptedInvite'],
      voteStatus: map['voteStatus'],
      friendRequestTimeStamp: map['friendRequestTimeStamp'],
      friendRequestsReceived: map['friendRequestsReceived'] != null
          ? List<String>.from(map['friendRequestsReceived'])
          : null,
      friendRequestsSent: map['friendRequestsSent'] != null
          ? List<String>.from(map['friendRequestsSent'])
          : null,
      friends:
          map['friends'] != null ? List<String>.from(map['friends']) : null,
      eventInvites: map['eventInvites'] != null
          ? List<String>.from(map['eventInvites'])
          : null,
      events: map['events'] != null ? List<String>.from(map['events']) : null,
      snapshot: snapshot,
      reference: snapshot.reference,
      documentID: snapshot.id,
    );
  }

  factory CustomUser.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return CustomUser(
      uid: map['uid'],
      name: map['name'],
      country: map['country'],
      state: map['state'],
      city: map['city'],
      imageUrl: map['imageUrl'],
      isInvited: map['isInvited'],
      acceptedInvite: map['acceptedInvite'],
      voteStatus: map['voteStatus'],
      friendRequestTimeStamp: map['friendRequestTimeStamp'],
      friendRequestsReceived: map['friendRequestsReceived'] != null
          ? List<String>.from(map['friendRequestsReceived'])
          : null,
      friendRequestsSent: map['friendRequestsSent'] != null
          ? List<String>.from(map['friendRequestsSent'])
          : null,
      friends:
          map['friends'] != null ? List<String>.from(map['friends']) : null,
      eventInvites: map['eventInvites'] != null
          ? List<String>.from(map['eventInvites'])
          : null,
      events: map['events'] != null ? List<String>.from(map['events']) : null,
    );
  }

  Map<String, dynamic> toMap() => {
        'uid': uid,
        'name': name,
        'country': country,
        'state': state,
        'city': city,
        'imageUrl': imageUrl,
        'isInvited': isInvited,
        'acceptedInvite': acceptedInvite,
        'voteStatus': voteStatus,
        'friendRequestTimeStamp': friendRequestTimeStamp,
        'friendRequestsReceived': friendRequestsReceived,
        'friendRequestsSent': friendRequestsSent,
        'friends': friends,
        'eventInvites': eventInvites,
        'events': events,
      };

  CustomUser copyWith({
    String uid,
    String name,
    String country,
    String state,
    String city,
    String imageUrl,
    bool isInvited,
    bool acceptedInvite,
    bool voteStatus,
    String friendRequestTimeStamp,
    List<String> friendRequestsReceived,
    List<String> friendRequestsSent,
    List<String> friends,
    List<String> eventInvites,
    List<String> events,
  }) {
    return CustomUser(
      uid: uid ?? this.uid,
      name: name ?? this.name,
      country: country ?? this.country,
      state: state ?? this.state,
      city: city ?? this.city,
      imageUrl: imageUrl ?? this.imageUrl,
      isInvited: isInvited ?? this.isInvited,
      acceptedInvite: acceptedInvite ?? this.acceptedInvite,
      voteStatus: voteStatus ?? this.voteStatus,
      friendRequestTimeStamp:
          friendRequestTimeStamp ?? this.friendRequestTimeStamp,
      friendRequestsReceived:
          friendRequestsReceived ?? this.friendRequestsReceived,
      friendRequestsSent: friendRequestsSent ?? this.friendRequestsSent,
      friends: friends ?? this.friends,
      eventInvites: eventInvites ?? this.eventInvites,
      events: events ?? this.events,
    );
  }

  @override
  String toString() {
    return '${uid.toString()}, ${name.toString()}, ${country.toString()}, ${state.toString()}, ${city.toString()}, ${imageUrl.toString()}, ${isInvited.toString()}, ${acceptedInvite.toString()}, ${voteStatus.toString()}, ${friendRequestTimeStamp.toString()}, ${friendRequestsReceived.toString()}, ${friendRequestsSent.toString()}, ${friends.toString()}, ${eventInvites.toString()}, ${events.toString()}, ';
  }

  @override
  bool operator ==(other) =>
      other is CustomUser && documentID == other.documentID;

  int get hashCode => documentID.hashCode;
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
