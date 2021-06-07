import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class FireBaseUserRegister{
  FirebaseFirestore firestore;
  String group;
  String groupPassword;
  String userName;
  String userId;

  FireBaseUserRegister({
    @required this.firestore, @required this.group,  this.groupPassword,
    @required this.userName, @required this.userId,
  });


  Future<void> createUserAdd()async{
    firestore.collection('group').doc(group).set({
      'createUserId': userId,
      'groupPassWord': groupPassword,
    });

    //group-rememberとgroup-completeに初期値としてhelloを追加


  }

  Future<void> groupUserAdd()async{
    firestore.collection('group').doc(group).collection('users').doc(userId).set({
      'userName': userName,
      'userId': userId,
    });
  }

  Future<void> usersUserAdd()async{
    firestore.collection('users').doc(userId).set({
      'userName': userName,
      'userId': userId,
      'group':group,
    });
  }

}