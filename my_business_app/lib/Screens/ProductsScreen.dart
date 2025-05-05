import 'package:MyBusiness/Class/Categoria.dart';
import 'package:MyBusiness/Class/Producto.dart';
import 'package:MyBusiness/Dialog/CreateProducts.dart';
import 'package:MyBusiness/Constants/constants.dart';
import 'package:MyBusiness/Dialog/ShowImage.dart';
import 'package:MyBusiness/generated/locale_keys.g.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class ProductsScreen extends StatefulWidget {
  ProductsScreen({super.key});
  List<Categoria> listaCategorias = [];
  List<Producto> listaProductos = [];
  List<Producto> listaProductosAux = [];

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
          return SpinKitWave(
            color: Theme.of(context).colorScheme.primary,
            size: 50.0,
          );
        } else if (snapshot.hasError) {
          return Center(child: Text('Sin productos disponibles'));
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
                          heroTag: categoria.id_categoria.toString(),
                          backgroundColor: currentCategory ==
                                  categoria.id_categoria.toString()
                              ? Theme.of(context).colorScheme.primaryFixedDim
                              : Theme.of(context).colorScheme.secondaryFixedDim,
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
                        child: cardProducts(
                          producto: producto,
                          onCantidadChanged: (nuevaCantidad) {
                            if (nuevaCantidad < 0) {
                              Utils().deleteCategory(currentCategory).then((_) {
                                setState(() {
                                  widget.listaProductos.removeAt(index);
                                  widget.listaProductosAux.removeAt(index);
                                });
                              });
                            }
                            producto.cantidad = nuevaCantidad;
                            widget.listaProductos[index] = producto;
                          },
                        ),
                      );
                    },
                  ),
                )
              ],
            ),
            floatingActionButton: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                FloatingActionButton(
                  hoverColor: Theme.of(context).primaryColor,
                  heroTag: "save",
                  onPressed: () {
                    bool hayCambios = compararListasProductos(
                        widget.listaProductos, widget.listaProductosAux);
                    if (hayCambios) {
                      customErrorSnackbar(
                          LocaleKeys.ProductsScreen_no_changes.tr(), context);
                      return;
                    }
                    widget.listaProductosAux = widget.listaProductos.map((e) {
                      Producto producto = Producto(
                        id_producto: e.id_producto,
                        nombre: e.nombre,
                        descripcion: e.descripcion,
                        precio: e.precio,
                        url_img: e.url_img,
                        id_categoria: e.id_categoria,
                        id_empresa: e.id_empresa,
                      );
                      producto.cantidad = e.cantidad;
                      return producto;
                    }).toList();
                    saveProducts();
                  },
                  child: Icon(Icons.save_sharp),
                ),
                SizedBox(
                  height: 10,
                ),
                FloatingActionButton(
                  heroTag: "add",
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return Createproducts(
                          listaCategorias: widget.listaCategorias
                              .map((e) => e.nombre)
                              .toList(),
                          refresh: () {
                            setState(() {
                              loadInfo();
                            });
                          },
                        );
                      },
                    );
                  },
                  child: Icon(Icons.add),
                ),
              ],
            ),
          );
        }
      },
    );
  }

  void saveProducts() async {
    for (Producto producto in widget.listaProductos) {
      Utils().saveProduct(producto);
    }

    customSuccessSnackbar(LocaleKeys.ProductsScreen_save_product.tr(), context);
  }

  Future<void> loadInfo() async {
    var value = await Utils().getCategories();
    widget.listaCategorias = value.map((e) => Categoria.fromJson(e)).toList();

    if (widget.listaCategorias.isEmpty) return;
    if (currentCategory.isEmpty) {
      currentCategory = widget.listaCategorias[0].id_categoria.toString();
    }
    var value2 = await Utils().getProductsFromCategory(currentCategory);
    widget.listaProductos = value2.map((e) {
      Producto producto = Producto.fromJson(e);
      producto.cantidad = e["inventario_producto"][0]["cantidad"];
      return producto;
    }).toList();
    widget.listaProductosAux = widget.listaProductos.map((e) {
      Producto producto = Producto(
        id_producto: e.id_producto,
        nombre: e.nombre,
        descripcion: e.descripcion,
        precio: e.precio,
        url_img: e.url_img,
        id_categoria: e.id_categoria,
        id_empresa: e.id_empresa,
      );
      producto.cantidad = e.cantidad;
      return producto;
    }).toList();
  }
}

bool compararListasProductos(
    List<Producto> listaProductos, List<Producto> listaProductosAux) {
  for (int index = 0; index < listaProductos.length; index += 1) {
    if (listaProductos[index].cantidad != listaProductosAux[index].cantidad) {
      return false;
    }
  }
  return true;
}

class cardProducts extends StatefulWidget {
  final Producto producto;
  final void Function(int nuevaCantidad) onCantidadChanged;
  cardProducts(
      {super.key, required this.producto, required this.onCantidadChanged});
  double tamanyo = 50;

  @override
  State<cardProducts> createState() => _cardProductsState();
}

class _cardProductsState extends State<cardProducts> {
  @override
  Widget build(BuildContext context) {
    var imageUrl =
        "https://cghpzfumlnoaxhqapbky.supabase.co/storage/v1/object/public/$bucketProducts//${widget.producto.url_img}";
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
                onTap: () {
                  if (widget.producto.url_img.isEmpty) return;
                  showDialog(
                      context: context,
                      builder: (context) {
                        return ShowImage(
                          url: imageUrl,
                        );
                      });
                },
                onLongPress: () {
                  setState(() {
                    widget.tamanyo = 150;
                  });
                },
                onLongPressUp: () {
                  setState(() {
                    widget.tamanyo = 50;
                  });
                },
                child: widget.producto.url_img.isEmpty
                    ? Icon(Icons.shop, size: widget.tamanyo)
                    : ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: CachedNetworkImage(
                          imageUrl: imageUrl,
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
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          NumberSpinner(
                              widget: widget,
                              cantidad: widget.producto.cantidad,
                              onCantidadChanged: (nuevaCantidad) {
                                widget.onCantidadChanged(nuevaCantidad);
                              }),
                          SizedBox(width: 60),
                          IconButton(
                              icon: Icon(Icons.delete),
                              color: Colors.red,
                              onPressed: () {
                                deleteProduct().then((_) {
                                  setState(() {
                                    widget.onCantidadChanged(-1);
                                  });
                                });
                              }),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> deleteProduct() async {
    await Utils().deleteProduct(widget.producto);
  }
}

class NumberSpinner extends StatefulWidget {
  final void Function(int nuevaCantidad) onCantidadChanged;

  NumberSpinner({
    super.key,
    required this.widget,
    required this.cantidad,
    required this.onCantidadChanged,
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

  void _updateCantidad(int cantidad) {
    setState(() {
      int newValue = widget.cantidad + cantidad;
      if (newValue < 0) return;
      widget.cantidad = newValue;
      inputNumberController.text = widget.cantidad.toString();
      widget.onCantidadChanged(widget.cantidad);
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
