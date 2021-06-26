import 'package:flutter/material.dart';
import 'package:go_out/models/custom_user.dart';
import 'package:go_out/services/auth.dart';
import 'package:go_out/shared/constants.dart';
import 'package:go_out/shared/loading.dart';
import 'package:country_picker/country_picker.dart';

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

//This will allow us to make a text field (country) that can't be edited.
class AlwaysDisabledFocusNode extends FocusNode {
  @override
  bool get hasFocus => false;
}

class _RegisterState extends State<Register> {
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  bool loading = false;
  var countryTextController = TextEditingController();

  //text field state values
  String email = '';
  String password = '';
  String error = '';
  String name = '';
  String selectedCountry = '';
  String state = '';
  String city = '';

  @override
  Widget build(BuildContext context) {
    return loading
        ? Loading()
        : Scaffold(
            appBar: AppBar(
              elevation: 0.0,
              title: Text('Email Registration'),
            ),
            body: Container(
                padding: EdgeInsets.symmetric(vertical: 20, horizontal: 50),
                child: Form(
                  //key will keep track of the form
                  key: _formKey,
                  child: SingleChildScrollView(
                    reverse: true,
                    child: Column(
                      children: <Widget>[
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
                        SizedBox(height: 10.0),
                        TextFormField(
                          decoration: textInputDecoration.copyWith(
                              hintText: 'Password'),
                          obscureText: true,
                          validator: (val) => val.length < 6
                              ? 'Enter a password 6+ chars long'
                              : null,
                          onChanged: (val) {
                            setState(() => password = val);
                          },
                        ),
                        SizedBox(height: 10.0),
                        TextFormField(
                          decoration:
                              textInputDecoration.copyWith(hintText: 'Name'),
                          obscureText: false,
                          validator: (val) =>
                              val.isEmpty ? 'Please provide a name!' : null,
                          onChanged: (val) {
                            setState(() => name = val);
                          },
                        ),
                        SizedBox(height: 10.0),
                        TextFormField(
                          enableInteractiveSelection: false,
                          focusNode: new AlwaysDisabledFocusNode(),
                          decoration: textInputDecoration.copyWith(
                              hintText: 'Select Country'),
                          obscureText: false,
                          controller: countryTextController,
                          validator: (val) => val.isEmpty
                              ? 'Please select your country!'
                              : null,
                          onChanged: (val) {
                            setState(() => selectedCountry = val);
                          },
                        ),
                        SizedBox(height: 10.0),
                        ElevatedButton.icon(
                          onPressed: () {
                            showCountryPicker(
                              context: context,
                              //Optional.  Can be used to exclude(remove) one ore more country from the countries list (optional).
                              exclude: <String>['KN', 'MF'],
                              //Optional. Shows phone code before the country name.
                              showPhoneCode: false,
                              onSelect: (Country country) {
                                print('Select country: ${country.displayName}');
                                selectedCountry = country.displayName;
                                countryTextController.text =
                                    country.displayName;
                              },
                            );
                          },
                          icon: Icon(Icons.arrow_drop_down_rounded),
                          label: const Text('Choose Your Country'),
                        ),
                        SizedBox(height: 10.0),
                        TextFormField(
                          decoration: textInputDecoration.copyWith(
                              hintText: 'State or Province'),
                          obscureText: false,
                          validator: (val) => val.isEmpty
                              ? 'Please provide a state or province!'
                              : null,
                          onChanged: (val) {
                            setState(() => state = val);
                          },
                        ),
                        SizedBox(height: 10.0),
                        TextFormField(
                          decoration:
                              textInputDecoration.copyWith(hintText: 'City'),
                          obscureText: false,
                          validator: (val) =>
                              val.isEmpty ? 'Please provide a city!' : null,
                          onChanged: (val) {
                            setState(() => city = val);
                          },
                        ),
                        SizedBox(height: 10.0),
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
                                CustomUser newUser = new CustomUser(
                                    name: name,
                                    country: selectedCountry,
                                    state: state,
                                    city: city);

                                dynamic result =
                                    await _auth.registerWithEmailAndPassword(
                                        email, password, newUser);

                                if (result == null) {
                                  setState(() {
                                    error =
                                        'There was an error processing the registration request, please try again.';
                                    loading = false;
                                  });
                                } else {
                                  Navigator.pop(context);
                                }
                              }
                            },
                            icon: Icon(
                              Icons.mail_outline,
                            ),
                            label: Text(
                              'Confirm Details and Register',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            )),
                        SizedBox(height: 10.0),
                        Text(
                          error,
                          style: TextStyle(color: Colors.red, fontSize: 14.0),
                        ),
                      ],
                    ),
                  ),
                )),
          );
  }
}
