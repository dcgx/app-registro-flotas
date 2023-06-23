import 'package:flutter/material.dart';
import 'package:fleeve/src/models/pickup.dart';

class PickupCard extends StatelessWidget {
  final Pickup pickup;
  final Function onTap;

  const PickupCard(
      {required Key? key, required this.pickup, required this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color patentCardColor = Colors.white;
    if (pickup.status == "NO DISPONIBLE") {
      patentCardColor = Colors.red;
    } else if (pickup.status == "SEMIDISPONIBLE") {
      patentCardColor = Colors.yellow;
    } else if (pickup.status == "DISPONIBLE") {
      patentCardColor = Colors.green;
    }

    return Card(
      color: patentCardColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      child: InkWell(
        splashColor: Colors.blue.withAlpha(30),
        onTap: () {
          onTap();
        },
        child: ListTile(
          title: FittedBox(
            fit: BoxFit.scaleDown,
            child: Center(
              child: Text(this.pickup.patent,
                      style: TextStyle(
                          fontSize: MediaQuery.of(context).size.width / 12,
                          fontWeight: FontWeight.bold,
                          color: Colors.black54)) ??
                  null,
            ),
          ),
          subtitle: FittedBox(
            fit: BoxFit.scaleDown,
            child: Center(
              child: Text(this.pickup.category,
                      style: TextStyle(
                          fontSize: MediaQuery.of(context).size.width / 18)) ??
                  null,
            ),
          ),
        ),
      ),
    );
  }
}

// return Card(
//     color: patentCardColor,
//     shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(10.0)),
//     child: InkWell(
//       splashColor: Colors.blue.withAlpha(30),
//       child: ListTile(
//         title: Center(
//             child: Text(
//           pickup.patent,
//           style: TextStyle(
//             fontSize: 30,
//             fontWeight: FontWeight.w500,
//             color: Colors.white,
//           ),
//         )),
//         subtitle: Center(
//             child: Text(
//           pickup.category,
//           style: TextStyle(
//             fontSize: 22,
//             color: Colors.white,
//           ),
//         )),
//       ),
//     ));
