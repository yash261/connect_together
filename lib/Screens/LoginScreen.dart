import 'package:connect_together/FirebaseRepository.dart';
import 'package:connect_together/Screens/LoadingScreen.dart';
import 'package:connect_together/Screens/RegisterScreen.dart';
import 'package:connect_together/universalvariables.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:shimmer/shimmer.dart';

FirebaseRepository _firebaseRepository = FirebaseRepository();
class LoginScreen extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return _loginScreen();
  }
}
GlobalKey<ScaffoldState> skey=GlobalKey<ScaffoldState>();
class _loginScreen extends State<LoginScreen> {
  bool load=false;
  int c=0;
  String error="";
  var email=TextEditingController();
  var pass=TextEditingController();
  @override
  Widget build(BuildContext context) {
    final key=GlobalKey<FormState>();
    return Scaffold(
      key: skey,
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: Stack(
            children: <Widget>[

              Container(
                height: double.infinity,
                width: double.infinity,
                decoration: BoxDecoration(
                    gradient: LinearGradient(colors: [
                      Colors.blue.shade300,Colors.blue.shade800
                    ],begin: Alignment.topCenter,end: Alignment.bottomCenter)
                ),
              ),
              Container(
                  height: double.infinity,
                  child: SingleChildScrollView(
                    physics: AlwaysScrollableScrollPhysics(),
                    padding: EdgeInsets.symmetric(
                      horizontal: 40.0,
                      vertical: 120.0,
                    ),
                    child: Form(
                        key: key,
                        child: Column(
                          children: <Widget>[
                            Shimmer.fromColors(
                                baseColor: Colors.white,
                                highlightColor: UniversalVariables.senderColor,
                                child: Text("Sign In",style: TextStyle(color: Colors.white,fontSize: 30,fontFamily: 'OpenSans',fontWeight: FontWeight.bold),)),
                            SizedBox(height: 20.0,),
                            TextFormField(
                              validator: (val)=>val.isEmpty?"Enter Email":null,
                              controller: email,
                              keyboardType: TextInputType.emailAddress,
                              decoration: InputDecoration(
                                prefixIcon: Icon(Icons.email,color: Colors.white,),
                                hintText: " Enter your email",
                                labelText: "Email",
                                contentPadding: EdgeInsets.only(top: 15),
                                hintStyle: TextStyle(color: Colors.black),
                                labelStyle: TextStyle(color: Colors.white),
                              ),
                            ),
                            SizedBox(height: 20.0,
                            ),
                            TextFormField(
                              validator: (val)=> val.isNotEmpty?null:"Enter correct password",
                              controller: pass,
                              keyboardType: TextInputType.visiblePassword,
                              decoration: InputDecoration(
                                  hintStyle: TextStyle(color: Colors.black),
                                  labelStyle: TextStyle(color: Colors.white),
                                  contentPadding: EdgeInsets.only(top: 14),
                                  labelText: "Password",
                                  prefixIcon: Icon(Icons.lock,color: Colors.white,),
                                  hintText: " Enter your password"
                              ),
                              obscureText: true,
                            ),
                            SizedBox(
                              height: 30.0,
                            ),
                            if(load==false)
                              Container(
                                width: double.infinity,
                                child: RaisedButton(
                                    color: Colors.white,
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                                    elevation: 5,
                                    onPressed: (){
                                      if(key.currentState.validate()) {
                                        login();
                                      }
                                    }, child: Text("LOGIN",style: TextStyle(color: Colors.blue.shade800,letterSpacing: 1.5),)),
                              )
                            else
                              SpinKitWave(size: 40,color: Colors.white,),
                            SizedBox(height: 20.0,),
                            Container(
                              child: Text("-OR-",style: TextStyle(color: Colors.white,fontSize: 20),),
                            ),
                            SizedBox(height: 20,),
                            Text("Sign in with",style: TextStyle(color: Colors.white),),
                            SizedBox(height: 20,),
                            GestureDetector(
                              onTap: (){
                                googleSignIn();
                              },
                              child: Container(
                                height: 50,
                                width: 50,
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    image: DecorationImage(image: AssetImage("images/google.png")),
                                    boxShadow: [BoxShadow(color: Colors.black,blurRadius: 6,)],
                                    shape: BoxShape.circle
                                ),
                              ),
                            ),
                            SizedBox(height: 30,),
                            GestureDetector(
                              onTap: (){
                                Navigator.of(context).push(MaterialPageRoute(builder: (context)=> RegisterScreen()));
                              },
                              child: Text("Don't have an account? Sign Up",style: TextStyle(color: Colors.white),),
                            ),
                            SizedBox(height: 30,),
                            //   Text(error,style: TextStyle(color: Colors.red,),)
                          ],
                        )
                    ),
                  ))
            ]
        ),
      ),


    );
  }
  void login() {
    setState(() {
      load = true;
    });
    _firebaseRepository.signInWithEmailAndPassword(
        email: email.text, password: pass.text).then((value){
        if(value==false){
          skey.currentState.showSnackBar(SnackBar(
            content: Text("Wrong password/email",
              style: TextStyle(color: Colors.white),),
            duration: Duration(seconds: 5),
            backgroundColor: Colors.black,));
    }
        });
    setState(() {
      load = false;
      email.text = "";
      pass.text = "";
    });
  }

  void googleSignIn() {
    setState(() {
      load=true;
    });
    _firebaseRepository.googleSignIn().then((User user) {
      if (user != null) {
        _firebaseRepository.authenticateUser(user).then((bool val) {
          if (val) {
            _firebaseRepository.addDatatoDB(user);
           }
        });
      }
    });
    setState(() {
      load=false;
    });
  }
}