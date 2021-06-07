import 'package:friends_english_app/components/components.dart';
import 'package:friends_english_app/components/firebase_count_read.dart';
import 'package:friends_english_app/components/firebase_delete_update.dart';
import 'package:friends_english_app/components/firebase_group_read.dart';
import 'package:friends_english_app/components/firebase_register.dart';
import 'package:friends_english_app/components/firebase_user_read.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../components/change_notifier.dart';
import '../../main.dart';



class SettingChangeToExistingGroupPage extends StatefulWidget {
  static const routeName = '/SettingChangeToExistingGroupPage';

  @override
  _SettingChangeToExistingGroupPageState createState() => _SettingChangeToExistingGroupPageState();
}

class _SettingChangeToExistingGroupPageState extends State<SettingChangeToExistingGroupPage> {
  final _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  bool circle = true;

  String currentGroup;
  String currentGroupPassword;

  String existingGroup;
  String existingGroupPassword;

  String userName;
  String userId;


  final _text2 = TextEditingController();
  bool _validate2 = false;
  final _text3 = TextEditingController();
  bool _validate3 = false;
  final _text4 = TextEditingController();
  bool _validate4 = false;

  bool _saving = false;


  FireBaseGroupRead fireBaseCurrentGroupRead;
  FireBaseGroupRead fireBaseExistingGroupRead;
  FireBaseUserRead fireBaseUserRead;
  FireBaseUserRegister fireBaseUserRegister;
  FireBaseDeleteUpdate fireBaseDeleteUpdate;
  FireBaseCountRead fireBaseCountRead;


  void createCurrentFireBaseGroupRead(){
    fireBaseCurrentGroupRead = FireBaseGroupRead(firestore: _firestore, group: currentGroup);
  }
  void createExistingFireBaseGroupRead(){
    fireBaseExistingGroupRead = FireBaseGroupRead(firestore: _firestore, group: existingGroup);
  }
  void createFireBaseUserRead(){
    fireBaseUserRead  =  FireBaseUserRead(firestore: _firestore, currentUserId: userId); 
  }
  void createFireBaseUserRegister(){
    fireBaseUserRegister = FireBaseUserRegister(
      firestore: _firestore,
      group: existingGroup,
      userName: userName,
      userId: userId,
    );
  }
  void createFireBaseDeleteUpdate(){
    fireBaseDeleteUpdate = FireBaseDeleteUpdate(
        firestore: _firestore, group: currentGroup, uid: userId,
      userName: userName,
    );
  }
  void createFireBaseCountRead(){
    fireBaseCountRead = FireBaseCountRead(firestore: _firestore, group: currentGroup);
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
    userId = _auth.currentUser.uid;
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();

    currentGroup = Provider.of<Data>(context, listen: true).group;
    userName = Provider.of<Data>(context, listen: true).userName;
  }



  @override
  Widget build(BuildContext context) {
    if (circle) {
      return ModalProgressHUD(
        inAsyncCall: _saving,
        child: Scaffold(
          appBar: AppBar(
            title: Text('Change to existing group'),
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
                      Text('Current Group Name :  ' + currentGroup.toString(),
                        style: TextStyle(
                          fontSize: 22,
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
                        currentGroupPassword = value;
                      },
                      decoration: kInputDecoration.copyWith(
                        hintText: 'Input your current group password',
                        errorText: _validate2 ? "Value can't be empty": null,
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
                      controller: _text3,
                      onChanged: (value) {
                        existingGroup = value;
                      },
                      decoration: kInputDecoration.copyWith(
                        hintText: 'Input existing group name',
                        errorText: _validate3 ? "Value can't be empty": null,
                      )
                  ),
                  SizedBox(
                    height: 8.0,
                  ),
                  TextField(
                      controller: _text4,
                      onChanged: (value) {
                        existingGroupPassword = value;
                      },
                      decoration: kInputDecoration.copyWith(
                        hintText: 'Input existing group password',
                        errorText: _validate4 ? "Value can't be empty": null,
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
                  //     Text(' if you change your group data...')
                  //   ],
                  // ),
                  // Container(
                  //   child: Text(
                  //       'Doing so will permanently delete your the data at this app, including all nested Remember and Complete.'
                  //   ),
                  // ),
                  DeleteButton(color: Colors.grey, text: 'Change',
                    function: ()async{
                      setState(() {
                        _text2.text.isEmpty ? _validate2 = true : _validate2 = false;
                        _text3.text.isEmpty ? _validate3 = true : _validate3 = false;
                        _text4.text.isEmpty ? _validate4 = true : _validate4 = false;
                      });

                      if(
                          _validate2 == false &&
                          _validate3 == false &&
                          _validate4 == false
                      ){
                        setState(() {
                          _saving = true;
                        });
                        
                        //オブジェクトの作成
                        createCurrentFireBaseGroupRead();
                        createExistingFireBaseGroupRead();
                        createFireBaseUserRead();

                          //  currentGroupPasswordの判定
                          if(await fireBaseCurrentGroupRead.checkDocumentGroupNamePassword(currentGroupPassword)){
                            //  passwordが合っている場合
                            // existingGroupの判定
                            if(await fireBaseExistingGroupRead.checkGroup()){
                              //  group名が存在している場合
                              if(await fireBaseExistingGroupRead.checkDocumentGroupNamePassword(existingGroupPassword)){
                                //  passwordが合っている場合
                                print('everything is correct!!');

                                //オブジェクトの作成
                                createFireBaseUserRegister();
                                createFireBaseDeleteUpdate();
                                createFireBaseCountRead();
                                //existingGroupにuserを追加
                                await fireBaseUserRegister.groupUserAdd();
                                //currentGroupからuserを除去
                                await fireBaseDeleteUpdate.deleteUserFromGroup();
                                //users-uid-['group']の値を更新
                                await fireBaseDeleteUpdate.updateUserGroupName(existingGroup);
                              //  currentGroupのnumberOfPeopleを更新
                                await fireBaseCountRead.countDocumentsNumberOfPeople(context);
                              // currentGroupのrememberのlistOfRememberPeopleの全てからuserを除去
                                await fireBaseDeleteUpdate.deleteUserAllFromListOfRememberPeople();
                              // currentGroupのrememberのWhetherSameNumberを全ての値に対して実行
                                await fireBaseDeleteUpdate.updateAllWhetherSameNumber(context);

                                RestartWidget.restartApp(context);


                              }else{
                                //  passwordが間違っている場合
                                createSnackBar(context, 'This existing group password is wrong');
                              }

                            }else{
                              //  group名が存在していない場合
                              createSnackBar(context, 'This existing group name is wrong');
                            }
                            
                          }else{
                            //  passwordが間違っている場合
                            createSnackBar(context, 'This current group password is wrong');
                          }



                      
                        setState(() {
                          _saving = false;
                        });
                      }

                    },
                  ),
                ],
              ),
            ),
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

