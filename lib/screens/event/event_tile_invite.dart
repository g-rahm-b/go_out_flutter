import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_out_v2/models/event.dart';
import 'package:go_out_v2/screens/event/event_details.dart';
import 'package:go_out_v2/screens/event/event_tile_general.dart';
import 'package:go_out_v2/services/eventDatabase.dart';
import 'package:go_out_v2/shared/shared_methods.dart';

class EventTileInvite extends StatefulWidget {
  final int index;
  final List<Event> events;
  final bool isHost, acceptedInvite, voteStatus;

  const EventTileInvite(this.events, this.index, this.isHost,
      this.acceptedInvite, this.voteStatus);

  @override
  _EventTileInviteState createState() =>
      _EventTileInviteState(events, index, isHost, acceptedInvite, voteStatus);
}

class _EventTileInviteState extends State<EventTileInvite> {
  int index;
  List<Event> events;
  bool isHost, acceptedInvite, voteStatus;
  _EventTileInviteState(this.events, this.index, this.isHost,
      this.acceptedInvite, this.voteStatus);
  Icon typeIcon = Icon(
    Icons.smartphone_outlined,
    size: 100,
  );
  bool declineInvite = false;

  @override
  Widget build(BuildContext context) {
    if (acceptedInvite) {
      return EventTileGeneral(
          events, index, isHost, acceptedInvite, voteStatus);
    }
    if (declineInvite) {
      return Container();
    }

    if (events[widget.index].type == 'Bar') {
      typeIcon = Icon(Icons.local_bar_outlined);
    } else if (events[widget.index].type == 'Restaurant') {
      typeIcon = Icon(Icons.restaurant_outlined);
    } else if (events[widget.index].type == 'Club') {
      typeIcon = Icon(Icons.speaker_group_outlined);
    } else if (events[widget.index].type == 'Pub') {
      typeIcon = Icon(Icons.event_seat);
    }

    return Card(
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: Column(
        children: [
          Row(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(4.0),
                child: typeIcon,
              ),
              SizedBox(
                width: 8,
              ),
              Padding(
                padding: const EdgeInsets.all(4.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      '${events[widget.index].eventName}',
                      textAlign: TextAlign.left,
                      style: TextStyle(fontSize: 20),
                    ),
                    Text(
                      '${events[widget.index].host.name} is inviting you to an event!',
                      textAlign: TextAlign.left,
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width - 100,
                      child: Text(
                        'Going to a ${events[widget.index].type}, near ${events[widget.index].places[0].address}',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        softWrap: false,
                      ),
                    ),
                    Text(
                      'Event on: ${convertDate(events[widget.index].date)}',
                    ),
                  ],
                ),
              )
            ],
          ),
          ButtonBar(
            children: [
              SizedBox.fromSize(
                size: Size(60, 60), // button width and height
                child: ClipOval(
                  child: Material(
                    color: Colors.blue, // button color
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  EventDetails(events[index])),
                        );
                      }, // button pressed
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Icon(
                            Icons.info_outline,
                            size: 30,
                            color: Colors.white,
                          ), // icon
                          Text(
                            "Event",
                            style: TextStyle(color: Colors.white, fontSize: 12),
                          ), // text
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox.fromSize(
                size: Size(60, 60), // button width and height
                child: ClipOval(
                  child: Material(
                    color: Colors.green[900], // button color
                    child: InkWell(
                      onTap: () async {
                        print('Accepted the invite');
                        await EventDatabase()
                            .acceptEventInvite(events[widget.index])
                            .then((value) {
                          print('returned value is $value');
                          //Status of 1 is successful, status of 0 is a failure.
                          if (value == 1) {
                            setState(() {
                              acceptedInvite = true;
                            });
                          } else {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) =>
                                  _acceptInviteFail(context),
                            );
                          }
                        });
                      }, // button pressed
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Icon(
                            Icons.add_circle_outline_sharp,
                            size: 30,
                            color: Colors.white,
                          ), // icon
                          Text(
                            "Accept",
                            style: TextStyle(fontSize: 12),
                          ), // text
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox.fromSize(
                size: Size(60, 60), // button width and height
                child: ClipOval(
                  child: Material(
                    color: Colors.red[900], // button color
                    child: InkWell(
                      onTap: () {
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return new AlertDialog(
                                title: const Text('Decline Invitation?'),
                                content: new Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                        "Are you sure that you'd like to decline the event invitation? You will have to ask the host to re-invite you if you do."),
                                  ],
                                ),
                                actions: <Widget>[
                                  new ElevatedButton(
                                    onPressed: () async {
                                      declineInvite = true;
                                      Navigator.of(context).pop();
                                      await EventDatabase()
                                          .declineEventInvite(events[index]);
                                      setState(() {});
                                    },
                                    child: const Text('Decline Invitation.'),
                                  ),
                                  new ElevatedButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: const Text('Go back.'),
                                  ),
                                ],
                              );
                            });
                      }, // button pressed
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Icon(
                            Icons.remove_circle_outline,
                            size: 30,
                            color: Colors.white,
                          ), // icon
                          Text(
                            "Decline",
                            style: TextStyle(fontSize: 12),
                          ), // text
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

Widget _leaveEvent(BuildContext context) {}

Widget _acceptInviteFail(BuildContext context) {
  return new AlertDialog(
    title: const Text('Accept Failed'),
    content: new Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
            "There hase beena database error accepting this invite. Please try again."),
      ],
    ),
    actions: <Widget>[
      new ElevatedButton(
        onPressed: () {
          Navigator.of(context).pop();
        },
        child: const Text('Go back.'),
      ),
    ],
  );
}
