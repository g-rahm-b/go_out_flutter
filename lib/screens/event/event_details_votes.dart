import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_out_v2/models/event.dart';
import 'package:go_out_v2/models/votes.dart';
import 'package:go_out_v2/credentials.dart';

class EventDetailsVotes extends StatefulWidget {
  final Event event;
  final List<Votes> eventVotes;
  const EventDetailsVotes(this.event, this.eventVotes);

  @override
  _EventDetailsVotesState createState() =>
      _EventDetailsVotesState(event, eventVotes);
}

class _EventDetailsVotesState extends State<EventDetailsVotes> {
  Event event;
  List<Votes> eventVotes;
  //If there are no votes, we'll just display all the places with no votes.
  //Assume they exist, to start off.
  bool votesExist = true;
  void initState() {
    event = this.event;
    eventVotes = this.eventVotes;
    event.places.forEach((placeElement) {
      eventVotes.forEach((voteElement) {
        //If we have a vote of -1, we know there are no votes (or some error)
        //If this is the case, then we'll just display the results, with no ranking
        if (voteElement.vote == -1) {
          votesExist = false;
        } else if (placeElement.name == voteElement.name) {
          placeElement.vote = voteElement.vote;
        }
      });
    });

    if (votesExist) {
      event.places.sort((a, b) {
        return a.vote.compareTo(b.vote);
      });
    }
    super.initState();
  }

  _EventDetailsVotesState(this.event, this.eventVotes);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: event.places.length,
        itemBuilder: (context, index) {
          String photoUrl = getUrl(event.places[index].photoReference);
          return (Card(
            elevation: 4.0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: <Widget>[
                  CircleAvatar(
                    minRadius: 37.0,
                    maxRadius: 47.0,
                    backgroundImage: NetworkImage(photoUrl),
                  ),
                  const SizedBox(width: 10.0),
                  Expanded(
                    flex: 2,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          "${event.places[index].name}",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16.0,
                          ),
                          overflow: TextOverflow.fade,
                          maxLines: 1,
                          softWrap: false,
                        ),
                        const SizedBox(height: 5.0),
                        Text(
                          "${event.places[index].address}",
                          style: TextStyle(
                            fontWeight: FontWeight.normal,
                            fontSize: 12.0,
                          ),
                          overflow: TextOverflow.fade,
                          maxLines: 1,
                          softWrap: false,
                        ),
                        Text(
                          "Rating of ${event.places[index].rating}/5.0",
                          style: TextStyle(
                            fontWeight: FontWeight.normal,
                            fontSize: 12.0,
                          ),
                          overflow: TextOverflow.fade,
                          maxLines: 1,
                          softWrap: false,
                        ),
                        Text(
                          "Pricing of ${event.places[index].pricing}/5.0",
                          style: TextStyle(
                            fontWeight: FontWeight.normal,
                            fontSize: 12.0,
                          ),
                          overflow: TextOverflow.fade,
                          maxLines: 1,
                          softWrap: false,
                        ),
                        if (votesExist)
                          Text(
                            //The list should be sorted at this point, so the index will reflect the 'position'
                            "Current vote ranking is: ${index + 1}",
                            style: TextStyle(
                              fontWeight: FontWeight.w300,
                              fontSize: 16.0,
                            ),
                          ),
                        if (!votesExist)
                          Text(
                            //The list should be sorted at this point, so the index will reflect the 'position'
                            "No votes yet.",
                            style: TextStyle(
                              fontWeight: FontWeight.w300,
                              fontSize: 16.0,
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ));
        });
  }
}

String getUrl(String photoReference) {
  //ToDo: if the photoreference is empty, will have to return a generic place URL
  String ref =
      'https://maps.googleapis.com/maps/api/place/photo?photoreference=${photoReference}&sensor=false&maxheight=800&maxwidth=800&key=${PLACES_API_KEY}';
  print(ref);
  return ref;
}
