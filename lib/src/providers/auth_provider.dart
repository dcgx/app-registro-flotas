import 'package:flutter/cupertino.dart';
import 'package:fleeve/src/models/user.dart';

class AuthProvider extends ChangeNotifier {
  User? _user;

  User? get user {
    return _user;
  }

  set user(User? user) {
    this._user = user;
    notifyListeners();
  }

  bool get isAuthenticated {
    return _user != null;
  }

  void login(User user) {
    this.user = user;
  }

  void logout() {
    this.user = null;
  }
}
