import 'package:friends_english_app/components/firebase_count_read.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';

import '../components/change_notifier.dart';

class ChatPage extends StatefulWidget {

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;
  final double maxScrollExtent = 0.0;
  String group;
  int numberOfPeople;
  String uid;

  @override
  void initState() {
    super.initState();
    uid = _auth.currentUser.uid;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    group = Provider.of<Data>(context, listen: false).group;
    numberOfPeople = Provider.of<Data>(context, listen: false).numberOfPeople;
    FireBaseCountRead fireBaseRead = FireBaseCountRead(firestore: _firestore, group: group);
    fireBaseRead.checkNumberOfPeople(context);
    }


  @override
  Widget build(BuildContext context) {

    //表示上限を100に設定
    Query collectionReference = FirebaseFirestore.instance.collection("group")
        .doc(group).collection('chat').orderBy('time', descending: true).limit(100);


    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(group + '(${Provider.of<Data>(context, listen: true).numberOfPeople.toString()} members)'),

      ),
      body: StreamBuilderWidget(collectionReference: collectionReference, uid: uid)

    );
  }
}

class StreamBuilderWidget extends StatelessWidget {
  const StreamBuilderWidget({
    Key key,
    @required this.collectionReference,
    @required this.uid,
  }) : super(key: key);

  final Query collectionReference;
  final String uid;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: collectionReference.snapshots(),
      builder: (BuildContext context,  snapshot) {
        if (snapshot.hasError) {
          return Text('Something went wrong');
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        return  ListView(
          reverse: true,
          shrinkWrap: true,
          children: snapshot.data.docs.map((DocumentSnapshot document) {
            return  Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                child: Column(
                  crossAxisAlignment: document.data()['uid'] == uid ? CrossAxisAlignment.end: CrossAxisAlignment.start,
                  children: <Widget>[
                    Material(
                      color: Color(0xD2FFFFFF),
                      borderRadius: document.data()['uid'] == uid ?
                      BorderRadius.only(topRight: Radius.circular(30), topLeft: Radius.circular(30), bottomLeft: Radius.circular(30)):
                      BorderRadius.only(topRight: Radius.circular(30), topLeft: Radius.circular(30), bottomRight: Radius.circular(30)),
                      elevation: 5,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                        child: Text(document.data()['word'],
                          style: TextStyle(fontSize: 25, color: Colors.black), ),
                      ),
                    ),
                    Text(document.data()['userName'],
                      style: TextStyle(fontSize: 15),)
                  ],
                )
            );
          }).toList(),
        );
      },
    );
  }
}



