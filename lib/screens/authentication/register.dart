import 'package:flutter/material.dart';
import 'package:go_out_v2/models/custom_user.dart';
import 'package:go_out_v2/services/auth.dart';
import 'package:go_out_v2/shared/constants.dart';
import 'package:go_out_v2/shared/loading.dart';
import 'package:country_picker/country_picker.dart';


class Register extends StatefulWidget {

  final Function toggleView;
  Register({this.toggleView});

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
    return loading ? Loading() :
    Scaffold(
      backgroundColor: Colors.pink[100],
      appBar: AppBar(
        backgroundColor: Colors.pink[400],
        elevation: 0.0,
        title: Text('Sign up to Go Out'),
        actions: <Widget> [
          TextButton.icon(
              onPressed: () {
                widget.toggleView();
              },
              icon: Icon(Icons.person),
              label: Text('Or Sign In'))
        ],
      ),
      body: Container(
          padding: EdgeInsets.symmetric(vertical: 20, horizontal: 50),
          child: Form(
            //key will keep track of the form
            key: _formKey,
            child: Column(
              children: <Widget>[
                SizedBox(height: 10.0),
                TextFormField(
                  decoration: textInputDecoration.copyWith(hintText: 'Email'),
                  validator: (val) => val.isEmpty ? 'Enter an email' : null,
                  onChanged: (val){
                    setState(() => email = val);
                  },
                ),
                SizedBox(height: 10.0),
                TextFormField(
                  decoration: textInputDecoration.copyWith(hintText: 'Password'),
                  obscureText: true,
                  validator: (val) => val.length < 6 ? 'Enter a password 6+ chars long' : null,
                  onChanged: (val){
                    setState(() => password = val);
                  },
                ),
                SizedBox(height: 10.0),
                TextFormField(
                  decoration: textInputDecoration.copyWith(hintText: 'Name'),
                  obscureText: false,
                  validator: (val) => val.isEmpty ? 'Please provide a name!' : null,
                  onChanged: (val){
                    setState(() => name = val);
                  },
                ),

                SizedBox(height: 10.0),

                TextFormField(
                  enableInteractiveSelection: false,
                  focusNode: new AlwaysDisabledFocusNode(),
                  decoration: textInputDecoration.copyWith(hintText: 'Select Country'),
                  obscureText: false,
                  controller: countryTextController,
                  validator: (val) => val.isEmpty ? 'Please select your country!' : null,
                  onChanged: (val){
                    setState(() => selectedCountry = val);
                  },
                ),

                SizedBox(height: 10.0),

                ElevatedButton(
                    onPressed: (){
                      showCountryPicker(
                        context: context,
                        //Optional.  Can be used to exclude(remove) one ore more country from the countries list (optional).
                        exclude: <String>['KN', 'MF'],
                        //Optional. Shows phone code before the country name.
                        showPhoneCode: false,
                        onSelect: (Country country) {
                          print('Select country: ${country.displayName}');
                          selectedCountry = country.displayName;
                          countryTextController.text = country.displayName;
                        },
                      );
                    },
                    child: const Text('Choose Your Country'),

                  style: ButtonStyle(

                      backgroundColor: MaterialStateProperty.resolveWith <Color> (
                              (Set<MaterialState> states){
                            return Colors.pink[400];
                          }
                      )
                  ),
                ),
                SizedBox(height: 10.0),
                TextFormField(
                  decoration: textInputDecoration.copyWith(hintText: 'State or Province'),
                  obscureText: false,
                  validator: (val) => val.isEmpty ? 'Please provide a state or province!' : null,
                  onChanged: (val){
                    setState(() => state = val);
                  },
                ),
                SizedBox(height: 10.0),
                TextFormField(
                  decoration: textInputDecoration.copyWith(hintText: 'City'),
                  obscureText: false,
                  validator: (val) => val.isEmpty ? 'Please provide a city!' : null,
                  onChanged: (val){
                    setState(() => city = val);
                  },
                ),

                SizedBox(height: 10.0),
                ElevatedButton(
                  child: Text(
                    'Register',
                    style: TextStyle(color: Colors.white),
                  ),
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.resolveWith <Color> (
                              (Set<MaterialState> states){
                            return Colors.pink[400];
                          }
                      )
                  ),
                  onPressed: () async {
                    if (_formKey.currentState.validate()){
                      setState(() => loading = true);
                      CustomUser newUser = new CustomUser();

                      newUser.name = name;
                      newUser.country = selectedCountry;
                      newUser.state = state;
                      newUser.city = city;

                      dynamic result = await _auth.registerWithEmailAndPassword(
                          email, password, newUser);
                      if(result == null){
                        setState(() {
                          error = 'There was an error processing the registration request, please try again.';
                          loading = false;
                        });
                      }
                    }
                  },
                ),
                SizedBox(height: 15.0),
                Text(
                  error,
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: 14.0
                  ),
                ),
              ],
            ),
          )
      ),
    );
  }


}
