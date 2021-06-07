import 'package:flutter/material.dart';
import 'package:friends_english_app/components/firebase_count_read.dart';
import 'package:intl/intl.dart';
import '../../components/change_notifier.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';



class RememberPage extends StatefulWidget {
  @override
  _RememberPageState createState() => _RememberPageState();
}

class _RememberPageState extends State<RememberPage> {
  var set = <String>{};
  var finalSet = <String>{};
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  FirebaseAuth currentUser;
  User loggedInUser;
  int lengthSet = 0;
  String group;
  int numberOfPeople;
  int numberOfRemember;
  int numberOfComplete;
  CollectionReference users;



  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }


  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    group = Provider.of<Data>(context, listen: false).group;
    // numberOfPeople = Provider.of<Data>(context, listen: false).numberOfPeople;
    // numberOfRemember = Provider.of<Data>(context, listen: false).numberOfRemember;

    // FireBaseCountRead fireBaseRead = FireBaseCountRead(firestore: _firestore, group: group);
    //
    // fireBaseRead.checkNumberOfPeople(context);
    // fireBaseRead.checkNumberOfRemember(context);
  }







  @override
  Widget build(BuildContext context) {
    Query collectionReference = FirebaseFirestore.instance.collection('group')
        .doc(group).collection('remember').orderBy('time', descending: true);
    numberOfPeople = Provider.of<Data>(context, listen: true).numberOfPeople;
    numberOfRemember = Provider.of<Data>(context, listen: true).numberOfRemember;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('Remember (count: ${numberOfRemember.toString()})'),
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
                    Navigator.pushNamed(context, '/RememberMe', arguments:ScreenArguments(
                        document.data()['word'],
                        document.data()['definition'],
                        document.data()['partOfSpeech'],
                        document.data()['examples'],
                        document.data()['time'],
                        document.data()['sender'],
                        document.id,
                        document.data()['pronunciation'],
                        document.data()['pronunciationKeys'],
                        document.data()['userName'],
                        document.data()['numberOfRemember'],
                        document.data()['listOfRememberPeople'],
                    ));
                  },
                  child: ListTile(
                    tileColor: Color(0xD2FFFFFF),
                    title: Text(document.data()['word'],style: TextStyle(fontSize: 30, color: Colors.black),),
                    subtitle:  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text((DateFormat.yMMMd()).format(document.data()['time'].toDate()).toString() , style: TextStyle(fontSize: 20, color: Colors.black)),
                        Text( document.data()['listOfRememberPeople'].length.toString()
                            + ' / '+ numberOfPeople.toString(), style: TextStyle(fontSize: 20, color: Colors.black)),
                      ],
                    ),
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


class ScreenArguments {
  final String word;

  final Timestamp time;
  final String sender;
  final String id;
  final String userName;
  final int numberOfRemember;
  var listOfRememberPeople;

  final List<dynamic> definition;
  final List<dynamic> partOfSpeech;
  final List<dynamic> examples;
  final List<dynamic> pronunciation;
  final List<dynamic> pronunciationKeys;



  ScreenArguments(this.word, this.definition, this.partOfSpeech,
      this.examples, this.time,this.sender,
      this.id, this.pronunciation, this.pronunciationKeys,
      this.userName, this.numberOfRemember, this.listOfRememberPeople,
      );
}
