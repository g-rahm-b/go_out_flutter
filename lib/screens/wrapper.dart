import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_out/screens/authentication/authenticate.dart';
import 'package:go_out/screens/authentication/confirm_email.dart';
import 'package:go_out/screens/home/home.dart';

class Wrapper extends StatefulWidget {
  @override
  _WrapperState createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {
  @override
  Widget build(BuildContext context) {
    //Checking the value of the user.
    //If there's a logout, this will be null, otherwise, it will be the user.
    // final user = Provider.of<CustomUser>(context);
    print('back in the wrapper!');

    return StreamBuilder<User>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          User user = snapshot.data;
          if (user != null && user.emailVerified) {
            return Home();
          } else if (user != null && !user.emailVerified) {
            return ConfirmEmail(onEmailConfirmed: () {
              setState(() {
                //This will notify the wrapper to rebuild and check if the email is confirmed.
              });
            });
          } else {
            return Authenticate();
          }
        } else {
          return Scaffold(
            body: Center(
              child: Text('Inactive Internet Connection'),
            ),
          );
        }
      },
    );

    // //return either Home or Authenticate widget
    // if (user != null && user.emailVerified) {
    //   //Here, the user exists and is verified. Send them to the main screen
    //   return Home();
    // } else if (user != null && !user.emailVerified) {
    //   //Here, the user exists, and is not-yet verified. Make them confirm the email.
    //   return ConfirmEmail();
    // } else {
    //   //Here, the user does not exist, send them to authenticate.
    //   return Authenticate();
    // }
  }
}

class LandingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {}
}
