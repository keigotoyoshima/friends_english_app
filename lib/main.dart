import 'package:friends_english_app/page/login_register/login_page1.dart';
import 'package:friends_english_app/page/login_register/login_page2.dart';
import 'package:friends_english_app/page/login_register/register_page1.dart';
import 'package:friends_english_app/page/login_register/register_page2.dart';
import 'package:friends_english_app/page/login_register/verify.dart';
import 'package:friends_english_app/page/remember/remember_me.dart';
import 'package:friends_english_app/page/search/search_page.dart';
import 'package:friends_english_app/page/search/search_page_card_listview.dart';
import 'package:friends_english_app/page/setting/setting_chageNewName.dart';
import 'package:friends_english_app/page/setting/setting_changeExistingGroup.dart';
import 'package:friends_english_app/page/setting/setting_changeNewGroup.dart';
import 'package:friends_english_app/page/setting/setting_page.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'components/change_notifier.dart';
import 'second_main.dart';
import 'page/login_register/welcome_screen_page.dart';


void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(RestartWidget(child: App()));
}

class App extends StatelessWidget {
  // Create the initialization Future outside of `build`:
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      // Initialize FlutterFire:
      future: _initialization,
      builder: (context, snapshot) {
        // Check for errors
        if (snapshot.hasError) {
          return Text('snapshot has error', style: TextStyle(fontSize: 80),);
        }

        // Once complete, show your application
        if (snapshot.connectionState == ConnectionState.done) {
          return ShareCalendar();
        }

        // Otherwise, show something whilst waiting for initialization to complete
        return CircularProgressIndicator();
      },
    );
  }
}


class ShareCalendar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context)=>Data(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData.dark(
        ),
        initialRoute: WelcomeScreenPage.routeName,
        routes: {
          WelcomeScreenPage.routeName: (context) => WelcomeScreenPage(),
          RegistrationScreen1.routeName: (context) => RegistrationScreen1(),
          RegistrationScreen2.routeName: (context) => RegistrationScreen2(),
          LoginScreen1.routeName: (context) => LoginScreen1(),
          LoginScreen2.routeName: (context) => LoginScreen2(),
          SettingPage.routeName:(context) => SettingPage(),
          SettingChangeToNewGroup.routeName:(context) => SettingChangeToNewGroup(),
          SettingChangeToExistingGroupPage.routeName:(context) => SettingChangeToExistingGroupPage(),
          SettingChangeToNewUserName.routeName:(context) => SettingChangeToNewUserName(),
          MyHomePage.routeName: (context) => MyHomePage(),
          SearchPage.routeName: (context) =>SearchPage(),
          SearchPageCardListView.routeName: (context) =>SearchPageCardListView(),
          RememberMe.routeName: (context) =>RememberMe(),
          VerifyScreen.routeName: (context) =>VerifyScreen(),
        },
      ),
    );
  }
}


class RestartWidget extends StatefulWidget {
  RestartWidget({this.child});

  final Widget child;

  static void restartApp(BuildContext context) {
    context.findAncestorStateOfType<_RestartWidgetState>().restartApp();
  }

  @override
  _RestartWidgetState createState() => _RestartWidgetState();
}

class _RestartWidgetState extends State<RestartWidget> {
  Key key = UniqueKey();

  void restartApp() {
    setState(() {
      key = UniqueKey();
    });
  }

  @override
  Widget build(BuildContext context) {
    return KeyedSubtree(
      key: key,
      child: widget.child,
    );
  }
}



