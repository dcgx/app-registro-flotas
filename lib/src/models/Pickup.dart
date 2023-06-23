import 'package:cloud_firestore/cloud_firestore.dart';

class Pickup {
  String id;
  String patent;
  String category;
  String status;
  String userId;

  Pickup({required this.id, required this.patent, required this.category, required this.status, required this.userId});

  factory Pickup.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic>? data = doc.data() as Map<String, dynamic>?;

    return Pickup(
        id: doc.id,
        patent: data?['patent'],
        category: data?['category'],
        status: data?['status'],
        userId: data?['user_id']);
  }

  factory Pickup.fromJson(Map<String, dynamic> json) {
    return Pickup(
        id: json['id'],
        patent: json['patent'],
        category: json['category'],
        status: json['status'],
        userId: json['user_id']);
  }
}
