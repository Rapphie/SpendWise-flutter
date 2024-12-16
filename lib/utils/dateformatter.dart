import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

String fromTimestamp(Timestamp timestamp) {
  DateTime dateFromtimestamp = timestamp.toDate();
  String formattedDate = DateFormat('d-MMM-yyyy h:mm a').format(dateFromtimestamp);
  return formattedDate;
}
