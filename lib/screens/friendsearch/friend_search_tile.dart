import 'package:flutter/material.dart';
import 'package:go_out/models/custom_user.dart';
import 'package:go_out/screens/profile/other_users_profile.dart';
import 'package:go_out/services/profileDatabase.dart';

class FriendSearchTile extends StatelessWidget {
  final CustomUser user;
  FriendSearchTile({this.user});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 8.0),
      child: GestureDetector(
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
                FutureBuilder(
                  future: ProfileDatabase().downLoadOtherUsersPhoto(user.uid),
                  builder:
                      (BuildContext context, AsyncSnapshot<String> snapshot) {
                    if (!snapshot.hasData && snapshot != null)
                      return CircleAvatar(
                        backgroundImage:
                            AssetImage('assets/default_user_image.png'),
                        minRadius: 40.0,
                      );
                    String profileUrl = snapshot.data;
                    return CircleAvatar(
                      backgroundImage: NetworkImage(profileUrl),
                      minRadius: 40.0,
                    );
                  },
                ),
                const SizedBox(width: 10.0),
                SizedBox(
                  width: 200,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        "${user.name}",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20.0,
                        ),
                      ),
                      const SizedBox(height: 5.0),
                      Text(
                        '${user.city}, ${user.state}',
                        style: TextStyle(
                          fontWeight: FontWeight.normal,
                          fontSize: 14.0,
                        ),
                      ),
                      const SizedBox(height: 5.0),
                      Text(
                        user.country,
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
      ),
    );
  }
}
