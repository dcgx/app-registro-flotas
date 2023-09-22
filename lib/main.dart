import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flit_app/src/core/app.dart';
import 'package:flit_app/src/providers/auth_provider.dart';

void main() {
  runApp(ChangeNotifierProvider(
    create: (context) => AuthProvider(),
    child: const MyApp(),
  ));
}

