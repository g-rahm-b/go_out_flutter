import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:go_out_v2/models/custom_user.dart';
import 'package:go_out_v2/models/event.dart';
import 'package:go_out_v2/models/place.dart';
import 'package:go_out_v2/models/votes.dart';
import 'package:google_place/google_place.dart';
import 'package:go_out_v2/credentials.dart';
import 'package:go_out_v2/services/auth.dart';

class EventDatabase {
  Future<Event> getPlacesForEvent(Event newEvent) async {
    print('Checking for places during event planning');
    var googlePlace = GooglePlace(PLACES_API_KEY);
    var result = await googlePlace.search.getNearBySearch(
      Location(lat: newEvent.lat, lng: newEvent.lng),
      newEvent.searchRadius.toInt(),
      keyword: newEvent.type,
    );
    if (result != null &&
        result.status != 'ZERO_RESULTS' &&
        result.results != null) {
      int i = 0;
      List<Place> places = [];
      result.results.forEach((element) {
        print('Trying to check each element');
        //ToDo: Probably a more robust way of handling this. Could probably just ask for 5 results.
        if (i < 5 && element.businessStatus == "OPERATIONAL") {
          Place newPlace = Place(
              latitude: element.geometry.location.lat ?? 0.0,
              longitude: element.geometry.location.lng ?? 0.0,
              photoReference:
                  element.photos[0].photoReference ?? 'Does not exist.',
              pricing: element.priceLevel?.toDouble() ?? 0.0,
              rating: element.rating?.toDouble() ?? 0.0,
              address: element.vicinity ?? "Address Unavailable",
              name: element.name ?? "Name Unavailable");
          places.add(newPlace);
          print(newPlace.toString());
          i++;
        }
      });
      //Want to set the googleLink to not empty to inform us that there are place results
      newEvent.googleLink = 'Not_Empty';
      newEvent.places = places;
      return newEvent;
    } else {
      //If there are no results, want to let the user know to expand their search.
      print('No results');
      newEvent.googleLink = 'Empty';
      print('returning event');
      return newEvent;
    }
  }

