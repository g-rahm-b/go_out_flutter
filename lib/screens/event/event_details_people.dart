import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_out_v2/models/event.dart';
import 'package:go_out_v2/services/profileDatabase.dart';

class EventDetailsPeople extends StatelessWidget {
  final Event event;
  const EventDetailsPeople(this.event);
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: event.invitedUsers.length,
        itemBuilder: (context, index) {
          String inviteString = '';
          String votedString = '';
          Color statusColorInvite = Colors.deepOrange[300];
          Color statusColorVote = Colors.deepOrange[300];
          if (event.invitedUsers[index].acceptedInvite == true) {
            inviteString = 'Of course!';
            statusColorInvite = Colors.lightGreen[500];
          } else {
            inviteString = 'Not yet...';
          }
          if (!event.invitedUsers[index].voteStatus ||
              event.invitedUsers[index].voteStatus == null) {
            votedString = 'Not yet...';
          } else {
            statusColorVote = Colors.lightGreen[500];
            votedString = 'Vote is in!';
          }
          return (Card(
            elevation: 4.0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: Padding(
              padding: const EdgeInsets.only(
                  top: 10.0, left: 15.0, right: 15.0, bottom: 15),
              child: Row(
                children: <Widget>[
                  FutureBuilder(
                    future: ProfileDatabase()
                        .downLoadOtherUsersPhoto(event.invitedUsers[index].uid),
                    builder:
                        (BuildContext context, AsyncSnapshot<String> snapshot) {
                      if (!snapshot.hasData && snapshot != null)
                        return CircleAvatar(
                          backgroundImage:
                              AssetImage('assets/default_user_image.png'),
                          minRadius: 35.0,
                        );
                      String profileUrl = snapshot.data;
                      return CircleAvatar(
                        backgroundImage: NetworkImage(profileUrl),
                        minRadius: 35.0,
                      );
                    },
                  ),
                  const SizedBox(width: 10.0),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        "${event.invitedUsers[index].name}",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 24.0,
                        ),
                      ),
                      const SizedBox(height: 5.0),
                      Text(
                        "Accepted Invite?",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18.0,
                        ),
                      ),
                      const SizedBox(height: 5.0),
                      Text(
                        "User Voted?",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18.0,
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        top: 10.0, left: 15.0, right: 15.0),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        "",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 24.0,
                        ),
                      ),
                      const SizedBox(height: 5.0),
                      Text(
                        inviteString,
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18.0,
                            color: statusColorInvite),
                      ),
                      const SizedBox(height: 5.0),
                      Text(
                        votedString,
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18.0,
                            color: statusColorVote),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ));
        });
  }
}
