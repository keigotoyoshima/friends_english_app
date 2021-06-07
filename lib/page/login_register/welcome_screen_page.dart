import 'package:friends_english_app/page/login_register/login_page1.dart';
import 'package:friends_english_app/page/login_register/register_page1.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class WelcomeScreenPage extends StatefulWidget {
  static const routeName = '/WelcomeScreenPage';

  @override
  _WelcomeScreenPageState createState() => _WelcomeScreenPageState();
}

class _WelcomeScreenPageState extends State<WelcomeScreenPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CupertinoColors.inactiveGray,
      body: Padding(
        padding: EdgeInsets.fromLTRB(30, 200, 30, 250),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Expanded(
              flex: 2,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    'Friends English',
                    style: TextStyle(
                      color: Colors.white,
                        fontSize: 50,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 40,
            ),
            Expanded(
              child: LoginRegisterWidget(
                onPress:(){
                  Navigator.pushNamed(context, LoginScreen1.routeName);
                //  今だけ
                //   Navigator.pushNamed(context, MyHomePage.routeName);
                },
                text: 'Log In',
                color: Colors.lightBlueAccent,
              ),
            ),
            Expanded(
              child: LoginRegisterWidget(
                  onPress: () {
                    Navigator.pushNamed(
                      context,
                      RegistrationScreen1.routeName,
                    );
                  },
                  text:  'Register',
                  color:  Colors.blueAccent,

              ),
            ),
          ],
        ),
      ),
    );
  }
}

class LoginRegisterWidget extends StatelessWidget {
  LoginRegisterWidget({@required this. color,@required this.onPress, @required this.text});
  final Color color;
  final Function onPress;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: Material(
        elevation: 5.0,
        borderRadius: BorderRadius.circular(30.0),
        child: MaterialButton(
          onPressed: onPress,
          minWidth: 200.0,
          height: 42.0,
          child: Text(
            text,
            style: TextStyle(
              fontSize: 30,
              color: color
            ),
          ),
        ),
      ),
    );
  }
}
