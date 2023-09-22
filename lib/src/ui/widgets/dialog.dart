import 'package:flutter/material.dart';

enum DialogType { INFO, LOADING, CONFIRMATION, ERROR, FORM }

class AppDialog {
  final BuildContext context;
  final DialogType dialogType;
  final Widget? body;
  final Text? title;
  final void Function()? onpressedConfirm;
  final void Function()? onPressedOk;

  AppDialog({
    required this.context,
    this.dialogType = DialogType.INFO,
    this.body,
    this.title,
    this.onpressedConfirm,
    this.onPressedOk,
  });

  Future<void> show() async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        switch (dialogType) {
          case DialogType.INFO:
            return AlertDialog(
              title: title,
              content: SingleChildScrollView(
                child: ListBody(
                  children: <Widget>[
                    Text('No hay conexión a internet'),
                  ],
                ),
              ),
              actions: <Widget>[
                TextButton(
                  child: Text('OK'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          case DialogType.CONFIRMATION:
            return AlertDialog(
              title: title,
              content: SingleChildScrollView(child: body),
              actions: <Widget>[
                TextButton(
                  child: Text('Cancelar'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                TextButton(
                  child: Text('Confirmar'),
                  onPressed: onpressedConfirm,
                ),
              ],
            );
          case DialogType.LOADING:
            return Dialog(
              child: Container(
                height: MediaQuery.of(context).size.height / 8,
                color: Colors.grey[400],
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width / 20,
                    ),
                    CircularProgressIndicator(),
                    SizedBox(
                      width: MediaQuery.of(context).size.width / 20,
                    ),
                    Text(
                      'Cargando...',
                      style: TextStyle(
                        fontSize: 18 * MediaQuery.of(context).textScaleFactor,
                      ),
                    ),
                  ],
                ),
              ),
            );
          case DialogType.FORM:
            return AlertDialog(
              title: title,
              content: SingleChildScrollView(child: body),
              actions: <Widget>[
                TextButton(child: Text('OK'), onPressed: onPressedOk),
              ],
            );
          default:
            return Text('');
        }
      },
    );
  }

  void close() => Navigator.of(context).pop();
}
