import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  String id;
  String name;
  String phone;
  List<dynamic> roles;

  User(
      {required this.id,
      required this.name,
      required this.phone,
      required this.roles});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
        id: json['id'],
        name: json['name'],
        phone: json['phone'],
        roles: json['roles']);
  }

  factory User.fromMap(Map<String, dynamic> data) {
    return User(
      id: data['id'],
      name: data['name'],
      phone: data['phone'],
      roles: List<dynamic>.from(data['roles']),
    );
  }

  factory User.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic>? data = doc.data() as Map<String, dynamic>?;

    return User(
        id: doc.id,
        name: data?['name'] ?? '',
        phone: data?['phone'] ?? '',
        roles: data?['roles'] ?? '');
  }
}
