import 'dart:collection';
import 'package:go_out_v2/credentials.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_out_v2/models/event.dart';
import 'package:go_out_v2/models/place.dart';
import 'package:go_out_v2/models/votes.dart';
import 'package:go_out_v2/shared/shared_methods.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class EventDetailsDetails extends StatefulWidget {
  final Event event;
  final List<Votes> eventVotes;
  const EventDetailsDetails(this.event, this.eventVotes);
  @override
  _EventDetailsDetailsState createState() =>
      _EventDetailsDetailsState(event, eventVotes);
}

class _EventDetailsDetailsState extends State<EventDetailsDetails> {
  _EventDetailsDetailsState(this.event, this.eventVotes);
  Event event;
  List<Votes> eventVotes;
  Place currentWinner = new Place();
  Image winnerPhoto;
  String photoUrl;
  GoogleMapController _controller;
  Set<Marker> _markers = HashSet<Marker>();
  Set<Circle> _circles = HashSet<Circle>();

  void initState() {
    event = this.event;
    eventVotes = this.eventVotes;
    currentWinner = getWinningPlace(event, eventVotes);
    photoUrl = getUrl(currentWinner.photoReference);
    super.initState();
  }

  var titleTextStyle = TextStyle(
    fontSize: 20.0,
    fontWeight: FontWeight.bold,
  );
  var teamNameTextStyle = TextStyle(
    fontSize: 18.0,
    fontWeight: FontWeight.w500,
  );

