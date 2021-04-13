import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_out_v2/models/event.dart';
import 'package:go_out_v2/screens/event/vote_on_event.dart';

class EventTileHost extends StatelessWidget {
  final int index;
  final List<Event> events;
  final bool isHost, acceptedInvite, voteStatus;

  const EventTileHost(this.events, this.index, this.isHost, this.acceptedInvite,
      this.voteStatus);

  @override
  Widget build(BuildContext context) {
// events[index].invitedUsers
    return Card(
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          ListTile(
            leading: Icon(Icons.restaurant_outlined),
            title: Text(
                '${events[index].eventName} hosted by: ${events[index].host.name}'),
            subtitle: Text(
              'Going to a ${events[index].type}',
              style: TextStyle(color: Colors.black.withOpacity(0.6)),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(0),
            child: Text(
              'Event on: ${events[index].date}',
              style: TextStyle(color: Colors.black.withOpacity(0.6)),
            ),
          ),
          ButtonBar(
            alignment: MainAxisAlignment.start,
            children: [
              TextButton(
                //textColor: const Color(0xFF6200EE),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              VoteOnEvent(newEvent: events[index])));
                  // Perform some action
                },
                child: const Text('Vote Now'),
              ),
              TextButton(
                //textColor: const Color(0xFF6200EE),
                onPressed: () {
                  // Perform some action
                },
                child: const Text('View Event Details'),
              ),
              TextButton(
                //textColor: const Color(0xFF6200EE),
                onPressed: () {
                  // Perform some action
                },
                child: const Text('Cancel Event'),
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
