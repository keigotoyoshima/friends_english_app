import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'change_notifier.dart';

class FireBaseGroupRead {
  FirebaseFirestore firestore;
  String group;
  String uid;

  FireBaseGroupRead({@required firestore, currentUserId, group}){
    this.uid = currentUserId;
    this.firestore = firestore;
    this.group = group;
  }





  //group名を取得
  Future getGroupName(BuildContext context)async{
    await firestore
        .collection('users')
        .doc(uid)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        group = documentSnapshot['group'];
        Provider.of<Data>(context, listen: false).currentGroupName(group);
        print('getGroupName');
      } else {
        print('Document does not exist on the database');
      }
    });
  }

  // userをfireStoreに登録しているか
  Future<bool> whetherUserRegister()async{
    bool flag = false;
    await firestore
        .collection('users')
        .doc(uid)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        flag = true;
      }
    });
    return flag;
  }

  //group名が他に使われていないか検索
  Future<bool> checkGroup()async{
    bool groupFlag = false;
    await firestore.collection('group')
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        if(doc.id == group) groupFlag = true;
      });
    });

    return groupFlag;
  }

  //groupNamePassWordの照合
  Future<bool> checkDocumentGroupNamePassword(String groupPassword) async{
    bool groupPasswordFlag = false;
    await firestore
        .collection('group')
        .doc(group)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot['groupPassWord'] == groupPassword) {
        groupPasswordFlag = true;
      }
    });

    return groupPasswordFlag;

  }

  //group内で他にuserNameが使われていないか検索
  Future<bool> checkUserNameInGroup(String newUserName)async{
    bool flag = false;
    await firestore.collection('group').doc(group).collection('users')
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        if(doc['userName'] == newUserName) flag = true;
      });
    });

    return flag;
  }





}