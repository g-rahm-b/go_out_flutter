import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_out_v2/models/event.dart';
import 'package:go_out_v2/models/place.dart';
import 'package:go_out_v2/models/votes.dart';
import 'package:go_out_v2/services/eventDatabase.dart';

// ignore: must_be_immutable
class VoteOnEvent extends StatefulWidget {
  Event newEvent = new Event();
  VoteOnEvent({this.newEvent});
  @override
  _VoteOnEventState createState() => _VoteOnEventState();
}

class _VoteOnEventState extends State<VoteOnEvent> {
  Event newEvent;
  @override
  Widget build(BuildContext context) {
    newEvent = widget.newEvent;

    int count = 0;
    print('Going to build the votes');
    newEvent.places.forEach((element) {
      element.vote = count;
      count++;
    });

    return Scaffold(
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            newEvent.places.forEach((element) {
              print('Vote of ${element.vote} for place: ${element.name}');
            });
            EventDatabase().submitPlaceVotes(newEvent);
          },
          label: Text("Submit Votes"),
          icon: const Icon(Icons.thumb_up_alt_outlined),
          backgroundColor: Colors.pink,
        ),
        appBar: new AppBar(
          title: new Text("Place Preferences"),
        ),
        body: ReorderableListView(
          padding: EdgeInsets.symmetric(vertical: 15),
          children: <Widget>[
            for (int index = 0; index < newEvent.places.length; index++)
              Card(
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                key: Key('$index'),
                child: Column(
                  children: [
                    ListTile(
                      leading: Text((index + 1).toString()),
                      title: Text(newEvent.places[index].name),
                      subtitle: Text(newEvent.places[index].address),
                      tileColor: Colors.green[(index + 1) * 100],
                    ),
                    Text(
                      'Location Rating: ${newEvent.places[index].rating}/5.0',
                      style: TextStyle(
                        color: Colors.black.withOpacity(0.6),
                      ),
                    ),
                  ],
                ),
              ),
          ],
          onReorder: (int oldIndex, int newIndex) {
            setState(() {
              if (oldIndex < newIndex) {
                newIndex -= 1;
              }
              final Place item = newEvent.places.removeAt(oldIndex);
              newEvent.places.insert(newIndex, item);
            });
          },
        ));
  }
}
