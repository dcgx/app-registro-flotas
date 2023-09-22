import 'package:flit_app/src/ui/screens/auth/auth_screen.dart';
import 'package:flutter/material.dart';

class Body extends StatefulWidget {
  Body({Key? key}) : super(key: key);

  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        color: Colors.white,
        child: Center(
          child: _buildContent(),
        ),
      ),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => AuthScreen()),
        );
      },
    );
  }

  Widget _buildContent() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        SizedBox(
          height: MediaQuery.of(context).size.height / 10,
        ),
        _buildLogo(),
        SizedBox(
          height: MediaQuery.of(context).size.height / 10,
        ),
        Text(
          'USO DE ',
          style: TextStyle(
            color: Color(0xFF183863),
            fontSize: Theme.of(context).textTheme.headlineMedium!.fontSize,
          ),
        ),
        Text(
          'CAMIONETAS',
          style: TextStyle(
            color: Color(0xFF183863),
            fontSize: Theme.of(context).textTheme.headlineMedium!.fontSize,
          ),
        ),
        SizedBox(
          height: MediaQuery.of(context).size.height / 4,
        ),
        Text(
          'Haga click en la pantalla',
          style: TextStyle(
            fontStyle: FontStyle.italic,
            fontSize: 15,
            color: Colors.grey,
          ),
        ),
        Divider(
          height: 60,
        ),
        TextButton(
          child: Text('Instructivo de la APP'),
          onPressed: () {},
        ),
      ],
    );
  }

  Widget _buildLogo() {
    return Image(
      image: AssetImage('assets/img/logo.png'),
      height: MediaQuery.of(context).size.height / 10,
    );
  }
}
