import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:formvalidation/src/blocs/provider.dart';
import 'package:formvalidation/src/services/user_provider.dart';
import 'package:formvalidation/src/util/utils.dart';

class loginPage extends StatelessWidget {

  final UserProvider = new userProvider();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          _background(context),
          _loginForm(context),
        ],
      )
    );
  }

 Widget _background(BuildContext context) {
    
    final size = MediaQuery.of(context).size; //tomar el valor total de la pantalla para hacer el fondo dinámico
    final back = Container(
      height: size.height *0.4,
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
            colors: <Color>[
              Color.fromRGBO(63, 63, 156, 1.0), Color.fromRGBO(90, 70, 178, 1.0)
            ]
        ),
      ),
    );
    
    final circle = Container(
      width: 100,
      height: 100,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(100),
        color: Color.fromRGBO(250, 250, 250, 0.2),
      ),
    );

    return Stack(
      children: <Widget>[
        back,
       // Positioned(top: 90, left: 50, child: circle),
        Positioned(top: -70, left: 250, child: circle),
        Positioned(top: 120, right: -50, child: circle),
        Positioned(top: 220, left: 100, child: circle),
        Positioned(top: 40, left: 30, child: circle),

        Container(
          padding: EdgeInsets.only(top: 50),
          child: Column(
            children: <Widget>[
              Icon(Icons.person_pin_circle, color: Colors.white, size: 100,),
              SizedBox(height: 10, width: double.infinity,),
              Text('Rodrigo Scott', style: TextStyle(color: Colors.white, fontSize: 20,),)
            ],
          ),
        ),
      ],
    );

 }

 Widget _loginForm(BuildContext context) {

    final bloc = Provider.of(context);
    final size = MediaQuery.of(context).size;

    return SingleChildScrollView(

      child: Column(
        children: <Widget>[

          SafeArea(
              child: Container(
                height: 175,
              ),
          ),

          Container(
            width: size.width *0.7,
            padding: EdgeInsets.symmetric(vertical: 30),
            margin: EdgeInsets.symmetric(vertical: 10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(5.0),
              boxShadow: <BoxShadow>[
                BoxShadow(
                  color: Colors.black12,
                  offset: Offset(0.0, 2.0),
                  spreadRadius: 2.0,
                  blurRadius: 5.0,
                )
              ]
            ),
            child: Column(
              children: <Widget>[
                Text('Ingreso', style:  TextStyle(fontSize: 20.0),),
                SizedBox(height: 20,),
                _email( bloc ),
                SizedBox(height: 20,),
                _password( bloc ),
                SizedBox(height: 20,),
                _buttom( bloc ),

              ],
            ),
          ),
          FlatButton(
              child: Text('¿No tienes cuenta? Registrate', style: TextStyle(color: Colors.blue),),
            onPressed: () => Navigator.pushReplacementNamed(context, 'register'),
          ),
          SizedBox(height: 80,),
        ],
      ),


    );
 }

 Widget _email(LoginBloc bloc) {


    return StreamBuilder(

        stream: bloc.getemailStream,

        builder: (BuildContext context, AsyncSnapshot snapshot){

          return Container(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: TextField(
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                  icon: Icon(Icons.alternate_email, color: Colors.deepPurple,),
                  hintText: 'ejemplo@correo.com',
                  labelText: 'Correo electronico',
                  counterText: snapshot.data,
                  errorText: snapshot.error,
              ),
              onChanged: bloc.getChangeEmail,
            ),
          );

        },
    );


 }

  Widget _password(LoginBloc bloc) {

    return StreamBuilder(

        stream: bloc.getpaswordStream,

        builder: (BuildContext context, AsyncSnapshot snapshot){
          return Container(
           padding: EdgeInsets.symmetric(horizontal: 20),
            child: TextField(
             obscureText: true,
              decoration: InputDecoration(
               icon: Icon(Icons.lock, color: Colors.deepPurple,),
               labelText: 'Password',
                errorText: snapshot.error,
             ),
              onChanged: bloc.getChangePassword,
            ),
          );
       },
    );


  }

  Widget _buttom(LoginBloc bloc){

    return StreamBuilder(
      stream: bloc.formValidStream,
      builder: (BuildContext context, AsyncSnapshot snapshot){
        return RaisedButton(
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 15, horizontal: 50),

              child: Text('Ingresar'),
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5.0),
            ),
            //elevation: 0.0,
            color: Colors.deepPurple,
            textColor: Colors.white,
            onPressed: snapshot.hasData ? () => _login( bloc, context ) : null
        );
      },
    );

  }

   _login(LoginBloc bloc, BuildContext context) async{
      Map info = await UserProvider.login(bloc.email, bloc.password);
      if (info['ok']){
        Navigator.pushReplacementNamed(context, 'home');
      }else{
        alerts(context,info['mensaje']);
      }

    //Navigator.pushReplacementNamed(context, 'home');
  }

}
