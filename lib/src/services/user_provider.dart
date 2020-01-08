
import 'dart:convert';

import 'package:formvalidation/src/pages/user_preferences.dart';
import 'package:http/http.dart' as http;



class userProvider{

  final String _fireBaseToken = 'AIzaSyCGgfYelEMro8XLwsvCyeGXdQm2PlW8v7c';
  final _prefs = new UserPreferences();

  Future<Map<String, dynamic>> login(String email, String password) async{
    final authData = {
      'email'             : email,
      'password'          : password,
      'returnSecureToken' : true,
    };

    final resp = await http.post('https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=$_fireBaseToken',body: json.encode(authData));

    Map<String, dynamic> decodedResp = json.decode(resp.body);

    print(decodedResp);

    if (decodedResp.containsKey('idToken')){

      _prefs.token = decodedResp['idToken'];

      return {'ok': true, 'token': decodedResp['idToken']};

    }else{

      return {'ok': true, 'mensaje': decodedResp['message']};

    }




  }

  Future<Map<String, dynamic>> newUser(String email, String password) async{
    final authData = {
      'email'             : email,
      'password'          : password,
      'returnSecureToken' : true,
    };

    final resp = await http.post('https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=$_fireBaseToken',body: json.encode(authData));

    Map<String, dynamic> decodedResp = json.decode(resp.body);

    print(decodedResp);

    if (decodedResp.containsKey('idToken')){

      _prefs.token = decodedResp['idToken'];

      return {'ok': true, 'token': decodedResp['idToken']};

    }else{

      return {'ok': true, 'mensaje': decodedResp['message']};
    }



  }


}