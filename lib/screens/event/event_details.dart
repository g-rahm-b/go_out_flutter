import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_out/models/event.dart';
import 'package:go_out/models/votes.dart';
import 'package:go_out/screens/event/event_details_details.dart';
import 'package:go_out/screens/event/event_details_people.dart';
import 'package:go_out/screens/event/event_details_votes.dart';
import 'package:go_out/services/eventDatabase.dart';
import 'package:go_out/shared/loading.dart';

class EventDetails extends StatefulWidget {
  final Event event;
  const EventDetails(this.event);

  @override
  _EventDetailsState createState() => _EventDetailsState(event);
}

class _EventDetailsState extends State<EventDetails> {
  Event event;
  // List<Votes> eventVotes = [];
  List<Widget> _widgetOptions = [];

  void initState() {
    event = this.event;
    super.initState();
  }

  _EventDetailsState(this.event);
  int currentIndex = 0;
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: EventDatabase().populateVotes(event),
        builder: (BuildContext context, AsyncSnapshot<List<Votes>> snapshot) {
          if (!snapshot.hasData) return Loading();
          List<Votes> eventVotes = snapshot.data;
          _widgetOptions = <Widget>[
            EventDetailsDetails(event, eventVotes),
            EventDetailsPeople(event),
            EventDetailsVotes(event, eventVotes),
          ];

          return Scaffold(
            appBar: AppBar(
              elevation: 0.0,
              title: Text(
                event.eventName,
                style: TextStyle(fontSize: 20.0),
              ),
            ),
            body: Container(
              child: _widgetOptions.elementAt(_selectedIndex),
            ),
            bottomNavigationBar: BottomNavigationBar(
              items: <BottomNavigationBarItem>[
                BottomNavigationBarItem(
                  icon: Icon(FontAwesomeIcons.infoCircle),
                  label: 'Details',
                ),
                BottomNavigationBarItem(
                  icon: Icon(FontAwesomeIcons.users),
                  label: 'People',
                ),
                BottomNavigationBarItem(
                  icon: Icon(FontAwesomeIcons.voteYea),
                  label: 'Votes',
                ),
              ],
              currentIndex: _selectedIndex,
              unselectedItemColor: Colors.grey.shade700,
              onTap: _onItemTapped,
            ),
          );
        });
  }
}
