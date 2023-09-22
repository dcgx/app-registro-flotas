import 'package:flit_app/src/ui/screens/details/pickup_details_screen.dart';
import 'package:flit_app/src/ui/screens/details/user_details_screen.dart';
import 'package:flit_app/src/ui/screens/reservation/reservation_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:flit_app/src/ui/constants.dart';
import 'package:flit_app/src/providers/auth_provider.dart';

class Body extends StatelessWidget {
  const Body({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var currentUser = Provider.of<AuthProvider>(context).user;

    return Column(
      children: [
        const Image(
          width: 200,
          image: AssetImage('assets/img/logo.png'),
        ),
        Text('Bienvenido ${currentUser?.name}',
            style: TextStyle(
                fontSize: Theme.of(context).textTheme.displayLarge!.fontSize,
                fontWeight: Theme.of(context).textTheme.displayLarge!.fontWeight)),
        Container(
            padding: const EdgeInsets.all(20),
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
                            const ReservationScreen()))),
                _buildGrid(
                    title: 'Detalle de camionetas',
                    icon: Icons.drive_eta,
                    onTap: () => Navigator.of(context).push(MaterialPageRoute(
                        builder: (BuildContext context) =>
                            const PickupDetailsScreen()))),
                _buildGrid(
                  title: 'Detalle de choreres',
                  icon: Icons.people,
                  onTap: () => Navigator.of(context).push(MaterialPageRoute(
                      builder: (BuildContext context) => const UserDetailsScreen())),
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
      {@required String? title,
      @required IconData? icon,
      @required Function? onTap}) {
    return GestureDetector(
      onTap: onTap as void Function()?,
      child: Container(
        padding: const EdgeInsets.all(8),
        color: primaryColor,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 65, color: Colors.white),
            Center(
              child: Text(
                title ?? '',
                textAlign: TextAlign.center,
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w400),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
