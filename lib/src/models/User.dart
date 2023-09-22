import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  String? id;
  String? name;
  String? phone;
  List<dynamic>? roles;

  User({this.id, this.name, this.phone, this.roles});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
        id: json['id'],
        name: json['name'],
        phone: json['phone'],
        roles: json['roles']);
  }

  factory User.fromMap(Map data) {
    return User(
        id: data['name'] ?? '',
        name: data['name'] ?? '',
        phone: data['phone'] ?? '',
        roles: data['roles'] ?? '');
  }
  factory User.fromFirestore(DocumentSnapshot doc) {
    final Map<String, dynamic>? data = doc.data() as Map<String, dynamic>?;

    return User(
        id: doc.id,
        name: data?['name'] ?? '',
        phone: data?['phone'] ?? '',
        roles: data?['roles'] ?? '');
  }
}
