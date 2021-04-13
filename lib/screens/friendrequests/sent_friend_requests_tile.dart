import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_out_v2/models/custom_user.dart';
import 'package:go_out_v2/screens/profile/other_users_profile.dart';

class SentFriendRequestTile extends StatelessWidget {
  // final CustomUser user;
  // SentFriendRequestTile({this.user});
  final int index;
  final List<CustomUser> users;
  SentFriendRequestTile({this.index,this.users});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 10.0),
      child: Card(
        margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
        elevation: 10.0,
        child: ListTile(
          leading: CircleAvatar(
            radius: 25,
            backgroundImage: AssetImage('assets/default_user_image.png'),
          ),
          title: Text(users[index].name),
          subtitle: Text('from ${users[index].city}, ${users[index].state} in ${users[index].country}'),
          //trailing: Text('Swipe to Cancel'),

          onTap: (){
            //navigate to the profile page here
            Navigator.push(
              context,
              //ToDo - Send to ANOTHER user's profile page
              MaterialPageRoute(
                builder: (context) => OtherUsersProfilePage(user: users[index]),),
            );
          },
        ),
      ),
    );
  }
}
