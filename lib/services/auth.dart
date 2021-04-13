import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_out_v2/models/custom_user.dart';
import 'package:go_out_v2/services/database.dart';


class AuthService {

  final FirebaseAuth _auth = FirebaseAuth.instance;

  //Create user object based on Firebase User
  CustomUser _userFromFirebaseUser(User firebaseUser){
    return firebaseUser != null ? CustomUser(uid: firebaseUser.uid) : null;
  }

  //auth change user stream
  Stream<CustomUser> get user {

    return _auth.authStateChanges()
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
    } catch(e){
      print(e.toString());
      return null;
    }
  }

  //sign in with email and password
  Future signInWithEmailAndPassword(String email, String password) async {
    try{
      UserCredential result = await _auth.signInWithEmailAndPassword(email: email, password: password);
      User user = result.user;
      return _userFromFirebaseUser(user);

    }catch(e){
      print(e.toString());
      return null;
    }
  }

  //register with email and password
  Future registerWithEmailAndPassword(String email, String password, CustomUser newUser) async {
    try{
      UserCredential result = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      User user = result.user;
      //create a new document for the user with the uid
      print(user);
      await DatabaseService(uid: user.uid).updateUserData('0', 'New User', 100);
      await DatabaseService(uid: user.uid).updateUserInfo(newUser);
      return _userFromFirebaseUser(user);
    }catch(e){
      print(e.toString());
      return null;
    }
  }

  //sign out
  Future signOut() async {
    try{
      return await _auth.signOut();
    } catch (e){
      print(e.toString());
      return null;
    }
  }

  String fetchUid(){
    try{
      return _auth.currentUser.uid;
    }catch(e){
      print(e.toString());
      return null;
    }
  }

}