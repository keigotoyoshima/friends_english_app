import 'package:friends_english_app/components/components.dart';
import 'package:friends_english_app/components/firebase_delete_update.dart';
import 'package:friends_english_app/components/firebase_group_read.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../components/change_notifier.dart';
import '../../main.dart';



class SettingChangeToNewUserName extends StatefulWidget {
  static const routeName = '/SettingChangeToNewUserName';

  @override
  _SettingChangeToNewUserNameState createState() => _SettingChangeToNewUserNameState();
}

class _SettingChangeToNewUserNameState extends State<SettingChangeToNewUserName> {
  final _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String currentUserName;
  
  String newUserName;
  String uid;
  String group;

  final _text2 = TextEditingController();
  bool _validate2 = false;

  bool _saving = false;
  bool circle = true;


  FireBaseDeleteUpdate fireBaseDeleteUpdate;

  void createFireBaseDeleteUpdate(){
    fireBaseDeleteUpdate = FireBaseDeleteUpdate(firestore: _firestore, uid: uid, userName: currentUserName, group:group
    );
  }

  FireBaseGroupRead fireBaseGroupRead;

  void createFireBaseGroupRead(){
    fireBaseGroupRead = FireBaseGroupRead(firestore: _firestore, group: group);
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
  void initState() {
    // TODO: implement initState
    super.initState();
    uid = _auth.currentUser.uid;
  }


  @override
  void didChangeDependencies() async{
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    currentUserName = Provider.of<Data>(context, listen: true).userName;
    group = Provider.of<Data>(context, listen: true).group;
  }



  @override
  Widget build(BuildContext context) {
    if(circle){
      return ModalProgressHUD(
        inAsyncCall: _saving,
        child: Scaffold(
          appBar: AppBar(
            title: Text('Change to new user name'),
          ),
          body: Container(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 0),
              child: Column(
                children: <Widget>[
                  SizedBox(
                    height: 24.0,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(width: 10,),
                      Expanded(
                        child: Text('Current User Name :' + currentUserName,
                          style: TextStyle(
                            fontSize: 22,
                          ),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(
                    height: 15.0,
                  ),
                  TextField(
                      controller: _text2,
                      onChanged: (value) {
                        newUserName = value;
                      },
                      decoration: kInputDecoration.copyWith(
                        hintText: 'Input new user name',
                        errorText: _validate2 ? "Value can't be empty": null,
                      )
                  ),

                  SizedBox(
                    height: 24.0,
                  ),
                  // Row(
                  //   children: <Widget>[
                  //     Icon(
                  //       Icons.warning,
                  //       color: Colors.greenAccent,
                  //       size: 30.0,
                  //     ),
                  //     Text(' if you change your data...')
                  //   ],
                  // ),
                  // Container(
                  //   child: Text(
                  //       'Doing so will permanently delete the data at this app, including all nested Remember and Complete.'
                  //   ),
                  // ),
                  DeleteButton(color: Colors.grey, text: 'Change',
                    function: ()async{
                      setState(() {
                        _text2.text.isEmpty ? _validate2 = true : _validate2 = false;
                      });

                      if(_validate2 == false){
                        setState(() {
                          _saving = true;
                        });
                        //group内でuserNameの重複が発生しないか判定
                        createFireBaseGroupRead();
                        if(! await fireBaseGroupRead.checkUserNameInGroup(newUserName)){
                        //  含まれていなかった場合
                          //  オブジェクトの作成
                          createFireBaseDeleteUpdate();
                          //userNameの更新
                          await fireBaseDeleteUpdate.updateUserName1(newUserName);
                          await fireBaseDeleteUpdate.updateUserName2(newUserName);
                          //chatのuserNameを全て更新(uidで判定)
                          await fireBaseDeleteUpdate.updateChatUserName(newUserName);
                          //rememberのlistOfRememberPeople内にあるuserNameを全て更新
                          await fireBaseDeleteUpdate.updateUserNameInListOfRememberPeople(newUserName,currentUserName);

                          RestartWidget.restartApp(context);
                        }else{
                          //含まれていた場合
                          createSnackBar(context, 'This user name is already exists.');
                        }





                        setState(() {
                          _saving = false;
                        });


                      }



                    },
                  )
                ],
              ),
            ),
          ),
        ),
      );
    } else{
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
  DeleteButton({this.text, this.color, this.function});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap:function,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Material(
            color: color,
            borderRadius: BorderRadius.all(Radius.circular(30)),
            child: Container(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                child: Text(text,
                  style: TextStyle(fontSize: 25),),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

