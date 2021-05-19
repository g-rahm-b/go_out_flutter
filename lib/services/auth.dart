import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:go_out_v2/models/custom_user.dart';
import 'package:go_out_v2/services/database.dart';
import 'package:go_out_v2/services/profileDatabase.dart';
import 'package:path_provider/path_provider.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  //Create user object based on Firebase User
  CustomUser _userFromFirebaseUser(User firebaseUser) {
    return firebaseUser != null ? CustomUser(uid: firebaseUser.uid) : null;
  }

  //auth change user stream
  Stream<CustomUser> get user {
    return _auth
        .authStateChanges()
        //.map((User user) => _userFromFirebaseUser(user));
        .map(_userFromFirebaseUser);
  }

  //sign in anon
  Future signInAnon() async {
    try {
      UserCredential result = await _auth.signInAnonymously();
      User firebaseUser = result.user;
      print(user);
      return _userFromFirebaseUser(firebaseUser);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  //sign in with email and password
  Future signInWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      User user = result.user;
      return _userFromFirebaseUser(user);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  //register with email and password
  Future registerWithEmailAndPassword(
      String email, String password, CustomUser newUser) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      User user = result.user;
      //create a new document for the user with the uid
      print(user);
      //await DatabaseService(uid: user.uid).updateUserData('0', 'New User', 100);
      await DatabaseService(uid: user.uid).updateUserInfo(newUser);
      //Need to create a default user image for the user, and send it to storage to avoid not-found exceptions through firebase storage.
      String defaultUrl = await getDefaultAvatar();
      await setDefaultAvatar(defaultUrl);

      return _userFromFirebaseUser(user);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  //sign out
  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  String fetchUid() {
    try {
      return _auth.currentUser.uid;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future<String> getDefaultAvatar() async {
    try {
      var ref = firebase_storage.FirebaseStorage.instance
          .ref('default_user_image.png');
      if (ref.getData() == null || ref.getMetadata() == null) {
        return null;
      } else {
        return ref.getDownloadURL();
      }
    } catch (e) {
      print(e);
    }
  }

  setDefaultAvatar(String defaultUrl) async {
    var appDocDir = await getApplicationDocumentsDirectory();
    File downloadToFile = File('${appDocDir.path}/download-logo.png');
    try {
      await firebase_storage.FirebaseStorage.instance
          .ref('default_user_image.png')
          .writeToFile(downloadToFile)
          .then((value) {
        //If the file has been saved from storage onto device, we can upload it at the users reference.
        ProfileDatabase().uploadFile(downloadToFile.path);
      });
    } catch (e) {
      // e.g, e.code == 'canceled'
    }
  }
}
