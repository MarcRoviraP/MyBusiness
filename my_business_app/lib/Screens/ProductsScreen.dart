import 'package:MyBusiness/Class/Categoria.dart';
import 'package:MyBusiness/Class/Producto.dart';
import 'package:MyBusiness/Dialog/CreateProducts.dart';
import 'package:MyBusiness/Constants/constants.dart';
import 'package:MyBusiness/generated/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
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
                        child: cardProducts(producto: producto),
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

    if (widget.listaCategorias.isEmpty) return;
    if (currentCategory.isEmpty) {
      currentCategory = widget.listaCategorias[0].id_categoria.toString();
    }
    var value2 = await Utils().getProductsFromCategory(currentCategory);
    widget.listaProductos = value2.map((e) => Producto.fromJson(e)).toList();
  }
}

class cardProducts extends StatefulWidget {
  final Producto producto;
  cardProducts({super.key, required this.producto});
  double tamanyo = 50;
  double cardSize = 150;

  @override
  State<cardProducts> createState() => _cardProductsState();
}

class _cardProductsState extends State<cardProducts> {
  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 200),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 2,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            children: [
              GestureDetector(
                onLongPress: () {
                  setState(() {
                    widget.tamanyo = 150;
                    widget.cardSize = 180;
                  });
                },
                onLongPressUp: () {
                  setState(() {
                    widget.tamanyo = 50;
                    widget.cardSize = 150;
                  });
                },
                child: widget.producto.url_img.isEmpty
                    ? Icon(Icons.shop, size: widget.tamanyo)
                    : ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          "https://cghpzfumlnoaxhqapbky.supabase.co/storage/v1/object/public/products//${widget.producto.url_img}",
                          width: widget.tamanyo,
                          height: widget.tamanyo,
                          fit: BoxFit.cover,
                        ),
                      ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.producto.nombre,
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    SizedBox(height: 4),
                    Text(
                      widget.producto.descripcion,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(color: Colors.grey[700]),
                    ),
                    SizedBox(height: 6),
                    Text(
                      "${widget.producto.precio} ${LocaleKeys.ProductsScreen_moneda.tr()}",
                      style: TextStyle(
                          fontWeight: FontWeight.w500, color: Colors.green),
                    ),
                    SizedBox(height: 4),
                    NumberSpinner(
                        widget: widget, cantidad: widget.producto.cantidad),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class NumberSpinner extends StatefulWidget {
  NumberSpinner({
    super.key,
    required this.widget,
    required this.cantidad,
  });

  final Widget widget;
  int cantidad;

  @override
  State<NumberSpinner> createState() => _NumberSpinnerState();
}

class _NumberSpinnerState extends State<NumberSpinner> {
  late TextEditingController inputNumberController;

  @override
  void initState() {
    super.initState();
    inputNumberController =
        TextEditingController(text: widget.cantidad.toString());
  }

  void _updateCantidad(int delta) {
    setState(() {
      int newValue = widget.cantidad + delta;
      if (newValue < 0) return; // Evita valores negativos
      widget.cantidad = newValue;
      inputNumberController.text = widget.cantidad.toString();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      width: 140,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Theme.of(context).cardColor,
        border: Border.all(
          color: Theme.of(context).secondaryHeaderColor,
          width: 1.2,
        ),
      ),
      child: Row(
        children: [
          _SpinnerButton(
            icon: Icons.remove,
            onTap: () => _updateCantidad(-1),
          ),
          Expanded(
            child: Center(
              child: TextFormField(
                controller: inputNumberController,
                textAlign: TextAlign.center,
                keyboardType: TextInputType.number,
                style: TextStyle(fontSize: 16),
                decoration: InputDecoration(
                  border: InputBorder.none,
                  isCollapsed: true, // <== reduce padding interno
                  contentPadding: EdgeInsets.zero,
                ),
                onChanged: (value) {
                  final parsed = int.tryParse(value);
                  if (parsed != null && parsed >= 0) {
                    setState(() {
                      widget.cantidad = parsed;
                    });
                  }
                },
              ),
            ),
          ),
          _SpinnerButton(
            icon: Icons.add,
            onTap: () => _updateCantidad(1),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    inputNumberController.dispose();
    super.dispose();
  }
}

class _SpinnerButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _SpinnerButton({
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
        ),
        child: Icon(icon,
            size: 20, color: Theme.of(context).textTheme.bodyLarge?.color),
      ),
    );
  }
}
