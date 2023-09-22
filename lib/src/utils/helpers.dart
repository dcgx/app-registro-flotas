import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';

void showSnackBar({
  required BuildContext context,
  required String message,
  required Icon icon,
  Duration? duration,
}) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    content: Row(
      children: <Widget>[
        icon,
        Text(
          message,
          style: TextStyle(fontSize: 20),
        )
      ],
    ),
    duration: duration ?? Duration(seconds: 1),
  ));
}

Future<bool> checkConnectivity() async {
  var connectivityResult = await Connectivity().checkConnectivity();
  if (connectivityResult == ConnectivityResult.mobile) {
    return true;
  } else if (connectivityResult == ConnectivityResult.wifi) {
    return true;
  }
  return false;
}

String getMonthName(DateTime date) {
  String? month;

  switch (date.month) {
    case 1:
      month = "Enero";
      break;
    case 2:
      month = "Febrero";
      break;
    case 3:
      month = "Marzo";
      break;
    case 4:
      month = "Abril";
      break;
    case 5:
      month = "Mayo";
      break;
    case 6:
      month = "Junio";
      break;
    case 7:
      month = "Julio";
      break;
    case 8:
      month = "Agosto";
      break;
    case 9:
      month = "Septiembre";
      break;
    case 10:
      month = "Octubre";
      break;
    case 11:
      month = "Noviembre";
      break;
    case 12:
      month = "Diciembre";
      break;
  }

  return month?.toLowerCase() ?? "";
}