  void _onMapCreated(GoogleMapController controller) {
    //_controller.complete(controller);
    _setMapStyle();
    _controller = controller;
    _circles.add(Circle(
        circleId: CircleId('epicenter'),
        center: LatLng(event.lat, event.lng),
        radius: event.searchRadius,
        fillColor: Colors.redAccent.withOpacity(.15),
        strokeWidth: 3,
        strokeColor: Colors.redAccent));
    addPlaceMarker();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListView(
        padding: const EdgeInsets.all(16.0),
        children: <Widget>[
          const SizedBox(height: 16.0),
          Card(
            elevation: 4.0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: Stack(
              children: <Widget>[
                Column(
                  children: <Widget>[
                    Container(
                      height: 200.0,
                      child: FadeInImage(
                        image: NetworkImage(photoUrl),
                        placeholder: AssetImage("assets/pub.jpg"),
                        imageErrorBuilder: (context, error, stackTrace) {
                          return Image.asset('assets/pub.jpg',
                              fit: BoxFit.fill);
                        },
                        fit: BoxFit.fitWidth,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        "Going to a ${event.type}",
                        style: titleTextStyle,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 40.0),
                      child: Row(
                        children: <Widget>[
                          Text(
                            "Event Location:",
                            style: TextStyle(
                              fontSize: 14.0,
                            ),
                          ),
                          Spacer(),
                          Text(
                            currentWinner.address,
                            style: TextStyle(
                              fontSize: 14.0,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 40.0),
                      child: Row(
                        children: <Widget>[
                          Text(
                            "Event date/time:",
                            style: TextStyle(
                              fontSize: 14.0,
                            ),
                          ),
                          Spacer(),
                          Text(
                            convertDate(event.date),
                            style: TextStyle(
                              fontSize: 14.0,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 60.0),
                      child: Row(
                        children: <Widget>[
                          IconButton(
                            icon: const Icon(Icons.calendar_today_outlined),
                            onPressed: () {},
                          ),
                          ElevatedButton(
                              onPressed: () {
                                //ToDo: If all users havent voted, add a pop-up asking them if they want to proceed, because the winning place might change after they add it to their calendar
                              },
                              child: Text('Add event to Calendar'))
                        ],
                      ),
                    ),
                    const SizedBox(height: 20.0),
                  ],
                ),
                Positioned(
                  top: 160,
                  left: 10.0,
                  child: Container(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "Current Winner: ${currentWinner.name}",
                      style: TextStyle(
                        fontSize: 14.0,
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
          const SizedBox(height: 5.0),
          Divider(),
          const SizedBox(height: 5.0),
          SizedBox(
            height: 250,
            child: GoogleMap(
              initialCameraPosition: CameraPosition(
                  target: LatLng(event.lat, event.lng), zoom: 14.0),
              myLocationEnabled: true,
              mapType: MapType.normal,
              compassEnabled: true,
              circles: _circles,
              markers: _markers,
              onMapCreated: _onMapCreated,
            ),
          ),
          const SizedBox(height: 10.0),
          // ListTile(
          //   title: Text(
          //     "Cosgrove hat-tricks sparks Aberdeen",
          //     style: titleTextStyle,
          //   ),
          //   subtitle: Text("Yesterday, 7:02 PM | Aberdeen"),
          //   trailing: Container(
          //     width: 80.0,
          //     decoration: BoxDecoration(
          //         borderRadius: BorderRadius.circular(10.0),
          //         image: DecorationImage(
          //           image: AssetImage('assets/pub.jpg'),
          //           fit: BoxFit.cover,
          //         )),
          //   ),
          // ),
        ],
      ),
    );
  }

  //Setting the styling of the map based on a saved Json file
  void _setMapStyle() async {
    String style = await DefaultAssetBundle.of(context)
        .loadString('assets/map_style.json');
    _controller.setMapStyle(style);
  }

  void addPlaceMarker() {
    //ID 0 is reserverd for epicenter
    int count = 1;
    event.places.forEach((element) {
      _markers.add(Marker(
          markerId: MarkerId(count.toString()),
          position: LatLng(element.latitude, element.longitude),
          icon: BitmapDescriptor.defaultMarkerWithHue(20.0),
          draggable: false,
          infoWindow:
              InfoWindow(title: element.name, snippet: element.address)));
      count++;
    });
  }
}

String getUrl(String photoReference) {
  String ref =
      'https://maps.googleapis.com/maps/api/place/photo?photoreference=$photoReference&sensor=false&maxheight=900&maxwidth=900&key=$PLACES_API_KEY';
  return ref;
}

Widget buildPhoto(String url) {
  Image image = Image.network(url);

  final ImageStream stream = image.image.resolve(ImageConfiguration.empty);

  stream.addListener(ImageStreamListener((info, call) {
    //you can also handle image loading
    //example: loading = false;//that's mean image is loaded
  }, onError: (dynamic exception, StackTrace stackTrace) {
//    print('enter onError start');
//    print(exception);
//    print(stackTrace);
//    print('enter onError end');
  }));

  return image;
}

Place getWinningPlace(Event event, List<Votes> eventVotes) {
  //If a -1 is returned in eventVotes, that means there are no actual votes present.
  //Want to return a general tile to indicate as such.
  int min = -2;
  Place winningPlace = new Place();
  String winningPlaceName = '';
  for (int i = 0; i < eventVotes.length; i++) {
    //First, see if there have been any votes at all.
    if (eventVotes[i].vote == -1) {
      print('Votes dont exist');
      Place noVotesPlace = Place(
          address: 'To be determined',
          name: 'No votes have been cast, yet!',
          pricing: 0.0,
          vote: 0);
      return noVotesPlace;
    }
    //Otherwise, just take the first value, and set everything to it
    else if (i == 0) {
      min = eventVotes[i].vote;
      winningPlaceName = eventVotes[i].name;
    } else if (min > eventVotes[i].vote) {
      //If the vote we're looking at now is lower than the current minimum, we have a new minimum
      min = eventVotes[i].vote;
      winningPlaceName = eventVotes[i].name;
    }
  }

  //Go through the places, and set the 'PLACE' to the winner, if there are votes
  event.places.forEach((element) {
    if (element.name == winningPlaceName) {
      winningPlace = element;
    }
  });
  return winningPlace;
}
