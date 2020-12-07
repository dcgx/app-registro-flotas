import 'package:fleeve/src/ui/constants.dart';
import 'package:flutter/material.dart';

enum DialogType { INFO, LOADING, CONFIRMATION, ERROR, FORM }

class AppDialog {
  final BuildContext context;
  final DialogType dialogType;
  final Widget body;
  final Text title;
  final void Function() onpressedConfirm;
  final void Function() onPressedOk;

  AppDialog(
      {@required this.context,
      this.dialogType = DialogType.INFO,
      this.body,
      this.title,
      this.onpressedConfirm,
      this.onPressedOk});

  Future show() => showDialog(
      context: this.context,
      builder: (BuildContext context) {
        switch (dialogType) {
          case DialogType.INFO:
            return AlertDialog(
              title: title ?? null,
              content: SingleChildScrollView(
                child: ListBody(
                  children: <Widget>[
                    Text('No hay conexión a internet'),
                  ],
                ),
              ),
              actions: <Widget>[
                FlatButton(
                  child: Text('OK'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                )
              ],
            );
            break;
          case DialogType.CONFIRMATION:
            return AlertDialog(
              title: title ?? null,
              content: SingleChildScrollView(child: body != null ? body : null),
              actions: <Widget>[
                RaisedButton(
                  color: secondaryColor,
                  child: Text('Cancelar'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                RaisedButton(
                  child: Text('Confirmar'),
                  onPressed: onpressedConfirm,
                )
              ],
            );
            break;
          case DialogType.LOADING:
            return Dialog(
              child: Container(
                height: MediaQuery.of(context).size.height / 8,
                color: Colors.grey[400],
                child: Row(mainAxisSize: MainAxisSize.min, children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width / 20,
                  ),
                  CircularProgressIndicator(),
                  SizedBox(
                    width: MediaQuery.of(context).size.width / 20,
                  ),
                  Text('Cargando...',
                      style: TextStyle(
                          fontSize:
                              18 * MediaQuery.of(context).textScaleFactor)),
                ]),
              ),
            );
            break;
          case DialogType.FORM:
            return AlertDialog(
              title: title ?? null,
              content: SingleChildScrollView(child: body ?? null),
              actions: <Widget>[
                FlatButton(child: Text('OK'), onPressed: onPressedOk)
              ],
            );
            break;
          default:
            return Text('');
        }
      });

  void close() => Navigator.of(context).pop();
}
