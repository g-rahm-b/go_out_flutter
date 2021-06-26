import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_out/models/custom_user.dart';
import 'package:go_out/screens/friendrequests/sent_friend_requests_tile.dart';
import 'package:go_out/services/database.dart';
import 'package:go_out/shared/loading.dart';

class SentFriendRequestList extends StatefulWidget {
  @override
  _SentFriendRequestListState createState() => _SentFriendRequestListState();
}

class _SentFriendRequestListState extends State<SentFriendRequestList> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: DatabaseService().userSentFriendRequests(),
      builder:
          (BuildContext context, AsyncSnapshot<List<CustomUser>> snapshot) {
        if (!snapshot.hasData) return Loading();
        List<CustomUser> sentFriendRequests = snapshot.data;

        return Expanded(
          child: ListView.builder(
              itemCount: sentFriendRequests.length,
              itemBuilder: (context, index) {
                return Dismissible(
                    key: Key(UniqueKey().toString()),
                    direction: DismissDirection.endToStart,
                    background: slideRightBackground(),
                    secondaryBackground: slideLeftBackground(),
                    onDismissed: (direction) {
                      // Remove the item from the data source.
                      setState(() {
                        DatabaseService()
                            .cancelSentFriendRequest(sentFriendRequests[index]);
                        sentFriendRequests.removeAt(index);
                      });
                    },
                    child: SentFriendRequestTile(
                      //user: sentFriendRequests[index]
                      users: sentFriendRequests,
                      index: index,
                    ));
              }),
        );
      },
    );
  }

  removeCancelledFriendRequest(CustomUser userToRemove) {
    print('Removing user: ${userToRemove.name}');
    setState(() {});
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
              " Cancel",
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
              Icons.edit,
              color: Colors.white,
            ),
            Text(
              " Edit",
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
