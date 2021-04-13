import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_out_v2/models/custom_user.dart';
import 'package:go_out_v2/services/database.dart';
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
          } else {
            return friendStatusFourWidget();
          }
        });
  }

  //Users are friends
  Widget friendStatusOneWidget() {
    return Scaffold(
      appBar: AppBar(title: Text('Your Beautiful Friend')),
      body: Center(
        child: Column(
          children: [
            SizedBox(height: 20),
            Container(
                width: 140.0,
                height: 140.0,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    image: ExactAssetImage(
                        widget.user.imageUrl ?? 'assets/default_user_image.png'),
                    fit: BoxFit.cover,
                  ),
                )),
            SizedBox(height: 20),
            Text(
              widget.user.name ?? 'Name unavailable',
              style: TextStyle(fontSize: 24),
            ),
            SizedBox(height: 20),
            Text(
              'From ' + widget.user.city + ', ' + widget.user.state ?? ' City and state unavailable',
              style: TextStyle(fontSize: 24),
            ),
            SizedBox(height: 20),
            Text(
              widget.user.country ?? 'Country unavailable',
              style: TextStyle(fontSize: 24),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                DatabaseService().removeFriend(widget.user);
                setState(() {
                  friendStatus =4;
                });

              },
              child: Row(
                // Replace with a Row for horizontal icon + text
                children: <Widget>[
                  Icon(Icons.cancel_outlined),
                  SizedBox(width: 20),
                  Text('Remove Friend')
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

  //Current user has RECEIVED a friend request from the other user.
  Widget friendStatusTwoWidget() {
    return Scaffold(
      appBar: AppBar(title: Text('Your Potential New Friend')),
      body: Center(
        child: Column(
          children: [
            SizedBox(height: 20),
            Container(
                width: 140.0,
                height: 140.0,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    image: ExactAssetImage(
                        widget.user.imageUrl ?? 'assets/default_user_image.png'),
                    fit: BoxFit.cover,
                  ),
                )),
            SizedBox(height: 20),
            Text(
              widget.user.name ?? 'Name unavailable',
              style: TextStyle(fontSize: 24),
            ),
            SizedBox(height: 20),
            Text(
              'From ' + widget.user.city + ', ' + widget.user.state ?? ' City and state unavailable',
              style: TextStyle(fontSize: 24),
            ),
            SizedBox(height: 20),
            Text(
              widget.user.country ?? 'Country unavailable',
              style: TextStyle(fontSize: 24),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                DatabaseService().acceptReceivedFriendRequest(widget.user);
                setState(() {
                  //Can do something in here, but the state will be set through the database.
                });

              },
              child: Row(
                // Replace with a Row for horizontal icon + text
                children: <Widget>[
                  Icon(Icons.add_circle_outline),
                  SizedBox(width: 20),
                  Text('Accept Friend Request')
                ],
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                DatabaseService().declineReceivedFriendRequest(widget.user);
                setState(() {
                  //Can do something in here, but the state will be set through the database.
                });

              },
              child: Row(
                // Replace with a Row for horizontal icon + text
                children: <Widget>[
                  Icon(Icons.remove_circle_outline),
                  SizedBox(width: 20),
                  Text('Decline Friend Request')
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

  Widget friendStatusThreeWidget() {
    return Scaffold(
      appBar: AppBar(title: Text('Your Potential New Friend')),
      body: Center(
        child: Column(
          children: [
            SizedBox(height: 20),
            Container(
                width: 140.0,
                height: 140.0,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    image: ExactAssetImage(
                        widget.user.imageUrl ?? 'assets/default_user_image.png'),
                    fit: BoxFit.cover,
                  ),
                )),
            SizedBox(height: 20),
            Text(
              widget.user.name ?? 'Name unavailable',
              style: TextStyle(fontSize: 24),
            ),
            SizedBox(height: 20),
            Text(
              'From ' + widget.user.city + ', ' + widget.user.state ?? ' City and state unavailable',
              style: TextStyle(fontSize: 24),
            ),
            SizedBox(height: 20),
            Text(
              widget.user.country ?? 'Country unavailable',
              style: TextStyle(fontSize: 24),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                DatabaseService().cancelSentFriendRequest(widget.user);
                setState(() {
                  //Can do something in here, but the state will be set through the database.
                });

              },
              child: Row(
                // Replace with a Row for horizontal icon + text
                children: <Widget>[
                  Icon(Icons.cancel_outlined),
                  SizedBox(width: 20),
                  Text('Cancel Sent Friend Request')
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

  //Current user has sent the other user a friend request
  Widget friendStatusFourWidget() {
    return Scaffold(
      appBar: AppBar(title: Text('Your Potential New Friend')),
      body: Center(
        child: Column(
          children: [
            SizedBox(height: 20),
            Container(
                width: 140.0,
                height: 140.0,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    image: ExactAssetImage(
                        widget.user.imageUrl ?? 'assets/default_user_image.png'),
                    fit: BoxFit.cover,
                  ),
                )),
            SizedBox(height: 20),
            Text(
              widget.user.name ?? 'Name unavailable',
              style: TextStyle(fontSize: 24),
            ),
            SizedBox(height: 20),
            Text(
              'From ' + widget.user.city + ', ' + widget.user.state ?? ' City and state unavailable',
              style: TextStyle(fontSize: 24),
            ),
            SizedBox(height: 20),
            Text(
              widget.user.country ?? 'Country unavailable',
              style: TextStyle(fontSize: 24),
            ),
            SizedBox(height: 20),
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
