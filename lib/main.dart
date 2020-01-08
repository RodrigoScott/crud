import 'package:flutter/material.dart';
import 'package:formvalidation/src/blocs/provider.dart';
import 'package:formvalidation/src/pages/home_page.dart';
import 'package:formvalidation/src/pages/login_page.dart';
import 'package:formvalidation/src/pages/product_page.dart';
import 'package:formvalidation/src/pages/register_page.dart';
import 'package:formvalidation/src/pages/user_preferences.dart';


void main() async{

  WidgetsFlutterBinding.ensureInitialized();
  final save = new UserPreferences();
  await save.initSave();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  

  @override
  Widget build(BuildContext context) {
    final prefs = new UserPreferences();
    
    print(prefs.token);

    return Provider(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Form Validation',
        initialRoute: 'login',
        routes: {
          'login'           : (BuildContext context) => loginPage(),
          'home'            : (BuildContext context) => HomePage(),
          'product'         : (BuildContext context) => ProductPage(),
          'register'        : (BuildContext context) => registerPage(),
        },
        theme: ThemeData(
          primaryColor: Colors.deepPurple
        ),
      ),
    );
  }
}