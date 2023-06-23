import 'package:flutter/material.dart';

import 'package:fleeve/src/ui/screens/home/widgets/body.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({required Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Body(key: new GlobalKey()));
  }
}
