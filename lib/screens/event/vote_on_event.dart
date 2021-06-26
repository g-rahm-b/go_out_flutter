import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_out/models/event.dart';
import 'package:go_out/models/place.dart';
import 'package:go_out/screens/home/home.dart';
import 'package:go_out/services/auth.dart';
import 'package:go_out/services/eventDatabase.dart';
import 'package:go_out/credentials.dart';

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
    String currentUid = AuthService().fetchUid();
    newEvent.invitedUsers.forEach((element) {
      if (element.uid == currentUid) {
        if (element.voteStatus == true) {
          return;
        }
      }
    });

    int count = 0;
    newEvent.places.forEach((element) {
      element.vote = count;
      count++;
    });

    return Scaffold(
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () async {
            //Push the new votes to the database
            await EventDatabase().submitPlaceVotes(newEvent);

            //Once the votes are submitted, go back to/re-load the homepage.
            Navigator.of(context).push(
              MaterialPageRoute(
                settings: RouteSettings(name: "/home"),
                builder: (context) => Home(),
              ),
            );
            Navigator.of(context).popUntil(ModalRoute.withName("/home"));
            dispose();
          },
          label: Text("Submit Preference Votes"),
          icon: const Icon(Icons.thumb_up_alt_outlined),
        ),
        appBar: new AppBar(
          title: new Text("Place Preferences"),
        ),
        body: ReorderableListView(
          padding: EdgeInsets.symmetric(vertical: 15),
          children: <Widget>[
            for (int index = 0; index < newEvent.places.length; index++)
              Card(
                // color: Colors.grey[(index + 1) * 100],
                elevation: 4.0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                key: Key('$index'),
                child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          flex: 1,
                          child: CircleAvatar(
                            minRadius: 37.0,
                            maxRadius: 47.0,
                            backgroundImage: NetworkImage(
                                getUrl(newEvent.places[index].photoReference)),
                          ),
                        ),
                        Expanded(
                            flex: 2,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  "${newEvent.places[index].name}",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16.0,
                                  ),
                                ),
                                const SizedBox(height: 5.0),
                                Text(
                                  "${newEvent.places[index].address}",
                                  style: TextStyle(
                                    fontWeight: FontWeight.normal,
                                    fontSize: 12.0,
                                  ),
                                ),
                                Text(
                                  'Location Rating: ${newEvent.places[index].rating}/5.0',
                                  style: TextStyle(
                                    fontWeight: FontWeight.normal,
                                    fontSize: 12.0,
                                  ),
                                ),
                                Text(
                                  'Location Pricing: ${newEvent.places[index].rating}/5.0',
                                  style: TextStyle(
                                    fontWeight: FontWeight.normal,
                                    fontSize: 12.0,
                                  ),
                                ),
                              ],
                            )),
                        const SizedBox(width: 5.0),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            SizedBox(height: 15.0),
                            Text('Rank'),
                            Text('${index + 1}',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                ))
                          ],
                        ),
                        SizedBox(width: 5)
                      ],
                    )),
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

String getUrl(String photoReference) {
  //ToDo: if the photoreference is empty, will have to return a generic place URL
  String ref =
      'https://maps.googleapis.com/maps/api/place/photo?photoreference=${photoReference}&sensor=false&maxheight=800&maxwidth=800&key=${PLACES_API_KEY}';
  print(ref);
  return ref;
}
