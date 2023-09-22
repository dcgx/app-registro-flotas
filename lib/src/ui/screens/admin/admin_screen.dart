import 'package:flit_app/src/providers/auth_provider.dart';

import 'package:flit_app/src/ui/screens/admin/widgets/body.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AdminScreen extends StatelessWidget {
  const AdminScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Body(),
      bottomNavigationBar: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 150,
            child: TextButton(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Icon(Icons.logout),
                  Text(
                    'Salir',
                    style: TextStyle(fontSize: 20),
                  ),
                ],
              ),
              onPressed: () {
                Provider.of<AuthProvider>(context).logout();
                Navigator.of(context).popAndPushNamed('/');
              },
            ),
          )
        ],
      ),
    );
  }
}
