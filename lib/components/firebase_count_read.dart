import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'change_notifier.dart';

class FireBaseCountRead {
  FirebaseFirestore firestore;
  int numberOfPeople;
  int numberOfComplete;
  int numberOfRemember;

  String group;

  FireBaseCountRead({@required firestore, @required group,}){
    this.group = group;
    this.firestore = firestore;
  }


  //numberOfPeopleの取得
  Future<void> countDocumentsNumberOfPeople(BuildContext context) async {
    print('countDocumentsNumberOfPeople');
    QuerySnapshot _myDoc = await firestore.collection('group')
        .doc(group).collection('users').get();
    numberOfPeople = _myDoc.size;
    print('numberOfPeople ' + numberOfPeople.toString());
    //更新
    Provider.of<Data>(context,listen: false).currentNumberOfPeople(numberOfPeople);
  }

  //numberOfCompleteの取得
  Future<void> countDocumentsNumberOfComplete(BuildContext context) async {
    print('countDocumentsNumberOfComplete');
    QuerySnapshot _myDoc = await firestore.collection('group')
        .doc(group).collection('complete').get();
    numberOfComplete = _myDoc.size;
    //更新
    Provider.of<Data>(context,listen: false).currentNumberOfComplete(numberOfComplete);
  }

  //numberOfRememberの取得
  Future<void> countDocumentsNumberOfRemember(BuildContext context) async {
    print('countDocumentsNumberOfRemember');
    QuerySnapshot _myDoc = await firestore.collection('group')
        .doc(group).collection('remember').get();
    numberOfRemember = _myDoc.size;
    //更新
    Provider.of<Data>(context,listen: false).currentNumberOfRemember(numberOfRemember);
  }



  //numberOfPeopleの内容に変更があればを更新
  checkNumberOfPeople(BuildContext context) async {
    int preSize = Provider.of<Data>(context, listen: false).numberOfPeople;
    QuerySnapshot _myDoc = await firestore.collection('group')
        .doc(group).collection('users').get();
    int docSize = _myDoc.size;
    if(docSize != preSize){
      Provider.of<Data>(context, listen: false).currentNumberOfPeople(_myDoc.size);
    }
  }

  //numberOfCompleteの内容に変更があればを更新
  checkNumberOfComplete(BuildContext context) async {
    int preSize = Provider.of<Data>(context, listen: false).numberOfComplete;

    QuerySnapshot _myDoc = await firestore.collection('group')
        .doc(group).collection('complete').get();
    int docSize = _myDoc.size;
    if (docSize != preSize) {
      Provider.of<Data>(context, listen: false).currentNumberOfComplete(_myDoc.size);
    }
  }

  //numberOfRememberの内容に変更があればを更新
  checkNumberOfRemember(BuildContext context) async {
    int preSize = Provider.of<Data>(context, listen: false).numberOfRemember;
    QuerySnapshot _myDoc = await firestore.collection('group')
        .doc(group).collection('remember').get();
    int docSize = _myDoc.size;
    if (docSize != preSize) {
      Provider.of<Data>(context, listen: false).currentNumberOfRemember(_myDoc.size);
    }
  }


}