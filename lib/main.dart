import 'package:flit_app/src/ui/screens/reservation/reservation_screen.dart';
import 'package:flutter/material.dart';
import 'package:flit_app/src/providers/auth_provider.dart';
import 'package:flit_app/src/ui/screens/admin/admin_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flit_app/src/ui/theme.dart';
import 'package:flit_app/src/ui/screens/home/home_screen.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(ChangeNotifierProvider(
    create: (context) => AuthProvider(),
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      // Initialize FlutterFirex
      future: Future.delayed(const Duration(seconds: 2), () async {
        print('init');
      }),
      // future: Firebase.initializeApp(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        // Check for errors
        print(snapshot.connectionState);
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
              localizationsDelegates: const [
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate
              ],
              supportedLocales: const [Locale('es', '')],
              initialRoute: '/',
              routes: {
                '/': (context) => HomeScreen(),
                '/admin': (context) => const AdminScreen(),
                '/reservation': (context) => const ReservationScreen()
              });
        }

        // Otherwise, show something whilst waiting for initialization to complete
        return Container(); // Loading
      },
    );
  }
}
