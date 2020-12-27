import 'package:connect_together/CallScreens/callScreen.dart';
import 'package:connect_together/Models/Call.dart';
import 'package:connect_together/call_methods.dart';
import 'package:connect_together/permissions.dart';
import 'package:flutter/material.dart';
class pickupScreen extends StatelessWidget {
  callMethods callmethods=callMethods();
  Call call;
  pickupScreen({this.call});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.blue.shade700,Colors.red.shade700],
          )
        ),
        alignment: Alignment.center,
        padding: EdgeInsets.all(10),

        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text("Incoming",style: TextStyle(color: Colors.black,fontSize: 30,fontStyle: FontStyle.italic),),
            Container(
                height: 150,
                decoration: BoxDecoration(shape: BoxShape.circle,),
                child: Image.network(
                    call.callerPic==null?"https://i.pinimg.com/originals/0c/3b/3a/0c3b3adb1a7530892e55ef36d3be6cb8.png":call.callerPic)),
            Text(call.callerName,style : TextStyle(color:Colors.black,fontSize:50)),
            Container(
              padding: EdgeInsets.only(top: 5,bottom: 30),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  IconButton(icon: Icon(Icons.call_end,size: 50,color: Colors.red,),onPressed: (){callmethods.endCall(call: call);},),
                  IconButton(icon: Icon(Icons.call,size: 50,color: Colors.green,),onPressed: () async{
                    if(await Permissions.cameraAndMicrophonePermissionsGranted()){
                    Navigator.of(context).push(MaterialPageRoute(builder: (context)=>CallScreen(call: call)));
                    }
                  },)
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
