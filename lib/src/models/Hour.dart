import 'package:cloud_firestore/cloud_firestore.dart';

class Hour {
  // DateTime date;
  String id;
  int hour;
  String userId;
  String userName;
  String userPhone;
  String pickupId;

  Hour(
      {this.id,
      this.hour,
      this.userId,
      this.userName,
      this.userPhone,
      this.pickupId});

  factory Hour.fromMap(Map data) {
    return Hour(
      id: data['name'] ?? '',
      hour: data['hour'],
      userId: data['user_id'] ?? '',
      userName: data['user_name'] ?? '',
      userPhone: data['user_phone'] ?? '',
      pickupId: data['pickup_id'] ?? '',
    );
  }

  factory Hour.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data();

    return Hour(
      id: doc.id,
      hour: data['hour'],
      userId: data['user_id'] ?? '',
      userName: data['user_name'] ?? '',
      userPhone: data['user_phone'] ?? '',
      pickupId: data['pickup_id'] ?? '',
    );
  }
}
