import 'package:flutter/material.dart';
import 'package:fleeve/src/ui/screens/home/widgets/body.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Body(),
    );
  }
}
