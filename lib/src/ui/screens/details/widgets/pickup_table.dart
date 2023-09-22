import 'package:flit_app/src/models/user.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:flit_app/src/services/database.dart';
import 'package:flit_app/src/models/hour.dart';

class PickupTable extends StatelessWidget {
  final DateTime date;
  final List<Hour> hours;
  const PickupTable({Key? key, required this.date, required this.hours}) : super(key: key);

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
                Text('Usuario'),
              ],
            ),
          ),
          Flexible(
            child: ListView.builder(
                itemCount: hours.length,
                itemBuilder: (context, index) {
                  // Retora la informacion del usuario que tomó la hora
                  return StreamBuilder<User>(
                      stream: db.streamUserById(hours[index].userId ?? ''),
                      builder: (context, snapshot) {
                        if (snapshot.hasError) {
                          print("has error");
                        }

                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(child: CircularProgressIndicator());
                        }
                        User user = snapshot.data!;
                        String formattedDate;
                        // Verifica si se ingresó la fecha en el calendario
                        if (date != null) {
                          formattedDate =
                              DateFormat('d/MMM/yyyy', 'es').format(date);
                        } else {
                          formattedDate = DateFormat('d/MMM/yyyy', 'es')
                              .format(hours[index].date ?? DateTime.now());
                        }

                        return ListTile(
                            title: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(formattedDate),
                            Text("${hours[index].hour.toString()}:00"),
                            Text(user.name ?? ''),
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
