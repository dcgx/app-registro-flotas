import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:flit_app/src/services/database.dart';

import 'package:flit_app/src/models/hour.dart';
import 'package:flit_app/src/models/pickup.dart';

class UserTable extends StatelessWidget {
  final DateTime date;
  final List<Hour> hours;
  const UserTable({Key? key, required this.date, required this.hours}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    DatabaseService db = DatabaseService();
    return Flexible(
      child: Column(
        children: [
          const ListTile(
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Fecha'),
                Text('Hora'),
                Text('Camioneta'),
              ],
            ),
          ),
          Flexible(
            child: ListView.builder(
                itemCount: hours.length,
                itemBuilder: (context, index) {
                  // Retora la informacion de la camioneta que el usuario tomó
                  return StreamBuilder<Pickup>(
                      stream: db.streamPickupById(hours[index].pickupId ?? ''),
                      builder: (context, snapshot) {
                        String formattedDate =
                            DateFormat('d/MMM/yyyy', 'es').format(date);

                        if (snapshot.hasError) {
                          print("has error");
                        }

                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(child: CircularProgressIndicator());
                        }
                        Pickup pickup = snapshot.data!;
                        return ListTile(
                            title: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(formattedDate),
                            Text("${hours[index].hour.toString()}:00"),
                            Text(pickup.patent ?? ''),
                          ],
                        ));
                      });
                }),
          ),
        ],
      ),
    );
  }
}
