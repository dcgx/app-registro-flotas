import 'package:flutter/material.dart';

import 'package:fleeve/src/ui/screens/auth/auth_screen.dart';

class Body extends StatefulWidget {
  Body({Key key}) : super(key: key);

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
            context, MaterialPageRoute(builder: (context) => AuthScreen()));
      },
    );
  }

  _buildContent() {
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
          Text('USO DE ',
              style: TextStyle(
                  color: Color(0xFF183863),
                  fontSize: Theme.of(context).textTheme.headline1.fontSize)),
          Text('CAMIONETAS',
              style: TextStyle(
                  color: Color(0xFF183863),
                  fontSize: Theme.of(context).textTheme.headline1.fontSize)),
          SizedBox(
            height: MediaQuery.of(context).size.height / 4,
          ),
          Text('Haga click en la pantalla',
              style: TextStyle(
                fontStyle: FontStyle.italic,
                fontSize: 15,
                color: Colors.grey,
              )),
          Divider(
            height: 60,
          ),
          FlatButton(
            child: Text('Instructivo de la APP'),
            onPressed: () {},
          ),
        ]);
  }

  _buildLogo() {
    return Image(
      image: AssetImage('assets/img/logo.png'),
      height: MediaQuery.of(context).size.height / 10,
    );
  }
}