  Future<void> createNewEvent(Event newEvent) async {
    final CollectionReference events =
        FirebaseFirestore.instance.collection('events');
    String currentUid = AuthService().fetchUid();
    DocumentReference ref = events.doc();
    String eventId = ref.id;
    newEvent.eventId = eventId;

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
        //ToDo: Probably a more robust way of handling this. Could probably just ask for 5 results.
        if (i < 5 && element.businessStatus == "OPERATIONAL") {
          Place newPlace = Place(
              latitude: element.geometry.location.lat ?? 0.0,
              longitude: element.geometry.location.lng ?? 0.0,
              photoReference:
                  element.photos[0].photoReference ?? 'Does not exist.',
              pricing: element.priceLevel?.toDouble() ?? 0.0,
              rating: element.rating?.toDouble() ?? 0.0,
              address: element.vicinity ?? "Address Unavailable",
              name: element.name ?? "Name Unavailable");
          places.add(newPlace);
          i++;
        }
      });
      if (result.results.isEmpty) {
        //ToDo: There are no results. Need to return an error to the user.
        return;
      } else {
        newEvent.places = places;
      }
    }

    newEvent.host = await getEventHostData(currentUid);
    //We will assume that the host has accpeted the invite, and their vote-status is falls.
    newEvent.host.acceptedInvite = true;
    newEvent.host.voteStatus = false;
    //Also want the host to show up in the invite list, for when we populate that list for other users.
    newEvent.invitedUsers.add(newEvent.host);
    //ToDo: Seems like the host isn't always added to the 'invited users list'
    newEvent.invitedUsers.forEach((element) {
      if (element.name == newEvent.host.name) {
        element.acceptedInvite = true;
        element.voteStatus = false;
      } else {
        element.acceptedInvite = false;
        element.voteStatus = false;
      }
    });
    var eventMap = newEvent.toMap();
    await ref.set(eventMap);
    await inviteUsersToEvent(newEvent.invitedUsers, newEvent.host, eventId);
    await addEventToHost(newEvent.host, eventId);
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
    final fireStoreInstance =
        FirebaseFirestore.instance.collection('users').doc(currentUid);
    var userData = await fireStoreInstance.get();
    CustomUser host = new CustomUser.fromFirestore(userData);
    return host;
  }

  //Get the user's events and populate them.
  Future<List<Event>> getUserEvents() async {
    String currentUid = AuthService().fetchUid();
    try {
      List<String> userEventIds = [];
      final fireStoreInstance =
          FirebaseFirestore.instance.collection('users').doc(currentUid);
      var result = await fireStoreInstance.collection('events').get();
      result.docs.forEach((element) {
        userEventIds.add(element.id);
      });
      result = await fireStoreInstance.collection('eventInvites').get();
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
    List<Event> userEvents = await buildEventList(userEventIds);
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
    final fireStoreInstance =
        FirebaseFirestore.instance.collection('events').doc(eventId);
    Event newEvent = new Event();
    await fireStoreInstance.get().then((querySnapshot) {
      newEvent = Event.fromFirestore(querySnapshot);
    });
    return newEvent;
  }

  Future<void> submitPlaceVotes(Event event) async {
    //First, we want to retrieve the current place votes:
    //Set up a bool to see if voting (from other users) has occured or not.
    List<Votes> votes = [];
    if (event.places.isNotEmpty) {
      event.places.forEach((element) {
        Votes placeVote = new Votes();
        placeVote.name = element.name;
        placeVote.vote = element.vote;
        votes.add(placeVote);
      });
      //Will need to map the list to allow one single push.

    } else {
      //No places are stored. Something must have gone wrong in event creation
      return;
    }

    //Going to use a transaction in case other users vote at the same time.
    DocumentReference docRef =
        FirebaseFirestore.instance.collection('events').doc(event.eventId);
    return FirebaseFirestore.instance.runTransaction((transaction) async {
      // Get the document
      DocumentSnapshot snapshot = await transaction.get(docRef);

      if (!snapshot.exists) {
        throw Exception("Event does not exist!");
      }

      //if there have been no votes at all, we can just upload our map.
      if (snapshot.data()['votes'] == null) {
        List<Map> voteMap = votes != null
            ? votes.map((placeVote) => placeVote.toMap()).toList()
            : null;
        transaction.update(docRef, {'votes': voteMap});
        //Now we want to update the invited users vote status.
        String currentUid = AuthService().fetchUid();
        //Unfortunately, for Firestore, we have to update all invited users
        List<CustomUser> updatedInvitedUsers = [];
        //Grabbing all invited users
        List.from(snapshot.data()['invitedUsers']).forEach((invitedUser) {
          //converting them to our class
          CustomUser userFromSnapshot = new CustomUser.fromMap(invitedUser);
          //If the current person just voted, want to change their voteStatus
          if (userFromSnapshot.uid == currentUid) {
            userFromSnapshot.voteStatus = true;
          }
          updatedInvitedUsers.add(userFromSnapshot);
        });
        //Re-map all of the users
        List<Map> userMap = updatedInvitedUsers != null
            ? updatedInvitedUsers
                .map((userUpdate) => userUpdate.toMap())
                .toList()
            : null;
        //Update the invited users to reflect the new vote-statuses
        transaction.update(docRef, {'invitedUsers': userMap});
      } else {
        //Grab each vote from the snapshot.
        List.from(snapshot.data()['votes']).forEach((snapshotVote) {
          //Iterate through each of the current placevotes, and add the total votes together.
          Votes voteFromSnapshot = new Votes.fromMap(snapshotVote);
          votes.forEach((userVote) {
            if (userVote.name == voteFromSnapshot.name) {
              userVote.vote = userVote.vote + voteFromSnapshot.vote;
            }
          });
        });
        //Here, votes has been updated to the most recent value. Push it to the DB
        List<Map> voteMap = votes != null
            ? votes.map((placeVote) => placeVote.toMap()).toList()
            : null;
        transaction.update(docRef, {'votes': voteMap});

        //Now we want to update the invited users vote status.
        String currentUid = AuthService().fetchUid();
        //Unfortunately, for Firestore, we have to update all invited users
        List<CustomUser> updatedInvitedUsers = [];
        //Grabbing all invited users
        List.from(snapshot.data()['invitedUsers']).forEach((invitedUser) {
          //converting them to our class
          CustomUser userFromSnapshot = new CustomUser.fromMap(invitedUser);
          //If the current person just voted, want to change their voteStatus
          if (userFromSnapshot.uid == currentUid) {
            userFromSnapshot.voteStatus = true;
          }
          updatedInvitedUsers.add(userFromSnapshot);
        });
        //Re-map all of the users
        List<Map> userMap = updatedInvitedUsers != null
            ? updatedInvitedUsers
                .map((userUpdate) => userUpdate.toMap())
                .toList()
            : null;
        //Update the invited users to reflect the new vote-statuses
        transaction.update(docRef, {'invitedUsers': userMap});
      }
    }).then((value) {
      print('Successfully added votes');
    }).catchError((error) => print("Failed to update user followers: $error"));
  }

  //Need method for accepting an event invitation
  Future<int> acceptEventInvite(Event event) async {
    String currentUserId = AuthService().fetchUid();

    DocumentReference docRef =
        FirebaseFirestore.instance.collection('events').doc(event.eventId);
    try {
      await docRef.get().then((value) {
        List<CustomUser> updatedInvitedUsers = [];
        List.from(value.data()['invitedUsers']).forEach((invitedUser) {
          //converting them to our class
          CustomUser userFromSnapshot = new CustomUser.fromMap(invitedUser);
          //If the current person accepted the invite, want to change their accepted status
          if (userFromSnapshot.uid == currentUserId) {
            userFromSnapshot.acceptedInvite = true;
          }
          updatedInvitedUsers.add(userFromSnapshot);

          //Re-map all of the users
          List<Map> userMap = updatedInvitedUsers != null
              ? updatedInvitedUsers
                  .map((userUpdate) => userUpdate.toMap())
                  .toList()
              : null;
          //Update the invited users to reflect the new vote-statuses
          docRef.update({'invitedUsers': userMap});
          //Need to remove this event fromt he user's event Invites.
          CollectionReference userEventCollection = FirebaseFirestore.instance
              .collection('users')
              .doc(currentUserId)
              .collection('eventInvites');
          userEventCollection.doc(event.eventId).delete();
          //Need to add this event to the user's main events.
          userEventCollection = FirebaseFirestore.instance
              .collection('users')
              .doc(currentUserId)
              .collection('events');
          userEventCollection
              .doc(event.eventId)
              .set({'acceptedOn': Timestamp.now()});
          return 1;
        });
      }).catchError((error) {
        print("Failed to update user invite status");
        //Unsuccessful
        //ToDo: Make sure return is actually async
        return 0;
      });
    } catch (e) {
      print(e);
      return 0;
    }
  }

  //Need method for declining an event invitation.
  Future<void> declineEventInvite(Event event) async {
    //Will need to remove the user from the invited users of the event.
    //Will also need to remove the eventInvite from the user.
    String currentUserId = AuthService().fetchUid();

    DocumentReference docRef =
        FirebaseFirestore.instance.collection('events').doc(event.eventId);
    try {
      await docRef.get().then((value) {
        List<CustomUser> updatedInvitedUsers = [];
        List.from(value.data()['invitedUsers']).forEach((invitedUser) {
          //converting them to our class
          CustomUser userFromSnapshot = new CustomUser.fromMap(invitedUser);
          //If we get to the current user's id, don't add them to the list.
          if (userFromSnapshot.uid != currentUserId) {
            updatedInvitedUsers.add(userFromSnapshot);
          }

          //Re-map all of the users still in the event.
          List<Map> userMap = updatedInvitedUsers != null
              ? updatedInvitedUsers
                  .map((userUpdate) => userUpdate.toMap())
                  .toList()
              : null;
          if (userMap == null) {
            //We don't want to destroy the whole event if something above fails.
            //For now, we will just return from here before anything is changed.
            //The event will still exist for this user, but they can try again.
            return 0;
          }
          //Update the invited users to reflect the new vote-statuses
          docRef.update({'invitedUsers': userMap});
          //Need to remove this event fromt he user's event Invites.
          CollectionReference userEventCollection = FirebaseFirestore.instance
              .collection('users')
              .doc(currentUserId)
              .collection('eventInvites');
          userEventCollection.doc(event.eventId).delete();
          return 1;
        });
      }).catchError((error) {
        print("Failed to update user invite status");
        //Unsuccessful
        //ToDo: Make sure return is actually async
        return 0;
      });
    } catch (e) {
      print(e);
      return 0;
    }
  }

  //Need method for cancelling/deleting an event.
  Future<void> cancelEvent(Event event) async {
    CollectionReference colRef =
        FirebaseFirestore.instance.collection('events');
    //Delete the event.
    await colRef.doc(event.eventId).delete();
    //Remove the event invite from every user and Remove the event from every user.
    await removeEventInvitations(event);
  }

  Future<void> removeEventInvitations(Event event) async {
    CollectionReference colRef = FirebaseFirestore.instance.collection('users');
    event.invitedUsers.forEach((element) {
      colRef
          .doc(element.uid)
          .collection('eventInvites')
          .doc(event.eventId)
          .delete();
    });
    event.invitedUsers.forEach((element) {
      colRef.doc(element.uid).collection('events').doc(event.eventId).delete();
    });
  }

  //Need a method for leaving an active event.
  Future<void> leaveEvent(Event event) async {
    String currentUid = AuthService().fetchUid();
    //Will need to re-build the invited users list, removing the current user
    DocumentReference docRef =
        FirebaseFirestore.instance.collection('events').doc(event.eventId);
    try {
      await docRef.get().then((value) {
        List<CustomUser> updatedInvitedUsers = [];
        List.from(value.data()['invitedUsers']).forEach((invitedUser) {
          //converting them to our class
          CustomUser userFromSnapshot = new CustomUser.fromMap(invitedUser);
          //We want to add the user's to our updated list, that are not our current user.
          if (userFromSnapshot.uid != currentUid) {
            updatedInvitedUsers.add(userFromSnapshot);
          }
          //Re-map all of the users, minus our current user.
          List<Map> userMap = updatedInvitedUsers != null
              ? updatedInvitedUsers
                  .map((userUpdate) => userUpdate.toMap())
                  .toList()
              : null;
          //Update the invited users to reflect the new vote-statuses
          docRef.update({'invitedUsers': userMap});
          //Need to remove this event fromt the user's event Invites.
          CollectionReference userEventCollection = FirebaseFirestore.instance
              .collection('users')
              .doc(currentUid)
              .collection('eventInvites');
          userEventCollection.doc(event.eventId).delete();
          //Need to also make sure it's removed from invites
          userEventCollection = FirebaseFirestore.instance
              .collection('users')
              .doc(currentUid)
              .collection('events');
          userEventCollection.doc(event.eventId).delete();
          return 1;
        });
      }).catchError((error) {
        print("Failed to update user invite status");
        //Unsuccessful
        //ToDo: Make sure return is actually async
        return 0;
      });
    } catch (e) {
      print(e);
    }
  }

  //Will get all of the current events for a vote for displaying the event details.
  Future<List<Votes>> populateVotes(Event event) async {
    List<Votes> votes = [];

    DocumentReference docRef =
        FirebaseFirestore.instance.collection('events').doc(event.eventId);
    return FirebaseFirestore.instance.runTransaction((transaction) async {
      // Get the document
      DocumentSnapshot snapshot = await transaction.get(docRef);
      if (!snapshot.exists) {
        print('Snapshot does not exist');
        throw Exception("Event does not exist!");
      }
      if (snapshot.data()['votes'] == null) {
        print('Snapshot data isnt there, dawg');
        //If there are no votes yet, going to pass in a negative number
        //This will let the event details know that no votes have been submitted yet.
        Votes tempVote = new Votes(vote: -1, name: 'No votes submitted yet.');
        votes.add(tempVote);
        return votes;
      } else {
        //Grab each vote from the snapshot.
        //Here is the issue.
        List.from(snapshot.data()['votes']).forEach((snapshotVote) {
          //Iterate through each of the current placevotes, and add the total votes together.
          Votes voteFromSnapshot = new Votes.fromMap(snapshotVote);
          votes.add(voteFromSnapshot);
        });
        return votes;
      }
    });
  }
}
