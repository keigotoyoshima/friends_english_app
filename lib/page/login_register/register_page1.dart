import 'package:friends_english_app/components/firebase_group_read.dart';
import 'package:friends_english_app/page/login_register/register_page2.dart';
import 'package:friends_english_app/page/login_register/verify.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:friends_english_app/components/components.dart';

class RegistrationScreen1 extends StatefulWidget {
  static const routeName = '/RegistrationScreen1';

  @override
  _RegistrationScreen1State createState() => _RegistrationScreen1State();
}

class _RegistrationScreen1State extends State<RegistrationScreen1> {
  final _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String uid;
  bool _saving = false;
  String email;
  String password;

  final _text1 = TextEditingController();
  bool _validate1 = false;
  final _text2 = TextEditingController();
  bool _validate2 = false;



  @override
  void initState() {
    super.initState();
  }


  FireBaseGroupRead fireBaseGroupRead;


  void createFireBaseGroupRead(){
    fireBaseGroupRead = FireBaseGroupRead(firestore: _firestore, currentUserId: uid);
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
          title: Text('register  1/2'),
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              TextField(
                controller: _text1,
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
                  decoration:
                  kInputDecoration.copyWith(
                    hintText: 'Input your password',
                    errorText: _validate2 ? "Value can't be empty": null,
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
                        _text1.text.isEmpty ? _validate1 = true : _validate1 = false;
                        _text2.text.isEmpty ? _validate2 = true : _validate2 = false;
                      });

                      if( _validate1 == false &&
                          _validate2 == false ){
                        setState(() {
                          _saving = true;
                        });


                        try{
                          UserCredential userCredential = await _auth.signInWithEmailAndPassword(
                            email: email,
                            password: password,
                          );
                          //singInできた場合
                          uid = _auth.currentUser.uid;

                          //FireBaseGroupReadのオブジェクト作成
                          createFireBaseGroupRead();


                          if(await fireBaseGroupRead.whetherUserRegister()){
                            setState(() {
                              _saving = false;
                            });
                            createSnackBar(context, 'You have already registered. Please move to log in page.');
                          }else{
                          //  group名の登録が未完の場合
                            //verifyメールなしでRegister2へ移動
                            setState(() {
                              _saving = false;
                            });
                            Navigator.pushNamed(context, RegistrationScreen2.routeName);

                          }



                        }on FirebaseAuthException catch (e) {
                          //_authの登録がまだの場合
                          if (e.code == 'user-not-found') {
                            try {
                              await  _auth
                                  .createUserWithEmailAndPassword(
                                  email: email, password: password);
                              //verifyメールありでRegister2へ移動
                              Navigator.pushNamed(context, VerifyScreen.routeName);
                            }
                            catch(e){
                              setState(() {
                                _saving = false;
                              });

                              print(e);
                              print(e.code);
                            }


                          } else if (e.code == 'wrong-password') {
                            //emailに対してのパスワードが違う場合
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