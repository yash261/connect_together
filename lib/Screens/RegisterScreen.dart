import 'package:connect_together/FirebaseRepository.dart';
import 'package:connect_together/Models/User.dart';
import 'package:connect_together/utils.dart';
import 'package:connect_together/universalvariables.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:shimmer/shimmer.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  FirebaseRepository _firebaseRepository =FirebaseRepository();
  var error="";
  bool load=false;
  final GlobalKey<ScaffoldState> rkey=GlobalKey<ScaffoldState>();
  var email=TextEditingController();
  var pass=TextEditingController();
  var cpass=TextEditingController();
  var username=TextEditingController();
  @override
  Widget build(BuildContext context) {
    final key1=GlobalKey<FormState>();

    return Scaffold(
      key: rkey,
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
                      key:key1,
                      child: Column(
                     children: <Widget>[
                      Shimmer.fromColors(
                          baseColor: Colors.white,
                          highlightColor: UniversalVariables.senderColor,
                          child: Text("Sign Up",style: TextStyle(color: Colors.white,fontSize: 30,fontFamily: 'OpenSans',fontWeight: FontWeight.bold),)),
                      SizedBox(height: 30.0,),
                      TextFormField(
                        decoration: InputDecoration(
                          hintStyle: TextStyle(color: Colors.black),
                          hintText: "Enter your username",
                          labelStyle: TextStyle(color: Colors.white),
                          prefixIcon: Icon(Icons.person,color: Colors.white,),
                          labelText: "Username",
                        ),
                        controller: username,
                        keyboardType: TextInputType.text,
                        validator: (val)=>val.isEmpty?"Enter a username":null,
                      ),
                      SizedBox(height: 20,),
                      TextFormField(
                        decoration: InputDecoration(
                          hintStyle: TextStyle(color: Colors.black),
                          hintText: "Enter your email",
                          labelStyle: TextStyle(color: Colors.white),
                          prefixIcon: Icon(Icons.email,color: Colors.white,),
                          labelText: "Email",
                        ),
                        controller: email,
                        keyboardType: TextInputType.emailAddress,
                        validator: (val)=>val.isEmpty?"Enter a email":null,
                      ),
                      SizedBox(
                        height: 20.0,
                      ),
                      TextFormField(
                        controller: pass,
                        decoration: InputDecoration(
                            labelText: "Enter password",
                            labelStyle: TextStyle(color: Colors.white
                            ),
                            hintStyle: TextStyle(color: Colors.black),
                            hintText: "Password",
                            prefixIcon: Icon(Icons.lock,color: Colors.white,)
                        ),
                        obscureText: true,
                        validator: (val){
                          return val.length>=6?null:"Enter a password of atleast 6 characters";},
                      ),
                      SizedBox(height: 20.0,),
                      TextFormField(
                        decoration: InputDecoration(
                          labelText: "Confirm password",
                          prefixIcon: Icon(Icons.lock,color: Colors.white,),
                          labelStyle: TextStyle(color: Colors.white
                          ),
                          hintStyle: TextStyle(color: Colors.black),
                          hintText: "Re-enter your password",
                        ),
                        obscureText: true,
                        controller: cpass,
                        validator: (val){
                          return val==pass.text?null:"Both passwords are different";},
                      ),
                      SizedBox(height: 40.0,),
                      if(load==false)
                        Container(
                          width: double.infinity,
                          child: RaisedButton(
                            color: Colors.white,
                            elevation: 5,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                            onPressed: (){
                              if(key1.currentState.validate()){
                                setState(() {
                                  load=true;
                                });
                                Register();
                              }
                            }
                            ,child: Text("Sign Up",style: TextStyle(color: Colors.blue.shade800,letterSpacing: 1.5),),),
                        )
                      else
                        SpinKitWave(size: 40,color: Colors.white,),
                       SizedBox(height: 30,),
                       GestureDetector(
                         onTap: (){
                           Navigator.pop(context);
                         },
                         child: Text("Already have an account? Log In",style: TextStyle(color: Colors.white),),
                       ),
                    ],
                  )
                  ),
                ),

              ),
          ],
        ),
      ),

    );
  }
  void Register() async {
      _firebaseRepository.createUserWithEmailAndPassword(email: email.text, password: pass.text).then((value){
        if(value==true){
          UserModel user=UserModel(name: username.text,username:Utils.getUsername(email.text),email: email.text);
          _firebaseRepository.addNewDatatoDB(user);
          setState(() {
            load = false;
          });
          Navigator.pop(context);
        }
        else{
          setState(() {
            email.text = "";
            pass.text = "";
            cpass.text='';
            load = false;
          });
          rkey.currentState.showSnackBar(SnackBar(content: Text(
            "Email already exists", style: TextStyle(color: Colors.white),),
            backgroundColor: Colors.black,));

        }
      });

    }

}


