import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:go_out_v2/models/custom_user.dart';
import 'package:path_provider/path_provider.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

import 'package:go_out_v2/services/auth.dart';

class ProfileDatabase {
  Future<CustomUser> fetchFullUserProfile() async {
    String currentUid = AuthService().fetchUid();
    final fireStoreInstance = FirebaseFirestore.instance;
    var result =
        await fireStoreInstance.collection('users').doc(currentUid).get();
    CustomUser user = CustomUser.fromFirestore(result);
    return user;
  }

  Future<void> updateProfileInfo(CustomUser userToUpdate) async {
    final fireStoreInstance = FirebaseFirestore.instance;
    await fireStoreInstance.collection('users').doc(userToUpdate.uid).update({
      'name': userToUpdate.name,
      'country': userToUpdate.country,
      'state': userToUpdate.state,
      'city': userToUpdate.city,
    });
  }

  Future<void> updateUserImageUrl(String url, String uid) async {
    final fireStoreInstance = FirebaseFirestore.instance;
    await fireStoreInstance
        .collection('users')
        .doc(uid)
        .update({'imageUrl': url});
  }

  Future<void> uploadImageFile(File _image) async {
    Directory appDocDir = await getApplicationDocumentsDirectory();
    //String filePath = '${appDocDir.absolute}/$_image';
    print('uploadImageFile');
    await uploadFile(_image.path);
  }

  Future<void> uploadFile(String filePath) async {
    String currentUid = AuthService().fetchUid();
    File file = File(filePath);
    print('uploadFile');
    print(filePath);
    try {
      //First, upload the image to the user's URL
      await firebase_storage.FirebaseStorage.instance
          .ref('users/$currentUid/avatar')
          .putFile(file);
      //Once we've done that, we will need to update the user's imageurl in firestore.
      firebase_storage.FirebaseStorage.instance
          .ref('users/$currentUid/avatar')
          .getDownloadURL()
          .then((url) {
        updateUserImageUrl(url, currentUid);
      });
    } catch (e) {
      print(e);
    }
  }

  Future<String> downLoadOtherUsersPhoto(String otherUid) async {
    try {
      var ref = firebase_storage.FirebaseStorage.instance
          .ref('users/$otherUid/avatar/');
      if (ref.getData() == null || ref.getMetadata() == null) {
        return null;
      } else {
        return ref.getDownloadURL();
      }
    } catch (e) {
      print(e);
    }
  }

  Future<String> getusersAvatar() async {
    try {
      String currentUid = AuthService().fetchUid();
      var ref = firebase_storage.FirebaseStorage.instance
          .ref('users/$currentUid/avatar/');
      if (ref.getData() == null || ref.getMetadata() == null) {
        return null;
      } else {
        return ref.getDownloadURL();
      }
    } catch (e) {
      print(e);
    }
  }
}
