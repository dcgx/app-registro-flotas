import 'package:fleeve/src/ui/constants.dart';
import 'package:fleeve/src/models/hour.dart';
import 'package:fleeve/src/models/user.dart';
import 'package:fleeve/src/services/database.dart';
import 'package:fleeve/src/ui/screens/details/widgets/user_table.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class UserHistory extends StatefulWidget {
  final User user;

  const UserHistory({Key? key, required this.user}) : super(key: key);

  @override
  _UserHistoryState createState() => _UserHistoryState();
}

class _UserHistoryState extends State<UserHistory> {
  double? _height;
  double? _width;

  String? _setDate;

  String? dateTime;

  DateTime selectedDate = DateTime.now();

  TextEditingController _dateController = TextEditingController();

  Future<Null> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      locale: Locale('es', ''),
      initialDatePickerMode: DatePickerMode.day,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );
    if (picked != selectedDate) {
      setState(() {
        selectedDate = picked!;
        _dateController.text =
            DateFormat('d/MMM/yyyy', 'es').format(selectedDate);
      });
    }
  }

  @override
  void initState() {
    _dateController.text = "Ingrese una fecha";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    DatabaseService db = DatabaseService();
    _height = MediaQuery.of(context).size.height;
    _width = MediaQuery.of(context).size.width;
    dateTime = DateFormat.yMd().format(DateTime.now());
    User user = this.widget.user;

    String userName = user.name ?? "Usuario Desconocido"; // Safely access user.name

    return Scaffold(
      appBar: AppBar(),
      body: Container(
        child: Column(
          children: [
            Text('Registro de horas'),
            Text("Usuario: $userName"), // Use userName
            InkWell(
              onTap: () {
                setState(() {
                  _selectDate(context);
                });
              },
              child: Container(
                width: _width! / 2,
                height: _height! / 14,
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
                      disabledBorder:
                          UnderlineInputBorder(borderSide: BorderSide.none),
                      contentPadding: EdgeInsets.only(top: 0.0)),
                ),
              ),
            ),
            StreamBuilder<List<Hour>>(
                stream: db.streamUserHours(selectedDate, user.id),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    print("has error");
                  }

                  if (snapshot.connectionState == ConnectionState.waiting ||
                      snapshot.data == null) {
                    return Center(child: CircularProgressIndicator());
                  }

                  if (!snapshot.hasData) {
                    return Center(
                      child: Text('No existen registros con esta fecha'),
                    );
                  }
                  var hours = snapshot.data;
                  return UserTable(hours: hours!, date: selectedDate);
                })
          ],
        ),
      ),
    );
  }
}
