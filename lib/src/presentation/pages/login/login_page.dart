import 'package:flit_app/src/core/resources/color_manager.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
            padding: const EdgeInsets.all(25.0),
            child: Column(
              children: [
                const Padding(
                  padding: EdgeInsets.only(top: 60.0),
                  child: Center(
                    child: SizedBox(
                      width: 200,
                      height: 150,
                      child: Text('Logo'),
                    ),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.all(4.0),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Email or Username',
                      style: TextStyle(
                        color: ColorManager.black87,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.all(4.0),
                  child: TextField(
                    key: Key('emailOrUsernameField'),
                    style: TextStyle(color: ColorManager.black87),
                    decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: ColorManager.shimmerLightGrey),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: ColorManager.shimmerDarkGrey),
                        ),
                        floatingLabelBehavior: FloatingLabelBehavior.never),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(top: 16),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Password',
                      style: TextStyle(
                        color: ColorManager.black87,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.all(4.0),
                  child: TextField(
                    key: Key('passwordField'),
                    style: TextStyle(color: ColorManager.black87),
                    decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: ColorManager.shimmerLightGrey),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: ColorManager.shimmerDarkGrey),
                        ),
                        floatingLabelBehavior: FloatingLabelBehavior.never),
                  ),
                ),
                Padding(
                    padding: const EdgeInsets.only(top: 16),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        minimumSize: const Size.fromHeight(50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                      key: const Key('loginButton'),
                      onPressed: () {},
                      child: const Text(
                        'Log In',
                        style: TextStyle(fontSize: 20, color: Colors.white),
                      ),
                    )),

                // or continue with SSO

                Padding(
                  padding: const EdgeInsets.only(top: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 80,
                        height: 1,
                        color: Colors.grey,
                      ),
                      const Padding(
                        padding: EdgeInsets.only(left: 8, right: 8),
                        child: Text(
                          'or continue with SSO',
                          style: TextStyle(color: Colors.grey),
                        ),
                      ),
                      Container(
                        width: 80,
                        height: 1,
                        color: Colors.grey,
                      ),
                    ],
                  ),
                ),

                // GoogleProviderButton
                Padding(
                  padding: const EdgeInsets.only(top: 16),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: ColorManager.lightGrey,
                      minimumSize: const Size.fromHeight(50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                    key: const Key('googleProviderButton'),
                    onPressed: () {},
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Image.asset(
                        //   'assets/images/google_logo.png',
                        //   width: 20,
                        //   height: 20,
                        // ),
                        Text(
                          'Google',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400, color: Colors.black54),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            )));
  }
}
