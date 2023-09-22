import 'package:flit_app/src/models/pickup.dart';
import 'package:flit_app/src/services/database.dart';
import 'package:flit_app/src/ui/screens/details/widgets/pickup_history.dart';
import 'package:flit_app/src/ui/widgets/dialog.dart';
import 'package:flit_app/src/utils/helpers.dart';
import 'package:flutter/material.dart';

class PickupDetailsScreen extends StatelessWidget {
  const PickupDetailsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    DatabaseService db = DatabaseService();
    TextEditingController patentController = TextEditingController();
    TextEditingController categoryController = TextEditingController();

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
                      textCapitalization: TextCapitalization.sentences,
                      controller: patentController,
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
                      controller: categoryController,
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
                  if (formKey.currentState!.validate()) {
                    Pickup pickup = Pickup(
                        patent: patentController.text.toUpperCase(),
                        category: categoryController.text);
                    db.addPickup(pickup).then((_) {
                      Navigator.pop(context);
                      showSnackBar(
                          context: context,
                          message: 'Datos correctamente guardado',
                          icon: const Icon(Icons.check));
                    });
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

    return Container(
      child: StreamBuilder<List<Pickup>>(
          stream: db.streamPickups(),
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
            return ListView.builder(
                itemCount: snapshot.data?.length,
                itemBuilder: (context, index) {
                  Pickup pickup = snapshot.data![index];
                  return ListTile(
                      leading: const Icon(Icons.drive_eta),
                      title: Text(pickup.patent ?? ''),
                      subtitle: Text(snapshot.data![index].category ?? ''),
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
