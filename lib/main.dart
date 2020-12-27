import 'package:connect_together/CallScreens/pickupLayout.dart';
import 'package:connect_together/CallScreens/pickupScreen.dart';
import 'package:connect_together/FirebaseRepository.dart';
import 'package:connect_together/Models/User.dart';
import 'package:connect_together/Screens/HomeScreen.dart';
import 'package:connect_together/Screens/LoadingScreen.dart';
import 'package:connect_together/Screens/LoginScreen.dart';
import 'package:connect_together/Screens/search_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  FirebaseRepository _firebaseRepository = FirebaseRepository();

  @override
  Widget build(BuildContext context) {
    return StreamProvider.value(value: _firebaseRepository.authChanged,
      child: MaterialApp(
    theme: ThemeData(
          brightness: Brightness.dark
        ),
        initialRoute: '/',
        routes: {
          '/search_screen':(context)=>SearchScreen(),
        },
        title: "Connect Together",
        home: Decide(),
      ),);
  }
}

class Decide extends StatefulWidget {
  @override
  _DecideState createState() => _DecideState();
}

class _DecideState extends State<Decide> {
  UserModel _userModel;
  @override
  void initState() {
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    FirebaseRepository _firebaseRepository =FirebaseRepository();
    User _currentUser=Provider.of(context);
    if(_currentUser!=null){
      _firebaseRepository.fetchCurrentUser().then((value){
        setState(() {
          _userModel=value;
        });
      });
    }
    return _currentUser==null?LoginScreen():_userModel==null?LoadingScreen():HomeScreen(user:_userModel);
  }
}
