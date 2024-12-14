import 'package:intl/intl.dart';

String formatTimestamp([DateTime? date]) {
  date ??= DateTime.now(); // If date is null, assign DateTime.now()
  String formattedDate = DateFormat('d-MMM-yyyy h:mm a').format(date);
  return formattedDate;
}
