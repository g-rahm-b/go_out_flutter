import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_out_v2/services/auth.dart';

class ConfirmEmail extends StatefulWidget {
  final VoidCallback onEmailConfirmed;
  ConfirmEmail({@required this.onEmailConfirmed});

  @override
  _ConfirmEmailState createState() => _ConfirmEmailState();
}

class _ConfirmEmailState extends State<ConfirmEmail> {
  bool loading = false;
  bool _isVerified = false;

  Widget build(BuildContext context) {
    print('Building the Confirm Email scaffold');
    if (!_isVerified)
      return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              AuthService().signOut();
            },
          ),
          title: const Text('Verify your email!'),
          actions: <Widget>[
            IconButton(
              icon: const Icon(Icons.info_outline),
              tooltip: 'Show Snackbar',
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text('Currently checking with our server')));
              },
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'An email has just been sent to you! Click the link provided to complete registration and verify your email address. After verification, come back here and get ready to go out!\n\n It might take a little while for the verification to complete.\n',
                style: TextStyle(fontSize: 18),
              ),
              ElevatedButton.icon(
                onPressed: () {
                  FirebaseAuth.instance.currentUser.reload();
                  var user = FirebaseAuth.instance.currentUser;
                  print(user.email);
                  print(user.emailVerified);
                  if (user.emailVerified) {
                    widget.onEmailConfirmed();
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text(
                            'Server-side verification not complete. Try again in a few seconds, or make sure you clicked the emailed link.')));
                  }
                },
                icon: Icon(Icons.navigate_next_outlined),
                label: Text('I have verified! Continue'),
              )
            ],
          ),
        ),
      );
    else
      return null;
  }
}
