import 'dart:convert';
import 'dart:io';
import 'package:formvalidation/src/pages/user_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:mime_type/mime_type.dart';
import 'package:formvalidation/src/model/product_model.dart';

class ProductPrvider{

  final String _url = 'https://flutter-varios-3121f.firebaseio.com';
  final _prefs = new UserPreferences();


  //CREAR PRODUCTOS

  Future<bool> createProduct (ProductModel product) async{

    final url = '$_url/productos.json?auth=${_prefs.token}';

    final resp = await http.post(url, body: productoModelToJson(product));

    final decodedData = json.decode(resp.body);

    print(decodedData);

    return true;

  }

  //MODIFICAR PRODUCTO

  Future<bool> EditProduct (ProductModel product) async{

    final url = '$_url/productos/${product.id}.json?auth=${_prefs.token}';

    final resp = await http.put(url, body: productoModelToJson(product));

    final decodedData = json.decode(resp.body);

    print(decodedData);

    return true;

  }



  //MOSTRAR INFORMACION DE LA BASE DE DATOS

  Future<List<ProductModel>> LoadData() async{

    final url = '$_url/productos.json?auth=${_prefs.token}';
    final resp = await http.get(url);

    final Map<String, dynamic> decodedData = json.decode(resp.body);

    final List<ProductModel> product = new List();

    if (decodedData == null) return [];
    decodedData. forEach((id, prod){

      final prodTemp = ProductModel.fromJson(prod);
      prodTemp.id = id;

      product.add(prodTemp);

    });

    return product;

  }

  //ELIMINAR LOS REGISTROS
Future<int> DeleteProduct(String id) async{

  final url = '$_url/productos/$id.json?auth=${_prefs.token}';

  final resp = await http.delete(url);

  print (json.decode(resp.body));

return 1;
}

Future<String>uploadImage(File image)async{
    final url = Uri.parse('https://api.cloudinary.com/v1_1/dwjbwlqhu/image/upload?upload_preset=eepagpu1');
    final mimeType = mime(image.path).split('/');//image/jpg

    final imageUploadRequest = http.MultipartRequest(
        'POST',
        url
    );

    final file = await http.MultipartFile.fromPath(
        'file',
        image.path,
      contentType: MediaType(mimeType[0],mimeType[1]),
    );

    imageUploadRequest.files.add(file);

    final streamResponse = await imageUploadRequest.send();
    final resp = await http.Response.fromStream(streamResponse);

    if (resp.statusCode != 200 && resp.statusCode !=201){
      print('ALgo slio mal');
      print(resp.body);
      return null;
    }

    final respData = json.decode(resp.body);
    print(respData);

    return respData['secure_url'];

}


}