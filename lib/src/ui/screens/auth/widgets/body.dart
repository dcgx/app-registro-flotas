import 'package:fleeve/src/ui/screens/auth/widgets/auth_form.dart';
import 'package:flutter/material.dart';

class Body extends StatefulWidget {
  Body({Key? key}) : super(key: key);

  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  @override
  Widget build(BuildContext context) {
    return Container(
        child: SafeArea(
      child: Column(
        children: <Widget>[
          _buildLogo(),
          SizedBox(height: MediaQuery.of(context).size.height / 25),
          Expanded(
            child: Container(
                alignment: Alignment(0, 0.5),
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: AuthForm()),
          ),
        ],
      ),
    ));
  }

  Widget _buildLogo() {
    return Image(
      height: MediaQuery.of(context).size.height / 10,
      image: AssetImage('assets/img/logo.png'),
    );
  }
}
