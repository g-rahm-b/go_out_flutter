import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_out_v2/models/custom_user.dart';
import 'package:go_out_v2/services/database.dart';
import 'package:go_out_v2/services/profileDatabase.dart';
import 'package:go_out_v2/shared/loading.dart';

class OtherUsersProfilePage extends StatefulWidget {
  CustomUser user = new CustomUser();
  OtherUsersProfilePage({this.user});

  @override
  _OtherUsersProfilePageState createState() => _OtherUsersProfilePageState();
}

class _OtherUsersProfilePageState extends State<OtherUsersProfilePage> {
  final fireStoreInstance = FirebaseFirestore.instance;
  int friendStatus;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: DatabaseService().friendStatus(widget.user),
        builder: (BuildContext context, AsyncSnapshot<int> snapshot) {
          if (!snapshot.hasData) return Loading();
          friendStatus = snapshot.data;
          if (friendStatus == 1) {
            return friendStatusOneWidget();
          } else if (friendStatus == 2) {
            return friendStatusTwoWidget();
          } else if (friendStatus == 3) {
            return friendStatusThreeWidget();
          } else if (friendStatus == 0) {
            return AlertDialog(
              title: Text('This is you!'),
              content: SingleChildScrollView(
                child: ListBody(
                  children: <Widget>[
                    Text('You might be searching for somebody else.'),
                    Text('But gosh, you are pretty'),
                  ],
                ),
              ),
              actions: <Widget>[
                TextButton(
                  child: Text('Why thank you!'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                )
              ],
            );
          } else {
            return friendStatusFourWidget();
          }
        });
  }

  //Users are friends
  Widget friendStatusOneWidget() {
    return Scaffold(
      appBar: AppBar(title: Text('Your Friend')),
      body: Center(
        child: Column(
          children: [
            SizedBox(height: 20),
            Container(
              width: 200.0,
              height: 200.0,
              child: FutureBuilder(
                future:
                    ProfileDatabase().downLoadOtherUsersPhoto(widget.user.uid),
                builder:
                    (BuildContext context, AsyncSnapshot<String> snapshot) {
                  if (!snapshot.hasData && snapshot != null)
                    return CircleAvatar(
                      backgroundImage:
                          AssetImage('assets/default_user_image.png'),
                      minRadius: 90.0,
                    );
                  String profileUrl = snapshot.data;
                  return CircleAvatar(
                    backgroundImage: NetworkImage(profileUrl),
                    minRadius: 120.0,
                  );
                },
              ),
            ),
            SizedBox(height: 20),
            Text(
              widget.user.name ?? 'Name unavailable',
              style: TextStyle(fontSize: 24),
            ),
            SizedBox(height: 20),
            Text(
              'From ' + widget.user.city + ', ' + widget.user.state ??
                  ' City and state unavailable',
              style: TextStyle(fontSize: 24),
            ),
            SizedBox(height: 20),
            Text(
              widget.user.country ?? 'Country unavailable',
              style: TextStyle(fontSize: 24),
            ),
            SizedBox(height: 20),
            FloatingActionButton.extended(
              onPressed: () {
                DatabaseService().removeFriend(widget.user);
                setState(() {
                  friendStatus = 4;
                });
              },
              label: const Text('Remove Friend'),
              icon: const Icon(Icons.cancel_outlined),
              backgroundColor: Colors.pink,
            ),
            // ListView(
            //   //Todo: add friends in common
            // )
          ],
        ),
      ),
    );
  }

  //Current user has RECEIVED a friend request from the other user.
  Widget friendStatusTwoWidget() {
    return Scaffold(
      appBar: AppBar(title: Text('Your Potential New Friend')),
      body: Center(
        child: Column(
          children: [
            SizedBox(height: 20),
            Container(
              child: FutureBuilder(
                future:
                    ProfileDatabase().downLoadOtherUsersPhoto(widget.user.uid),
                builder:
                    (BuildContext context, AsyncSnapshot<String> snapshot) {
                  if (!snapshot.hasData && snapshot != null)
                    return CircleAvatar(
                      backgroundImage:
                          AssetImage('assets/default_user_image.png'),
                      minRadius: 90.0,
                    );
                  String profileUrl = snapshot.data;
                  return CircleAvatar(
                    backgroundImage: NetworkImage(profileUrl),
                    minRadius: 120.0,
                  );
                },
              ),
            ),
            SizedBox(height: 20),
            Text(
              widget.user.name ?? 'Name unavailable',
              style: TextStyle(fontSize: 24),
            ),
            SizedBox(height: 20),
            Text(
              'From ' + widget.user.city + ', ' + widget.user.state ??
                  ' City and state unavailable',
              style: TextStyle(fontSize: 24),
            ),
            SizedBox(height: 20),
            Text(
              widget.user.country ?? 'Country unavailable',
              style: TextStyle(fontSize: 24),
            ),
            SizedBox(height: 20),
            FloatingActionButton.extended(
              onPressed: () {
                DatabaseService().acceptReceivedFriendRequest(widget.user);
                setState(() {
                  friendStatus = 4;
                });
              },
              label: const Text('Accept Friend Request'),
              icon: const Icon(Icons.thumb_up),
              backgroundColor: Colors.green,
            ),

            SizedBox(height: 20),
            FloatingActionButton.extended(
              onPressed: () {
                DatabaseService().declineReceivedFriendRequest(widget.user);
                setState(() {
                  friendStatus = 4;
                });
              },
              label: const Text('Decline Friend Request'),
              icon: const Icon(Icons.thumb_down),
              backgroundColor: Colors.pink,
            ),
            // ListView(
            //   //Todo: add friends in common
            // )
          ],
        ),
      ),
    );
  }

  //Neither user currently shares an interaction with the other.
  Widget friendStatusThreeWidget() {
    return Scaffold(
      appBar: AppBar(title: Text('Your Potential New Friend')),
      body: Center(
        child: Column(
          children: [
            SizedBox(height: 20),
            Container(
              child: FutureBuilder(
                future:
                    ProfileDatabase().downLoadOtherUsersPhoto(widget.user.uid),
                builder:
                    (BuildContext context, AsyncSnapshot<String> snapshot) {
                  if (!snapshot.hasData && snapshot != null)
                    return CircleAvatar(
                      backgroundImage:
                          AssetImage('assets/default_user_image.png'),
                      minRadius: 90.0,
                    );
                  String profileUrl = snapshot.data;
                  return CircleAvatar(
                    backgroundImage: NetworkImage(profileUrl),
                    minRadius: 120.0,
                  );
                },
              ),
            ),
            SizedBox(height: 20),
            Text(
              widget.user.name ?? 'Name unavailable',
              style: TextStyle(fontSize: 24),
            ),
            SizedBox(height: 20),
            Text(
              'From ' + widget.user.city + ', ' + widget.user.state ??
                  ' City and state unavailable',
              style: TextStyle(fontSize: 24),
            ),
            SizedBox(height: 20),
            Text(
              widget.user.country ?? 'Country unavailable',
              style: TextStyle(fontSize: 24),
            ),
            SizedBox(height: 20),
            FloatingActionButton.extended(
              onPressed: () {
                DatabaseService().cancelSentFriendRequest(widget.user);
                setState(() {
                  friendStatus = 4;
                });
              },
              label: const Text('Cancel Sent Friend Request'),
              icon: const Icon(Icons.thumb_up),
              backgroundColor: Colors.pink,
            ),
            // ListView(
            //   //Todo: add friends in common
            // )
          ],
        ),
      ),
    );
  }

  //Neither user has interactions with the other
  Widget friendStatusFourWidget() {
    return Scaffold(
      appBar: AppBar(title: Text('Your Potential New Friend!')),
      body: Center(
        child: Column(
          children: [
            SizedBox(height: 20),
            Container(
              height: 200,
              width: 200,
              child: FutureBuilder(
                future:
                    ProfileDatabase().downLoadOtherUsersPhoto(widget.user.uid),
                builder:
                    (BuildContext context, AsyncSnapshot<String> snapshot) {
                  if (!snapshot.hasData && snapshot != null)
                    return CircleAvatar(
                      backgroundImage:
                          AssetImage('assets/default_user_image.png'),
                      minRadius: 90.0,
                    );
                  String profileUrl = snapshot.data;
                  return CircleAvatar(
                    backgroundImage: NetworkImage(profileUrl),
                    minRadius: 90.0,
                    maxRadius: 100.0,
                  );
                },
              ),
            ),
            SizedBox(height: 20),
            Text(
              widget.user.name ?? 'Name unavailable',
              style: TextStyle(fontSize: 24),
            ),
            SizedBox(height: 20),
            Text(
              'From ' + widget.user.city + ', ' + widget.user.state ??
                  ' City and state unavailable',
              style: TextStyle(fontSize: 24),
            ),
            SizedBox(height: 20),
            Text(
              widget.user.country ?? 'Country unavailable',
              style: TextStyle(fontSize: 24),
            ),
            SizedBox(height: 20),
            FloatingActionButton.extended(
              onPressed: () {
                // Add your onPressed code here!
              },
              label: const Text('Approve'),
              icon: const Icon(Icons.thumb_up),
              backgroundColor: Colors.pink,
            ),
            ElevatedButton(
              onPressed: () {
                DatabaseService().sendFriendRequest(widget.user);
                setState(() {
                  //Can do something in here, but the state will be set through the database.
                });
              },
              child: Row(
                // Replace with a Row for horizontal icon + text
                children: <Widget>[
                  Icon(Icons.add_circle_outline),
                  SizedBox(width: 20),
                  Text('Send Friend Request')
                ],
              ),
            ),
            // ListView(
            //   //Todo: add friends in common
            // )
          ],
        ),
      ),
    );
  }

  void sendFriendRequest(CustomUser user) {
    //DatabaseService().sendFriendRequest(user);
  }
}
