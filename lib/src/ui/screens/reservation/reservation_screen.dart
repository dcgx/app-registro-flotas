import 'package:fleeve/src/ui/screens/reservation/widgets/hour_reservation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:fleeve/src/models/pickup.dart';

import 'package:fleeve/src/services/database.dart';
import 'package:fleeve/src/providers/auth_provider.dart';
import 'package:fleeve/src/ui/widgets/pickup_card.dart';

class ReservationScreen extends StatelessWidget {
  const ReservationScreen({required Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      bottomNavigationBar: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          SizedBox(
              width: 150,
              child: ElevatedButton(
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
          SizedBox(
              width: 150,
              child: ElevatedButton(
                  onPressed: () {
                    Provider.of<AuthProvider>(context).logout();
                    Navigator.of(context).popAndPushNamed('/');
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Icon(Icons.exit_to_app),
                      Text(
                        'Salir',
                        style: TextStyle(fontSize: 15),
                      ),
                    ],
                  ))),
        ],
      ),
      body: Body(key: key),
    );
  }
}

class Body extends StatelessWidget {
  const Body({required Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    DatabaseService db = DatabaseService();
    var currentUser = Provider.of<AuthProvider>(context).user;
    return Container(
      child: Column(
        children: [
          Image(
            width: 200,
            image: AssetImage('assets/img/logo.png'),
          ),
          SizedBox(
            height: 10,
          ),
          Text(currentUser.name,
              style: TextStyle(
                  fontSize: Theme.of(context).textTheme.displayLarge?.fontSize,
                  fontWeight:
                      Theme.of(context).textTheme.displayLarge?.fontWeight)),
          Text('ELIJA UNA CAMIONETA',
              style: TextStyle(
                  fontSize: Theme.of(context).textTheme.headline2?.fontSize,
                  fontWeight:
                      Theme.of(context).textTheme.headline2?.fontWeight)),
          Container(
              child: StreamBuilder<List<Pickup>>(
                  stream: db.streamPickups(),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      print("has error");
                    }
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    return Flexible(
                      child: ListView(
                          children: snapshot.data!.map((Pickup pickup) {
                        return Container(
                          padding: EdgeInsets.only(
                              right: MediaQuery.of(context).size.width / 30,
                              left: MediaQuery.of(context).size.width / 39,
                              top: 8,
                              bottom: 8),
                          child: PickupCard(
                              key: Key(pickup.patent),
                              pickup: pickup,
                              onTap: () => Navigator.of(context).push(
                                  MaterialPageRoute(
                                      builder: (BuildContext context) =>
                                          HourReservation(
                                            pickup: pickup,
                                            key: new Key(pickup.patent),
                                          )))),
                        );
                      }).toList()),
                    );
                  })),
        ],
      ),
    );
  }
}
