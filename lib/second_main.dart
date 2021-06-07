import 'package:friends_english_app/page/complete_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'page/chat_page.dart';
import 'page/search/search_page.dart';
import 'page/setting/setting_page.dart';
import 'page/remember/remember_page.dart';
import 'package:firebase_auth/firebase_auth.dart';





class MyHomePage extends StatefulWidget {
  static const routeName = '/MyHomePage';

  MyHomePage({Key key}) : super(key: key);


  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _auth = FirebaseAuth.instance;
  String currentUserId;
  List  appointments =  [];
  int _selectedIndex = 0;
  PageController _pageController;
  String day;
  String week;
  String month;
  String currentGroupName;
  User user;

  List<Widget> _pageList = [
    // CalendarPage(),
    SearchPage(),
    ChatPage(),
    RememberPage(),
    HistoryPage(),
    SettingPage(),
  ];


  @override
  void initState() {
    super.initState();
    _pageController = PageController(
      initialPage: _selectedIndex,
    );
    print(_auth.currentUser.toString());
    print('initState of second_main: ' + _auth.currentUser.uid.toString());
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: PageView(
        controller: _pageController,
        children: _pageList,
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.grey,
        selectedItemColor: Colors.blueAccent,
        items: const <BottomNavigationBarItem>[
          // BottomNavigationBarItem(
          //   backgroundColor: Colors.grey,
          //   icon: Icon(Icons.calendar_today),
          //   title: Text('Calendar'),
          // ),
          BottomNavigationBarItem(
            backgroundColor: Colors.grey,
            icon: Icon(Icons.search),
            title: Text('Search'),
          ),
          BottomNavigationBarItem(
            backgroundColor: Colors.grey,
            icon: Icon(Icons.chat),
            title: Text('Friends'),
          ),
          BottomNavigationBarItem(
            backgroundColor: Colors.grey,
            icon: Icon(Icons.cloud_done_outlined),
            title: Text('Remember'),
          ),
          BottomNavigationBarItem(
            backgroundColor: Colors.grey,
            icon: Icon(Icons.history),
            title: Text('Complete'),
          ),
          BottomNavigationBarItem(
            backgroundColor: Colors.grey,
            icon: Icon(Icons.settings),
            title: Text('Setting'),
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });

          _pageController.animateToPage(index,
              duration: Duration(milliseconds: 10), curve: Curves.easeIn);

        },
      ),
    );
  }


}





