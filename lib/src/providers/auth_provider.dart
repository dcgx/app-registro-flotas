import 'package:flutter/cupertino.dart';
import 'package:fleeve/src/models/user.dart';

class AuthProvider extends ChangeNotifier {
  User _user = new User();

  get user {
    return _user;
  }

  set user(User user) {
    this._user = user;
  }

  bool get isAuthenticated {
    return _user != null;
  }

  void login(User user) {
    this._user = user;
    // This call tells the widgets that are listening to this model to rebuild.
    notifyListeners();
  }

  void logout() {
    this.user = null;
  }
}
