import 'package:friends_english_app/components/firebase_count_read.dart';
import 'package:friends_english_app/components/firebase_delete_update.dart';
import 'package:friends_english_app/components/firebase_input_format.dart';
import 'package:friends_english_app/components/firebase_remember_complete_read.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import '../../components/change_notifier.dart';
import 'remember_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:friends_english_app/components/components.dart';
import 'package:friends_english_app/page/search/search_page.dart';
import 'package:friends_english_app/components/components.dart';


class RememberMe extends StatefulWidget {
  static const routeName = '/RememberMe';

  @override
  _RememberMeState createState() => _RememberMeState();
}

class _RememberMeState extends State<RememberMe> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;
  var time;
  User user;
  String textMessage;
  Response response;
  String group;
  String uid;
  String word;
  String sender;
  String userName;
  String documentId;
  int numberOfPeople;
  List<dynamic> listOfRememberPeople;
  List<dynamic> definition ;
  List<dynamic> partOfSpeech;
  List<dynamic> examples;
  List<dynamic> pronunciation;
  List<dynamic> pronunciationKeys;

  bool loading = false;

  FireBaseInputFormat fireBaseInputFormat;

  void createFireBaseInputFormat(){
    fireBaseInputFormat = FireBaseInputFormat(
      documentGroupName: group,
      firestore: _firestore,
      word: word,
      definition: definition,
      partOfSpeech: partOfSpeech,
      examples: examples,
      pronunciation: pronunciation,
      pronunciationKeys: pronunciationKeys,
      time: time,
      userName: userName,
      uid: uid,
    );
  }

  FireBaseDeleteUpdate fireBaseDeleteUpdate;

  void createFireBaseDeleteUpdate(){
    fireBaseDeleteUpdate = FireBaseDeleteUpdate(firestore: _firestore, group: group,
      numberOfPeople: numberOfPeople, listOfRememberPeople: listOfRememberPeople, uid: uid, userName: userName,
      documentId: documentId,
    );
  }


  FireBaseRememberCompleteRead fireBaseRememberCompleteRead;

  void createFireBaseRememberCompleteRead(){
    fireBaseRememberCompleteRead = FireBaseRememberCompleteRead(firestore: _firestore, group: group);
  }









  @override
  void initState(){
    super.initState();
  }
  
  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    group = Provider.of<Data>(context,listen: false).group;
    numberOfPeople = Provider.of<Data>(context,listen: false).numberOfPeople;
    userName = Provider.of<Data>(context,listen: false).userName;
  }

  @override
  Widget build(BuildContext context) {
    uid = _auth.currentUser.uid;
    final ScreenArguments data = ModalRoute.of(context).settings.arguments;
     word = data.word;
     definition  = data.definition;
     partOfSpeech = data.partOfSpeech;
     examples = data.examples;
     pronunciation = data.pronunciation;
     pronunciationKeys = data.pronunciationKeys;
     time = data.time;
     sender = data.sender;
     documentId = data.id;
    listOfRememberPeople = data.listOfRememberPeople;


    return Scaffold(
        appBar: AppBar(
          title: Text('Check Remember'),
        ),
        body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
                children:<Widget> [
                  Card(
                    color: Color(0xD2FFFFFF),
                    clipBehavior: Clip.antiAlias,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,

                      children: [
                        Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,

                            children: [
                              Row(
                                children: [
                                  Text("Word: ",
                                      style:kTextDecorationBold),
                                  Text(word.toString(),
                                      style:kTextDecoration),
                                ],
                              ),

                              Row(
                                children: [
                                  Text('Time: '  ,
                                      style:kTextDecorationBold),
                                  Text( (DateFormat.yMMMd()).format(time.toDate()).toString(),
                                      style: kTextDecoration),
                                ],
                              ),

                              SizedBox(height: 8,),
                              Text('Complete people list: '  ,
                                  style:kTextDecorationBold),
                              Text(data.listOfRememberPeople.toString() ,
                                  style: kTextDecoration),
                            ],
                          ),
                        ),

                      ],
                    ),
                  ),
                  ButtonBar(
                    alignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton(
                        onPressed: () async{
                          // Provider.of<Data>(context, listen: false).changeString(
                          //     definition[0],
                          //     (DateFormat.yMMMd()).format(time.toDate()).toString(),
                          // );
                          //  search_page_card_listviewに移動
                          await  Navigator.pushNamed(
                              context,
                              '/SearchPageCardListView',
                              arguments: SearchData(
                                definition: definition,
                                partOfSpeech: partOfSpeech,
                                wordResult: word,
                                examples: examples,
                                pronunciation: pronunciation,
                                pronunciationKeys: pronunciationKeys,
                              )
                          );
                        },
                        child: Text(
                          'Meaning',
                          style: TextStyle(
                            color: Colors.tealAccent[200],
                            fontSize: 25,
                          ),
                        ),
                      ),

                      TextButton(
                        //completeボタンを押したときの挙動
                        onPressed: () async{
                          setState(() {
                            loading = true;
                          });
                          //オブジェクト作成
                          createFireBaseDeleteUpdate();
                          createFireBaseRememberCompleteRead();

                          //過去にcurrentUserがcompleteしているかの確認
                          if(fireBaseDeleteUpdate.whetherListHaveCurrentUser()){
                            print(userName);
                            final snackBar = SnackBar(
                              content: Text('you have done it before!'),
                              action: SnackBarAction(
                                label: 'Undo',
                                onPressed: () {
                                  // Some code to undo the change.
                                },
                              ),
                            );
                            ScaffoldMessenger.of(context).showSnackBar(snackBar);
                          }else {

                            print('updateListOfRemember');
                            //listOfRememberPeopleを更新
                            await fireBaseDeleteUpdate.updateListOfRememberPeople(userName);
                            //listOfRememberPeopleのlengthとnumberOfPeopleが同じ値か判定
                            if(fireBaseDeleteUpdate.whetherSameNumber()){
                              if(! await fireBaseRememberCompleteRead.checkWord('complete', documentId)){
                                //含まれていなかった場合,firebaseのcompleteに値を入力
                                createFireBaseInputFormat();
                                await fireBaseInputFormat.fireBaseInputToRememberOrComplete(collectionNameOfFirebase: 'complete');
                                //numberOfCompleteの値を更新
                                FireBaseCountRead fireBaseRead = FireBaseCountRead(firestore: _firestore, group: group);
                                fireBaseRead.checkNumberOfComplete(context);
                              }
                              // 含まれていた場合でも、rememberからは除去
                              await fireBaseDeleteUpdate.deleteRemember(documentId);

                              //numberOfRememberの値を更新
                              FireBaseCountRead fireBaseRead = FireBaseCountRead(firestore: _firestore, group: group);
                              await fireBaseRead.checkNumberOfRemember(context);

                            }

                          }



                          setState(() {
                            loading = false;
                          });

                          Navigator.pop(context, null);

                        },
                        child: Text(
                          'Complete',
                          style:TextStyle(
                            color: Colors.tealAccent[200],
                            fontSize: 25,
                          ),
                        ),
                      ),



                    ],
                  ),
                  loading == true ? CircularProgressIndicator(): Container(),

                ]
            )
        )
    );
  }
}