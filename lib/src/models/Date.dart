import 'package:cloud_firestore/cloud_firestore.dart';

class Date {
  String? id;
  DateTime? date;
  List<dynamic>? hours;

  Date({this.id, this.date, this.hours});

  factory Date.fromFirestore(DocumentSnapshot doc) {
    final Map<String, dynamic>? data = doc.data() as Map<String, dynamic>?;

    return Date(
      id: doc.id,
      date: data?['date']?.toDate(),
      hours: List<dynamic>.from(data?['hours'] ?? []),
    );
  }

  factory Date.fromMap(Map<String, dynamic> data) {
    return Date(
      id: data['name'] as String?,
      date: (data['date'] as Timestamp?)?.toDate(),
      hours: List<dynamic>.from(data['hours'] ?? []),
    );
  }
}
