import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fleeve/src/models/user.dart';
import 'package:fleeve/src/providers/auth_provider.dart';
import 'package:fleeve/src/services/authentication.dart';
import 'package:fleeve/src/ui/screens/reservation/reservation_screen.dart';
import 'package:fleeve/src/ui/widgets/dialog.dart';
import 'package:fleeve/src/utils/helpers.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AuthForm extends StatefulWidget {
  AuthForm({required Key? key}) : super(key: key);

  @override
  _AuthFormState createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  AuthService auth = AuthService();

  List<String> currentPassword = ["", "", "", ""];
  TextEditingController firstNumberController = TextEditingController();
  TextEditingController secondNumberController = TextEditingController();
  TextEditingController thirdNumberController = TextEditingController();
  TextEditingController fourthNumberController = TextEditingController();

  var outlineInputBorder = OutlineInputBorder(
    borderRadius: BorderRadius.circular(10.0),
    borderSide: BorderSide(color: Colors.transparent),
  );

  int numberIndex = 0;
  String password = "";
  bool loggedIn = false;

  @override
  void initState() {
    password = "";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildLoginButton(),
        SizedBox(
          height: MediaQuery.of(context).size.height / 20,
        ),
        _buildPasswordRow(),
        SizedBox(height: MediaQuery.of(context).size.height / 25),
        _buildKeyboard(),
      ],
    );
  }

  Widget _buildLoginButton() {
    return ElevatedButton(
        child: Text(
          'Entrar',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        onPressed: () {
          checkConnectivity().then((internet) {
            if (internet) {
              if (password.isEmpty) {
                showSnackBar(
                    context: context,
                    message: 'Ingrese contraseña',
                    duration: Duration(seconds: 2),
                    icon: Icon(Icons.info));
              } else {
                signIn(password);
              }
            } else {
              // AppDialog(context: context, dialogType: DialogType.INFO)..show();
            }
          });
        });
  }

  Future<void> signIn(String password) async {
    AppDialog(
        context: context,
        dialogType: DialogType.LOADING,
        body: Container(),
        title: Text("Cargando"),
        onpressedConfirm: () => {},
        onPressedOk: () => {})
      ..show();

    auth.signIn(this.password).then((QuerySnapshot querySnapshot) {
      if (querySnapshot.docs.first.exists) {
        // var user = jsonEncode(querySnapshot.docs.first.data());

        var user = User.fromJson(
            querySnapshot.docs.first.data() as Map<String, dynamic>);

        user.id = querySnapshot.docs.first.id;

        Provider.of<AuthProvider>(context).user = user;

        if (user.roles.contains('admin')) {
          Navigator.popAndPushNamed(context, '/admin')
              .then((_) => clearPassInput());
        } else if (user.roles.contains('driver')) {
          Navigator.of(context)
              .push(MaterialPageRoute(
                  builder: (context) =>
                      ReservationScreen(key: new GlobalKey())))
              .then((_) {
            clearPassInput();
            // AppDialog(context: context)..close();
          });
        }
      }
    }).catchError((error) {
      print(error);
      // AppDialog(context: context)..close();
      clearPassInput();
      if (error.toString() == "Bad state: No element") {
        showSnackBar(
            context: context,
            message: 'Contraseña incorrecta',
            duration: Duration(seconds: 2),
            icon: Icon(Icons.error));
      } else {
        showSnackBar(
            context: context,
            message: 'Error inesperado',
            duration: Duration(seconds: 2),
            icon: Icon(Icons.error));
      }
    });
  }

  void clearPassInput() {
    password = "";
    firstNumberController.clear();
    secondNumberController.clear();
    thirdNumberController.clear();
    fourthNumberController.clear();
    numberIndex = 0;
  }

  Widget _buildKeyboard() {
    return Expanded(
        child: Container(
      alignment: Alignment.bottomCenter,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                KeyboardNumber(n: 1, onPressed: () => _passIndexSetup("1")),
                KeyboardNumber(n: 2, onPressed: () => _passIndexSetup("2")),
                KeyboardNumber(n: 3, onPressed: () => _passIndexSetup("3")),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                KeyboardNumber(n: 4, onPressed: () => _passIndexSetup("4")),
                KeyboardNumber(n: 5, onPressed: () => _passIndexSetup("5")),
                KeyboardNumber(n: 6, onPressed: () => _passIndexSetup("6")),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                KeyboardNumber(n: 7, onPressed: () => _passIndexSetup("7")),
                KeyboardNumber(n: 8, onPressed: () => _passIndexSetup("8")),
                KeyboardNumber(n: 9, onPressed: () => _passIndexSetup("9")),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Container(
                  width: 60.0,
                  child: MaterialButton(
                    color: Colors.white,
                    onPressed: null,
                    child: SizedBox(),
                  ),
                ),
                KeyboardNumber(n: 0, onPressed: () => _passIndexSetup("0")),
                Container(
                  width: MediaQuery.of(context).size.width / 6,
                  child: MaterialButton(
                    height: 60.0,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(60.0)),
                    onPressed: () {
                      _backspacePassButton();
                    },
                    child: Icon(
                      Icons.backspace,
                      color: Colors.black,
                    ),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    ));
  }

  void _backspacePassButton() {
    if (numberIndex == 0)
      numberIndex = 0;
    else if (numberIndex == 4) {
      _setPass(numberIndex, "");
      currentPassword[numberIndex - 1] = "";
      numberIndex--;
    } else {
      _setPass(numberIndex, "");
      currentPassword[numberIndex - 1] = "";
      numberIndex--;
    }
  }

  void _passIndexSetup(String text) {
    if (numberIndex == 0) {
      numberIndex = 1;
    } else if (numberIndex < 4) {
      numberIndex++;
    }
    _setPass(numberIndex, text);
    currentPassword[numberIndex - 1] = text;
    String strNumber = "";
    currentPassword.forEach((e) {
      strNumber += e;
    });
    password = strNumber;
  }

  void _setPass(int n, String text) {
    switch (n) {
      case 1:
        firstNumberController.text = text;
        break;
      case 2:
        secondNumberController.text = text;
        break;
      case 3:
        thirdNumberController.text = text;
        break;
      case 4:
        fourthNumberController.text = text;
        break;
    }
  }

  Widget _buildPasswordRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        PasswordNumber(
            outlineInputBorder: outlineInputBorder,
            textEditingController: firstNumberController),
        PasswordNumber(
            outlineInputBorder: outlineInputBorder,
            textEditingController: secondNumberController),
        PasswordNumber(
            outlineInputBorder: outlineInputBorder,
            textEditingController: thirdNumberController),
        PasswordNumber(
            outlineInputBorder: outlineInputBorder,
            textEditingController: fourthNumberController),
      ],
    );
  }
}

class PasswordNumber extends StatelessWidget {
  final TextEditingController textEditingController;
  final OutlineInputBorder outlineInputBorder;
  PasswordNumber(
      {required this.textEditingController, required this.outlineInputBorder});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width / 6,
      height: MediaQuery.of(context).size.height / 10,
      child: TextField(
        controller: textEditingController,
        enabled: false,
        obscureText: true,
        textAlign: TextAlign.center,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.all(16.0),
          border: outlineInputBorder,
          filled: true,
          fillColor: Colors.white30,
        ),
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 40.0,
          color: Colors.black,
        ),
      ),
    );
  }
}

class KeyboardNumber extends StatelessWidget {
  final int n;
  final Function() onPressed;
  KeyboardNumber({required this.n, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width / 5,
      height: MediaQuery.of(context).size.height / 12,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
      ),
      alignment: Alignment.center,
      child: MaterialButton(
        padding: EdgeInsets.all(8.0),
        onPressed: onPressed,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(60.0),
        ),
        child: Text(
          "$n",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 38 * MediaQuery.of(context).textScaleFactor,
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
