import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:go_out_v2/models/custom_user.dart';
import 'package:go_out_v2/screens/friendrequests/friend_requests.dart';
import 'package:go_out_v2/screens/friendrequests/friend_tile.dart';
import 'package:go_out_v2/screens/friendsearch/friend_search.dart';
import 'package:go_out_v2/services/database.dart';
import 'package:go_out_v2/shared/loading.dart';

class FriendsList extends StatefulWidget {
  @override
  _FriendsListState createState() => _FriendsListState();
}

class _FriendsListState extends State<FriendsList> {
  @override
  Widget build(BuildContext context) {
    //final friends = Provider.of<List<CustomUser>>(context) ?? [];

    return Column(
      children: <Widget>[
        SizedBox(height: 15.0),

        //Buttons for either finding friends or looking at requests.
        Wrap(children: <Widget>[
          ElevatedButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => FriendSearch()));
              },
              child: Text('Find New Friends')),
          SizedBox(width: 10.0),
          ElevatedButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => FriendRequests()));
              },
              child: Text('Pending Friend Requests')),
        ]),

        FutureBuilder(
          future: DatabaseService().getUsersFriends(),
          builder:
              (BuildContext context, AsyncSnapshot<List<CustomUser>> snapshot) {
            if (!snapshot.hasData) return Loading();
            List<CustomUser> usersFriends = snapshot.data;
            print('Snapshot returned:');
            print(snapshot.data);

            return Expanded(
                child: ListView.builder(
                    itemCount: usersFriends.length,
                    itemBuilder: (context, index) {
                      return Dismissible(
                          key: Key(UniqueKey().toString()),
                          direction: DismissDirection.endToStart,
                          background: slideRightBackground(),
                          secondaryBackground: slideLeftBackground(),
                          onDismissed: (direction) {
                            // Remove the item from the data source.
                            setState(() {
                              //Maybe do something here.
                            });
                          },
                          child: FriendTile(
                            //user: sentFriendRequests[index]
                            users: usersFriends,
                            index: index,
                          ));
                    }));
          },
        )
      ],
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
              " Remove Friend",
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
