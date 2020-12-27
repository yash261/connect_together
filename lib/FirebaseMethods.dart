import 'dart:io';
import 'package:connect_together/Models/Contact.dart';
import 'package:connect_together/currentUserProvider.dart';
import 'package:connect_together/imageload.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connect_together/Models/Message.dart';
import 'package:connect_together/Models/User.dart';
import 'package:connect_together/utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';

class FirebaseMethods{
  UserModel user;
  FirebaseAuth _auth =FirebaseAuth.instance;
  GoogleSignIn _googleSignIn=GoogleSignIn();
  Reference _reference;
  static final FirebaseFirestore _firestore=FirebaseFirestore.instance;
  QuerySnapshot snap;

  Future<User> getCurrentUser() async{
    User currentUser=_auth.currentUser;
    return currentUser;
  }

  Future<User> googleSignIn() async{
    GoogleSignInAccount _googleSignInAccount=await _googleSignIn.signIn();
    GoogleSignInAuthentication _googleAuth=await _googleSignInAccount.authentication;
    AuthCredential credential =GoogleAuthProvider.credential(idToken: _googleAuth.idToken,accessToken: _googleAuth.accessToken);
    UserCredential currentuser =await _auth.signInWithCredential(credential);
    return _auth.currentUser;
  }
  Future<bool> authenticateUser(User user) async{
    QuerySnapshot snap=await _firestore.collection('users').where('email',isEqualTo: user.email).get();
    List<DocumentSnapshot> docs=snap.docs;
    return docs.length==0?true:false;
  }
  Future<void> addDatatoDB(User currentUser){
    user=UserModel(
      uid: currentUser.uid,
      profilePhoto: currentUser.photoURL,
      name: currentUser.displayName,
      email: currentUser.email,
      username: Utils.getUsername(currentUser.email),
    );
    _firestore.collection('users').doc(currentUser.uid).set(user.toMap(user));
  }
  void signOut(){
    _googleSignIn.signOut();
    _auth.signOut();
  }
  Stream<User> get authChanged{
    return _auth.authStateChanges();
  }
  Future<bool> createUserWithEmailAndPassword({email,password}) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      return true;
    }
    catch(Exception){
      return false;
    }
  }
  Future<bool> signInWithEmailAndPassword({email,password})async{
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      return true;
    }
    catch(Exception){
      return false;
    }
  }
  Future<void> addNewDatatoDB(UserModel user){
    user.uid=_auth.currentUser.uid;
    _firestore.collection('users').doc(user.uid).set(user.toMap(user));
  }
  Future<List<UserModel>> fetchAllUsers(User currentUser) async {
    List<UserModel> userList = List<UserModel>();
    if(snap==null) {
      snap = await _firestore.collection("users").get();
    }
    List<DocumentSnapshot> docs=snap.docs;
    for (var i = 0; i < docs.length; i++) {
      if (docs[i]['uid']!=currentUser.uid) {
        print(docs[i]['name']);
        userList.add(UserModel(uid:docs[i]['uid'],name:docs[i]['name'],username: docs[i]['username'],profilePhoto: docs[i]['profile_photo']));
      }
    }
    return userList;
  }
  Future<UserModel> fetchCurrentUser()async{
    if(snap==null){
      snap =await _firestore.collection("users").get();
    }
    List<DocumentSnapshot> docs=snap.docs;
    User currentUser=await getCurrentUser();
    for (var i = 0; i < docs.length; i++) {
      if (docs[i]['uid']==currentUser.uid) {
        print(docs[i]['name']);
        return UserModel(uid:docs[i]['uid'],name:docs[i]['name'],username: docs[i]['username'],profilePhoto: docs[i]['profile_photo']);
      }
    }

  }
  Future<void> addchat(String msg,UserModel user,UserModel currentuser) async{
    Message message=Message(senderId:currentuser.uid,receiverId: user.uid,message: msg,type: 'text',timestamp: FieldValue.serverTimestamp());
    var map=message.toMap();
    Contact _sendercontact=Contact(user: user,addedOn: Timestamp.now());
    Contact _receivercontact=Contact(user: currentuser,addedOn: Timestamp.now());
    await _firestore.collection('messages').doc(currentuser.uid).collection(user.uid).add(map);
    await _firestore.collection('messages').doc(user.uid).collection(currentuser.uid).add(map);
    await _firestore.collection('users').doc(currentuser.uid).collection('contacts').doc(user.uid).set(_sendercontact.toMap(_sendercontact));
    await _firestore.collection('users').doc(user.uid).collection('contacts').doc(currentuser.uid).set(_receivercontact.toMap(_receivercontact));

  }
  void uploadImage(File img,String receiverId,ImageUploadProvider _imageUpload) async{
    _imageUpload.setToLoading();
    _reference=FirebaseStorage.instance.ref().child(DateTime.now().microsecondsSinceEpoch.toString());
    UploadTask _uploadTask=_reference.putFile(img);
    String url;
    _uploadTask.whenComplete(() async{
      await _reference.getDownloadURL().then((url) async {
        print(url);
        User currentuser=await getCurrentUser();
        Message message=Message(receiverId: receiverId,senderId: currentuser.uid,type: 'image',message: url,timestamp: FieldValue.serverTimestamp());
        var map=message.toMap();
        await _firestore.collection('messages').doc(currentuser.uid).collection(receiverId).add(map);
        await _firestore.collection('messages').doc(receiverId).collection(currentuser.uid).add(map);
        _imageUpload.setToIdle();
      });
    });
  }


}