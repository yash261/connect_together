import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connect_together/Models/Call.dart';

class callMethods{
  final CollectionReference callReference=FirebaseFirestore.instance.collection("call");
  Future<bool> makeCall({Call call}) async {
    call.hasDialled=true;
    Map<String,dynamic> sender=call.toMap(call);
    call.hasDialled=false;
    Map<String,dynamic> receiver=call.toMap(call);
    await callReference.doc(call.callerId).set(sender);
    await callReference.doc(call.receiverId).set(receiver);
    return true;
  }
  Future<bool> endCall({Call call}) async {
    await callReference.doc(call.callerId).delete();
    await callReference.doc(call.receiverId).delete();
    return true;
  }
  Stream<DocumentSnapshot> callStream(String uid){
    return callReference.doc(uid).snapshots();
  }
}