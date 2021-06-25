import 'package:add_2_calendar/add_2_calendar.dart';

void addToCalendar(String title, String description, String location,
    DateTime startDate, DateTime endDate) {
  final Event event = Event(
    title: title,
    description: description,
    location: location,
    startDate: startDate,
    endDate: endDate,
    allDay: false,
    iosParams: IOSParams(
      reminder: Duration(minutes: 60),
    ),
  );
  Add2Calendar.addEvent2Cal(event);
}
