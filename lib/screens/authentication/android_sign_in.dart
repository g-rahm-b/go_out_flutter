import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_out_v2/services/auth.dart';
import 'package:go_out_v2/shared/constants.dart';
import 'package:go_out_v2/shared/loading.dart';

class AndroidSignIn extends StatefulWidget {
  final Function toggleView;
  AndroidSignIn({this.toggleView});

  @override
  _AndroidSignInState createState() => _AndroidSignInState();
}

class _AndroidSignInState extends State<AndroidSignIn> {
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  bool loading = false;

  //text field state values
  String email = '';
  String password = '';
  String error = '';

  @override
  Widget build(BuildContext context) {
    return loading
        ? Loading()
        : Scaffold(
            appBar: AppBar(
              elevation: 0.0,
              title: Text('Sign in to Go Out'),
              actions: <Widget>[
                TextButton.icon(
                    onPressed: () {
                      widget.toggleView();
                    },
                    icon: Icon(Icons.person),
                    label: Text(
                      'Register',
                    ))
              ],
            ),
            body: Container(
                padding: EdgeInsets.symmetric(vertical: 20, horizontal: 50),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: <Widget>[
                      SizedBox(height: 20.0),
                      Text('Login with email and password:'),
                      SizedBox(height: 10.0),
                      TextFormField(
                        decoration:
                            textInputDecoration.copyWith(hintText: 'Email'),
                        validator: (val) =>
                            val.isEmpty ? 'Enter an email' : null,
                        onChanged: (val) {
                          setState(() => email = val);
                        },
                      ),
                      SizedBox(height: 20.0),
                      TextFormField(
                        decoration:
                            textInputDecoration.copyWith(hintText: 'Password'),
                        validator: (val) => val.length < 6
                            ? 'Please enter your password'
                            : null,
                        obscureText: true,
                        onChanged: (val) {
                          setState(() => password = val);
                        },
                      ),
                      SizedBox(height: 20.0),
                      OutlinedButton.icon(
                          style: ButtonStyle(
                            shape: MaterialStateProperty.all(
                              StadiumBorder(),
                            ),
                            //padding: EdgeInsets.symmetric(horizontal: 12, vertical: 12)
                          ),
                          onPressed: () async {
                            if (_formKey.currentState.validate()) {
                              setState(() => loading = true);
                              dynamic result = await _auth
                                  .signInWithEmailAndPassword(email, password);
                              if (result == null) {
                                setState(() {
                                  error =
                                      'Could not sign in with provided credentials';
                                  loading = false;
                                });
                              }
                            }
                          },
                          icon: Icon(
                            Icons.mail_outline,
                          ),
                          label: Text(
                            'Sign in',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          )),
                      SizedBox(height: 12.0),
                      Text(
                        error,
                        style: TextStyle(fontSize: 14.0),
                      ),
                      Text('- or -'),
                      SizedBox(
                        height: 26.0,
                      ),
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
                            'Continue with Google',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          )),
                    ],
                  ),
                )),
          );
  }
}
