import 'dart:io';
import 'package:flutter/material.dart';
import 'package:formvalidation/src/model/product_model.dart';
import 'package:formvalidation/src/services/product_provider.dart';
import 'package:formvalidation/src/util/utils.dart' as utils;
import 'package:image_picker/image_picker.dart';

class ProductPage extends StatefulWidget {

  @override
  _ProductPageState createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {

  final productProvider = new ProductPrvider();

  final formKey = GlobalKey<FormState>();

  final scaffoldkey = GlobalKey<ScaffoldState>();

  bool _saved = false;

  File photo;

  ProductModel product = new ProductModel();

  @override
  Widget build(BuildContext context) {

    final ProductModel prodData = ModalRoute.of(context).settings.arguments;
    if (prodData != null){
      product = prodData;
    }

    return Scaffold(
      key: scaffoldkey,
      appBar: AppBar(
        title: Text('productos'),
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.photo_size_select_actual),
              onPressed: _selectPhoto
              ),

          IconButton(
              icon: Icon(Icons.camera_alt),
              onPressed: _getPhoto
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(15),
          child: Form(
            key: formKey,
              child: Column(
                children: <Widget>[
                  _showphoto(),
                  _name(),
                  _price(),
                  _avaible(),
                  SizedBox(height: 20,),
                  _buttom(),
                ],
              ),
          ),
        ),
      ),
    );
  }

 Widget _name() {
    return TextFormField(
      initialValue: product.titulo,
      textCapitalization: TextCapitalization.sentences,
      decoration: InputDecoration(
        labelText: 'Producto',
      ),
      onSaved: (value) => product.titulo = value,
      validator: (value){
        if(value.length < 3){
          return 'Ingrese el nombre del producto';
        }else{
          return null;
        }
      },

    );
 }

 Widget _price() {
   return TextFormField(
     initialValue: product.valor.toString(),
     keyboardType: TextInputType.numberWithOptions(decimal: true),
     decoration: InputDecoration(
       labelText: 'Precio',
     ),
     onSaved: (value) => product.valor = double.parse(value),
     validator: (value){
       if( utils.isNumeric(value)){
         return null;
       }else{
         return 'Solo numeros';
       }
     },

   );
 }

 Widget _buttom() {
    return RaisedButton.icon(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      color: Colors.deepPurple,
      textColor: Colors.white,
      label: Text('Guardar'),
      icon: Icon(Icons.save),
      onPressed: (_saved) ? null : _submit,
    );
 }

 void _submit() async{



    if (!formKey.currentState.validate()) return;

    formKey.currentState.save();//esto dispara los onSave para hacer el guardado de los datos

    setState(() { _saved = true; });

    if (photo != null){

     product.fotoUrl = await productProvider.uploadImage(photo);
     print(product.fotoUrl);
    }


    if (product.id == null) {
      productProvider.createProduct(product);
    }else{
      productProvider.EditProduct(product);
    }


    showSnackbar('Registro Guardado');
    //Navigator.pop(context);
 }

 Widget _avaible() {
    return SwitchListTile(
      value: product.disponible,
      title: Text('Disponible'),
      activeColor: Colors.deepPurple,
      onChanged: (value) => setState((){
        product.disponible = value;
      }),
    );
 }

 void showSnackbar( String message){
    final snackbar = SnackBar(
      content: Text(message),
       duration: Duration(seconds: 2),
    );

    scaffoldkey.currentState.showSnackBar(snackbar);

 }

 _showphoto (){

    if(product.fotoUrl != null){
      return FadeInImage(
          placeholder: AssetImage('assets/jar-loading.gif'),
          image: NetworkImage(product.fotoUrl),
        height: 300.0,
        fit: BoxFit.cover,
      );
    }else{

      if( photo != null ){
        return Image.file(
          photo,
          fit: BoxFit.cover,
          height: 300.0,
        );
      }
      return Image.asset('assets/no-image.png');
    }
 }

  void _selectPhoto() async {
    _imageprocess(ImageSource.gallery);

  }

  _getPhoto() async {
    _imageprocess(ImageSource.camera);
  }

  _imageprocess(ImageSource origin) async{
      photo = await ImagePicker.pickImage(
          source: origin
      );

      if (photo != null) {
        product.fotoUrl = null;//limpieza
      }

    setState(() { });
  }

}





