import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FirbaseController with ChangeNotifier{
  String userUID='';
  late firebase_storage.Reference ref;
   signupMethod({required email,required password})async{
    try {
      FirebaseAuth authInstance=FirebaseAuth.instance;
      var ref=await authInstance.createUserWithEmailAndPassword(email: email, password: password);
      if(ref.user!.uid.isNotEmpty){
        userUID=ref.user!.uid;
      var shPref =await SharedPreferences.getInstance();
      shPref.setString("userUid", userUID);
      }
    }on FirebaseAuthException catch (e) {
      print("\n-----Error-------");
      print("$e");
    }
    notifyListeners();
  }
  
  loginMethod({required email,required password})async{
    try {
      FirebaseAuth authInstance=FirebaseAuth.instance;
      var ref=await authInstance.signInWithEmailAndPassword(email: email, password: password);
      if (ref.user!.uid.isNotEmpty) {
        userUID=ref.user!.uid;
        var shPref =await SharedPreferences.getInstance();
        shPref.setString("userUid", userUID);
      }else{
        print("object");
      }
    }on FirebaseAuthException catch (e) {
      print("\n-------Error------\n");
      print("$e");
    }
    notifyListeners();
  }

  Future  databaseAdd({required String email,required String password,required File image,required Map<String,dynamic> data})async{
    FirebaseFirestore ff=FirebaseFirestore.instance;
    var fs=firebase_storage.FirebaseStorage.instance;
    try{
    await signupMethod(email: email, password: password);
    if (userUID.isNotEmpty) {
      data["userID"]=userUID;
      var imageRef=await fs.ref().child("UserProfile/$userUID/profile").putFile(image);
      var imgUrl=await imageRef.ref.getDownloadURL();
      data["image"]=imgUrl;
     await ff.collection("Users").doc(userUID).set(data);
    }else{
      print("empty user ID");
    }

  }catch(e){
    print("Error:  $e");
  }}
}
