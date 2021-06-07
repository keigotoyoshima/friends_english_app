import 'package:friends_english_app/components/components.dart';
import 'package:friends_english_app/components/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';


class LoginScreen2 extends StatefulWidget {
  static const routeName = '/LoginScreen2';

  @override
  _LoginScreen2State createState() => _LoginScreen2State();
}

class _LoginScreen2State extends State<LoginScreen2> {
  bool _saving = false;

  final _text1 = TextEditingController();
  bool _validate1 = false;
  final AuthService _auth = AuthService();
  final _formGlobalKey = GlobalKey();
  String _email = '';


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
          title: Text('login'),
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              TextField(
                key: _formGlobalKey,
                  controller:_text1,
                  onChanged: (value) {
                    _email = value;
                  },
                  decoration:
                  kInputDecoration.copyWith(
                    hintText: 'Input your email',
                    errorText: _validate1 ? "Value can't be empty": null,
                  )
              ),


              Padding(
                padding: EdgeInsets.symmetric(vertical: 16.0),
                child: Material(
                  color: Colors.lightBlueAccent,
                  borderRadius: BorderRadius.all(Radius.circular(30.0)),
                  elevation: 5.0,
                  child: MaterialButton(
                    onPressed: () async{
                      setState(() {
                        _text1.text.isEmpty ? _validate1 = true : _validate1 = false;
                      });
                      if(_validate1 == false){
                        String _result = await _auth.sendPasswordResetEmail(_email);
                        // 成功時は戻る
                        if (_result == 'success') {
                          createSnackBar(context, 'Send a email. Please check it out.');
                          Navigator.pop(context);
                        } else if (_result == 'ERROR_INVALID_EMAIL') {
                          createSnackBar(context, 'This is invalid e-mail address.');
                        } else if (_result == 'ERROR_USER_NOT_FOUND') {
                          createSnackBar(context, 'This e-mail address is not registered.');
                        } else {
                          createSnackBar(context, 'Fail to send a email.');
                        }
                      }
                      },

                    minWidth: 200.0,
                    height: 42.0,
                    child: Text(
                      'Send a email',
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