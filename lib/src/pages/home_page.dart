import 'package:flutter/material.dart';
import 'package:formvalidation/src/model/product_model.dart';
import 'package:formvalidation/src/services/product_provider.dart';

class HomePage extends StatelessWidget {

  final productProvider = new ProductPrvider();

  @override
  Widget build(BuildContext context) {


    return Scaffold(
      appBar: AppBar(
        title: Text('Productos'),
      ),
      body: _createListing(),
      floatingActionButton: _bottom(context),
    );
  }

  _bottom(BuildContext context) {

    return FloatingActionButton(
      backgroundColor: Colors.deepPurple,
      child: Icon(Icons.add),
        onPressed: () => Navigator.pushNamed(context, 'product')
        );

  }

 Widget _createListing() {
    return FutureBuilder(
        future: productProvider.LoadData(),
        builder: (BuildContext context, AsyncSnapshot<List<ProductModel>> snapshot){
          if (snapshot.hasData){

            final products = snapshot.data;

            return ListView.builder(
                itemCount: products.length,
                itemBuilder: (context, i) => _createItem(context, products[i]),
            );
          }else{
            return Center(child: CircularProgressIndicator(),);
          }


        },
    );

 }

 Widget _createItem(BuildContext context, ProductModel product){
    return Dismissible(
      key: UniqueKey(),
      background: Container(
        color: Colors.red,
      ),
      onDismissed: (Direccion){
        //TODO: Borrar producto
        productProvider.DeleteProduct(product.id);
      },
      child: Card(
        child: Column(
          children: <Widget>[
            (product.fotoUrl == null)
                ? Image(image: AssetImage('assets/no-image.png'))
                : FadeInImage(
                    image: NetworkImage(product.fotoUrl),
                    placeholder: AssetImage('assets/jar-loading.gif'),
                    height: 300.0,
                    width: double.infinity,
                    fit: BoxFit.cover,
            ),
            ListTile(
              title: Text('${product.titulo } -  ${product.valor }'),
              subtitle: Text(product.id),
              onTap: () => Navigator.pushNamed(context, 'product', arguments: product),
            ),
          ],
        ),
      ),
    );
 }
}