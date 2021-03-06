import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_out/models/custom_user.dart';
import 'package:go_out/models/event.dart';
import 'package:flutter/cupertino.dart';
import 'package:go_out/screens/eventPlanning/friendInviteTile.dart';
import 'package:go_out/screens/home/home.dart';
import 'package:go_out/services/database.dart';
import 'package:go_out/services/eventDatabase.dart';
import 'package:go_out/shared/loading.dart';

// ignore: must_be_immutable
class PlanEventInviteFriends extends StatefulWidget {
  //Receive new event.
  Event newEvent = new Event();
  PlanEventInviteFriends({this.newEvent});

  @override
  _PlanEventInviteFriendsState createState() => _PlanEventInviteFriendsState();
}

class _PlanEventInviteFriendsState extends State<PlanEventInviteFriends> {
  Event newEvent;

  @override
  Widget build(BuildContext context) {
    newEvent = widget.newEvent;

    return Scaffold(
        appBar: AppBar(
          elevation: 10.0,
          title: Text('Invite your friends'),
        ),
        body: FutureBuilder(
            future: DatabaseService().getUsersFriends(),
            builder: (BuildContext context,
                AsyncSnapshot<List<CustomUser>> snapshot) {
              //Loading while the snapshot is being built
              if (!snapshot.hasData) return Loading();
              //Populate the user's friends List
              List<CustomUser> usersFriends = snapshot.data;

              //First, ensure that all friends loaded are initially uninvited.
              //This event is being created fresh, so it shouldn't be a problem.
              usersFriends.forEach((element) {
                element.isInvited = false;
              });
              return Column(
                children: [
                  //Keep the size such that the button will fit
                  ConstrainedBox(
                    constraints: BoxConstraints(
                        maxHeight: MediaQuery.of(context).size.height * 0.75,
                        minHeight: MediaQuery.of(context).size.width * 0.8),
                    //Build the list of all the invite-able friends.
                    child: ListView.builder(
                        scrollDirection: Axis.vertical,
                        itemCount: usersFriends.length,
                        itemBuilder: (BuildContext context, int index) {
                          return FriendInviteTile(
                            index: index,
                            friends: usersFriends,
                            //Callback event from the Friend Tile
                            userInviteStatus: () => print(
                                "Parent Widget:  ${usersFriends[index].name} invite status is ${usersFriends[index].isInvited}"),
                          );
                        }),
                  ),
                  FloatingActionButton.extended(
                    label: Text("Invite Selected Friends and Create Event"),
                    icon: Icon(FontAwesomeIcons.chevronCircleRight),
                    onPressed: () async {
                      //This means the user is satisfied with who they invited.
                      //Need to add them to the event.
                      //Not sure why I can't just add items directly to the event
                      //Have to just make a new list, and add that in. Might need an "Add" function in the object.
                      List<CustomUser> invitedFriends = [];
                      usersFriends.forEach((element) {
                        if (element.isInvited == true) {
                          element.acceptedInvite = false;
                          invitedFriends.add(element);
                        }
                      });

                      newEvent.invitedUsers = invitedFriends;
                      //ToDO: Might need to add loading here, so the user's events are updated when they're kicked back home.
                      await EventDatabase().createNewEvent(newEvent);

                      //Want to pop us back to the home page once the event has been created
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          settings: RouteSettings(name: "/home"),
                          builder: (context) => Home(),
                        ),
                      );
                      Navigator.of(context)
                          .popUntil(ModalRoute.withName("/home"));
                      dispose();
                    },
                  ),
                ],
              );
            }));
  }
}
