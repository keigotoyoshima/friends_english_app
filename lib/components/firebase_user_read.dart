import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'change_notifier.dart';

class FireBaseUserRead {
  FirebaseFirestore firestore;
  String uid;

  FireBaseUserRead({@required firestore, @required currentUserId}){
    this.uid = currentUserId;
    this.firestore = firestore;
  }

  //ユーザー名の取得
  Future<void> getUserName(BuildContext context)async{
    String userName;
    await firestore
        .collection('users')
        .doc(uid)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        userName = documentSnapshot['userName'];
        Provider.of<Data>(context, listen: false).currentUserName(userName);
        print('getUserName');
      } else {
        print('Document does not exist on the database');
      }
    });
    
  }





}