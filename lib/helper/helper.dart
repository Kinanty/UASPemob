import 'package:intl/intl.dart';

String capitalizeFirstLetter(String text) {
  if (text.isEmpty) {
    return text;
  }
  return text[0].toUpperCase() + text.substring(1);
}

class DateHelper {
   static String formatDateToReadable(String dateString) {
    DateTime date = DateTime.parse(dateString);
    return DateFormat('d MMMM yyyy').format(date);
  }
}