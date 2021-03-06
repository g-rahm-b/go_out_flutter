import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:go_out/models/user_feedback.dart';
import 'package:go_out/models/custom_user.dart';
import 'package:go_out/services/auth.dart';

//All methods used to interact with Database
class DatabaseService {
  final String uid;
  DatabaseService({this.uid});

  //Collection Reference

  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection('users');

  //Happens typically when a user registers.
  Future updateUserInfo(CustomUser updateUser) async {
    //Want to set up the search parameters for a user to assist in finding people.
    String userNameForSearch = updateUser.name.toLowerCase();

    return await userCollection.doc(uid).set({
      'uid': uid,
      'name': updateUser.name,
      'country': updateUser.country,
      'state': updateUser.state,
      'city': updateUser.city,
      'imageUrl': updateUser.imageUrl,
      'isEmailVerified': updateUser.isEmailVerified,
      'search_name': updateUser.name.toLowerCase(),
      'userSearch': setSearchParam(userNameForSearch)
    });
  }

  sendFriendRequest(CustomUser otherUser) async {
    final CollectionReference users =
        FirebaseFirestore.instance.collection('users');
    String currentUid = AuthService().fetchUid();
    await users
        .doc(otherUser.uid)
        .collection("receivedFriendRequests")
        .doc(currentUid)
        .set({'acceptStatus': false, 'created': FieldValue.serverTimestamp()});
    await users
        .doc(currentUid)
        .collection("sentFriendRequests")
        .doc(otherUser.uid)
        .set({'sentStatus': true, 'created': FieldValue.serverTimestamp()});
  }

