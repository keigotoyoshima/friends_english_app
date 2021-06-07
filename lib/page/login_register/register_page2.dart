import 'package:friends_english_app/components/firebase_register.dart';
import 'package:friends_english_app/components/firebase_count_read.dart';
import 'package:friends_english_app/components/firebase_group_read.dart';
import 'package:friends_english_app/components/firebase_user_read.dart';
import 'package:friends_english_app/second_main.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:friends_english_app/components/components.dart';
import 'package:provider/provider.dart';
import '../../components/change_notifier.dart';

class RegistrationScreen2 extends StatefulWidget {
  static const routeName = '/RegistrationScreen2';

  @override
  _RegistrationScreen2State createState() => _RegistrationScreen2State();
}

class _RegistrationScreen2State extends State<RegistrationScreen2> {
  final _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String currentUserId;
  bool _saving = false;
  String email;
  String password;
  String group;
  String groupPassword;
  String userName;
  User loggedInUser;
  int number = 0;
  bool groupFlag = false;
  bool groupPasswordFlag = false;





  final _text3 = TextEditingController();
  bool _validate3 = false;
  final _text4 = TextEditingController();
  bool _validate4 = false;
  final _text5 = TextEditingController();
  bool _validate5 = false;



  @override
  void initState() {
    super.initState();
  }



  FireBaseUserRegister fireBaseUserRegister;
  FireBaseCountRead fireBaseCountRead;
  FireBaseGroupRead fireBaseGroupRead;
  FireBaseUserRead fireBaseUserRead;


  void createFireBaseUserRegister(){
    fireBaseUserRegister = FireBaseUserRegister(
      firestore: _firestore,
      group: group,
      groupPassword:groupPassword,
      userName: userName,
      userId: currentUserId,
    );
  }

  void createFireBaseCountRead(){
    fireBaseCountRead = FireBaseCountRead(group: group, firestore: _firestore);
  }

  void createFireBaseGroupRead(){
    fireBaseGroupRead = FireBaseGroupRead(firestore: _firestore, currentUserId: currentUserId, group: group);
  }

  void createFireBaseUserRead(){
    fireBaseUserRead  =  FireBaseUserRead(firestore: _firestore, currentUserId: currentUserId);
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
    print('build');
    return ModalProgressHUD(
      inAsyncCall: _saving,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,

          title: Text('register  2/2'),
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              TextField(
                  controller: _text3,
                  onChanged: (value) {
                    group = value;
                  },
                  decoration: kInputDecoration.copyWith(
                    hintText: 'Input your group name',
                    errorText: _validate3 ? "Value can't be empty": null,
                  )
              ),
              SizedBox(
                height: 8.0,
              ),
              TextField(
                  controller: _text4,
                  onChanged: (value) {
                    groupPassword = value;
                  },
                  decoration: kInputDecoration.copyWith(
                    hintText: 'Input your group password',
                    errorText: _validate4 ? "Value can't be empty": null,
                  )
              ),
              SizedBox(
                height: 8.0,
              ),
              Divider(
                thickness: 3.0,
              ),
              SizedBox(
                height: 8.0,
              ),
              TextField(
                  controller: _text5,
                  onChanged: (value) {
                    userName = value;
                  },
                  decoration: kInputDecoration.copyWith(
                    hintText: 'Input your user name',
                    errorText: _validate5 ? "Value can't be empty": null,
                  )
              ),

              SizedBox(
                height: 24.0,
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 16.0),
                child: Material(
                  color: Colors.blueAccent,
                  borderRadius: BorderRadius.all(Radius.circular(30.0)),
                  elevation: 5.0,
                  child: MaterialButton(
                    onPressed: () async{

                      setState(() {
                        _text3.text.isEmpty ? _validate3 = true : _validate3 = false;
                        _text4.text.isEmpty ? _validate4 = true : _validate4 = false;
                        _text5.text.isEmpty ? _validate5 = true : _validate5 = false;
                      });

                      if( _validate3 == false &&
                          _validate4 == false &&
                          _validate5 == false
                      ){
                        setState(() {
                          _saving = true;
                        });
                          currentUserId = _auth.currentUser.uid;
                          email = _auth.currentUser.email;
                        // オブジェクトの作成
                          createFireBaseUserRegister();
                          createFireBaseCountRead();
                          createFireBaseGroupRead();
                          createFireBaseUserRead();



                          //group名が存在する場合
                          if(await fireBaseGroupRead.checkGroup()) {

                            if(await fireBaseGroupRead.checkDocumentGroupNamePassword(groupPassword)){
                              //groupPasswordが合っていた場合
                              await fireBaseUserRegister.groupUserAdd();
                              await fireBaseUserRegister.usersUserAdd();

                              //userNameの反映
                              await fireBaseUserRead.getUserName(context);
                              //groupの取得と反映
                              await fireBaseGroupRead.getGroupName(context);
                              group = Provider.of<Data>(context, listen: false).group;

                              await fireBaseCountRead.countDocumentsNumberOfPeople(context);
                              await fireBaseCountRead.countDocumentsNumberOfComplete(context);
                              await fireBaseCountRead.countDocumentsNumberOfRemember(context);
                              setState(() {
                                _saving = false;
                              });
                              Navigator.pushNamed(context, MyHomePage.routeName);
                            }else{
                              //groupPasswordが間違っていた場合
                              createSnackBar(context, 'Wrong group password provided for that group or that group already exists.');
                              setState(() {
                                _saving = false;
                              });
                            }
                          } else{
                            //group名が存在しない場合
                            await fireBaseUserRegister.createUserAdd();
                            await fireBaseUserRegister.groupUserAdd();
                            await fireBaseUserRegister.usersUserAdd();
                            //userNameの反映
                            await fireBaseUserRead.getUserName(context);
                            //groupの反映と取得
                            await fireBaseGroupRead.getGroupName(context);
                            group = Provider.of<Data>(context, listen: false).group;

                            await fireBaseCountRead.countDocumentsNumberOfPeople(context);
                            await fireBaseCountRead.countDocumentsNumberOfComplete(context);
                            await fireBaseCountRead.countDocumentsNumberOfRemember(context);



                            setState(() {
                              _saving = false;
                            });
                            Navigator.pushNamed(context, MyHomePage.routeName);
                          }
                        }

                      },


                    minWidth: 200.0,
                    height: 42.0,
                    child: Text(
                      'Register',
                      style: TextStyle(color: Colors.white),
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