import 'dart:async';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flit_app/src/models/hour.dart';
import 'package:flit_app/src/models/pickup.dart';
import 'package:flit_app/src/models/user.dart';

class DatabaseService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  List<Hour> hourList = [];

  DateTime dateNow =
      DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);

  Future<User> getUser(String id) async {
    var snapshot = await _db.collection('users').doc(id).get();

    return User.fromMap(snapshot.data() as Map<String, dynamic>);
  }

  Future<void> addUser(User user) async {
    var userRef = _db.collection('users');
    await userRef.add({
      "name": user.name,
      "password": Random().nextInt(4),
      "phone": user.phone,
      "roles": user.roles
    });
  }

  Future<void> addPickup(Pickup pickup) async {
    var pickupRef = _db.collection('pickups');
    await pickupRef.add({
      "patent": pickup.patent,
      "category": pickup.category,
      "status": "DISPONIBLE"
    });
  }

  Future<void> updatePickup(Pickup pickup) async {
    var ref = _db.collection('pickups').doc(pickup.id);

    print(pickup.id);
    await ref.update({"patent": pickup.patent, "category": pickup.category});
  }

  Future<void> addHoursToDate(
      List<int> hours, User currentUser, Pickup pickup) async {
    var dateRef =
        _db.collection('dates').where('date', isGreaterThanOrEqualTo: dateNow);

    var hoursRef =
        _db.collection('dates').doc(dateNow.toString()).collection('hours');

    await dateRef.get().then((date) {
      if (date.docs.length > 0) {
        hours.forEach((hour) {
          hoursRef.add({
            "hour": hour,
            "user_id": currentUser.id,
            "pickup_id": pickup.id,
            "user_name": currentUser.name,
            "user_phone": currentUser.phone,
          });
        });
      } else {
        _db.collection('dates').doc(dateNow.toString()).set({'date': dateNow});
        hours.forEach((hour) {
          hoursRef.add({
            "hour": hour,
            "user_id": currentUser.id,
            "pickup_id": pickup.id,
            "user_name": currentUser.name,
            "user_phone": currentUser.phone,
          });
        });
      }
    });
  }

  Future<void> deleteHour(int hour) {
    var hoursRef = _db
        .collection('dates')
        .doc(dateNow.toString())
        .collection('hours')
        .where('hour', isEqualTo: hour);

    return hoursRef.get().then((hour) {
      _db
          .collection('dates')
          .doc("${dateNow.toString()}/hours/${hour.docs.first.id}")
          .delete();
    });
  }

  Stream<List<Hour>> streamHours(Pickup pickup) {
    var ref = _db
        .collection('dates')
        .doc(dateNow.toString())
        .collection('hours')
        .where('pickup_id', isEqualTo: pickup.id);

    return ref.snapshots().map(
        (list) => list.docs.map((hour) => Hour.fromFirestore(hour)).toList());
  }

  Stream<List<Pickup>> streamPickups() {
    var ref = _db.collection('pickups');

    return ref.snapshots().map((list) =>
        list.docs.map((pickup) => Pickup.fromFirestore(pickup)).toList());
  }

  Stream<List<User>> streamUsers() {
    var userRef =
        _db.collection('users').where('roles', arrayContains: 'driver');

    return userRef.snapshots().map(
        (list) => list.docs.map((user) => User.fromFirestore(user)).toList());
  }

  Stream<List<Hour>> streamUserHours(DateTime date, String userId) {
    var hourRef = _db
        .collection('dates')
        .doc(date.toString())
        .collection('hours')
        .where('user_id', isEqualTo: userId)
        .orderBy('hour');

    return hourRef.snapshots().map(
        (list) => list.docs.map((hour) => Hour.fromFirestore(hour)).toList());
  }

  Stream<List<Hour>> streamPickupHours(DateTime date, String pickupId) {
    if (date != null) {
      var ref = _db
          .collection('dates')
          .doc(date.toString())
          .collection('hours')
          .where('pickup_id', isEqualTo: pickupId)
          .orderBy(
              'hour'); // retorna todas las horas segun la camioneta y la fecha indicada

      return ref.snapshots().map(
          (list) => list.docs.map((hour) => Hour.fromFirestore(hour)).toList());
    } else {
      print("yess");
      var ref = _db
          .collectionGroup('hours')
          .where('pickup_id', isEqualTo: pickupId)
          .orderBy('hour'); // retorna todas las horas segun la camioneta

      ref.snapshots().forEach((element) {
        element.docs.forEach((element) {
          print(element.reference.parent.parent?.id);
        });
      });
      return ref.snapshots().map((list) => list.docs.map((hour) {
            // Obtiene y agrega al fecha correspondiente a la hora

            var date = hour.reference.parent.parent?.id;
            var hourData = Hour.fromFirestore(hour);
            hourData.date = DateTime.parse(date!);

            return hourData;
          }).toList());
    }
  }

  Stream<Pickup> streamPickupById(String pickupId) {
    var pickupRef = _db.collection('pickups').doc(pickupId);

    return pickupRef
        .snapshots()
        .map((pickup) => Pickup.fromJson(pickup.data() as Map<String, dynamic>));
  }

  Stream<User> streamUserById(String userId) {
    var userRef = _db.collection('users').doc(userId);

    return userRef
        .snapshots()
        .map((user) => User.fromJson(user.data() as Map<String, dynamic>));
  }

  Future<User> getUserById(String userId) {
    var userRef = _db.collection('users').doc(userId);

    return userRef.get().then((user) {
      return User.fromJson(user.data() as Map<String, dynamic>);
    });
  }

  Future<void> changeStatusPickup(String status, String pickupId) async {
    await _db.collection('pickups').doc(pickupId).update({"status": status});
  }
}