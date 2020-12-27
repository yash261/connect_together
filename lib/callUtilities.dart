import 'dart:math';
import 'package:connect_together/CallScreens/callScreen.dart';
import 'package:connect_together/Models/Call.dart';
import 'package:connect_together/Models/User.dart';
import 'package:connect_together/call_methods.dart';
import 'package:flutter/material.dart';

class CallUtils {
  static final callMethods _callMethods = callMethods();
  static dial({UserModel from, UserModel to,BuildContext context}) async {
    Call call = Call(
      callerId: from.uid,
      callerName: from.name,
      callerPic: from.profilePhoto,
      receiverId: to.uid,
      receiverName: to.name,
      receiverPic: to.profilePhoto,
      channelId: Random().nextInt(1000).toString(),
    );

    bool callMade = await _callMethods.makeCall(call: call);
    if(callMade){
      Navigator.push(context,MaterialPageRoute(builder: (_)=>CallScreen(call: call,)));
    }
  }
}