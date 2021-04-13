import 'package:flutter/material.dart';
import 'package:go_out_v2/models/custom_user.dart';
import 'package:like_button/like_button.dart';

class FriendInviteTile extends StatelessWidget {
  final int index;
  final List<CustomUser> friends;

  //Below are for communicating with the parent widget.
  final VoidCallback userInviteStatus;
  FriendInviteTile(
      {this.index, this.friends, this.userInviteStatus});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      leading: Container(
        padding: EdgeInsets.only(right: 12.0),
        decoration: new BoxDecoration(
            border: new Border(
                right: new BorderSide(width: 1.0, color: Colors.white24))),
        child: CircleAvatar(
          radius: 25,
          backgroundImage: AssetImage(
              friends[index].imageUrl ?? 'assets/default_user_image.png'),
        ),
      ),
      title: Text(
        "${friends[index].name}",
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      ),
      // subtitle: Text("Intermediate", style: TextStyle(color: Colors.white)),

      //General user information
      subtitle: Wrap(
        children: <Widget>[
          Text('from ${friends[index].city}, ${friends[index].state}',
              style: TextStyle(color: Colors.white))
        ],
      ),
      trailing: SizedBox(
        width: 50,
        child: LikeButton(
          size: 40,
          circleColor:
              CircleColor(start: Color(0xff00ddff), end: Color(0xff0099cc)),
          bubblesColor: BubblesColor(
            dotPrimaryColor: Color(0xff33b5e5),
            dotSecondaryColor: Color(0xff0099cc),
          ),
          likeBuilder: (bool isLiked) {
            return Icon(
              Icons.add_circle,
              color: isLiked ? Colors.green : Colors.grey,
              size: 40,
            );
          },
          onTap: onLikeButtonTapped,
          animationDuration: const Duration(milliseconds: 250),
        ),
      ),
    );
  }

  //One of the "add friend" buttons has been pressed. Need to send back to the parent widget.
  Future<bool> onLikeButtonTapped(bool isLiked) async {

    //When "isLiked" arrives here, it is the OPPOSITE of what it is
    //That is, isLiked == false implies that the user has been invited.

    if(isLiked){
      //The user is REMOVED from the invite list here
      print('==============isLiked TRUE===================');
      print('uninviting user');
      print(friends[index].uid);
      print(friends[index].name);
      friends[index].isInvited = false;
      print(isLiked);
      userInviteStatus();
      print('=================================');
    }else{
      //The user is ADDED to the invite list here
      print('==============isLiked False===================');
      print('Inviting user');
      print(friends[index].uid);
      print(friends[index].name);
      friends[index].isInvited = true;
      print(isLiked);
      userInviteStatus();
      print('=================================');
    }
    return !isLiked;
  }
}