  //This will generate a list of users and their info to use throughout the app.
  //For starters, being used so search for new friends.
  List<CustomUser> _userListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return CustomUser(
          name: doc.data()['name'] ?? 'Unknown Name',
          state: doc.data()['state'] ?? 'Unknown State',
          country: doc.data()['country'] ?? 'Unknown Country',
          city: doc.data()['city'] ?? 'Unknown City',
          uid: doc.data()['uid'] ?? 'Unknown UID',
          imageUrl: doc.data()['uid'] ?? 'assets/default_user_image.png');
    }).toList();
  }

  //Setting up the user data stream.
  //Todo: Maybe disable this if it takes too many calls as user's are being added.
  Stream<List<CustomUser>> get listOfAllUsers {
    return userCollection.snapshots().map(_userListFromSnapshot);
  }

  Future<List<CustomUser>> getUsersFromQuery(String userQuery) async {
    //Todo: Will need to figure out how to make the search more robust.
    try {
      List<CustomUser> usersFromQuery = [];
      final fireStoreInstance = FirebaseFirestore.instance.collection('users');
      userQuery = userQuery.toLowerCase();
      var result = await fireStoreInstance
          .where('userSearch', arrayContains: userQuery)
          .get();
      result.docs.forEach((res) {
        CustomUser user = new CustomUser(
            country: res.data()['country'] ?? 'unknown country',
            state: res.data()['state'] ?? 'unknown state',
            city: res.data()['city'] ?? 'unknown city',
            name: res.data()['name'] ?? 'unknown name',
            uid: res.data()['uid'] ?? 'unknown uid',
            imageUrl:
                res.data()['imageUrl'] ?? 'assets/default_user_image.png');
        usersFromQuery.add(user);
      });

      return usersFromQuery;
    } catch (e) {
      print(e);
      return null;
    }
  }

  //Get all of the user's friends.
  Future<List<CustomUser>> getUsersFriends() async {
    try {
      print('getting friends');
      String currentUid = AuthService().fetchUid();
      final fireStoreInstance = FirebaseFirestore.instance;
      List<CustomUser> usersFriends = [];
      await _populateFriendUids(usersFriends, currentUid, fireStoreInstance);
      //Using this method I did originally, that will effectively just populate the UIDs with the actual user info
      usersFriends = await _populateFriendRequests(usersFriends);
      return usersFriends;
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<List<CustomUser>> _populateFriendUids(List<CustomUser> usersFriends,
      String currentUid, FirebaseFirestore fireStoreInstance) async {
    var result = await fireStoreInstance
        .collection('users')
        .doc(currentUid)
        .collection('friends')
        .get();
    result.docs.forEach((element) {
      CustomUser friend = new CustomUser(uid: element.id);
      usersFriends.add(friend);
    });
    return usersFriends;
  }

  //Setting up the friend request data stream.
  //ToDo: Make sure the final UID above actually stays present. Don't keep using the Auth getter.
  Future<List<CustomUser>> userFriendRequests() async {
    try {
      String currentUid = AuthService().fetchUid();
      //Set up an empty list to populate.
      List<CustomUser> friendRequestUserList = [];
      //First, we will get the current user's pending friend requests.
      friendRequestUserList =
          await _fetchFriendRequests(friendRequestUserList, currentUid);
      //Second, we will go through the list, and add all of the user's data
      friendRequestUserList =
          await _populateFriendRequests(friendRequestUserList);
      return friendRequestUserList;
    }
    //ToDo: Handle errors
    catch (e) {
      print(e);
      return null;
    }
  }

  //Below will simply return the received friend requests for a particular user.
  Future<List<CustomUser>> _fetchFriendRequests(
      List<CustomUser> friendRequestUserList, String currentUid) async {
    final fireStoreInstance = FirebaseFirestore.instance;
    var result = await fireStoreInstance
        .collection('users')
        .doc(currentUid)
        .collection('receivedFriendRequests')
        .where('acceptStatus', isEqualTo: false)
        .get();
    result.docs.forEach((element) {
      CustomUser newFriendRequest = new CustomUser(
          friendRequestTimeStamp: element.get('created').toString(),
          uid: element.id);
      friendRequestUserList.add(newFriendRequest);
    });
    return friendRequestUserList;
  }

  //This will actually populate the requests with the user information, so that we can populate some tiles.
  Future<List<CustomUser>> _populateFriendRequests(
      List<CustomUser> friendRequestUserList) async {
    final fireStoreInstance = FirebaseFirestore.instance.collection('users');
    List<CustomUser> populatedList = [];
    for (CustomUser user in friendRequestUserList) {
      var result = await fireStoreInstance.doc(user.uid).get();
      print('Retrieved user of ID: ${user.uid}');
      CustomUser populateUser = CustomUser.fromFirestore(result);
      populatedList.add(populateUser);
    }
    return populatedList;
  }

  Future<List<CustomUser>> userSentFriendRequests() async {
    try {
      String currentUid = AuthService().fetchUid();
      //Set up an empty list to populate.
      List<CustomUser> friendRequestUserList = [];
      //First, we will get the current user's pending friend requests(sent to other users).
      friendRequestUserList =
          await _fetchSentFriendRequests(friendRequestUserList, currentUid);

      //Second, we will go through the list, and add all of the user's data
      //We can use the same function as before, as the this function doesn't care about sent or received.
      friendRequestUserList =
          await _populateFriendRequests(friendRequestUserList);

      return friendRequestUserList;
    }
    //ToDo: Handle errors
    catch (e) {
      print(e);
      return null;
    }
  }

  Future<List<CustomUser>> _fetchSentFriendRequests(
      List<CustomUser> friendRequestUserList, String currentUid) async {
    final fireStoreInstance = FirebaseFirestore.instance;
    var result = await fireStoreInstance
        .collection('users')
        .doc(currentUid)
        .collection('sentFriendRequests')
        .where('sentStatus', isEqualTo: true)
        .get();
    result.docs.forEach((element) {
      CustomUser sentFriendRequest = new CustomUser(
          friendRequestTimeStamp: element.get('created').toString(),
          uid: element.id);
      friendRequestUserList.add(sentFriendRequest);
    });
    return friendRequestUserList;
  }

  //Can probably be used for declining a friend request, as well.
  Future<void> cancelSentFriendRequest(CustomUser otherUser) async {
    //Will get the other User. Want to delete their received request, and delete the current user's sent request.
    String currentUserId = AuthService().fetchUid();
    final fireStoreInstance = FirebaseFirestore.instance;

    await fireStoreInstance
        .collection('users')
        .doc(currentUserId)
        .collection('sentFriendRequests')
        .doc(otherUser.uid)
        .delete();
    await fireStoreInstance
        .collection('users')
        .doc(otherUser.uid)
        .collection('receivedFriendRequests')
        .doc(currentUserId)
        .delete();
  }

  //Will decline a friend request
  Future<void> declineReceivedFriendRequest(CustomUser otherUser) async {
    String currentUserId = AuthService().fetchUid();
    final fireStoreInstance = FirebaseFirestore.instance;

    await fireStoreInstance
        .collection('users')
        .doc(currentUserId)
        .collection('receivedFriendRequests')
        .doc(otherUser.uid)
        .delete();
    await fireStoreInstance
        .collection('users')
        .doc(otherUser.uid)
        .collection('sentFriendRequests')
        .doc(currentUserId)
        .delete();
  }

  Future<void> removeFriend(CustomUser otherUser) async {
    String currentUserId = AuthService().fetchUid();
    final fireStoreInstance = FirebaseFirestore.instance.collection('users');
    await fireStoreInstance
        .doc(currentUserId)
        .collection('friends')
        .doc(otherUser.uid)
        .delete();
    await fireStoreInstance
        .doc(otherUser.uid)
        .collection('friends')
        .doc(currentUserId)
        .delete();
  }

  //Will make two users friends upon the current user accepting a request
  //Will also have to remove the received friend request from the current user, as well as the sent request.
  Future<void> acceptReceivedFriendRequest(CustomUser otherUser) async {
    String currentUserId = AuthService().fetchUid();
    final fireStoreInstance = FirebaseFirestore.instance;

    //add for the current user.
    await fireStoreInstance
        .collection('users')
        .doc(currentUserId)
        .collection('friends')
        .doc(otherUser.uid)
        .set({"status": "friends", "time": Timestamp.now()});

    //add for the other user.
    await fireStoreInstance
        .collection('users')
        .doc(otherUser.uid)
        .collection('friends')
        .doc(currentUserId)
        .set({"status": "friends", "time": Timestamp.now()});

    await declineReceivedFriendRequest(otherUser);
  }

  String getCurrentUserId() {
    return uid;
  }

  //Will turn the given username into an array helping with search functionality.
  List<String> setSearchParam(String lowerCase) {
    List<String> caseSearchList = [];
    String temp = "";
    for (int i = 0; i < lowerCase.length; i++) {
      temp = temp + lowerCase[i];
      caseSearchList.add(temp);
    }
    return caseSearchList;
  }

  //Want to check the friend status between two users, to send them to the proper profile.
  Future<int> friendStatus(CustomUser otherUser) async {
    String currentUid = AuthService().fetchUid();
    String otherUid = otherUser.uid;
    final fireStoreInstance = FirebaseFirestore.instance.collection('users');

    //Case one. User's are friends.
    if (currentUid == otherUid) {
      return 0;
    }

    var caseOne = await fireStoreInstance
        .doc(currentUid)
        .collection('friends')
        .doc(otherUid)
        .get();
    if (caseOne.exists) {
      print('CASE 1: These two users are friends');
      return 1;
    }
    //Case two. The user has received a friend request from the other person.
    var caseTwo = await fireStoreInstance
        .doc(currentUid)
        .collection('receivedFriendRequests')
        .doc(otherUid)
        .get();
    if (caseTwo.exists) {
      print(
          'CASE 2: This user has received a friend request from the other user.');
      return 2;
    }

    //Case three. The user has sent the other person a request.
    var caseThree = await fireStoreInstance
        .doc(currentUid)
        .collection('sentFriendRequests')
        .doc(otherUid)
        .get();
    if (caseThree.exists) {
      print('CASE 3: This user has sent a friend request to the other user.');
      return 3;
    }

    //Case four. User's are not friends and have not sent each-other requests
    return 4;
  }

  Future<void> submitFeedback(UserFeedback userFeedback) async {
    String currentUserId = AuthService().fetchUid();
    UserFeedback feedbackToSubmit = new UserFeedback(
      currentUid: currentUserId,
      open: userFeedback.open,
      read: userFeedback.read,
      timestamp: userFeedback.timestamp,
      type: userFeedback.type,
      userFeedback: userFeedback.userFeedback,
    );

    var feedbackMap = feedbackToSubmit.toMap();

    final fireStoreInstance = FirebaseFirestore.instance;
    //add the new feedback to firestore
    await fireStoreInstance.collection('feedback').add(feedbackMap);
  }
}
