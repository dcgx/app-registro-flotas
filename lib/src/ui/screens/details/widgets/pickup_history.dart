import 'package:flit_app/src/models/hour.dart';
import 'package:flit_app/src/models/pickup.dart';
import 'package:flit_app/src/ui/screens/details/widgets/pickup_table.dart';
import 'package:flit_app/src/ui/widgets/dialog.dart';
import 'package:flit_app/src/utils/helpers.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:flit_app/src/ui/constants.dart';
import 'package:flit_app/src/services/database.dart';

class PickupHistory extends StatefulWidget {
  final Pickup pickup;
  const PickupHistory({Key? key, required this.pickup}) : super(key: key);

  @override
  _PickupHistoryState createState() => _PickupHistoryState();
}

class _PickupHistoryState extends State<PickupHistory> {
  double? _height;
  double? _width;

  String _setDate = 'Ingrese una fecha';
  String dateTime = DateFormat.yMd().format(DateTime.now());
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _patentController = TextEditingController();
  final TextEditingController _categoryController = TextEditingController();

  DateTime? selectedDate;

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      locale: const Locale('es', ''),
      initialDatePickerMode: DatePickerMode.day,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        selectedDate = picked;
        _dateController.text = DateFormat('d/MMM/yyyy', 'es').format(selectedDate!);
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _patentController.text = widget.pickup.patent ?? '';
    _categoryController.text = widget.pickup.category ?? '';
  }

  @override
  Widget build(BuildContext context) {
    final db = DatabaseService();
    _height = MediaQuery.of(context).size.height;
    _width = MediaQuery.of(context).size.width;

    final pickup = widget.pickup;

    return Scaffold(
      appBar: AppBar(),
      body: Container(
        child: Column(
          children: [
            const Text('Registro de horas'),
            Row(
              children: [
                Text('Patente: ${pickup.patent}'),
                Text(pickup.category ?? ''),
              ],
            ),
            Row(
              children: [
                Container(
                  width: _width! / 2,
                  height: _height! / 14,
                  margin: const EdgeInsets.only(top: 15),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: primaryColor,
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: TextButton(
                    onPressed: () {
                      setState(() {
                        selectedDate = null;
                        _dateController.text = 'Ingrese una fecha';
                      });
                    },
                    child: const Text(
                      'Mostrar todo',
                      style: TextStyle(fontSize: 20, color: Colors.white),
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    _selectDate(context);
                  },
                  child: Container(
                    width: _width! / 2,
                    height: _height! / 14,
                    margin: const EdgeInsets.only(top: 15),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: primaryColor,
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: TextFormField(
                      style: const TextStyle(fontSize: 20, color: Colors.white),
                      textAlign: TextAlign.center,
                      enabled: false,
                      keyboardType: TextInputType.text,
                      controller: _dateController,
                      onSaved: (String? val) {
                        _setDate = val!;
                      },
                      decoration: const InputDecoration(
                        disabledBorder: InputBorder.none,
                        contentPadding: EdgeInsets.only(top: 0.0),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            StreamBuilder<List<Hour>>(
              stream: db.streamPickupHours(selectedDate!, pickup.id ?? ''),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  print('has error');
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (!snapshot.hasData) {
                  return const Center(
                    child: Text('No existen registros con esta fecha'),
                  );
                }
                final hours = snapshot.data!;

                return PickupTable(hours: hours, date: selectedDate!);
              },
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.edit),
        onPressed: () {
          final formKey = GlobalKey<FormState>();

          AppDialog(
            context: context,
            dialogType: DialogType.FORM,
            title: const Text('Editar datos'),
            body: Form(
              key: formKey,
              child: Column(
                children: [
                  TextFormField(
                    textCapitalization: TextCapitalization.sentences,
                    controller: _patentController,
                    decoration: const InputDecoration(
                      icon: Icon(Icons.drive_eta),
                      labelText: 'Patente *',
                      hintText: 'XXXX-00',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Rellenar todos los campos';
                      }
                      if (value.length != 7) {
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
                      hintText: 'Rojo Mina, Amarillo Operacional',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Rellenar todos los campos';
                      }
                      return null;
                    },
                  ),
                ],
              ),
            ),
            onPressedOk: () {
              if (formKey.currentState!.validate()) {
                final pickup = Pickup(
                  id: widget.pickup.id,
                  patent: _patentController.text.toUpperCase(),
                  category: _categoryController.text.toUpperCase(),
                );
                db.updatePickup(pickup).then((_) {
                  Navigator.pop(context);
                  showSnackBar(
                    context: context,
                    message: 'Datos actualizados correctamente',
                    icon: const Icon(Icons.check),
                  );
                });
              }
            },
          ).show();
        },
      ),
    );
  }
}
