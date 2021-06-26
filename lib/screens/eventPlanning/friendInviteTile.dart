import 'package:flutter/material.dart';
import 'package:go_out/models/custom_user.dart';
import 'package:go_out/services/profileDatabase.dart';
import 'package:like_button/like_button.dart';

// ignore: must_be_immutable
class FriendInviteTile extends StatelessWidget {
  final int index;
  List<CustomUser> friends;

  //Below are for communicating with the parent widget.
  final VoidCallback userInviteStatus;
  FriendInviteTile({this.index, this.friends, this.userInviteStatus});

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.only(top: 5.0),
        child: Card(
          elevation: 4.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          child: Padding(
            padding: const EdgeInsets.only(
                top: 10.0, left: 10.0, right: 10.0, bottom: 10),
            child: Row(
              children: <Widget>[
                FutureBuilder(
                  future: ProfileDatabase()
                      .downLoadOtherUsersPhoto(friends[index].uid),
                  builder:
                      (BuildContext context, AsyncSnapshot<String> snapshot) {
                    if (!snapshot.hasData && snapshot != null)
                      return CircleAvatar(
                        backgroundImage:
                            AssetImage('assets/default_user_image.png'),
                        radius: 40,
                      );
                    String profileUrl = snapshot.data;
                    return CircleAvatar(
                      backgroundImage: NetworkImage(profileUrl),
                      radius: 40,
                    );
                  },
                ),
                const SizedBox(width: 10.0),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.5,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        "${friends[index].name}",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20.0,
                        ),
                      ),
                      const SizedBox(height: 5.0),
                      Text(
                        '${friends[index].city}, ${friends[index].state}',
                        style: TextStyle(
                          fontWeight: FontWeight.normal,
                          fontSize: 14.0,
                        ),
                      ),
                      const SizedBox(height: 5.0),
                      Text(
                        friends[index].country,
                        style: TextStyle(
                          fontWeight: FontWeight.normal,
                          fontSize: 14.0,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  width: 60,
                  child: LikeButton(
                    size: 50,
                    circleColor: CircleColor(
                        start: Color(0xff00ddff), end: Color(0xff0099cc)),
                    bubblesColor: BubblesColor(
                      dotPrimaryColor: Color(0xff33b5e5),
                      dotSecondaryColor: Color(0xff0099cc),
                    ),
                    likeBuilder: (bool isLiked) {
                      return Icon(
                        Icons.add_circle,
                        color: isLiked ? Colors.green : Colors.grey,
                        size: 60,
                      );
                    },
                    onTap: onLikeButtonTapped,
                    animationDuration: const Duration(milliseconds: 250),
                  ),
                ),
              ],
            ),
          ),
        ));
  }

  //One of the "add friend" buttons has been pressed. Need to send back to the parent widget.
  Future<bool> onLikeButtonTapped(bool isLiked) async {
    //When "isLiked" arrives here, it is the OPPOSITE of what it is
    //That is, isLiked == false implies that the user has been invited.

    if (isLiked) {
      //The user is REMOVED from the invite list here
      friends[index].isInvited = false;

      userInviteStatus();
    } else {
      //The user is ADDED to the invite list here

      friends[index].isInvited = true;

      userInviteStatus();
    }
    return !isLiked;
  }
}
