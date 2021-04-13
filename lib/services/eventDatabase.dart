import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:go_out_v2/models/custom_user.dart';
import 'package:go_out_v2/models/event.dart';
import 'package:go_out_v2/models/place.dart';
import 'package:go_out_v2/models/votes.dart';
import 'package:google_place/google_place.dart';
import 'package:go_out_v2/credentials.dart';
import 'package:go_out_v2/services/auth.dart';

class EventDatabase {
  Future<void> createNewEvent(Event newEvent) async {
    final CollectionReference events =
        FirebaseFirestore.instance.collection('events');
    String currentUid = AuthService().fetchUid();

    //ToDo: To make things faster, just request the data you actually need
    //Get the google place information
    var googlePlace = GooglePlace(PLACES_API_KEY);
    var result = await googlePlace.search.getNearBySearch(
      Location(lat: newEvent.lat, lng: newEvent.lng),
      newEvent.searchRadius.toInt(),
      keyword: newEvent.type,
    );

    if (result != null) {
      int i = 0;
      List<Place> places = [];
      result.results.forEach((element) {
        Place newPlace = Place();
        //ToDo: Probably a more robust way of handling this. Could probably just ask for 5 results.
        if (i < 5 && element.businessStatus == "OPERATIONAL") {
          newPlace.longitude = element.geometry.location.lng ?? 0;
          newPlace.latitude = element.geometry.location.lat ?? 0;
          newPlace.pricing = element.priceLevel ?? 0;
          newPlace.photoReference = element.photos[0].photoReference ?? 0;
          newPlace.rating = element.rating ?? 0;
          newPlace.address = element.vicinity ?? "Address Unavailable";
          newPlace.name = element.name ?? "Name Unavailable";
          print(newPlace.name);
          places.add(newPlace);
          i++;
        }
      });
      if (places.length == 0) {
        //ToDo: There are no results. Need to return an error to the user.
        return;
      } else {
        newEvent.places = places;
      }
    }

    newEvent.host = await getEventHostData(currentUid);
    //Also want the host to show up in the invite list, for when we populate that list for other users.
    newEvent.invitedUsers.add(newEvent.host);
    String eventId = '';

    //Add the event to the database.
    await events.add({'eventData': ''}).then((value) {
      eventId = value.id;
      newEvent.eventId = eventId;
    }).catchError((error) => print("There's been a problem: $error"));
    //Need to add the eventID into the DB

    await events.doc(eventId).update({'eventData': newEvent.toJson()}).then(
        (value) => print("Updated event ID"));

    //Add the invites for the other users.
    print('** INVITING USERS TO EVENT **');
    await inviteUsersToEvent(newEvent.invitedUsers, newEvent.host, eventId);

    //Add the event to the HOSTID's accepted event page.
    await addEventToHost(newEvent.host, eventId);

    return;
  }

  //The event has been created, now sending the invite to all of the users on the list
  Future<void> inviteUsersToEvent(
      List<CustomUser> usersToInvite, CustomUser host, String eventId) async {
    final CollectionReference users =
        FirebaseFirestore.instance.collection('users');
    for (int i = 0; i < usersToInvite.length; i++) {
      //Make sure we don't re-invite the host
      if (usersToInvite[i].uid != host.uid) {
        await users
            .doc(usersToInvite[i].uid)
            .collection('eventInvites')
            .doc(eventId)
            .set({'inviteTime': Timestamp.now()})
            .then((value) => print("Added invite to user"))
            .catchError((error) => print(error));
      }
    }
  }

  Future<void> addEventToHost(CustomUser host, String eventId) async {
    final DocumentReference hostRef =
        FirebaseFirestore.instance.collection('users').doc(host.uid);
    await hostRef
        .collection('events')
        .doc(eventId)
        .set({'acceptedOn': Timestamp.now()})
        .then((value) => print("Added event to host"))
        .catchError((error) => print(error));
  }

  Future<CustomUser> getEventHostData(String currentUid) async {
    CustomUser host = new CustomUser();
    final fireStoreInstance =
        FirebaseFirestore.instance.collection('users').doc(currentUid);
    var userData = await fireStoreInstance.get();
    host.name = userData.get('name');
    host.city = userData.get('city');
    host.country = userData.get('country');
    host.state = userData.get('state');
    host.uid = currentUid;
    return host;
  }

  //Get the user's events and populate them.
  Future<List<Event>> getUserEvents() async {
    String currentUid = AuthService().fetchUid();
    try {
      List<String> userEventIds = [];

      final fireStoreInstance = FirebaseFirestore.instance
          .collection('users')
          .doc(currentUid)
          .collection('events');
      var result = await fireStoreInstance.get();
      result.docs.forEach((element) {
        userEventIds.add(element.id);
      });

      List<Event> userEvents = [];
      userEvents = await populateEventData(userEventIds);

      return userEvents;
    } catch (e) {
      print(e);
      return null;
    }
  }

  //This is broked out to the others, just to ensure proper Async/Await ordering
  Future<List<Event>> populateEventData(List<String> userEventIds) async {
    List<Event> userEvents = [];
    userEvents = await buildEventList(userEventIds);
    return userEvents;
  }

  Future<List<Event>> buildEventList(List<String> userEventIds) async {
    List<Event> userEvents = [];
    //Go through each of the user's event IDs, and populate them.
    for (int i = 0; i < userEventIds.length; i++) {
      Event newEvent = await populateEventFromId(userEventIds[i]);
      userEvents.add(newEvent);
    }

    return userEvents;
  }

  Future<Event> populateEventFromId(String eventId) async {
    final fireStoreInstance = FirebaseFirestore.instance.collection('events');
    Event newEvent = new Event();
    await fireStoreInstance.doc(eventId).get().then((querySnapshot) {
      Map<String, dynamic> map =
          new Map<String, dynamic>.from(querySnapshot.get('eventData'));
      newEvent = Event.fromJson(map);
    });
    // print('returning event');
    return newEvent;
  }

  Future<void> submitPlaceVotes(Event event) async {
    //First, we want to retrieve the current place votes:

    List<String> names = [];
    List<int> votes = [];
    event.places.forEach((element) {});

    final eventVotes = FirebaseFirestore.instance
        .collection('events')
        .doc(event.eventId)
        .collection('votes');

    await eventVotes.get().then((snapshot) {
      if (snapshot.docs.isEmpty) {
        for (int i = 0; i < votes.length; i++) {}
      } else {}
    });

    //Second, we want to add our current votes to those values

    //Return, and send the user to the event.
  }
}
