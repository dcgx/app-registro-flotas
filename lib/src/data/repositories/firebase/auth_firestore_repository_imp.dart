
// import 'package:flit_app/src/domain/repositories/auth/auth_repository.dart';

// class AuthFirestoreRepositoryImp implements AuthRepository {
//   const AuthFirestoreRepositoryImp();
//   static AuthFireStoreImp _authFireStoreImp = AuthFireStoreImp();
//   @override
//   Future forgetPassowrd(String email) async {
//     return await _authFireStoreImp.resetPasswordFirestore(email: email);
//   }

//   @override
//   Future logOut() async {
//     return await _authFireStoreImp.logOutFireStore();
//   }

//   @override
//   Future login(model) async {
//     return await _authFireStoreImp.loginFireStore(model.email, model.password);
//   }

//   @override
//   Future register(model) async {
//     return await _authFireStoreImp.registerFirestore(model);
//   }

//   @override
//   Future updatePassword(String newPassword) async {
//     return await _authFireStoreImp.updatePasswordFireStore(newPassword);
//   }
// }