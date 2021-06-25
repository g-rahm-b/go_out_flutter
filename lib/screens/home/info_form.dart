import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_out_v2/models/user_feedback.dart';
import 'package:go_out_v2/services/database.dart';

class InfoForm extends StatefulWidget {
  @override
  _InfoFormState createState() => _InfoFormState();
}

class _InfoFormState extends State<InfoForm> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        elevation: 10.0,
        title: Text('About GoOut'),
      ),
      body: Column(
        children: <Widget>[
          SizedBox(
            height: 10,
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.8,
            child: ElevatedButton(
              onPressed: () {
                print('Click');
                feedbackPopup(context);
              },
              child: Text('Send Feedback'),
            ),
          ),
          Container(
            height: MediaQuery.of(context).size.height * .70,
            width: MediaQuery.of(context).size.width,
            margin: EdgeInsets.symmetric(vertical: 20.0),
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                SingleChildScrollView(child: AboutText()),
                SingleChildScrollView(child: UpcomingFeaturesText()),
                SingleChildScrollView(child: LegalText())
              ],
            ),
          )
        ],
      ),
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
                    content: Text('Submitting Your Feedback!'),
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

class UpcomingFeaturesText extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: new Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          new Padding(
            padding: const EdgeInsets.all(12.0),
            child: new Text(
              "Upcoming Features",
              style: new TextStyle(fontSize: 18.0, fontWeight: FontWeight.w600),
            ),
          ),
          new Container(
            padding: const EdgeInsets.all(16.0),
            width: MediaQuery.of(context).size.width * 0.8,
            child: new Text(
              "- iOS Support so that your iPhone friends can join." +
                  "\n" +
                  "- As things return to normal, so should location schedules. I will build-in an alert to let you know if a place is closed when you want to go there." +
                  "\n" +
                  "- Push notifications, as long as I can make them not annoying." +
                  "\n" +
                  "- Group messanging for specific events. I'm not looking to make a chat app, but it could be useful." +
                  "\n" +
                  "- Friend mapping during event. Essentially a map showing each person's location on the map while the event is taking place (only with your consent, though)." +
                  "\n" +
                  "- Integration with Google reviews/Yelp/Etc, so you can review once events are completed. " +
                  "\n\n" +
                  "Feel free to use the send feedback button above to make any suggestions you might have!",
              style: new TextStyle(
                fontSize: 16.0,
              ),
              softWrap: true,
            ),
          ),
        ],
      ),
    );
  }
}

class AboutText extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: new Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          new Padding(
            padding: const EdgeInsets.all(12.0),
            child: new Text(
              "About GoOut",
              style: new TextStyle(fontSize: 18.0, fontWeight: FontWeight.w600),
            ),
          ),
          new Container(
            padding: const EdgeInsets.all(16.0),
            width: MediaQuery.of(context).size.width * 0.8,
            child: new Text(
              "Welcome to GoOut! An app that makes it slightly easier for indecisvie people to figure out what they're going to be doing. I've been slowly putting this app together on my own, and would appreciate your feedback or suggestions! Alternatively, feel free to visit the project's github repo at:\n https://github.com/g-rahm-b/go_out_flutter" +
                  "\n\n" +
                  "If you'd like to contribute, put in a pull request! Alternatively, feel free to submit an issue and I'll put it in the queue. At the end of the day, as things return to normal, I just hope this app can help you to get up and GoOut!",
              style: new TextStyle(
                fontSize: 16.0,
              ),
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
    return Card(
      child: new Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          new Padding(
            padding: const EdgeInsets.all(12.0),
            child: new Text(
              "General Disclaimer",
              style: new TextStyle(fontSize: 18.0, fontWeight: FontWeight.w600),
            ),
          ),
          new Container(
            padding: const EdgeInsets.all(16.0),
            width: MediaQuery.of(context).size.width * 0.8,
            child: new Text(
              "GoOut only requests some personal information for the sole intention of making it easier for you to find your friends. GoOut doesn't share any of the information provided to us and stored on the FireBase servers with any third parties. Your email and passwords are stored securely with Google's Cloud Services. If you lie about your name and location, we won't be bothered in the least! Just be sure to let your friends know! \n\nWhen planning your event, please remember to be covid-conscious!",
              style: new TextStyle(
                fontSize: 16.0,
              ),
            ),
          ),
        ],
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
