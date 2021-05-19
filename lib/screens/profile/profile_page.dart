import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:go_out_v2/models/custom_user.dart';
import 'package:go_out_v2/services/profileDatabase.dart';
import 'package:go_out_v2/shared/loading.dart';
import 'package:image_picker/image_picker.dart';
import 'package:country_picker/country_picker.dart';

class ProfilePage extends StatefulWidget {
  @override
  MapScreenState createState() => MapScreenState();
}

class MapScreenState extends State<ProfilePage>
    with SingleTickerProviderStateMixin {
  bool _status = true;
  bool firstBuild = true;
  Color buttonColor = Colors.grey;
  final FocusNode myFocusNode = FocusNode();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  File imageFile;
  File _image;
  final picker = ImagePicker();

  String name = 'name';
  String country = 'country';
  String state = 'state';
  String city = 'city';

  Future _openGallery(BuildContext context) async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    this.setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
        ProfileDatabase().uploadImageFile(_image);
      } else {
        print('No image selected.');
      }
    });
    Navigator.of(context).pop();
  }

  Future _openCamera(BuildContext context) async {
    final pickedFile = await picker.getImage(source: ImageSource.camera);
    this.setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
        ProfileDatabase().uploadImageFile(_image);
      } else {
        print('No image selected.');
      }
    });
    Navigator.of(context).pop();
  }

  Future<void> _showChoiceDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Choose Image Source'),
            content: SingleChildScrollView(
                child: ListBody(
              children: <Widget>[
                GestureDetector(
                  child: Text("Gallery"),
                  onTap: () {
                    _openGallery(context);
                  },
                ),
                Padding(
                  padding: EdgeInsets.all(8.0),
                ),
                GestureDetector(
                  child: Text("Camera"),
                  onTap: () {
                    _openCamera(context);
                  },
                )
              ],
            )),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: ProfileDatabase().fetchFullUserProfile(),
        builder: (context, AsyncSnapshot<CustomUser> snapshot) {
          if (!snapshot.hasData) return Loading();
          CustomUser currentUser = snapshot.data;

          if (firstBuild) {
            print('in the cursed firstBuild');
            name = currentUser.name;
            country = currentUser.country;
            state = currentUser.state;
            city = currentUser.city;
            firstBuild = false;
          }

          return new Scaffold(
              body: new Container(
            color: Colors.white,
            child: new ListView(
              children: <Widget>[
                Column(
                  children: <Widget>[
                    new Container(
                      height: 250.0,
                      color: Colors.white,
                      child: new Column(
                        children: <Widget>[
                          Padding(
                              padding: EdgeInsets.only(left: 10.0, top: 10.0),
                              child: new Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  IconButton(
                                    // icon: Icons.arrow_back_ios,
                                    // color: Colors.black,
                                    // size: 22.0,
                                    //label: Text('back'),
                                    icon: Icon(
                                      Icons.arrow_back,
                                      size: 15,
                                    ),
                                    onPressed: () => {
                                      Navigator.pop(context)
                                    }, //button pressed
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(left: 20, top: 15),
                                    child: new Text('Edit your profile',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15.0,
                                            fontFamily: 'sans-serif-light',
                                            color: Colors.black)),
                                  )
                                ],
                              )),
                          Padding(
                            padding: EdgeInsets.only(top: 10.0),
                            child: new Stack(fit: StackFit.loose, children: <
                                Widget>[
                              new Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  new Container(
                                    width: 160.0,
                                    height: 160.0,
                                    child: _image == null
                                        ? FutureBuilder(
                                            future: ProfileDatabase()
                                                .getusersAvatar(),
                                            builder: (BuildContext context,
                                                AsyncSnapshot<String>
                                                    snapshot) {
                                              if (!snapshot.hasData &&
                                                  snapshot != null)
                                                return CircleAvatar(
                                                  backgroundImage: AssetImage(
                                                      'assets/default_user_image.png'),
                                                  minRadius: 35.0,
                                                );
                                              String profileUrl = snapshot.data;
                                              return CircleAvatar(
                                                backgroundImage:
                                                    NetworkImage(profileUrl),
                                                minRadius: 35.0,
                                              );
                                            },
                                          )
                                        : CircleAvatar(
                                            backgroundImage: FileImage(_image)),
                                  )
                                ],
                              ),
                              Padding(
                                  padding:
                                      EdgeInsets.only(top: 100.0, right: 100.0),
                                  child: new Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      new CircleAvatar(
                                        backgroundColor: Colors.red,
                                        radius: 25.0,
                                        child: IconButton(
                                          color: Colors.white,
                                          icon: Icon(Icons.camera_alt),
                                          onPressed: () {
                                            _showChoiceDialog(context);
                                          },
                                        ),
                                      )
                                    ],
                                  )),
                            ]),
                          )
                        ],
                      ),
                    ),
                    new Container(
                      color: Color(0xffFFFFFF),
                      child: Padding(
                        padding: EdgeInsets.only(bottom: 15.0),
                        child: new Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Padding(
                                padding: EdgeInsets.only(
                                    left: 25.0, right: 25.0, top: 10.0),
                                child: new Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  mainAxisSize: MainAxisSize.max,
                                  children: <Widget>[
                                    new Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.min,
                                      children: <Widget>[
                                        new Text(
                                          'Edit Your Personal Information',
                                          style: TextStyle(
                                              fontSize: 18.0,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                    new Column(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      mainAxisSize: MainAxisSize.min,
                                      children: <Widget>[
                                        _status
                                            ? _getEditIcon()
                                            : new Container(),
                                      ],
                                    )
                                  ],
                                )),
                            Padding(
                                padding: EdgeInsets.only(
                                    left: 25.0, right: 25.0, top: 15.0),
                                child: new Row(
                                  mainAxisSize: MainAxisSize.max,
                                  children: <Widget>[
                                    new Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.min,
                                      children: <Widget>[
                                        new Text(
                                          'Name',
                                          style: TextStyle(
                                              fontSize: 16.0,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                  ],
                                )),
                            Padding(
                                padding: EdgeInsets.only(
                                    left: 25.0, right: 25.0, top: 2.0),
                                child: new Row(
                                  mainAxisSize: MainAxisSize.max,
                                  children: <Widget>[
                                    new Flexible(
                                      child: new TextField(
                                        decoration: InputDecoration(
                                          hintText: currentUser.name,
                                        ),
                                        enabled: !_status,
                                        autofocus: !_status,
                                        onChanged: (val) {
                                          print('Setting name value');
                                          setState(() => name = val);
                                        },
                                      ),
                                    ),
                                  ],
                                )),
                            Padding(
                                padding: EdgeInsets.only(
                                    left: 25.0, right: 25.0, top: 15.0),
                                child: new Row(
                                  mainAxisSize: MainAxisSize.max,
                                  children: <Widget>[
                                    new Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.min,
                                      children: <Widget>[
                                        new Text(
                                          'Country',
                                          style: TextStyle(
                                              fontSize: 16.0,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                  ],
                                )),
                            Padding(
                              padding: EdgeInsets.only(
                                  left: 25.0, right: 25.0, top: 15.0),
                              child: ElevatedButton.icon(
                                onPressed: () {
                                  if (!_status) {
                                    showCountryPicker(
                                      context: context,
                                      //Optional.  Can be used to exclude(remove) one ore more country from the countries list (optional).
                                      exclude: <String>['KN', 'MF'],
                                      //Optional. Shows phone code before the country name.
                                      showPhoneCode: false,
                                      onSelect: (Country countryPicker) {
                                        print(
                                            'Select country: ${countryPicker.displayName}');
                                        country = countryPicker.displayName;
                                        //countryTextController.text = countryPicker.displayName;
                                      },
                                    );
                                  } else {
                                    return null;
                                  }
                                },
                                icon: Icon(Icons.arrow_drop_down_rounded),
                                label: Text(country),
                                style: ButtonStyle(backgroundColor:
                                    MaterialStateProperty.resolveWith<Color>(
                                        (Set<MaterialState> states) {
                                  return buttonColor;
                                })),
                              ),
                            ),
                            Padding(
                                padding: EdgeInsets.only(
                                    left: 25.0, right: 25.0, top: 15.0),
                                child: new Row(
                                  mainAxisSize: MainAxisSize.max,
                                  children: <Widget>[
                                    new Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.min,
                                      children: <Widget>[
                                        new Text(
                                          'State',
                                          style: TextStyle(
                                              fontSize: 16.0,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                  ],
                                )),
                            Padding(
                                padding: EdgeInsets.only(
                                    left: 25.0, right: 25.0, top: 2.0),
                                child: new Row(
                                  mainAxisSize: MainAxisSize.max,
                                  children: <Widget>[
                                    new Flexible(
                                      child: new TextField(
                                        decoration: InputDecoration(
                                            hintText: currentUser.state),
                                        enabled: !_status,
                                        onChanged: (val) {
                                          print('Setting state value');
                                          setState(() => state = val);
                                        },
                                      ),
                                    ),
                                  ],
                                )),
                            Padding(
                                padding: EdgeInsets.only(
                                    left: 25.0, right: 25.0, top: 15.0),
                                child: new Row(
                                  mainAxisSize: MainAxisSize.max,
                                  children: <Widget>[
                                    new Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.min,
                                      children: <Widget>[
                                        new Text(
                                          'City',
                                          style: TextStyle(
                                              fontSize: 16.0,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                  ],
                                )),
                            Padding(
                                padding: EdgeInsets.only(
                                    left: 25.0, right: 25.0, top: 2.0),
                                child: new Row(
                                  mainAxisSize: MainAxisSize.max,
                                  children: <Widget>[
                                    new Flexible(
                                      child: new TextField(
                                        decoration: InputDecoration(
                                            hintText: currentUser.city),
                                        enabled: !_status,
                                        onChanged: (val) {
                                          print('Setting city value');
                                          setState(() {
                                            city = val;
                                            print(city);
                                          });
                                        },
                                      ),
                                    ),
                                  ],
                                )),
                            !_status
                                ? _getActionButtons(currentUser)
                                : new Container(),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ],
            ),
          ));
        });
  }

  @override
  void dispose() {
    // Clean up the controller when the Widget is disposed
    myFocusNode.dispose();
    super.dispose();
  }

//All of the widgets/code for the save/cancel buttons after hitting save or cancel
  Widget _getActionButtons(CustomUser currentUser) {
    return Padding(
      padding: EdgeInsets.only(left: 25.0, right: 25.0, top: 45.0),
      child: new Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(right: 10.0),
              child: Container(
                  child: new RaisedButton(
                child: new Text("Save"),
                textColor: Colors.white,
                color: Colors.green,
                onPressed: () {
                  print('******* IN PROFILE PAGE *******');
                  print('setting up new user');
                  CustomUser updateUser = new CustomUser(
                      name: name,
                      state: state,
                      uid: currentUser.uid,
                      country: country,
                      city: city);
                  print(currentUser.toString());
                  print('setting up update user');
                  print(updateUser.toString());
                  print('******* IN PROFILE PAGE *******');
                  ProfileDatabase().updateProfileInfo(updateUser);
                  setState(() {
                    _status = true;
                    FocusScope.of(context).requestFocus(new FocusNode());
                  });
                },
                shape: new RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(20.0)),
              )),
            ),
            flex: 2,
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(left: 10.0),
              child: Container(
                  child: new RaisedButton(
                child: new Text("Cancel"),
                textColor: Colors.white,
                color: Colors.red,
                onPressed: () {
                  setState(() {
                    buttonColor = Colors.grey;
                    _status = true;
                    FocusScope.of(context).requestFocus(new FocusNode());
                  });
                },
                shape: new RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(20.0)),
              )),
            ),
            flex: 2,
          ),
        ],
      ),
    );
  }

//Controls whether or not the text widgets are in 'edit' mode or not
  Widget _getEditIcon() {
    return new GestureDetector(
      child: new CircleAvatar(
        backgroundColor: Colors.red,
        radius: 14.0,
        child: new Icon(
          Icons.edit,
          color: Colors.white,
          size: 16.0,
        ),
      ),
      onTap: () {
        setState(() {
          buttonColor = Colors.red;
          _status = false;
        });
      },
    );
  }
}
