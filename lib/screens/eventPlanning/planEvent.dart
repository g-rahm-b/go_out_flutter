import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_out_v2/models/event.dart';
import 'package:go_out_v2/screens/eventPlanning/planEventInviteFriends.dart';
import 'package:go_out_v2/services/eventDatabase.dart';
import 'package:go_out_v2/shared/constants.dart';
import 'package:go_out_v2/models/typeSelection.dart';

// ignore: must_be_immutable
class PlanEvent extends StatefulWidget {
  //Receive the new event data
  Event newEvent = new Event();
  PlanEvent({this.newEvent});

  @override
  _PlanEventState createState() => _PlanEventState();
}

class _PlanEventState extends State<PlanEvent> {
  final _formKey = GlobalKey<FormState>();

  //Text field state values
  String email = '';
  String password = '';
  String error = '';
  String name = '';
  String selectedCountry = '';
  String state = '';
  String city = '';
  Event newEvent;

  //Type Selectors:
  TypeSelection selectedType;
  List<TypeSelection> selections = <TypeSelection>[
    const TypeSelection(
        'Restaurant',
        Icon(
          Icons.restaurant,
        )),
    const TypeSelection(
        'Bar',
        Icon(
          Icons.sports_bar,
        )),
    const TypeSelection(
        'Pub',
        Icon(
          Icons.event_seat,
        )),
    const TypeSelection(
        'Night Club',
        Icon(
          Icons.speaker_group_outlined,
        )),
  ];

  //Date and Time variables
  DateTime selectedDate = DateTime.now();
  TimeOfDay initialTime = TimeOfDay.now();
  TimeOfDay selectedTime = TimeOfDay(hour: 00, minute: 00);
  String _time, enteredEventName;
  TextEditingController _timeController = TextEditingController();
  TextEditingController _dateController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    //_time = formatTime(initialTime);
    newEvent = widget.newEvent;

    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        title: Text('Event Details'),
      ),
      body: SingleChildScrollView(
        child: Container(
            padding: EdgeInsets.symmetric(vertical: 20, horizontal: 50),
            child: Form(
              //key will keep track of the form
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    width: 200,
                    child: Text(
                      "Event Name",
                      textAlign: TextAlign.start, // has impact
                    ),
                  ),
                  TextFormField(
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    decoration: textInputDecoration.copyWith(
                        hintText: 'Tap here to name event!'),
                    validator: (val) =>
                        val.isEmpty ? 'Enter your event name' : null,
                    onChanged: (val) {
                      enteredEventName = val;
                      // setState(() => newEvent.eventName = val);
                    },
                  ),
                  SizedBox(height: 10.0),
                  Text(
                    'Event Date:',
                  ),
                  TextFormField(
                    enabled: false,
                    controller: _dateController,
                    validator: (val) =>
                        val.isEmpty ? 'Please select a date' : null,
                    style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10.0),
                  Text(
                    'Event Time:',
                  ),
                  TextFormField(
                    enabled: false,
                    validator: (val) =>
                        val.isEmpty ? 'Please select a time' : null,
                    onTap: () => _selectTime(context),
                    controller: _timeController,
                    style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10.0),
                  Text('Event Type:'),
                  DropdownButton<TypeSelection>(
                    isExpanded: true,
                    hint: Text('Select Event Type'),
                    value: selectedType,
                    style: new TextStyle(
                        fontSize: 25, fontWeight: FontWeight.bold),
                    onChanged: (TypeSelection value) {
                      setState(() {
                        selectedType = value;
                      });
                    },
                    items: selections.map((TypeSelection selection) {
                      return DropdownMenuItem<TypeSelection>(
                          value: selection,
                          child: Row(
                            children: <Widget>[
                              selection.icon,
                              SizedBox(
                                width: 10,
                              ),
                              Text(
                                selection.type,
                              )
                            ],
                          ));
                    }).toList(),
                  ),
                  SizedBox(height: 10.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      FloatingActionButton.extended(
                        heroTag: "btn1",
                        onPressed: () => _selectDate(context),
                        label: Text('Date'),
                        icon: Icon(Icons.date_range),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      FloatingActionButton.extended(
                        heroTag: "btn2",
                        onPressed: () => _selectTime(context),
                        label: Text('Time'),
                        icon: Icon(Icons.access_time),
                      ),
                    ],
                  ),
                  SizedBox(height: 40.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: <Widget>[
                      Text('Once everything is filled out:'),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: <Widget>[
                      FloatingActionButton.extended(
                        heroTag: "btn3",
                        onPressed: () async {
                          if (_formKey.currentState.validate() &&
                              selectedType != null) {
                            Event tempEvent = Event(
                              date: new DateTime(
                                      selectedDate.year,
                                      selectedDate.month,
                                      selectedDate.day,
                                      selectedTime.hour,
                                      selectedTime.minute)
                                  .toString(),
                              eventName: enteredEventName,
                              type: selectedType.type,
                              searchRadius: newEvent.searchRadius,
                              lat: newEvent.lat,
                              lng: newEvent.lng,
                            );
                            //Want to check if there are google place results before creating the event
                            newEvent = await EventDatabase()
                                .getPlacesForEvent(tempEvent)
                                // ignore: missing_return
                                .then((value) {
                              //If there's no results, want to inform user
                              if (value.googleLink == 'Empty') {
                                print('there are no results');
                                return showDialog(
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        title:
                                            Text('No ${tempEvent.type}s Here'),
                                        content: Text(
                                            'There are no places in your search area that match your event criteria. Please go back and either expand your search radius, change your search location, or change your event type.'),
                                        actions: <Widget>[
                                          ElevatedButton(
                                            child: Text('OK'),
                                            onPressed: () {
                                              setState(() {
                                                Navigator.pop(context);
                                              });
                                            },
                                          ),
                                        ],
                                      );
                                    });
                              } else {
                                //If we are here, then we have populated results, and can go invite friends.
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            PlanEventInviteFriends(
                                                newEvent: value)));
                              }
                            });
                          } else {
                            print('ERROR');
                          }
                        },
                        label: Text('Invite Friends!'),
                        icon: Icon(Icons.add_circle),
                      ),
                    ],
                  ),
                  SizedBox(height: 15.0),
                  Text(
                    error,
                    style: TextStyle(fontSize: 14.0),
                  ),
                ],
              ),
            )),
      ),
    );
  }

  _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2025),
    );
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
        _dateController.text = "${selectedDate.toLocal()}".split(' ')[0];
      });
  }

  Future<Null> _selectTime(BuildContext context) async {
    final TimeOfDay picked = await showTimePicker(
      context: context,
      initialTime: selectedTime,
    );
    if (picked != null)
      setState(() {
        selectedTime = picked;
        _time = formatTime(picked);
        _timeController.text = _time;
      });
  }

  String formatTime(TimeOfDay timeToFormat) {
    String formattedTime = '';
    int hourInt = timeToFormat.hour;
    int minuteInt = timeToFormat.minute;
    String hour = timeToFormat.hour.toString();
    String minute = timeToFormat.minute.toString();
    //ToDo: You can really do better than this, Graeme
    if (hourInt >= 12) {
      if (minuteInt < 10) {
        formattedTime = "$hour: 0$minute pm";
      } else {
        formattedTime = "$hour: $minute pm";
      }
    } else {
      if (minuteInt < 10) {
        formattedTime = "$hour: 0$minute am";
      } else {
        formattedTime = "$hour: $minute am";
      }
    }
    return formattedTime;
  }
}
