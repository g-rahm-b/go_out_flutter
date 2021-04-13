
import 'package:flutter/cupertino.dart';
import 'package:go_out_v2/screens/event/event_tile.dart';
import 'package:go_out_v2/services/eventDatabase.dart';
import 'package:go_out_v2/models/event.dart';
import 'package:go_out_v2/shared/loading.dart';

class EventList extends StatefulWidget {
  @override
  _EventListState createState() => _EventListState();
}

class _EventListState extends State<EventList> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: EventDatabase().getUserEvents(),
      builder: (BuildContext context, AsyncSnapshot<List <Event>> snapshot) {
        if(!snapshot.hasData) return Loading();
        List<Event> usersEvents = snapshot.data;

        return Expanded(
          child: ListView.builder(
            itemCount: usersEvents.length,
              itemBuilder: (context, index) {
                return EventTile(
                  index: index,
                  events: usersEvents,
                );
              }),
        );

      },
    );
    // return ListView.builder(
    //     itemCount: ,
    //     itemBuilder: itemBuilder)
  }
}
