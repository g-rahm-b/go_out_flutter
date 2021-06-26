import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_out/models/event.dart';
import 'package:go_out/screens/event/event_details.dart';
import 'package:go_out/screens/event/vote_on_event.dart';
import 'package:go_out/services/eventDatabase.dart';
import 'package:go_out/shared/shared_methods.dart';

class EventTileHost extends StatefulWidget {
  final int index;
  final List<Event> events;
  final bool isHost, acceptedInvite, voteStatus;

  const EventTileHost(this.events, this.index, this.isHost, this.acceptedInvite,
      this.voteStatus);

  @override
  _EventTileHostState createState() =>
      _EventTileHostState(events, index, isHost, acceptedInvite, voteStatus);
}

class _EventTileHostState extends State<EventTileHost> {
  int index;
  List<Event> events;
  bool isHost, acceptedInvite, voteStatus;
  _EventTileHostState(this.events, this.index, this.isHost, this.acceptedInvite,
      this.voteStatus);
  double iconSize = 50.0;
  Icon typeIcon = Icon(Icons.smartphone_outlined);
  bool eventCancelled = false;

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
    //If the user cancels the event, this will hide the card.
    if (eventCancelled == true) {
      return Container();
    }
    //Otherwise, load the card normally. If it's deleted, it will be removed from the list
    //The next time the list is loaded, the event won't even load into it.
    return Card(
      elevation: 10,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: <Widget>[
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
                      'You are hosting this event.',
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
                      splashColor: Colors.green, // splash color
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
              if (!voteStatus)
                SizedBox.fromSize(
                  size: Size(60, 60), // button width and height
                  child: ClipOval(
                    child: Material(
                      color: Colors.purple[900], // button color
                      child: InkWell(
                        splashColor: Colors.green, // splash color
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
                              color: Colors.white,
                            ), // icon
                            Text(
                              "Vote",
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
                      splashColor: Colors.green, // splash color
                      onTap: () {
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return new AlertDialog(
                                title: const Text('Cancel Event?'),
                                content: new Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                        "Cancelling the event will remove it from all other invited users. This action cannot be undone."),
                                  ],
                                ),
                                actions: <Widget>[
                                  new ElevatedButton(
                                    onPressed: () async {
                                      print('cancelling event');
                                      await EventDatabase()
                                          .cancelEvent(events[index]);
                                      eventCancelled = true;
                                      Navigator.pop(context);
                                      setState(() {});
                                    },
                                    child: const Text('Cancel Event.'),
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
                            Icons.cancel_outlined,
                            size: 30,
                            color: Colors.white,
                          ), // icon
                          Text(
                            "Cancel",
                            style: TextStyle(color: Colors.white, fontSize: 12),
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

Widget _cancelEvent(BuildContext context, Event event) {
  return new AlertDialog(
    title: const Text('Cancel Event?'),
    content: new Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
            "Cancelling the event will remove it from all other invited users. This action cannot be undone."),
      ],
    ),
    actions: <Widget>[
      new ElevatedButton(
        onPressed: () {
          print('cancelling event');
          EventDatabase().cancelEvent(event);

          Navigator.pop(context, true);
        },
        child: const Text('Cancel Event.'),
      ),
      new ElevatedButton(
        onPressed: () {
          Navigator.of(context).pop();
        },
        child: const Text('Go back.'),
      ),
    ],
  );
}
