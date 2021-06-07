import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'change_notifier.dart';
import 'firebase_input_format.dart';
import 'firebase_remember_complete_read.dart';

class FireBaseDeleteUpdate {
  FirebaseFirestore firestore;
  String group;
  String uid;
  List<dynamic> listOfRememberPeople;
  int numberOfPeople;
  String documentId;
  String userName;



  FireBaseDeleteUpdate({@required firestore,  group,  listOfRememberPeople,
     numberOfPeople,   uid, userName, documentId,
  }){
    this.firestore = firestore;
    this.group = group;
    this.listOfRememberPeople = listOfRememberPeople;
    this.numberOfPeople = numberOfPeople;
    this.uid = uid;
    this.userName = userName;
    this.documentId = documentId;
  }

  //listOfRememberPeopleにuserを追加
  Future updateListOfRememberPeople(String userName,) async{


    await firestore.collection('group').doc(group)
        .collection('remember')
        .doc(documentId)
        .update({'listOfRememberPeople': FieldValue.arrayUnion([userName])})
        .then((value) => print("User Updated"))
        .catchError((error) => print("Failed to update user: $error"));

  }

  bool whetherListHaveCurrentUser(){
    return listOfRememberPeople.contains(userName);
  }
  bool whetherSameNumber(){
    return listOfRememberPeople.length + 1 >= numberOfPeople;
  }

  Future<void> deleteRemember(String documentId)async{
    await firestore.collection('group').doc(group).collection('remember')
        .doc(documentId).delete().then((value) => print("User Deleted"))
        .catchError((error) => print("Failed to delete user: $error"));
  }


  //groupから除名
  Future<void> deleteUserFromGroup()async{
    await firestore.collection('group').doc(group).collection('users')
        .doc(uid).delete().then((value) => print("User Deleted"))
        .catchError((error) => print("Failed to delete user: $error"));
  }



  // currentGroupのrememberのlistOfRememberPeopleの全てからuserを除去
  Future<void> deleteUserAllFromListOfRememberPeople()async{
    print('deleteUserAllFromListOfRememberPeople');
     await firestore.collection('group').doc(group)
        .collection('remember')
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        List listOfRememberPeople;
        listOfRememberPeople = doc['listOfRememberPeople'];
        if(listOfRememberPeople.contains(userName)){
          final index = listOfRememberPeople.indexOf(userName);
          listOfRememberPeople.removeAt(index);
          print('listOfRememberPeople' + listOfRememberPeople.toString());
          doc.reference.update({'listOfRememberPeople': listOfRememberPeople});
        }
      });
    });
  }


  FireBaseRememberCompleteRead fireBaseRememberCompleteRead;

  void createFireBaseRememberCompleteRead(){
    fireBaseRememberCompleteRead = FireBaseRememberCompleteRead(firestore: firestore, group: group);
  }


  FireBaseInputFormat fireBaseInputFormat;
  String word;
  String sender;
  List<dynamic> definition ;
  List<dynamic> partOfSpeech;
  List<dynamic> examples;
  List<dynamic> pronunciation;
  List<dynamic> pronunciationKeys;
  var time;


  void createFireBaseInputFormat(){
    fireBaseInputFormat = FireBaseInputFormat(
      documentGroupName: group,
      firestore: firestore,
      word: word,
      definition: definition,
      partOfSpeech: partOfSpeech,
      examples: examples,
      pronunciation: pronunciation,
      pronunciationKeys: pronunciationKeys,
      time: time,
      uid: uid,
    );
  }




  // currentGroupのrememberのWhetherSameNumberを全ての値に対して実行
  Future<void> updateAllWhetherSameNumber(BuildContext context)async{
    createFireBaseRememberCompleteRead();
    numberOfPeople = Provider.of<Data>(context, listen: false).numberOfPeople;
    print('updateAllWhetherSameNumber ' + numberOfPeople.toString());


    await firestore.collection('group').doc(group)
        .collection('remember')
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc)  async {

        word = doc['word'];
        List listOfRememberPeople = doc['listOfRememberPeople'];
        print('listOfRememberPeople.length ' + listOfRememberPeople.length.toString());

        if(listOfRememberPeople.length >= numberOfPeople){
          //completeにwordが含まれていないかの判定
          if(! await fireBaseRememberCompleteRead.checkWord('complete', word)){
            //firebaseのcompleteに値を入力
            definition = doc['definition'];
            partOfSpeech = doc['partOfSpeech'];
            examples = doc['examples'];
            pronunciation = doc['pronunciation'];
            pronunciationKeys = doc['pronunciationKeys'];
            time = doc['time'];
            uid = doc['uid'];
            documentId = doc.id;
            word = doc['word'];
            createFireBaseInputFormat();
            await fireBaseInputFormat.fireBaseInputToRememberOrComplete(collectionNameOfFirebase: 'complete');
          }
          print('docId ' + documentId);
          print('word ' + word);

          // 含まれていた場合でも、rememberからは除去
          await this.deleteRemember(documentId);
        }

      });
    });

  }


  //users-uid-['group']の値を更新
  Future<void> updateUserGroupName(String newGroup) {
    return firestore.collection('users')
        .doc(uid)
        .update({'group': newGroup})
        .then((value) => print("User Updated"))
        .catchError((error) => print("Failed to update user: $error"));
  }


//users-uid-['userName']の値を更新
  Future<void> updateUserName1(String newUserName) {
    return firestore.collection('users')
        .doc(uid)
        .update({'userName': newUserName})
        .then((value) => print("updateUserName1: User Updated"))
        .catchError((error) => print("updateUserName1: Failed to update user: $error"));
  }
  // group-users-uid-['userName']の値を更新
  Future<void> updateUserName2(String newUserName) {
    return firestore.collection('group').doc(group).collection('users')
        .doc(uid)
        .update({'userName': newUserName})
        .then((value) => print("updateUserName2: User Updated"))
        .catchError((error) => print("updateUserName2: Failed to update user: $error"));
  }



  // //chatのuserNameを全て更新
  Future<void> updateChatUserName(String newUserName)async{
    print('updateChatUserName');
    firestore.collection('group').doc(group)
        .collection('chat')
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        if(doc['uid'] == uid){
          doc.reference.update({'userName': newUserName});
        }
      });
    });
  }

  //rememberのlistOfRememberPeople内にあるuserNameを全て更新
  Future<void> updateUserNameInListOfRememberPeople(String newUserName, String currentUserName)async{
    print('updateUserNameInListOfRememberPeople');
    firestore.collection('group').doc(group)
        .collection('remember')
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        List listOfRememberPeople = doc['listOfRememberPeople'];
        if(listOfRememberPeople.contains(currentUserName)){
          final index = listOfRememberPeople.indexOf(currentUserName);
          listOfRememberPeople[index] = newUserName;
          doc.reference.update({'listOfRememberPeople': listOfRememberPeople});
        }
      });
    });
  }




}