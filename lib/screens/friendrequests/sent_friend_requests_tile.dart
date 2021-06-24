import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_out_v2/models/custom_user.dart';
import 'package:go_out_v2/screens/profile/other_users_profile.dart';
import 'package:go_out_v2/services/profileDatabase.dart';

class SentFriendRequestTile extends StatelessWidget {
  // final CustomUser user;
  // SentFriendRequestTile({this.user});
  final int index;
  final List<CustomUser> users;
  SentFriendRequestTile({this.index, this.users});

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.only(top: 5.0),
        child: GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              //ToDo - Send to ANOTHER user's profile page
              MaterialPageRoute(
                builder: (context) => OtherUsersProfilePage(user: users[index]),
              ),
            );
          },
          child: Card(
            elevation: 4.0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
            child: Padding(
              padding: const EdgeInsets.only(
                  top: 10.0, left: 15.0, right: 15.0, bottom: 15),
              child: Row(
                children: <Widget>[
                  CircleAvatar(
                    radius: 40,
                    backgroundImage: NetworkImage(users[index].imageUrl),
                  ),
                  const SizedBox(width: 10.0),
                  SizedBox(
                    width: 200,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          "${users[index].name}",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20.0,
                          ),
                        ),
                        const SizedBox(height: 5.0),
                        Text(
                          '${users[index].city}, ${users[index].state}',
                          style: TextStyle(
                            fontWeight: FontWeight.normal,
                            fontSize: 14.0,
                          ),
                        ),
                        const SizedBox(height: 5.0),
                        Text(
                          users[index].country,
                          style: TextStyle(
                            fontWeight: FontWeight.normal,
                            fontSize: 14.0,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}

// onTap: () {
//   //navigate to the profile page here
//   Navigator.push(
//     context,
//     //ToDo - Send to ANOTHER user's profile page
//     MaterialPageRoute(
//       builder: (context) => OtherUsersProfilePage(user: users[index]),
//     ),
//   );
// },
