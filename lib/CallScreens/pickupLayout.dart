import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connect_together/CallScreens/callScreen.dart';
import 'package:connect_together/CallScreens/pickupScreen.dart';
import 'package:connect_together/Models/Call.dart';
import 'package:connect_together/Models/User.dart';
import 'package:connect_together/call_methods.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class pickupLayout extends StatelessWidget {
  final Widget body;
  UserModel user;
  callMethods _methods=callMethods();
  pickupLayout({this.body,this.user});
  @override
  Widget build(BuildContext context) {
    print(user.email);
    return StreamBuilder<DocumentSnapshot>(stream: _methods.callStream(user.uid),
    builder: (context,snapshot){
      if(snapshot.hasData && snapshot.data.data()!=null) {
        print("calling");
        final Map <String, dynamic> doc = snapshot.data.data();
        Call call = Call.fromMap(doc);
        if (!call.hasDialled) {
          return pickupScreen(call: call);
        }
        else{
          return CallScreen(call: call,);
        }
      }
        return body;
    },
    );
  }
}
