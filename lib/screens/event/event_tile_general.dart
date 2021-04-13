import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_out_v2/models/event.dart';

class EventTileGeneral extends StatelessWidget {
  final int index;
  final List<Event> events;
  final bool isHost, acceptedInvite, voteStatus;

  const EventTileGeneral(this.events, this.index, this.isHost,
      this.acceptedInvite, this.voteStatus);

  @override
  Widget build(BuildContext context) {
// events[index].invitedUsers
    return Card(
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          ListTile(
            leading: Icon(Icons.arrow_drop_down_circle),
            title: Text(events[index].host.name),
            subtitle: Text(
              'Going to a place',
              style: TextStyle(color: Colors.black.withOpacity(0.6)),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Event on: Date',
              style: TextStyle(color: Colors.black.withOpacity(0.6)),
            ),
          ),
          ButtonBar(
            alignment: MainAxisAlignment.start,
            children: [
              TextButton(
                //textColor: const Color(0xFF6200EE),
                onPressed: () {
                  // Perform some action
                },
                child: const Text('ACTION 1'),
              ),
              TextButton(
                //textColor: const Color(0xFF6200EE),
                onPressed: () {
                  // Perform some action
                },
                child: const Text('ACTION 2'),
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
