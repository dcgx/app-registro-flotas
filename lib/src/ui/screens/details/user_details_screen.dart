import 'package:flit_app/src/models/user.dart';
import 'package:flit_app/src/services/database.dart';
import 'package:flit_app/src/ui/screens/details/widgets/user_history.dart';
import 'package:flit_app/src/ui/widgets/dialog.dart';
import 'package:flit_app/src/ui/widgets/multi_select_chip.dart';
import 'package:flutter/material.dart';

class UserDetailsScreen extends StatefulWidget {
  const UserDetailsScreen({Key? key}) : super(key: key);

  @override
  _UserDetailsScreenState createState() => _UserDetailsScreenState();
}

class _UserDetailsScreenState extends State<UserDetailsScreen> {
  List<String> roleList = [
    "Chofer",
    "Administrador",
  ];

  List<String> selectedRoleList = [];

  _showReportDialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          //Here we will build the content of the dialog
          return AlertDialog(
            title: const Text("Seleccionar roles"),
            content: MultiSelectChip(
              roleList,
              onSelectionChanged: (selectedList) {
                setState(() {
                  selectedRoleList = selectedList;
                });
              },
            ),
            actions: <Widget>[
              TextButton(
                child: const Text("Aceptar"),
                onPressed: () => Navigator.of(context).pop(),
              )
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController userNameController = TextEditingController();
    TextEditingController userPhoneController = TextEditingController();
    DatabaseService db = DatabaseService();

    return Scaffold(
      appBar: AppBar(),
      body: const Body(),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          final formKey = GlobalKey<FormState>();

          AppDialog(
              context: context,
              dialogType: DialogType.FORM,
              title: const Text('Agregar una camioneta'),
              body: Form(
                key: formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: userNameController,
                      decoration: const InputDecoration(
                          icon: Icon(Icons.drive_eta),
                          labelText: 'Nombre y apellido *',
                          hintText: ''),
                      validator: (value) {
                        // if (value.isEmpty) {
                        //   return 'Rellenar todos los campos';
                        // }
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: userPhoneController,
                      decoration: const InputDecoration(
                          icon: Icon(Icons.layers),
                          labelText: 'Número de teléfono *',
                          hintText: '9XXXXXXXX'),
                      validator: (value) {
                        // if (value.isEmpty) {
                        //   return 'Rellenar todos los campos';
                        // }
                        return null;
                      },
                    ),
                    // DropdownButton<String>(
                    //   value: dropdownValue,
                    //   icon: Icon(Icons.arrow_downward),
                    //   iconSize: 24,
                    //   elevation: 16,
                    //   style: TextStyle(color: Colors.deepPurple),
                    //   underline: Container(
                    //     height: 2,
                    //     color: Colors.deepPurpleAccent,
                    //   ),
                    //   onChanged: (String newValue) {
                    //     setState(() {
                    //       dropdownValue = newValue;
                    //     });
                    //   },
                    //   items: <String>['Chofer', 'Administrador']
                    //       .map<DropdownMenuItem<String>>((String value) {
                    //     return DropdownMenuItem<String>(
                    //       value: value,
                    //       child: Text(value),
                    //     );
                    //   }).toList(),
                    // ),
                    TextButton(
                      child: const Text("Roles"),
                      onPressed: () => _showReportDialog(),
                    ),
                  ],
                ),
              ),
              onPressedOk: () {
                {
                  if (formKey.currentState!.validate()) {
                    List<String> valueRoleList = [];
                    for (var role in selectedRoleList) {
                      if (role == 'Administrador') {
                        valueRoleList.add('admin');
                      }
                      if (role == 'Chofer') {
                        valueRoleList.add('driver');
                      }
                    }
                    User user = User(
                        name: userNameController.text,
                        phone: userPhoneController.text,
                        roles: valueRoleList);

                    db.addUser(user).whenComplete(() => Navigator.pop(context));

                    // Scaffold.of(context).showSnackBar(
                    //     SnackBar(content: Text('Processing Data')));
                  }
                }
              })
            .show();
        },
      ),
    );
  }
}

class Body extends StatelessWidget {
  const Body({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    DatabaseService db = DatabaseService();

    return StreamBuilder<List<User>>(
        stream: db.streamUsers(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            print("has error");
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (!snapshot.hasData) {
            return const Center(
              child: Text('No se han encontrado datos'),
            );
          }

          return Container(
            child: ListView.builder(
                itemCount: snapshot.data?.length,
                itemBuilder: (context, index) {
                  User user = snapshot.data![index];
                  return ListTile(
                    leading: const Icon(Icons.person),
                    title: Text(user.name ?? ''),
                    subtitle: Text(user.phone ?? ''),
                    onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => UserHistory(user: user))),
                  );
                }),
          );
        });
  }
}
