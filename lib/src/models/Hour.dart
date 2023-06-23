import 'package:cloud_firestore/cloud_firestore.dart';

class Hour {
  // DateTime date;
  String id;
  int hour;
  String userId;
  String userName;
  String userPhone;
  String pickupId;
  DateTime date;

  Hour(
      {required this.id,
      required this.hour,
      required this.userId,
      required this.userName,
      required this.userPhone,
      required this.pickupId,
      required this.date});

  factory Hour.fromMap(Map data) {
    return Hour(
      id: data['name'] ?? '',
      hour: data['hour'],
      userId: data['user_id'] ?? '',
      userName: data['user_name'] ?? '',
      userPhone: data['user_phone'] ?? '',
      pickupId: data['pickup_id'] ?? '',
      date: DateTime.now(),
    );
  }

  factory Hour.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic>? data = doc.data() as Map<String, dynamic>?;

    return Hour(
      id: doc.id,
      hour: data?['hour'],
      userId: data?['user_id'] ?? '',
      userName: data?['user_name'] ?? '',
      userPhone: data?['user_phone'] ?? '',
      pickupId: data?['pickup_id'] ?? '',
      date: DateTime.now(),
    );
  }
}
