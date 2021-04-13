import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_out_v2/models/event.dart';
import 'package:go_out_v2/screens/eventPlanning/planEventInviteFriends.dart';
import 'package:go_out_v2/shared/constants.dart';
import 'package:go_out_v2/models/typeSelection.dart';

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
          color: const Color(0xFF167F67),
        )),
    const TypeSelection(
        'Bar',
        Icon(
          Icons.sports_bar,
          color: const Color(0xFF167F67),
        )),
    const TypeSelection(
        'Pub',
        Icon(
          Icons.event_seat,
          color: const Color(0xFF167F67),
        )),
    const TypeSelection(
        'Club',
        Icon(
          Icons.speaker_group_outlined,
          color: const Color(0xFF167F67),
        )),
  ];

  //Date and Time variables
  DateTime selectedDate = DateTime.now();
  TimeOfDay initialTime = TimeOfDay.now();
  TimeOfDay selectedTime = TimeOfDay(hour: 00, minute: 00);
  String _hour, _minute, _time;
  TextEditingController _timeController = TextEditingController();
  TextEditingController _dateController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    //_time = formatTime(initialTime);
    newEvent = widget.newEvent;

    return Scaffold(
      backgroundColor: Colors.pink[100],
      appBar: AppBar(
        backgroundColor: Colors.pink[400],
        elevation: 0.0,
        title: Text('Event Details'),
        actions: <Widget>[
          TextButton.icon(
              onPressed: () {},
              icon: Icon(Icons.person),
              label: Text('Placeholder'))
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
            padding: EdgeInsets.symmetric(vertical: 20, horizontal: 50),
            child: Form(
              //key will keep track of the form
              key: _formKey,
              child: Column(
                children: <Widget>[
                  SizedBox(height: 10.0),
                  TextFormField(
                    decoration: textInputDecoration.copyWith(
                        hintText: 'Name your event!'),
                    validator: (val) =>
                        val.isEmpty ? 'Enter your event name' : null,
                    onChanged: (val) {
                      newEvent.eventName = val;
                      setState(() => newEvent.eventName = val);
                    },
                  ),
                  SizedBox(height: 10.0),
                  TextFormField(
                    enabled: false,
                    controller: _dateController,
                    validator: (val) =>
                        val.isEmpty ? 'Please select a date' : null,
                    style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(width: 10.0),
                  Row(
                    children: [
                      ElevatedButton.icon(
                        onPressed: () => _selectDate(context),
                        icon: Icon(Icons.date_range),
                        label: Text(
                          'Choose date',
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10.0),
                  TextFormField(
                    enabled: false,
                    validator: (val) =>
                        val.isEmpty ? 'Please select a time' : null,
                    onTap: () => _selectTime(context),
                    controller: _timeController,
                    style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(width: 10.0),
                  Row(
                    children: [
                      ElevatedButton.icon(
                        onPressed: () => _selectTime(context),
                        icon: Icon(Icons.access_time),
                        label: Text(
                          'Choose Time',
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10.0),
                  DropdownButton<TypeSelection>(
                    hint: Text('Select Event Type'),
                    value: selectedType,
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
                                style: TextStyle(color: Colors.black),
                              )
                            ],
                          ));
                    }).toList(),
                  ),
                  SizedBox(height: 40.0),
                  ElevatedButton.icon(
                    icon: Icon(Icons.add_circle),
                    label: Text('Invite Friends!'),
                    onPressed: () {
                      if (_formKey.currentState.validate() && selectedType != null) {
                        newEvent.date = new DateTime(
                            selectedDate.year,
                            selectedDate.month,
                            selectedDate.day,
                            selectedTime.hour,
                            selectedTime.minute).toString();
                        newEvent.type = selectedType.type;
                        print('');
                        print('New Event Data is: ');
                        print(newEvent.eventName);
                        print(newEvent.type);
                        print(newEvent.date);
                        Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => PlanEventInviteFriends(newEvent: newEvent)));
                      }
                      else{
                        print('ERROR');
                      }
                    },
                  ),
                  SizedBox(height: 15.0),
                  Text(
                    error,
                    style: TextStyle(color: Colors.black, fontSize: 14.0),
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
