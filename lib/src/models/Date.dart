import 'package:cloud_firestore/cloud_firestore.dart';

class Date {
  String id;
  DateTime date;
  List<dynamic> hours;

  Date({required this.id, required this.date, required this.hours});

  factory Date.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic>? data = doc.data() as Map<String, dynamic>?;

    return Date(
      id: doc.id,
      date: (data?["date"] as Timestamp?)?.toDate() ?? DateTime.now(),
      hours: data?["hours"] as List<dynamic>? ?? [],
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
