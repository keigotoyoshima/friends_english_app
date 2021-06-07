import 'package:friends_english_app/components/firebase_count_read.dart';
import 'package:friends_english_app/page/search/search_page.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:friends_english_app/components/change_notifier.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';



class HistoryPage extends StatefulWidget {
  @override
  _HistoryPageState createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  var set = <String>{};
  var finalSet = <String>{};
  User loggedInUser;
  int lengthSet = 0;
  String group;
  int numberOfComplete;

  FireBaseCountRead fireBaseRead;

  @override
  void initState() {
    super.initState();
  }
  
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    group = Provider.of<Data>(context, listen: false).group;
  }



  @override
  Widget build(BuildContext context) {
    Query collectionReference = FirebaseFirestore.instance.collection('group')
        .doc(group).collection('complete').orderBy('time', descending: true);
    numberOfComplete = Provider.of<Data>(context, listen: true).numberOfComplete;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('Complete History (count: ${numberOfComplete.toString()})'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: collectionReference.snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text('Something went wrong');
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          return ListView(
            children: snapshot.data.docs.map((DocumentSnapshot document) {
              return  Padding(
                padding: const EdgeInsets.all(8.0),
                child: GestureDetector(
                  onTap: (){
                    print(document.id);
                    Navigator.pushNamed(
                        context,
                        '/SearchPageCardListView',
                        arguments: SearchData(
                          definition: document.data()['definition'],
                          partOfSpeech: document.data()['partOfSpeech'],
                          wordResult: document.data()['word'],
                          examples: document.data()['examples'],
                          pronunciation: document.data()['pronunciation'],
                          pronunciationKeys:  document.data()['pronunciationKeys'],
                        )
                    );

                  },
                  child: ListTile(
                    tileColor: Color(0xD2FFFFFF),
                    title: Text(document.data()['word'],style: TextStyle(fontSize: 30, color: Colors.black),),
                    subtitle:  Text((DateFormat.yMMMd()).format(document.data()['time'].toDate()).toString() ,
                        style: TextStyle(fontSize: 20, color: Colors.black)),
                  ),
                ),
              );
            }).toList(),
          );
        },
      ),
    );
  }
}

