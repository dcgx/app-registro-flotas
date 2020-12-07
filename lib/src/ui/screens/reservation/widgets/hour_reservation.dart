import 'package:fleeve/src/ui/screens/reservation/widgets/confirm_button.dart';
import 'package:fleeve/src/ui/screens/reservation/widgets/hour_list.dart';
import 'package:flutter/material.dart';

import 'package:fleeve/src/models/pickup.dart';

import 'package:intl/intl.dart';

import 'package:fleeve/src/models/hour.dart';

import 'package:fleeve/src/ui/constants.dart';
import 'package:fleeve/src/services/database.dart';
import 'package:fleeve/src/ui/widgets/pickup_card.dart';

class HourReservation extends StatelessWidget {
  final Pickup pickup;
  const HourReservation({Key key, this.pickup}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<int> selectedHours = List<int>();

    return Scaffold(
      appBar: AppBar(
        title: Text('Elegir una hora'),
      ),
      body: Body(
        selectedHours: selectedHours,
        pickup: pickup,
      ),
      bottomNavigationBar: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          SizedBox(
              width: 150,
              child: RaisedButton(
                  onPressed: () => Navigator.pop(context),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Icon(Icons.arrow_back),
                      Text(
                        'Volver',
                        style: TextStyle(fontSize: 15),
                      ),
                    ],
                  ))),
          ConfirmButton(selectedHours: selectedHours, pickup: pickup),
        ],
      ),
    );
  }
}

class Body extends StatefulWidget {
  final List<int> selectedHours;
  final Pickup pickup;

  Body({Key key, this.selectedHours, this.pickup}) : super(key: key);

  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  DatabaseService db = DatabaseService();

  List<dynamic> hours = [];
  List<dynamic> totalHoursByDate = [];
  @override
  Widget build(BuildContext context) {
    Hour hour = Hour();
    String currentTime = DateFormat('HH:mm').format(DateTime.now());
    String currentDate = DateFormat('dd-MM-yyyy').format(DateTime.now());

    for (int i = 0; i < 11; i++) {
      hour.hour = i + 8;
      totalHoursByDate.add(hour);
    }
    return StreamBuilder<List<Hour>>(
        stream: db.streamHours(this.widget.pickup),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            print("has error");
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          hours = snapshot.data;

          if (hours.isNotEmpty &&
              hours.length < 11 &&
              widget.pickup.status != "SEMIDISPONIBLE") {
            db.changeStatusPickup('SEMIDISPONIBLE', widget.pickup.id);
          }

          if (hours.length == 11 && widget.pickup.status != "NO DISPONIBLE") {
            db.changeStatusPickup('NO DISPONIBLE', widget.pickup.id);
          }

          if (hours.isEmpty && widget.pickup.status != "DISPONIBLE") {
            db.changeStatusPickup('DISPONIBLE', widget.pickup.id);
          }

          hours.forEach((hour) {
            totalHoursByDate[hour.hour - 8] = hour;
          });

          return Container(
              child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  SizedBox(
                    width: 190,
                    height: 75,
                    child: PickupCard(
                      pickup: this.widget.pickup,
                    ),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildHeaderTitle(
                          title: '$currentTime h.',
                          icon: Icon(Icons.watch_later_outlined)),
                      _buildHeaderTitle(title: currentDate)
                    ],
                  ),
                ],
              ),
              HourList(
                selectedHours: this.widget.selectedHours,
                totalHoursByDate: totalHoursByDate,
                pickup: widget.pickup,
              ),
            ],
          ));
        });
  }

  Widget _buildHeaderTitle({String title, Icon icon}) {
    return Row(
      children: [
        icon ?? Text(''),
        Text(
          title,
          style: TextStyle(
              color: primaryColor, fontSize: 22, fontWeight: FontWeight.w500),
        ),
      ],
    );
  }
}
