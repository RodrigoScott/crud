

import 'package:shared_preferences/shared_preferences.dart';

class UserPreferences{
  static final UserPreferences _instance = new UserPreferences._internal();

  UserPreferences._internal();

  factory UserPreferences(){
    return _instance;
  }

  SharedPreferences _save;

  initSave() async{
    this._save = await SharedPreferences.getInstance();
  }

  //SET & GET
  get token{
    return _save.getString('token') ?? '';
  }

  set token (String value){
    _save.setString('token', value);
  }

}