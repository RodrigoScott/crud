

import 'dart:async';
import 'package:rxdart/rxdart.dart';

import 'package:formvalidation/src/blocs/validtors.dart';

class LoginBloc with Validators{
  final _emailController    = BehaviorSubject<String>();
  final _passwordController = BehaviorSubject<String>();

  //datos del stream

  Stream<String> get getemailStream   => _emailController.stream.transform(validateEmail);
  Stream<String> get getpaswordStream => _passwordController.stream.transform(validatePassword);
  Stream<bool>   get formValidStream  => CombineLatestStream.combine2(getemailStream, getpaswordStream, (e, p) => true);


  // GET & SET

  Function (String) get getChangeEmail      => _emailController.sink.add;

  Function (String) get getChangePassword   => _passwordController.sink.add;

  //obtener el último valor ingresado a los streams
String get email => _emailController.value;
String get password => _passwordController.value;


  dispose(){
    _emailController?.close();
    _passwordController?.close();
  }


}