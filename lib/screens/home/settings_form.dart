import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:go_out_v2/models/user_feedback.dart';
import 'package:go_out_v2/services/database.dart';

class SettingsForm extends StatefulWidget {
  @override
  _SettingsFormState createState() => _SettingsFormState();
}

class _SettingsFormState extends State<SettingsForm> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Text('Go Out Info'),
        ElevatedButton(
          onPressed: () {
            print('Click');
            feedbackPopup(context);
          },
          child: Text('Send Feedback'),
        ),
        ElevatedButton(
          onPressed: () {
            print('Click');
          },
          child: Text('Delete my Account'),
        ),
        LegalText()
      ],
    );
  }
}

// Create a Form widget.
class MyCustomForm extends StatefulWidget {
  @override
  MyCustomFormState createState() {
    return MyCustomFormState();
  }
}

// Create a corresponding State class.
// This class holds data related to the form.
class MyCustomFormState extends State<MyCustomForm> {
  // Create a global key that uniquely identifies the Form widget
  // and allows validation of the form.
  //
  // Note: This is a GlobalKey<FormState>,
  // not a GlobalKey<MyCustomFormState>.
  final _formKey = GlobalKey<FormState>();
  String currentValue = 'Praise';
  String currentFeedback = '';

  @override
  Widget build(BuildContext context) {
    // Build a Form widget using the _formKey created above.
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          new DropdownButton<String>(
            isExpanded: true,
            value: currentValue,
            hint: new Text("Select Feedback Type"),
            items: <String>[
              'Praise',
              'Bug Report',
              'Feature Request',
              'Account Issue'
            ].map((String currentValue) {
              return new DropdownMenuItem<String>(
                value: currentValue,
                child: new Text(currentValue),
              );
            }).toList(),
            onChanged: (String selectedValue) {
              setState(() {
                print('Changed the dropdown:');
                print(selectedValue);
                print('Changing the currentValue');
                currentValue = selectedValue;
                print(currentValue);
              });
            },
          ),
          TextFormField(
            // The validator receives the text that the user has entered.
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter some text';
              } else {
                currentFeedback = value;
              }
              return null;
            },
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: ElevatedButton(
              onPressed: () {
                // Validate returns true if the form is valid, or false otherwise.
                if (!_formKey.currentState.validate()) {
                  // If the form is valid, display a snackbar. In the real world,
                  // you'd often call a server or save the information in a database.
                  print('clicked submit with invalid value');
                  ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Error Processing Data')));
                } else {
                  print('clicked valid?');
                  UserFeedback userFeedback = new UserFeedback(
                    open: true,
                    read: false,
                    timestamp: Timestamp.now(),
                    type: currentValue,
                    userFeedback: currentFeedback,
                  );
                  print(userFeedback.toString());
                  DatabaseService().submitFeedback(userFeedback);
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text('Submitting Data'),
                  ));
                }
              },
              child: Text('Submit'),
            ),
          ),
        ],
      ),
    );
  }
}

class LegalText extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Container(
      child: SizedBox(
        height: 270,
        child: new Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            new Padding(
              padding: const EdgeInsets.all(12.0),
              child: new Text(
                "Go Out Legal Disclaimer",
                style: new TextStyle(
                    fontSize: 18.0,
                    color: Colors.black,
                    fontWeight: FontWeight.w600),
              ),
            ),
            new Expanded(
              flex: 1,
              child: new SingleChildScrollView(
                scrollDirection: Axis.vertical, //.horizontal
                child: new Text(
                  "1 Description that is too long in text format(Here Data is coming from API) jdlksaf j klkjjflkdsjfkddfdfsdfds " +
                      "2 Description that is too long in text format(Here Data is coming from API) d fsdfdsfsdfd dfdsfdsf sdfdsfsd d " +
                      "3 Description that is too long in text format(Here Data is coming from API)  adfsfdsfdfsdfdsf   dsf dfd fds fs" +
                      "4 Description that is too long in text format(Here Data is coming from API) dsaf dsafdfdfsd dfdsfsda fdas dsad" +
                      "5 Description that is too long in text format(Here Data is coming from API) dsfdsfd fdsfds fds fdsf dsfds fds " +
                      "6 Description that is too long in text format(Here Data is coming from API) asdfsdfdsf fsdf sdfsdfdsf sd dfdsf" +
                      "7 Description that is too long in text format(Here Data is coming from API) df dsfdsfdsfdsfds df dsfds fds fsd" +
                      "8 Description that is too long in text format(Here Data is coming from API)" +
                      "9 Description that is too long in text format(Here Data is coming from API)" +
                      "10 Description that is too long in text format(Here Data is coming from API)",
                  style: new TextStyle(
                    fontSize: 16.0,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

void feedbackPopup(context) {
  showDialog(
      context: context,
      builder: (BuildContext context) {
        return new AlertDialog(
          title: const Text('Submit Feedback'),
          content: new Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[MyCustomForm()],
          ),
          actions: <Widget>[
            new ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel.'),
            ),
          ],
        );
      });
}
