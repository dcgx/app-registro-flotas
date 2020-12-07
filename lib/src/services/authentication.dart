import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  var _db = FirebaseFirestore.instance;

  Future<QuerySnapshot> signIn(String password) {
    return _db.collection('users').where('password', isEqualTo: password).get();
  }

  // Future signOut() {}
}
