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
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Expanded(
            flex: 8,
              child: SizedBox()),
          Expanded(
            flex: 10,
            child: Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Expanded(child: SizedBox()),
                        Expanded(
                          flex: 7,
                          child: Container(
                            height: 70,
                            child: FittedBox(
                              fit:BoxFit.cover,
                              child: Text(
                                'Friends',
                                style: TextStyle(
                                  color: Colors.black,
                                    fontWeight: FontWeight.bold,

                                ),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 3,
                            child: SizedBox()),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Expanded(
                          flex:3,
                            child: SizedBox()),
                        Expanded(
                          flex: 7,
                          child: Container(
                            height:70,
                            child: FittedBox(
                              fit:BoxFit.cover,
                              child: Text(
                                'English',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black38,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: SizedBox(),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: SizedBox(
            ),
          ),
          Expanded(
            flex: 5,
            child: Row(
              children: [
                Expanded(child: SizedBox()),
                Expanded(
                  flex: 15,
                  child: LoginRegisterWidget(
                    onPress:(){
                      Navigator.pushNamed(context, LoginScreen1.routeName);
                    //  今だけ
                    //   Navigator.pushNamed(context, MyHomePage.routeName);
                    },
                    text: 'Log In',
                    color: Colors.white,
                  ),
                ),
                Expanded(child: SizedBox()),
              ],
            ),
          ),
          // Expanded(child: SizedBox()),
          Expanded(
            flex: 5,
            child: Row(
              children: [
                Expanded(child: SizedBox()),
                Expanded(
                  flex: 15,
                  child: LoginRegisterWidget(
                      onPress: () {
                        Navigator.pushNamed(
                          context,
                          RegistrationScreen1.routeName,
                        );
                      },
                      text:  'Register',
                      color: Colors.white,

                  ),
                ),
                Expanded(child: SizedBox()),
              ],
            ),
          ),
          Expanded(
            flex: 8,
              child: SizedBox()),
        ],
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
    return Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(30.0),
      child: MaterialButton(
        onPressed: onPress,
        child: Container(
          height: 60,
          child: FittedBox(
            // fit:BoxFit.cover,
            child: Text(
              text,
              style: TextStyle(
                color: color
              ),
            ),
          ),
        ),
      ),
    );
  }
}
