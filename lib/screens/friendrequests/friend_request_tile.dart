import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_out_v2/models/custom_user.dart';
import 'package:go_out_v2/screens/profile/other_users_profile.dart';

class FriendRequestTile extends StatelessWidget {
  final CustomUser user;
  FriendRequestTile({this.user});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 10.0),
      child: Card(
        margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
        elevation: 10.0,
        child: ListTile(
          leading: CircleAvatar(
            radius: 40,
            backgroundImage: AssetImage('assets/default_user_image.png'),
          ),
          title: Text(user.name),
          subtitle: Text('from ${user.city}, ${user.state} in ${user.country}'),
          onTap: () {
            //navigate to the profile page here
            Navigator.push(
              context,
              //ToDo - Send to ANOTHER user's profile page
              MaterialPageRoute(
                builder: (context) => OtherUsersProfilePage(user: user),
              ),
            );
          },
        ),
      ),
    );
  }
}
