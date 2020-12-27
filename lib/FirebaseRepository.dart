import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connect_together/FirebaseMethods.dart';
import 'package:connect_together/Models/User.dart';
import 'package:connect_together/imageload.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

class FirebaseRepository{
  FirebaseMethods _firebaseMethods=FirebaseMethods();
  Future<User> getCurrentUser()=>_firebaseMethods.getCurrentUser();
  Future<User> googleSignIn()=>_firebaseMethods.googleSignIn();
  Future<bool> authenticateUser(User user)=>_firebaseMethods.authenticateUser(user);
  Future<void> addDatatoDB(User user)=>_firebaseMethods.addDatatoDB(user);
  void signOut()=>_firebaseMethods.signOut();
  Stream<User> get authChanged=>_firebaseMethods.authChanged;
  Future<bool> createUserWithEmailAndPassword({email,password})=>_firebaseMethods.createUserWithEmailAndPassword(email: email,password: password);
  Future<void> addNewDatatoDB(UserModel user)=>_firebaseMethods.addNewDatatoDB(user);
  Future<bool> signInWithEmailAndPassword({email,password})=>_firebaseMethods.signInWithEmailAndPassword(email: email,password: password);
  Future<List<UserModel>> fetchAllUsers(User currentuser)=>_firebaseMethods.fetchAllUsers(currentuser);
  Future<UserModel> fetchCurrentUser()=>_firebaseMethods.fetchCurrentUser();
  Future<void> addchat(String msg,UserModel uid,UserModel currentuid)=>_firebaseMethods.addchat(msg,uid,currentuid);
  void uploadImage(File img,String receiverId,ImageUploadProvider _imageUpload)=>_firebaseMethods.uploadImage(img,receiverId,_imageUpload);
}