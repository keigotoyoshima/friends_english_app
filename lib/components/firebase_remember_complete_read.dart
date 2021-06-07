import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class FireBaseRememberCompleteRead {
  FirebaseFirestore firestore;
  String group;
  String currentUserId;

  FireBaseRememberCompleteRead({@required firestore, currentUserId, group}){
    this.currentUserId = currentUserId;
    this.firestore = firestore;
    this.group = group;
  }





  //wordがcollectionにドキュメントとして含まれているかの判定
  Future <bool>checkWord(String collectionName, String word)async{
    bool flag = false;
    await firestore
        .collection('group')
        .doc(group).collection(collectionName).doc(word)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        flag = true;
        print('checkWord: Document exist on the database');
      } else {
        print('checkWord: Document does not exist on the database');
      }
    });
    return flag;
  }







}