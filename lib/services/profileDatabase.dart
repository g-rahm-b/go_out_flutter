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
    print('Updating the current user');
    print(userToUpdate.toString());
    print('User ID is:');
    print(userToUpdate.uid);
    final fireStoreInstance = FirebaseFirestore.instance;
    await fireStoreInstance.collection('users').doc(userToUpdate.uid).update({
      'name': userToUpdate.name,
      'country': userToUpdate.country,
      'state': userToUpdate.state,
      'city': userToUpdate.city,
    });
  }

  Future<void> uploadImageFile(File _image) async {
    Directory appDocDir = await getApplicationDocumentsDirectory();
    String filePath = '${appDocDir.absolute}/$_image';
    await uploadFile(_image.path);
  }

  Future<void> uploadFile(String filePath) async {
    String currentUid = AuthService().fetchUid();
    File file = File(filePath);

    try {
      await firebase_storage.FirebaseStorage.instance
          .ref('users/$currentUid/avatar')
          .putFile(file);
    } catch (e) {
      print(e);
    }
  }

  Future<String> downLoadOtherUsersPhoto(String otherUid) async {
    try {
      print('======Getting Ref======');
      var ref = firebase_storage.FirebaseStorage.instance
          .ref('users/$otherUid/avatar/');
      if (ref.getData() == null || ref.getMetadata() == null) {
        print('======Getting lots of nulls======');
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
