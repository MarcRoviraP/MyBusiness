import 'package:MyBusiness/Constants/constants.dart';
import 'package:flutter/material.dart';

class ProductsScreen extends StatefulWidget {
  ProductsScreen({super.key});
  List<String> listaCategorias = [
    "Categoria 1",
    "Categoria 2",
    "Categoria 3",
    "Categoria 4",
    "Categoria 5",
    "Categoria 6",
    "Categoria 7",
    "Categoria 8",
    "Categoria 9",
    "iiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiii 10",
  ];

  @override
  State<ProductsScreen> createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  @override
  Widget build(BuildContext context) {
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
                final categoria = widget.listaCategorias[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: FloatingActionButton.extended(
                    onPressed: () {},
                    label: Text(categoria),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          createProduct(context);
        },
        child: Icon(Icons.add),
      ),
    );
  }

  Future<dynamic> createProduct(BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Agregar Producto"),
          content: Column(mainAxisSize: MainAxisSize.min, children: [
            TextField(
              decoration: InputDecoration(labelText: "Nombre del producto"),
            ),
            Autocomplete(
              optionsBuilder: (TextEditingValue textEditingValue) {
                if (textEditingValue.text.isEmpty) {
                  return const Iterable<String>.empty();
                }
                return widget.listaCategorias.where((String option) {
                  return option
                      .toLowerCase()
                      .contains(textEditingValue.text.toLowerCase());
                });
              },
              optionsViewBuilder: (context, onSelected, options) {
                return Container(
                  height: 200,
                  width: double.infinity,
                  padding: EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black),
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: ListView.builder(
                    padding: EdgeInsets.all(8.0),
                    itemCount: options.length,
                    itemBuilder: (context, index) {
                      final option = options.elementAt(index);
                      return ListTile(
                        title: Text(option.toString()),
                        onTap: () {
                          onSelected(option);
                        },
                      );
                    },
                  ),
                );
              },
            )
          ]),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("Cancelar"),
            ),
            TextButton(
              onPressed: () {
                // Lógica para agregar el producto
                Navigator.of(context).pop();
              },
              child: Text("Agregar"),
            ),
          ],
        );
      },
    );
  }
}
