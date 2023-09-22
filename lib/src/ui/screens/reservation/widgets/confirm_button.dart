import 'package:fleeve/src/utils/helpers.dart';
import 'package:flutter/material.dart';
import 'package:fleeve/src/models/pickup.dart';
import 'package:fleeve/src/providers/auth_provider.dart';
import 'package:fleeve/src/services/database.dart';
import 'package:fleeve/src/ui/widgets/dialog.dart';
import 'package:provider/provider.dart';

class ConfirmButton extends StatelessWidget {
  final List<int> selectedHours;
  final Pickup pickup;

  const ConfirmButton({Key? key, required this.selectedHours, required this.pickup})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final db = DatabaseService();
    final currentUser = Provider.of<AuthProvider>(context).user;

    return SizedBox(
      width: 150,
      child: ElevatedButton(
        onPressed: () {
          if (selectedHours.isEmpty) {
            showSnackBar(
              context: context,
              message: 'Seleccionar una hora',
              icon: Icon(Icons.info),
            );
          } else {
            AppDialog(
              context: context,
              dialogType: DialogType.CONFIRMATION,
              title: Text('Confirmar hora'),
              body: ListBody(
                children: [
                  Text(
                    '¿Está seguro de confirmar la hora ${selectedHours.map((hour) => '$hour:00').join(", ")} para la camioneta ${pickup.patent} el ${DateTime.now().day} de ${getMonthName(DateTime.now())}',
                  ),
                ],
              ),
              onpressedConfirm: () {
                // db.addHoursToDate(selectedHours, currentUser, pickup);
                AppDialog(
                  context: context,
                  dialogType: DialogType.LOADING,
                )..close();
                showSnackBar(
                  context: context,
                  message: 'Hora confirmada correctamente',
                  duration: Duration(seconds: 2),
                  icon: Icon(Icons.check),
                );
              },
            )..show();
          }
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Icon(Icons.check_box),
            Text(
              'Confirmar',
              style: TextStyle(fontSize: 15),
            ),
          ],
        ),
      ),
    );
  }
}
