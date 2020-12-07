import 'package:fleeve/src/ui/screens/details/pickup_details_screen.dart';
import 'package:fleeve/src/ui/screens/details/user_details_screen.dart';
import 'package:fleeve/src/ui/screens/reservation/reservation_screen.dart';
import 'package:fleeve/src/ui/screens/reservation/widgets/hour_reservation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:fleeve/src/ui/constants.dart';
import 'package:fleeve/src/providers/auth_provider.dart';

class Body extends StatelessWidget {
  const Body({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var currentUser = Provider.of<AuthProvider>(context).user;

    return Column(
      children: [
        Image(
          width: 200,
          image: AssetImage('assets/img/logo.png'),
        ),
        Text(currentUser.name,
            style: TextStyle(
                fontSize: Theme.of(context).textTheme.headline1.fontSize,
                fontWeight: Theme.of(context).textTheme.headline1.fontWeight)),
        Container(
            padding: EdgeInsets.all(20),
            child: GridView.count(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              primary: false,
              padding: const EdgeInsets.all(8),
              crossAxisSpacing: 10,
              mainAxisSpacing: 15,
              crossAxisCount: 2,
              children: <Widget>[
                _buildGrid(
                    title: 'Elegir una hora',
                    icon: Icons.schedule,
                    onTap: () => Navigator.of(context).push(MaterialPageRoute(
                        builder: (BuildContext context) =>
                            ReservationScreen()))),
                _buildGrid(
                    title: 'Detalle de camionetas',
                    icon: Icons.drive_eta,
                    onTap: () => Navigator.of(context).push(MaterialPageRoute(
                        builder: (BuildContext context) =>
                            PickupDetailsScreen()))),
                _buildGrid(
                  title: 'Detalle de choreres',
                  icon: Icons.people,
                  onTap: () => Navigator.of(context).push(MaterialPageRoute(
                      builder: (BuildContext context) => UserDetailsScreen())),
                ),
                _buildGrid(
                    title: 'Uso diario',
                    icon: Icons.bar_chart,
                    onTap: () => print("ontap")),
              ],
            )),
      ],
    );
  }

  Widget _buildGrid(
      {@required String title,
      @required IconData icon,
      @required Function onTap}) {
    return GestureDetector(
      child: Container(
        padding: EdgeInsets.all(8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 65, color: Colors.white),
            Center(
              child: Text(
                title,
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w400),
              ),
            ),
          ],
        ),
        color: primaryColor,
      ),
      onTap: onTap,
    );
  }
}
