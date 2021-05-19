import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_out_v2/services/auth.dart';
import 'package:go_out_v2/models/event.dart';
import 'package:go_out_v2/screens/event/event_tile_host.dart';
import 'package:go_out_v2/screens/event/event_tile_invite.dart';
import 'package:go_out_v2/screens/event/event_tile_general.dart';

class EventTile extends StatelessWidget {
  final int index;
  final List<Event> events;
  EventTile({this.index, this.events});

  @override
  Widget build(BuildContext context) {
    String currentUserId = AuthService().fetchUid();
    //Want to see if the user has accepted the invite or not.
    //If they haven't been, we want them

    bool isHost = false;
    bool acceptedInvite = false;
    bool voteStatus = false;
    if (events[index].host.uid == currentUserId) {
      isHost = true;
      print('isHost is: $isHost');
    }
    events[index].invitedUsers.forEach((element) {
      if (element.uid == currentUserId) {
        acceptedInvite = element.acceptedInvite;
        voteStatus = element.voteStatus;
      }
    });
    if (isHost) {
      return EventTileHost(events, index, isHost, acceptedInvite, voteStatus);
    } else if (!isHost && !acceptedInvite) {
      return EventTileInvite(events, index, isHost, acceptedInvite, voteStatus);
    } else {
      return EventTileGeneral(
          events, index, isHost, acceptedInvite, voteStatus);
    }
  }
}
