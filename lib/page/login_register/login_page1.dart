import 'package:friends_english_app/components/firebase_count_read.dart';
import 'package:friends_english_app/components/firebase_delete_update.dart';
import 'package:friends_english_app/components/firebase_group_read.dart';
import 'package:friends_english_app/components/firebase_user_read.dart';
import 'package:friends_english_app/page/login_register/login_page2.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:friends_english_app/components/components.dart';
import 'package:provider/provider.dart';

import '../../components/change_notifier.dart';
import '../../second_main.dart';

class LoginScreen1 extends StatefulWidget {
  static const routeName = '/LoginScreen1';

  @override
  _LoginScreen1State createState() => _LoginScreen1State();
}

class _LoginScreen1State extends State<LoginScreen1> {
  final _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String uid;
  bool _saving = false;
  String email;
  String password;
  String userName;
  User loggedInUser;
  int number = 0;
  int numberOfPeople;
  bool groupFlag = false;
  String group;

  final _text1 = TextEditingController();
  bool _validate1 = false;
  final _text2 = TextEditingController();
  bool _validate2 = false;



  FireBaseCountRead fireBaseCountRead;
  FireBaseGroupRead fireBaseGroupRead;
  FireBaseUserRead fireBaseUserRead;
  FireBaseDeleteUpdate fireBaseDeleteUpdate;


  void createFireBaseCountRead(){
    fireBaseCountRead = FireBaseCountRead(firestore: _firestore, group: group);
  }

  void createFireBaseGroupRead(){
    fireBaseGroupRead = FireBaseGroupRead(firestore: _firestore, currentUserId: uid);
  }

  void createFireBaseUserRead(){
    fireBaseUserRead  =  FireBaseUserRead(firestore: _firestore, currentUserId: uid);
  }


  void createFireBaseDeleteUpdate(){
    fireBaseDeleteUpdate = FireBaseDeleteUpdate(
      firestore: _firestore, group: group, uid: uid,
      userName: userName, numberOfPeople: numberOfPeople,
    );
  }

  @override
  void initState() {
    super.initState();
  }



  void createSnackBar(BuildContext context, String errorMessage){
    final snackBar = SnackBar(
      content: Text(errorMessage),
      action: SnackBarAction(
        label: 'Undo',
        onPressed: () {
        },
      ),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }





  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: _saving,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Login'),
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              TextField(
                  controller:_text1,
                  cursorColor: Colors.tealAccent[200],
                  onChanged: (value) {
                    email = value;
                  },
                  decoration:
                  kInputDecoration.copyWith(
                    hintText: 'Input your email',
                    errorText: _validate1 ? "Value can't be empty": null,
                  )
              ),
              SizedBox(
                height: 8.0,
              ),
              TextField(
                controller: _text2,
                  onChanged: (value) {
                    password = value;
                  },
                  cursorColor: Colors.tealAccent[200],
                  decoration:
                  kInputDecoration.copyWith(
                    hintText: 'Input your password',
                    errorText: _validate2 ? "Value can't be empty": null,
                  )

              ),
              SizedBox(height: 5,),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () async{
                      Navigator.pushNamed(context, LoginScreen2.routeName);
                    },
                    child:  Text(
                      'Forget password?',
                      style: TextStyle(
                        color: Colors.tealAccent[200],
                        fontSize: 20,
                      ),
                    ),
                  ),
                ],
              ),

              Padding(
                padding: EdgeInsets.symmetric(vertical: 16.0),
                child: Material(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(30.0)),
                  elevation: 5.0,
                  child: MaterialButton(
                    onPressed: () async{
                      setState(() {
                        _text1.text.isEmpty ? _validate1 = true : _validate1 = false;
                        _text2.text.isEmpty ? _validate2 = true : _validate2 = false;
                      });
                      if(_validate1 == false &&
                      _validate2 == false){
                        setState(() {
                          _saving = true;
                        });
                        //try???????????????????????????????????????catch?????????
                        try {
                          UserCredential userCredential = await _auth.signInWithEmailAndPassword(
                            email: email,
                            password: password,
                          );
                          uid = _auth.currentUser.uid;



                          //????????????????????????
                          createFireBaseGroupRead();
                          createFireBaseUserRead();




                          if(await fireBaseGroupRead.whetherUserRegister()){
                            //userName?????????
                            await fireBaseUserRead.getUserName(context);
                            //group?????????
                            await fireBaseGroupRead.getGroupName(context);
                            group = Provider.of<Data>(context, listen: false).group;


                            //FireBaseCountRead???????????????????????????
                            createFireBaseCountRead();
                            await fireBaseCountRead.countDocumentsNumberOfPeople(context);
                            await fireBaseCountRead.countDocumentsNumberOfComplete(context);
                            await fireBaseCountRead.countDocumentsNumberOfRemember(context);



                            // currentGroup???remember???WhetherSameNumber?????????????????????????????????
                            numberOfPeople = Provider.of<Data>(context, listen: false).numberOfPeople;
                            createFireBaseDeleteUpdate();
                            await fireBaseDeleteUpdate.updateAllWhetherSameNumber(context);


                            setState(() {
                              _saving = false;
                            });
                            Navigator.pushNamed(context, MyHomePage.routeName);
                          }else{
                            //  user???group??????????????????
                            setState(() {
                              _saving = false;
                            });
                            createSnackBar(context, "You haven't register group, please register your group");
                          }
                        } on FirebaseAuthException catch (e) {
                          setState(() {
                            _saving = false;
                          });
                          print(e);
                          if (e.code == 'user-not-found') {
                            createSnackBar(context, 'No user found for that email.');
                          } else if (e.code == 'wrong-password') {
                            createSnackBar(context,'Wrong password provided for that user.' );
                          }else{
                            createSnackBar(context, 'No user found for that email.');
                          }

                        }
                      }


                    },
                    minWidth: 200.0,
                    height: 42.0,
                    child: Text(
                      'Log In',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 20
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}