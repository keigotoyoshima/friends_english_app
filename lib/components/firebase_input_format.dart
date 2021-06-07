import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class FireBaseInputFormat{
  FirebaseFirestore firestore;
  String documentGroupName;
  String word;
  var time;
  String userName;
  String uid;

  List definition ;
  List partOfSpeech;
  List examples;
  List  pronunciation;
  List pronunciationKeys;


  FireBaseInputFormat({
    @required this.documentGroupName, @required this.firestore, @required this.word,@required this.definition,
    @required this.partOfSpeech, @required this.examples, @required this.pronunciation, @required this.pronunciationKeys,
    @required this.time,  this.userName, @required this.uid,
  });

  //setだと重複がなくなるが上書きされるため、登録時のtimeプロパティが更新されてしまう。登録前に含まれているかの判定が必要。
  Future <void> fireBaseInputToRememberOrComplete({@required String collectionNameOfFirebase})async{
    firestore.collection('group').doc(documentGroupName).collection(collectionNameOfFirebase)
    .doc(word).set({
      'word' : word,
      'definition': definition,
      'partOfSpeech' : partOfSpeech,
      'examples': examples,
      'pronunciation': pronunciation,
      'pronunciationKeys': pronunciationKeys,
      'time': time,
      'uid' : uid,
      'listOfRememberPeople' : FieldValue.arrayUnion([]),
    });
  }

  Future<void> fireBaseInputToChat()async {
    firestore.collection('group').doc(documentGroupName).collection('chat').add({
      'word' : word,
      'definition': definition,
      'partOfSpeech' : partOfSpeech,
      'examples': examples,
      'pronunciation': pronunciation,
      'pronunciationKeys': pronunciationKeys,
      'time': time,
      'userName': userName,
      'uid' : uid,
      'listOfRememberPeople' : FieldValue.arrayUnion([]),
    })
        .then((value) => print("User Added history: $value"))
        .catchError((error) => print("Failed to add user1: $error"));

  }

}