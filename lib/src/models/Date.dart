import 'package:cloud_firestore/cloud_firestore.dart';

class Date {
  String id;
  DateTime date;
  List<dynamic> hours;

  Date({this.id, this.date, this.hours});

  factory Date.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data();

    return Date(
      id: doc.id,
      date: data['date'] ?? '',
      hours: data['hours'] ?? '',
    );
  }

  factory Date.fromMap(Map data) {
    return Date(
      id: data['name'] ?? '',
      date: data['date'].toDate() ?? '',
      hours: data['hours'] ?? '',
    );
  }
}
