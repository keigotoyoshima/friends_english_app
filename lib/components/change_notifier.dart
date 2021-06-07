import 'dart:math';
import 'package:flutter/material.dart';

class Data extends ChangeNotifier{
  String accountOfA;


  String definition = "???";
  String time  = "???";
  String randomStringOfCollectionName = 'remember';
  var historyOfList = [];

  List rememberList = [];
  List completeList = [];


  //全ページ共通部分
  int numberOfPeople;
  int numberOfComplete;
  int numberOfRemember;
  String group;
  String userName;


  void currentNumberOfPeople(int numberOfPeople){
    this.numberOfPeople = numberOfPeople;
    notifyListeners();
  }

  void currentNumberOfComplete(int numberOfComplete){
    this.numberOfComplete = numberOfComplete;
    notifyListeners();
  }

  void currentNumberOfRemember(int numberOfRemember){
    this.numberOfRemember = numberOfRemember;
    notifyListeners();
  }


  void currentGroupName(String group){
    this.group = group;
  }


  void currentUserName(String userName){
    this.userName = userName;
  }


  void changeCollectionName(){
    const _chars = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
    Random _rnd = Random();

    String getRandomString(int length) => String.fromCharCodes(Iterable.generate(
        length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));

    randomStringOfCollectionName = getRandomString(10);
    notifyListeners();
  }




}
