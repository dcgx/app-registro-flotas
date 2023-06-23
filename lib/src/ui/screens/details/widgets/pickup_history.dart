import 'package:fleeve/src/models/hour.dart';
import 'package:fleeve/src/models/pickup.dart';
import 'package:fleeve/src/ui/screens/details/widgets/pickup_table.dart';
import 'package:fleeve/src/ui/widgets/dialog.dart';
import 'package:fleeve/src/utils/helpers.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:fleeve/src/ui/constants.dart';
import 'package:fleeve/src/services/database.dart';

class PickupHistory extends StatefulWidget {
  final Pickup pickup;
  const PickupHistory({Key? key, required this.pickup}) : super(key: key);

  @override
  _PickupHistoryState createState() => _PickupHistoryState();
}

class _PickupHistoryState extends State<PickupHistory> {
  late double _height;
  late double _width;

  late String _setDate;

  late String dateTime;

  DateTime selectedDate = DateTime.now();

  TextEditingController _dateController = TextEditingController();
  TextEditingController _patentController = TextEditingController();
  TextEditingController _categoryController = TextEditingController();

  Future<Null> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      locale: Locale('es', ''),
      initialDatePickerMode: DatePickerMode.day,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );
    if (picked != null)
      setState(() {
        selectedDate = picked;
        _dateController.text =
            DateFormat('d/MMM/yyyy', 'es').format(selectedDate);
      });
  }

  @override
  void initState() {
    _dateController.text = "Ingrese una fecha";
    _patentController.text = widget.pickup.patent;
    _categoryController.text = widget.pickup.category;
  }

  @override
  Widget build(BuildContext context) {
    DatabaseService db = DatabaseService();
    _height = MediaQuery.of(context).size.height;
    _width = MediaQuery.of(context).size.width;
    dateTime = DateFormat.yMd().format(DateTime.now());
    Pickup pickup = this.widget.pickup;
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        child: Column(
          children: [
            Text('Registro de horas'),
            Row(
              children: [
                Text("Patente: ${pickup.patent}"),
                Text("${pickup.category}"),
              ],
            ),
            Row(
              children: [
                Container(
                    width: _width / 2,
                    height: _height / 14,
                    margin: EdgeInsets.only(top: 15),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        color: primaryColor,
                        borderRadius: BorderRadius.circular(50)),
                    child: TextButton(
                      child: Text('Mostrar todo',
                          style: TextStyle(fontSize: 20, color: Colors.white)),
                      onPressed: () {
                        setState(() {
                          selectedDate = DateTime.now();
                          _dateController.text = "Ingrese una fecha";
                        });
                      },
                    )),
                InkWell(
                  onTap: () {
                    setState(() {
                      selectedDate = DateTime.now();
                      _selectDate(context);
                    });
                  },
                  child: Row(
                    children: [
                      Container(
                        width: _width / 2,
                        height: _height / 14,
                        margin: EdgeInsets.only(top: 15),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            color: primaryColor,
                            borderRadius: BorderRadius.circular(50)),
                        child: TextFormField(
                          style: TextStyle(fontSize: 20, color: Colors.white),
                          textAlign: TextAlign.center,
                          enabled: false,
                          keyboardType: TextInputType.text,
                          controller: _dateController,
                          onSaved: (String? val) {
                            _setDate = val!;
                          },
                          decoration: InputDecoration(
                              disabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide.none),
                              contentPadding: EdgeInsets.only(top: 0.0)),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            StreamBuilder<List<Hour>>(
                stream: db.streamPickupHours(selectedDate, pickup.id),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    print("has error");
                  }

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }

                  if (!snapshot.hasData) {
                    return Center(
                      child: Text('No existen registros con esta fecha'),
                    );
                  }
                  var hours = snapshot.data;

                  return PickupTable(
                    hours: hours as List<Hour>,
                    date: selectedDate,
                    key: new GlobalKey(),
                  );
                })
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.edit),
        onPressed: () {
          final _formKey = GlobalKey<FormState>();

          AppDialog(
              onpressedConfirm: () => {},
              context: context,
              dialogType: DialogType.FORM,
              title: Text('Editar datos'),
              body: Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      textCapitalization: TextCapitalization.sentences,
                      controller: _patentController,
                      decoration: const InputDecoration(
                          icon: Icon(Icons.drive_eta),
                          labelText: 'Patente *',
                          hintText: 'XXXX-00'),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Rellenar todos los campos';
                        }
                        if (value.length < 7 || value.length > 7) {
                          return 'Formato incorrecto (Ej. BBDB-10)';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: _categoryController,
                      decoration: const InputDecoration(
                          icon: Icon(Icons.layers),
                          labelText: 'Categoria *',
                          hintText: 'Rojo Mina, Amarillo Operacional'),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Rellenar todos los campos';
                        }
                        return null;
                      },
                    ),
                  ],
                ),
              ),
              onPressedOk: () {
                {
                  // Validate returns true if the form is valid, otherwise false.
                  // if (_formKey.currentState.validate()) {
                  //   Pickup pickup = Pickup(
                  //       status: '',
                  //       userId: '',
                  //       id: widget.pickup.id,
                  //       patent: _patentController.text.toUpperCase(),
                  //       category: _categoryController.text.toUpperCase());
                  //   db.updatePickup(pickup).then((_) {
                  //     Navigator.pop(context);
                  //     showSnackBar(
                  //         context: context,
                  //         message: 'Datos actualizados correctamente',
                  //         duration: Duration(seconds: 2),
                  //         icon: Icon(Icons.check));
                  //   });
                  // }
                }
              })
            ..show();
        },
      ),
    );
  }
}
