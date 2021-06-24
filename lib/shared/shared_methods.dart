import 'package:intl/intl.dart';

String convertDate(String dateToConvert) {
  //Convert the date from Firebase back to a DateTime
  DateTime tempDate = new DateFormat("yyyy-MM-dd hh").parse(dateToConvert);

  //Revert it back to a String in a more readable format
  dateToConvert = DateFormat('MMMM d, y – h:mm a').format(tempDate);

  return dateToConvert;
}
