import 'package:flutter/material.dart';
import 'package:go_out_v2/screens/authentication/android_register.dart';
import 'package:go_out_v2/screens/authentication/android_sign_in.dart';
import 'dart:io' show Platform;

class Authenticate extends StatefulWidget {
  @override
  _AuthenticateState createState() => _AuthenticateState();
}

class _AuthenticateState extends State<Authenticate> {
  bool showSignIn = true;
  void toggleView() {
    setState(() => showSignIn = !showSignIn);
  }

  @override
  Widget build(BuildContext context) {
    //Need to check which platform we are on, as that will change sign-in/register functions
    if (Platform.isAndroid) {
      print('platform is android');
      if (showSignIn) {
        return AndroidSignIn(toggleView: toggleView);
      } else {
        return AndroidRegister(toggleView: toggleView);
      }
    } else if (Platform.isIOS) {
      if (showSignIn) {
        //return SignIn(toggleView: toggleView);
      } else {
        //return Register();
      }
    } else {
      return Scaffold(
        body: Text('An error has occured. Please close the app and try again.'),
      );
    }
  }
}
