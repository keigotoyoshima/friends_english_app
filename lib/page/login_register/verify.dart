import 'dart:async';
import 'package:friends_english_app/page/login_register/register_page2.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class VerifyScreen extends StatefulWidget {
  static const routeName = '/VerifyScreen';

  @override
  _VerifyScreenState createState() => _VerifyScreenState();
}

class _VerifyScreenState extends State<VerifyScreen> {
  final auth = FirebaseAuth.instance;
  User user;
  Timer timer;

  @override
  void initState() {
    user = auth.currentUser;
    user.sendEmailVerification();

    timer = Timer.periodic(Duration(seconds: 2), (timer) {
      //every five seconds
      print('every five seconds');
      checkEmailVerified();
    });

    super.initState();
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('Verify'),
      ),
      body: Center(
        child: SafeArea(
          child: Text('An email has been sent to ${user.email}, please check it and verify.',
              style: TextStyle(
                  fontStyle: FontStyle.italic,
                  fontSize: 25
              ),
          ),
        ),
      ),
    );
  }

  Future<void> checkEmailVerified() async{
    user = auth.currentUser;
    await user.reload();
    if(user.emailVerified){
      timer.cancel();
      Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => RegistrationScreen2()));
    }
  }
}
