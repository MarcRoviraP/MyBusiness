import 'package:MyBusiness/Class/Categoria.dart';
import 'package:MyBusiness/Class/Producto.dart';
import 'package:MyBusiness/Dialog/CreateProducts.dart';
import 'package:MyBusiness/Constants/constants.dart';
import 'package:flutter/material.dart';

class ProductsScreen extends StatefulWidget {
  ProductsScreen({super.key});
  List<Categoria> listaCategorias = [];
  List<Producto> listaProductos = [];

  @override
  State<ProductsScreen> createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  String currentCategory = "";
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: loadInfo(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else if (snapshot.hasError) {
          return Center(child: Text('Error'));
        } else {
          return Scaffold(
            body: Column(
              children: [
                SizedBox(
                  height: 50,
                  width: double.infinity,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: widget.listaCategorias.length,
                    itemBuilder: (context, index) {
                      Categoria categoria = widget.listaCategorias[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: FloatingActionButton.extended(
                          onPressed: () {
                            setState(() {
                              currentCategory =
                                  categoria.id_categoria.toString();
                            });
                          },
                          label: Text(categoria.nombre),
                        ),
                      );
                    },
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Expanded(
                  child: ListView.builder(
                    scrollDirection: Axis.vertical,
                    itemCount: widget.listaProductos.length,
                    itemBuilder: (context, index) {
                      final producto = widget.listaProductos[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: FloatingActionButton.extended(
                          onPressed: () {},
                          label: Text(producto.nombre),
                        ),
                      );
                    },
                  ),
                )
              ],
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    return Createproducts(
                      listaCategorias:
                          widget.listaCategorias.map((e) => e.nombre).toList(),
                    );
                  },
                );
              },
              child: Icon(Icons.add),
            ),
          );
        }
      },
    );
  }

  Future<void> loadInfo() async {
    var value = await Utils().getCategories();
    widget.listaCategorias = value.map((e) => Categoria.fromJson(e)).toList();

    if (currentCategory.isEmpty) {
      currentCategory = widget.listaCategorias[0].id_categoria.toString();
    }
    var value2 = await Utils().getProductsFromCategory(currentCategory);
    widget.listaProductos = value2.map((e) => Producto.fromJson(e)).toList();
  }
}
