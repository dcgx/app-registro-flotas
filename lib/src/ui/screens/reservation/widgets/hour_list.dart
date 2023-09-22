import 'package:fleeve/src/ui/constants.dart';
import 'package:flutter/material.dart';
import 'package:fleeve/src/models/pickup.dart';
import 'package:fleeve/src/providers/auth_provider.dart';
import 'package:fleeve/src/services/database.dart';
import 'package:fleeve/src/ui/widgets/dialog.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../utils/helpers.dart';

class HourList extends StatefulWidget {
  final List<int> selectedHours;
  final List<dynamic> totalHoursByDate;
  final Pickup pickup;
  HourList({
    Key? key,
    required this.selectedHours,
    required this.totalHoursByDate,
    required this.pickup,
  }) : super(key: key);

  @override
  _HourListState createState() => _HourListState();
}

class _HourListState extends State<HourList> {
  @override
  Widget build(BuildContext context) {
    final db = DatabaseService();
    final currentUser = Provider.of<AuthProvider>(context).user;

    return Flexible(
      child: ListView.builder(
        itemCount: widget.totalHoursByDate.length,
        itemExtent: MediaQuery.of(context).size.height / 16,
        itemBuilder: (context, index) {
          int hour = index + 8;

          var hourByDate = widget.totalHoursByDate[index];

          bool enabled = true;
          Color? backgroundColor;

          if (hourByDate.userId != null) {
            if (hourByDate.userId == currentUser?.id) {
              enabled = false;
              backgroundColor = secondaryColor;
            } else {
              enabled = false;
              backgroundColor = Colors.red;
            }
          }
          return Container(
            child: ListTile(
              enabled: enabled,
              trailing: currentUser?.id == hourByDate.userId
                  ? IconButton(
                      color: Colors.red,
                      iconSize: MediaQuery.of(context).size.width / 15,
                      icon: Icon(Icons.cancel),
                      onPressed: () => AppDialog(
                            context: context,
                            dialogType: DialogType.CONFIRMATION,
                            title: Text('Eliminar hora'),
                            body: ListBody(
                              children: [
                                Text(
                                  '¿Está seguro de eliminar la hora ${hourByDate.hour} para la camioneta ${widget.pickup.patent} el ${DateTime.now().day} de ${getMonthName(DateTime.now())}',
                                )
                              ],
                            ),
                            onpressedConfirm: () {
                              db
                                  .deleteHour(
                                      int.parse(hourByDate.hour.toString()))
                                  .then((_) {
                                Navigator.pop(context);
                                showSnackBar(
                                  context: context,
                                  message: 'Hora eliminada correctamente',
                                  icon: Icon(Icons.delete),
                                );
                              });
                            },
                          )..show())
                  : hourByDate.userId != null
                      ? IconButton(
                          icon: Icon(
                            Icons.phone,
                            color: primaryColor,
                          ),
                          iconSize: MediaQuery.of(context).size.width / 15,
                          onPressed: () => launch("tel://${hourByDate.userPhone}"),
                        )
                      : Text(''),
              leading: Padding(
                padding: const EdgeInsets.only(bottom: 0),
                child: ChoiceChip(
                  backgroundColor: backgroundColor,
                  elevation: 5,
                  label: Text('$hour:00'),
                  labelStyle: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                  ),
                  selected: widget.selectedHours.contains(hour),
                  selectedColor: Colors.green,
                  onSelected: (bool selected) {
                    if (enabled) {
                      setState(() {
                        widget.selectedHours.contains(hour)
                            ? widget.selectedHours.remove(hour)
                            : widget.selectedHours.add(hour);
                      });
                    }
                  },
                ),
              ),
              onTap: () {
                setState(() {
                  widget.selectedHours.contains(hour)
                      ? widget.selectedHours.remove(hour)
                      : widget.selectedHours.add(hour);
                });
              },
              title: Container(
                child: FittedBox(
                  fit: BoxFit.none,
                  alignment: Alignment.centerLeft,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        child: enabled
                            ? Text(
                                'Disponible',
                                style: TextStyle(
                                  fontSize: MediaQuery.of(context).size.width / 21,
                                ),
                              )
                            : Text(
                                hourByDate.userName,
                                style: TextStyle(
                                  fontSize: MediaQuery.of(context).size.width / 21,
                                ),
                              ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
