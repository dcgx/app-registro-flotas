import 'package:flit_app/src/core/functions/intial_function.dart';
import 'package:flit_app/src/core/resources/assets_manager.dart';
import 'package:flit_app/src/core/resources/color_manager.dart';
import 'package:flit_app/src/presentation/pages/login/login_page.dart';
import 'package:flutter/material.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';

import 'package:flit_app/src/config/themes/app_theme.dart';
import 'package:flit_app/src/config/themes/theme_service.dart';
import 'package:flit_app/src/core/utility/constant.dart';

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    _defineThePlatform(context);
    return materialApp(context);
    // return MultiBlocs(materialApp(context));
  }

  Widget materialApp(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'FlitApp',
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: ThemeOfApp().theme,
      home: const LoginPage(),
      // home: AnimatedSplashScreen.withScreenFunction(
      //   screenFunction: screenFunction,
      //   centered: true,
      //   splash: IconsAssets.splashIcon,
      //   backgroundColor: ColorManager.white,
      //   splashTransition: SplashTransition.scaleTransition,
      // ),
    );
  }
}

Future<Widget> screenFunction() async {
  return const LoginPage();
  // String? myId = await initializeDefaultValues();

  // return myId == null
  //     ? const LoginPage()
  //     : const Scaffold(
  //         body: Center(
  //           child: Text('Home Page'),
  //         ),
  //       );
}

_defineThePlatform(BuildContext context) {
  TargetPlatform platform = Theme.of(context).platform;
  isThatMobile =
      platform == TargetPlatform.iOS || platform == TargetPlatform.android;
  isThatAndroid = platform == TargetPlatform.android;
}
