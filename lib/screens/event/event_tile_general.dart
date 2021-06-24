import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_out_v2/models/event.dart';
import 'package:go_out_v2/screens/event/event_details.dart';
import 'package:go_out_v2/screens/event/vote_on_event.dart';
import 'package:go_out_v2/shared/shared_methods.dart';
import 'package:intl/intl.dart';

class EventTileGeneral extends StatefulWidget {
  final int index;
  final List<Event> events;
  final bool isHost, acceptedInvite, voteStatus;

  const EventTileGeneral(this.events, this.index, this.isHost,
      this.acceptedInvite, this.voteStatus);

  @override
  _EventTileGeneralState createState() =>
      _EventTileGeneralState(events, index, isHost, acceptedInvite, voteStatus);
}

class _EventTileGeneralState extends State<EventTileGeneral> {
  int index;
  List<Event> events;
  bool isHost, acceptedInvite, voteStatus;
  _EventTileGeneralState(this.events, this.index, this.isHost,
      this.acceptedInvite, this.voteStatus);
  Icon typeIcon = Icon(Icons.smartphone_outlined);
  String voteButtonString = '';
  bool leaveEvent = false;
  double iconSize = 50.0;

  @override
  Widget build(BuildContext context) {
    if (events[widget.index].type == 'Bar') {
      typeIcon = Icon(
        FontAwesomeIcons.glassCheers,
        size: iconSize,
      );
    } else if (events[widget.index].type == 'Restaurant') {
      typeIcon = Icon(
        FontAwesomeIcons.utensils,
        size: iconSize,
      );
    } else if (events[widget.index].type == 'Club') {
      typeIcon = Icon(
        FontAwesomeIcons.music,
        size: iconSize,
      );
    } else if (events[widget.index].type == 'Pub') {
      typeIcon = Icon(
        FontAwesomeIcons.beer,
        size: iconSize,
      );
    }

    voteButtonString = getVoteButtonString(widget.voteStatus);

    if (leaveEvent == true) {
      return Container();
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
                      'Event created by ${events[widget.index].host.name}',
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
                      // splash color
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
                          ), // icon
                          Text(
                            'Event',
                            style: TextStyle(fontSize: 12),
                          ), // text
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              if (!voteStatus)
                SizedBox.fromSize(
                  size: Size(60, 60), // button width and height
                  child: ClipOval(
                    child: Material(
                      color: Colors.purple[900], // button color
                      child: InkWell(
                        // splash color
                        onTap: () {
                          if (voteStatus) {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) =>
                                  _alreadyVotedPopup(context),
                            );
                          } else {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => VoteOnEvent(
                                        newEvent: events[widget.index])));
                          }
                        }, // button pressed
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Icon(
                              Icons.how_to_vote_outlined,
                              size: 30,
                            ), // icon
                            Text(
                              voteButtonString,
                              style:
                                  TextStyle(color: Colors.white, fontSize: 12),
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
                              title: const Text('Leave Event?'),
                              content: new Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                      "Are you sure that you'd like to leave this event?."),
                                ],
                              ),
                              actions: <Widget>[
                                new ElevatedButton(
                                  onPressed: () async {
                                    print('Leaving event');
                                    // await EventDatabase()
                                    //       .leaveEvent(events[index]);
                                    leaveEvent = true;
                                    Navigator.pop(context);
                                    setState(() {});
                                  },
                                  child: const Text('Confirm Leave.'),
                                ),
                                new ElevatedButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: const Text('Go back.'),
                                ),
                              ],
                            );
                          },
                        );
                      }, // button pressed
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Icon(
                            Icons.cancel_outlined,
                            size: 30,
                          ), // icon
                          Text(
                            'Leave',
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
          // Image.asset('assets/rave.jpg'),
          // Image.asset('assets/pub.jpg'),
        ],
      ),
    );
  }
}

String getVoteButtonString(bool voteStatus) {
  if (voteStatus) {
    return 'Voting Complete';
  } else {
    return 'Vote';
  }
}

Widget _alreadyVotedPopup(BuildContext context) {
  return new AlertDialog(
    title: const Text('You have already voted for this event!'),
    content: new Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      // children: <Widget>[
      //   Text("Hello"),
      // ],
    ),
    actions: <Widget>[
      new ElevatedButton(
        onPressed: () {
          Navigator.of(context).pop();
        },
        child: const Text('Close Notification'),
      ),
    ],
  );
}

Widget _leaveEvent(BuildContext context) {}
