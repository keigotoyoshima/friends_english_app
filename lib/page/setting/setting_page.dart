import 'package:flutter/material.dart';



class SettingPage extends StatefulWidget {
  static const routeName = '/SettingPage';

  @override
  _SettingPageState createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  bool circle = true;




  @override
  Widget build(BuildContext context) {
    if (circle) {
      return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('Setting'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                    GestureDetector(
                    child: Row(
                      children: [
                        Expanded(
                          child: Material(
                            color: Color(0xFF1B252A),
                            child: Container(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                                child: Text('Change your group to :',
                                  style: TextStyle(
                                      color: Colors.white54,
                                      fontSize: 20),),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                DeleteButton(color: Color(0xFF1B252A), text: ' New group',
                  function: (){
                    Navigator.pushNamed(context, '/SettingChangeToNewGroup');
                  },
                ),
                DeleteButton(color: Color(0xFF1B252A), text: ' Existing group',
                  function: (){
                    Navigator.pushNamed(context, '/SettingChangeToExistingGroupPage');
                  },
                ),

              ],
            ),
            SizedBox(height: 5),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                    GestureDetector(
                    child: Row(
                      children: [
                        Expanded(
                          child: Material(
                            color: Color(0xFF1B252A),
                            child: Container(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                                child: Text('Change your user name to :',
                                  style: TextStyle(
                                      color: Colors.white54,
                                      fontSize: 20),),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                DeleteButton(color: Color(0xFF1B252A), text: ' New user name',
                  function: (){
                    Navigator.pushNamed(context, '/SettingChangeToNewUserName');
                  },
                ),


              ],
            ),
          ],
        ),
      ),
    );
    } else {
      return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('Setting'),
      ),
      body: Center(child: CircularProgressIndicator()),
    );
    }
  }
}

class DeleteButton extends StatelessWidget {

  final Color color;
  final String text;
  final Function function;
  DeleteButton({@required this.text, @required this.color, this.function});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap:function,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Expanded(
            child: Material(
              color: color,
              child: Container(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  child: Text(text,
                    style: TextStyle(
                      color: Colors.white,
                        fontSize: 25),),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

