import 'dart:io';

import 'package:class12chatapp/db/DBHelper.dart';
import 'package:class12chatapp/models/usermodel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class Userprovider extends ChangeNotifier{
  List<UserModel> remainingUserList = [];


  Future<void> addUser(UserModel userModel){
    return DBHelper.addUser(userModel);
  }
  Stream<DocumentSnapshot<Map<String, dynamic>>> getUserBYId(String uid)=>
      DBHelper.getUserBYId(uid);

  getAllRemainingUsers(String uid){
    DBHelper.getAllRemainingUsers(uid).listen((event) {
      remainingUserList = List.generate(event.docs.length, (index) =>
          UserModel.fromMap(event.docs[index].data())
      );
      notifyListeners();
    });
}

  Future<String> updateImage(File file) async{
    final imageName = 'Image_${DateTime.now().microsecondsSinceEpoch}';
    final photoRef = FirebaseStorage.instance.ref().child('pictures/$imageName');
    final task =photoRef.putFile(file);
    final snapshot = await task.whenComplete(() => null);
    return snapshot.ref.getDownloadURL();
  }

  Future<void> updateprofile(String uid,Map<String, dynamic> map)=>
      DBHelper.updateprofile(uid, map);
}