import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_out_v2/models/custom_user.dart';
import 'package:go_out_v2/screens/friendrequests/friend_request_tile.dart';
import 'package:go_out_v2/services/database.dart';
import 'package:go_out_v2/shared/loading.dart';

class FriendRequestList extends StatefulWidget {
  @override
  _FriendRequestListState createState() => _FriendRequestListState();
}

class _FriendRequestListState extends State<FriendRequestList> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: DatabaseService().userFriendRequests(),
      builder:
          (BuildContext context, AsyncSnapshot<List<CustomUser>> snapshot) {
        if (!snapshot.hasData) return Loading();
        List<CustomUser> receivedFriendRequests = snapshot.data;

        //ToDo: After accepting all friend requests, the list doesn't update properly. Make sure the list updates properly.
        return Expanded(
          child: ListView.builder(
              itemCount: receivedFriendRequests.length,
              itemBuilder: (context, index) {
                if (receivedFriendRequests.length == 0) {
                  return Text('You have no pending friend requests');
                } else {
                  return Dismissible(
                      key: Key(UniqueKey().toString()),
                      background: slideRightBackground(),
                      secondaryBackground: slideLeftBackground(),
                      onDismissed: (direction) {
                        if (direction == DismissDirection.endToStart) {
                          //This is the DECLINE direction
                          DatabaseService().declineReceivedFriendRequest(
                              receivedFriendRequests[index]);
                          // Remove the item from the data source.
                          setState(() {
                            DatabaseService().cancelSentFriendRequest(
                                receivedFriendRequests[index]);
                            receivedFriendRequests.removeAt(index);
                          });
                        } else {
                          //This is the ACCEPT direction
                          // Remove the item from the data source.
                          DatabaseService().acceptReceivedFriendRequest(
                              receivedFriendRequests[index]);
                          setState(() {
                            receivedFriendRequests.removeAt(index);
                          });
                        }
                      },
                      child: FriendRequestTile(
                          user: receivedFriendRequests[index]));
                }
              }),
        );
      },
    );
  }

  Widget slideLeftBackground() {
    return Container(
      color: Colors.red,
      child: Align(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Icon(
              Icons.cancel,
              color: Colors.white,
            ),
            Text(
              " Decline",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
              textAlign: TextAlign.right,
            ),
            SizedBox(
              width: 20,
            ),
          ],
        ),
        alignment: Alignment.centerRight,
      ),
    );
  }

  Widget slideRightBackground() {
    return Container(
      color: Colors.green,
      child: Align(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            SizedBox(
              width: 20,
            ),
            Icon(
              Icons.add_circle,
              color: Colors.white,
            ),
            Text(
              " Accept",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
              textAlign: TextAlign.left,
            ),
          ],
        ),
        alignment: Alignment.centerLeft,
      ),
    );
  }
}
