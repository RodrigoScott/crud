

import 'package:flutter/material.dart';

bool isNumeric (String s){

  if (s.isEmpty) return false;

  final n = num.tryParse(s);

  return (n == null) ? false : true;
}

void alerts (BuildContext context, String message){
  showDialog(
      context: context,
     builder: (context){
        return AlertDialog(
          title: Text('Información Incorrecta'),
          content: Text(message),
          actions: <Widget>[
            FlatButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text('Ok'),
            )
          ],
        );
     }
  );
}