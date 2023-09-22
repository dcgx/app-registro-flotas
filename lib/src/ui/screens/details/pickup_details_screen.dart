import 'package:fleeve/src/models/pickup.dart';
import 'package:fleeve/src/services/database.dart';
import 'package:fleeve/src/ui/screens/details/widgets/pickup_history.dart';
import 'package:fleeve/src/ui/widgets/dialog.dart';
import 'package:fleeve/src/utils/helpers.dart';
import 'package:flutter/material.dart';

class PickupDetailsScreen extends StatelessWidget {
  const PickupDetailsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    DatabaseService db = DatabaseService();
    TextEditingController _patentController = TextEditingController();
    TextEditingController _categoryController = TextEditingController();

    return Scaffold(
      appBar: AppBar(),
      body: Body(),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          final _formKey = GlobalKey<FormState>();

          AppDialog(
              context: context,
              dialogType: DialogType.FORM,
              title: Text('Agregar una camioneta'),
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
                        // if (value.isEmpty) {
                        //   return 'Rellenar todos los campos';
                        // }
                        // if (value.length < 7 || value.length > 7) {
                        //   return 'Formato incorrecto (Ej. BBDB-10)';
                        // }
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
                        // if (value.isEmpty) {
                        //   return 'Rellenar todos los campos';
                        // }
                        return null;
                      },
                    ),
                  ],
                ),
              ),
              onPressedOk: () {
                {
                  // Validate returns true if the form is valid, otherwise false.
                  if (_formKey.currentState!.validate()) {
                    Pickup pickup = Pickup(
                        patent: _patentController.text.toUpperCase(),
                        category: _categoryController.text);
                    db.addPickup(pickup).then((_) {
                      Navigator.pop(context);
                      showSnackBar(
                          context: context,
                          message: 'Datos correctamente guardado',
                          icon: Icon(Icons.check));
                    });
                  }
                }
              })
            ..show();
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

    return Container(
      child: StreamBuilder<List<Pickup>>(
          stream: db.streamPickups(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              print("has error");
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }

            if (!snapshot.hasData) {
              return Center(
                child: Text('No se han encontrado datos'),
              );
            }
            return ListView.builder(
                itemCount: snapshot.data?.length,
                itemBuilder: (context, index) {
                  Pickup pickup = snapshot.data![index];
                  return ListTile(
                      leading: Icon(Icons.drive_eta),
                      title: Text(snapshot.data![index].patent),
                      subtitle: Text(snapshot.data![index].category),
                      onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  PickupHistory(pickup: pickup))));
                });
          }),
    );
  }
}
