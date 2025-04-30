import 'dart:io';

import 'package:MyBusiness/Class/Categoria.dart';
import 'package:MyBusiness/Class/Producto.dart';
import 'package:MyBusiness/Constants/constants.dart';
import 'package:MyBusiness/generated/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

class Inventoryscreen extends StatefulWidget {
  const Inventoryscreen({super.key});

  @override
  State<Inventoryscreen> createState() => _InventoryscreenState();
}

class _InventoryscreenState extends State<Inventoryscreen> {
  List<Producto> productos = [];
  List<Categoria> listaCategorias = [];
  Map<Categoria, List<Producto>> info = {};
  String simbolo = "";

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: loadInfo(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            return Scaffold(
              appBar: AppBar(
                title: Text(LocaleKeys.BusinessScreen_inventory.tr()),
              ),
              body: Text("DONE"),
              floatingActionButton: FloatingActionButton(
                onPressed: () {
                  createPDF();
                },
                child: Icon(Icons.picture_as_pdf_rounded),
              ),
            );
          }
        });
  }

  Future<void> loadInfo() async {
    info = {};
    var value = await Utils().getCategories();
    listaCategorias = value.map((e) => Categoria.fromJson(e)).toList();

    info = listaCategorias.asMap().map((index, value) {
      return MapEntry(value, []);
    });
    var value2 = await Utils().getProducts();
    productos = value2.map((e) {
      Producto producto = Producto.fromJson(e);
      producto.cantidad = e["inventario_producto"][0]["cantidad"];
      return producto;
    }).toList();
    for (var producto in productos) {
      for (var categoria in listaCategorias) {
        if (producto.id_categoria == categoria.id_categoria) {
          info[categoria]!.add(producto);
        }
      }
    }
  }

  void createPDF() async {
    simbolo = LocaleKeys.ProductsScreen_moneda.tr();
    final pdf = pw.Document(
      theme: pw.ThemeData.withFont(
        base: pw.Font.ttf(
            await rootBundle.load("assets/fonts/Roboto-Regular.ttf")),
        bold:
            pw.Font.ttf(await rootBundle.load("assets/fonts/Roboto-Bold.ttf")),
        italic: pw.Font.ttf(
            await rootBundle.load("assets/fonts/Roboto-Italic.ttf")),
      ),
    );

    DateTime now = DateTime.now();
    String hora = DateFormat('dd/MM/yyyy HH:mm:ss').format(now);
    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        footer: (context) {
          return pw.Container(
              alignment: pw.Alignment.center,
              child: pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text(
                    "${LocaleKeys.InventoryScreen_solicitante.tr()}: ${usuario.nombre} $hora",
                    style: pw.TextStyle(fontSize: 10),
                  ),
                  pw.Text(
                    "${context.pageNumber}",
                    style: pw.TextStyle(fontSize: 10),
                  ),
                ],
              ));
        },
        build: (pw.Context context) {
          return [
            // Nombre de la empresa
            pw.Text(
              empresa.nombre,
              style: pw.TextStyle(
                fontSize: 40,
                fontWeight: pw.FontWeight.bold,
              ),
            ),

            pw.SizedBox(height: 10),
            // Inventario
            pw.Text(
              LocaleKeys.BusinessScreen_inventory.tr(),
              style: pw.TextStyle(
                fontSize: 30,
                fontWeight: pw.FontWeight.bold,
              ),
            ),
            pw.SizedBox(height: 20),
            ...info.entries.map(
              (entry) {
                Categoria categoria = entry.key;
                List<Producto> productos = entry.value;

                return pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    // Título de la categoría
                    pw.Text(
                      categoria.nombre, // Nombre de la categoría
                      style: pw.TextStyle(
                        fontSize: 20,
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                    pw.SizedBox(height: 10),

                    // Encabezados de la tabla
                    pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                      children: [
                        pw.Container(
                          width: 150,
                          child: pw.Text(
                            LocaleKeys.InventoryScreen_name.tr(),
                            textAlign: pw.TextAlign.left,
                            style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                          ),
                        ),
                        pw.Container(
                          width: 100,
                          child: pw.Text(
                            LocaleKeys.InventoryScreen_quantity.tr(),
                            textAlign: pw.TextAlign.left,
                            style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                          ),
                        ),
                        pw.Container(
                          width: 100,
                          child: pw.Text(
                            LocaleKeys.InventoryScreen_price.tr(),
                            textAlign: pw.TextAlign.left,
                            style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                          ),
                        ),
                        pw.Container(
                          width: 100,
                          child: pw.Text(
                            LocaleKeys.InventoryScreen_precio_total.tr(),
                            textAlign: pw.TextAlign.left,
                            style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                    pw.SizedBox(height: 5),

                    // Productos de la categoría
                    ...productos.map((producto) {
                      return pw.Row(
                        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                        children: [
                          pw.Container(
                            width: 150,
                            child: pw.Text(
                              producto.nombre,
                              textAlign: pw.TextAlign.left,
                              style: pw.TextStyle(fontSize: 12),
                            ),
                          ),
                          pw.Container(
                            width: 100,
                            child: pw.Text(
                              producto.cantidad.toString(),
                              textAlign: pw.TextAlign.left,
                              style: pw.TextStyle(fontSize: 12),
                            ),
                          ),
                          pw.Container(
                            width: 100,
                            child: pw.Text(
                              "${producto.precio} $simbolo",
                              textAlign: pw.TextAlign.left,
                              style: pw.TextStyle(fontSize: 12),
                            ),
                          ),
                          pw.Container(
                            width: 100,
                            child: pw.Text(
                              "${(producto.precio * producto.cantidad).toStringAsFixed(2)} $simbolo",
                              textAlign: pw.TextAlign.left,
                              style: pw.TextStyle(fontSize: 12),
                            ),
                          ),
                        ],
                      );
                    }),

                    pw.SizedBox(height: 20),
                  ],
                );
              },
              // Info inventario
            ),
            pw.Text(
              "${LocaleKeys.InventoryScreen_inventory_value.tr()}: ${getInventoryValue()} $simbolo",
              style: pw.TextStyle(
                fontSize: 16,
                fontWeight: pw.FontWeight.bold,
              ),
            ),
          ];
        },
      ),
    );

    String formattedDate =
        "${now.year}_${now.month}_${now.day}_${now.hour}_${now.minute}_${now.second}";
    String fileName = "Inv_$formattedDate.pdf";
    final file = File("/storage/emulated/0/Download/$fileName");

    await file.writeAsBytes(await pdf.save());
    mostrarNotificacion(
        titulo: LocaleKeys.InventoryScreen_download.tr(),
        cuerpo: fileName,
        payload: file.path);
  }

  String getInventoryValue() {
    double total = 0;
    info.forEach((key, value) {
      for (var producto in value) {
        total += producto.precio * producto.cantidad;
      }
    });
    return total.toStringAsFixed(2);
  }
}
