import 'package:fleeve/src/ui/screens/reservation/reservation_screen.dart';
import 'package:flutter/material.dart';
import 'package:fleeve/src/providers/auth_provider.dart';
import 'package:fleeve/src/ui/screens/admin/admin_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:fleeve/src/ui/theme.dart';
import 'package:fleeve/src/ui/screens/home/home_screen.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(ChangeNotifierProvider(
    create: (context) => AuthProvider(),
    child: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      // Initialize FlutterFirex
      future: Firebase.initializeApp(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        // Check for errors
        if (snapshot.hasError) {
          print(snapshot);
          return Container();
        }

        // Once complete, show your application
        if (snapshot.connectionState == ConnectionState.done) {
          return MaterialApp(
              title: 'Flutter Demo',
              theme: theme(),
              // home: HomeScreen(),
              localizationsDelegates: [
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate
              ],
              supportedLocales: [const Locale('es', '')],
              initialRoute: '/',
              routes: {
                '/': (context) => HomeScreen(
                      key: new GlobalKey(),
                    ),
                '/admin': (context) => AdminScreen(key: new GlobalKey()),
                '/reservation': (context) =>
                    ReservationScreen(key: new GlobalKey())
              });
        }

        // Otherwise, show something whilst waiting for initialization to complete
        return Container(); // Loading
      },
    );
  }
}
