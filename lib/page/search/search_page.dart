import 'dart:core';
import 'package:friends_english_app/components/firebase_count_read.dart';
import 'package:friends_english_app/components/firebase_input_format.dart';
import 'package:friends_english_app/components/firebase_remember_complete_read.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';
import 'package:friends_english_app/components/change_notifier.dart';
import 'package:friends_english_app/components/components.dart';

class SearchPage extends StatefulWidget {
  static const routeName = '/SearchPage';

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;
  final _formKey = GlobalKey<FormState>();
  Response response;
  String currentUserId;
  String group;
  String constWord;
  String word;
  String wordResult;

  var time;
  String sender;
  String userName;
  FireBaseInputFormat fireBaseInputFormat;

  List definition;
  List partOfSpeech;
  List examples;


  // List<Map<String, dynamic>> _data;

  List <dynamic> _dataElement;

  Map<String, dynamic> pronunciationMap = {};
  dynamic jsonResponse;
  List<dynamic> pronunciation;
  List<dynamic> pronunciationKeys;
  bool loading  = false;
  bool noResult = false;


  @override
  void initState(){
    super.initState();
    definition =  [];
    partOfSpeech = [];
    examples = [];
    pronunciation = [];
    pronunciationKeys = [];
    noResult = false;
    loading = false;
  }

  void initialize(){
    definition =  [];
    partOfSpeech = [];
    examples = [];
    pronunciation = [];
    pronunciationKeys = [];
    noResult = false;
    loading = false;
  }

  Future<void> getData(String word, BuildContext context) async {
      response =
      await http.get(Uri.https('wordsapiv1.p.rapidapi.com', '/words/$word',
          {
            "rapidapi-key": "d9b807fb4cmsh2d38a49db8cfd84p1d21e5jsnb1989efbc96f",
            "rapidapi-host": "wordsapiv1.p.rapidapi.com",
          }
      )
      );

    if (response.statusCode == 200) {
      jsonResponse = await json.decode(response.body);
    } else {
      noResult = true;
      noResults(context);
    }


    print(response.body);
  }


  void pronunciationToList(){
    pronunciationMap.forEach((var key, var value) {
      pronunciationKeys.add(key);
      pronunciation.add(value);
    });
  }

  void loadPronunciationMap(){
    pronunciationMap = jsonResponse['pronunciation'];
    pronunciationToList();
  }

  void loadPronunciationSingleString(){
    pronunciation[0] = jsonResponse['pronunciation'];
    pronunciationKeys[0] = 'all';
  }



  Future<void> loadPronunciationAsset() async {
    try {

      if(jsonResponse['pronunciation'].runtimeType == String){
          //pronunciationがMap型でないとき
          loadPronunciationSingleString();
      }else{
        //pronunciationがMap型のとき
        loadPronunciationMap();
      }
    } catch(e){
      print(e);
    }
  }

  void loadElement(){
    int len = _dataElement.length;
    if(len > 5) len = 5;
    for (int i = 0; i < len; i++){
      definition.add(_dataElement[i]['definition']);
      partOfSpeech.add(_dataElement[i]['partOfSpeech']);
      try{
        examples.add(_dataElement[i]['examples'][0]);
      }catch(e){
        //examplesがない場合
        examples.add('no example');
      }
    }
  }
  Future<void> loadElementAsset()async{
    try {
      _dataElement = jsonResponse['results'];
        loadElement();
    } catch(e){
      noResult = true;
      noResults(context);
      print('loadElementAsset: '+ e.toString());
    }
  }


  Future checkSenderName()async{
    await _firestore
        .collection('users')
        .doc(currentUserId)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
          userName = documentSnapshot['userName'];
    });
  }

  createFireBaseInputFormat(){
    fireBaseInputFormat = FireBaseInputFormat(
      documentGroupName: group,
      firestore: _firestore,
      word: constWord,
      definition: definition,
      partOfSpeech: partOfSpeech,
      examples: examples,
      pronunciation: pronunciation,
      pronunciationKeys: pronunciationKeys,
      time: time,
      userName: userName,
      uid: currentUserId,
    );
  }



  FireBaseRememberCompleteRead fireBaseRememberCompleteRead;

  void createFireBaseRememberCompleteRead(){
    fireBaseRememberCompleteRead = FireBaseRememberCompleteRead(firestore: _firestore, group: group);
  }


  void noResults(BuildContext context){
    setState(() {
      loading = false;
    });
    final snackBar = SnackBar(
      content: Text('No results for that word.'),
      action: SnackBarAction(
        label: 'Undo',
        onPressed: () {
          // Some code to undo the change.
        },
      ),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    group = Provider.of<Data>(context,listen: false).group;
  }






  @override
  Widget build(BuildContext context) {
    currentUserId = _auth.currentUser.uid;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('Search'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Form(
                key: _formKey,
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: <Widget>[
                      TextFormField(
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Please enter some text';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.search),
                          hintText: 'search',
                          border: OutlineInputBorder(),
                          filled: true,
                          // errorText:
                        ),
                        onChanged: (value) {
                          word = value;
                        },
                      ),
                      TextButton(
                        onPressed: () async{
                          constWord = word;
                          setState(() {
                            loading = true;
                          });
                          await getData(constWord,context);
                          if(!noResult){
                            await loadElementAsset();
                          }
                          //noResultの二重チェック
                          if(!noResult){
                            if(constWord != null) {
                              await loadPronunciationAsset();
                            }
                            time = DateTime.now();
                            //userNameの取得
                            await checkSenderName();

                            //firebaseフォーマット作成
                            createFireBaseInputFormat();
                            createFireBaseRememberCompleteRead();



                            if(! await fireBaseRememberCompleteRead.checkWord('remember', constWord)){
                              //含まれていなかった場合,firebaseのremember,chatに値を入力
                              await fireBaseInputFormat.fireBaseInputToRememberOrComplete(
                                collectionNameOfFirebase: 'remember',
                              );
                              await fireBaseInputFormat.fireBaseInputToChat();

                              //numberOfRememberの値を更新
                              FireBaseCountRead fireBaseRead = FireBaseCountRead(firestore: _firestore, group: group);

                              fireBaseRead.checkNumberOfRemember(context);
                            }



                            _formKey.currentState.reset();
                            setState(() {
                              loading = false;
                            });

                            await  Navigator.pushNamed(
                                context,
                                '/SearchPageCardListView',
                                arguments: SearchData(
                                  definition: definition,
                                  partOfSpeech: partOfSpeech,
                                  wordResult: constWord,
                                  examples: examples,
                                  pronunciationKeys: pronunciationKeys,
                                  pronunciation: pronunciation,
                                )
                            );

                          }
                          initialize();
                        },
                        child: Text(
                          'Search',
                          style: TextStyle(
                            color: kAccentColor,
                            fontSize: 18,
                          ),
                        ),
                      ),
                      loading == true ? CircularProgressIndicator(): Container(),
                    ]
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}



class SearchData{
  final String wordResult;
  final List<dynamic> definition;
  final List<dynamic> partOfSpeech;
  final List<dynamic> examples;
  final List<dynamic> pronunciation;
  final List<dynamic> pronunciationKeys;

  SearchData({this.partOfSpeech, this.definition,
    this.wordResult, this.examples, this.pronunciation, this.pronunciationKeys});
}


