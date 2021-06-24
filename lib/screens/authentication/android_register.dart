import 'dart:async';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_out_v2/screens/authentication/register.dart';
import 'package:go_out_v2/services/auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AndroidRegister extends StatefulWidget {
  final Function toggleView;
  AndroidRegister({this.toggleView});

  @override
  _AndroidRegisterState createState() => _AndroidRegisterState();
}

class _AndroidRegisterState extends State<AndroidRegister> {
  final AuthService _auth = AuthService();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0.0,
          title: Text('Register Go Out (Android)'),
          actions: <Widget>[
            TextButton.icon(
                onPressed: () {
                  widget.toggleView();
                },
                icon: Icon(Icons.person),
                label: Text(
                  'Sign In',
                ))
          ],
        ),
        body: RegistrationOptions());
  }
}

class RegistrationOptions extends StatefulWidget {
  @override
  State createState() => RegistrationOptionsState();
}

class RegistrationOptionsState extends State<RegistrationOptions> {
  GoogleSignInAccount _currentUser;

  Future<void> _handleSignIn() async {
    try {
      await _googleSignIn.signIn();
    } catch (error) {
      print(error);
    }
  }

  Future<void> _handleSignOut() => _googleSignIn.disconnect();

  //General screen construction
  Widget _buildBody() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text("Choose Registration Option."),
        OutlinedButton.icon(
            style: ButtonStyle(
              shape: MaterialStateProperty.all(
                StadiumBorder(),
              ),
              //padding: EdgeInsets.symmetric(horizontal: 12, vertical: 12)
            ),
            onPressed: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => Register()));
            },
            icon: Icon(
              Icons.mail_outline,
            ),
            label: Text(
              'Register with Email',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            )),
        OutlinedButton.icon(
            style: ButtonStyle(
              shape: MaterialStateProperty.all(StadiumBorder()),
              //padding: EdgeInsets.symmetric(horizontal: 12, vertical: 12)
            ),
            onPressed: () async {
              await AuthService().signInWithGoogle();
            },
            icon: FaIcon(
              FontAwesomeIcons.google,
            ),
            label: Text(
              'Register with Google',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            )),
        OutlinedButton.icon(
            style: ButtonStyle(
              shape: MaterialStateProperty.all(StadiumBorder()),
              //padding: EdgeInsets.symmetric(horizontal: 12, vertical: 12)
            ),
            onPressed: _handleSignIn,
            icon: FaIcon(
              FontAwesomeIcons.apple,
            ),
            label: Text(
              'Register with Apple',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            )),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints.expand(),
      child: _buildBody(),
    );
  }
}

GoogleSignIn _googleSignIn = GoogleSignIn(
  // Optional clientId
  // clientId: '479882132969-9i9aqik3jfjd7qhci1nqf0bm2g71rm1u.apps.googleusercontent.com',
  scopes: <String>[
    'email',
    //'https://www.googleapis.com/auth/contacts.readonly',
  ],
);
