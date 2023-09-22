import 'package:flutter/material.dart';
import 'package:fleeve/src/models/pickup.dart';

class PickupCard extends StatelessWidget {
  final Pickup pickup;
  final Function? onTap;

  const PickupCard({Key? key, required this.pickup, this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color? patentCardColor;
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
        onTap: onTap != null ? () => onTap!() : null,
        child: ListTile(
          title: FittedBox(
            fit: BoxFit.scaleDown,
            child: Center(
              child: Text(
                this.pickup.patent,
                style: TextStyle(
                  fontSize: MediaQuery.of(context).size.width / 12,
                  fontWeight: FontWeight.bold,
                  color: Colors.black54,
                ),
              ),
            ),
          ),
          subtitle: FittedBox(
            fit: BoxFit.scaleDown,
            child: Center(
              child: Text(
                this.pickup.category,
                style: TextStyle(
                  fontSize: MediaQuery.of(context).size.width / 18,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
