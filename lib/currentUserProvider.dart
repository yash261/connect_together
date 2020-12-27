import 'package:connect_together/FirebaseRepository.dart';
import 'package:connect_together/Models/User.dart';
import 'package:flutter/widgets.dart';


class currentUserProvider with ChangeNotifier {
  FirebaseRepository _firebaseRepository=FirebaseRepository();
  UserModel user;
  UserModel get getViewState => user;
  void refreshUser() async {
    user=await _firebaseRepository.fetchCurrentUser();
    notifyListeners();
  }
}