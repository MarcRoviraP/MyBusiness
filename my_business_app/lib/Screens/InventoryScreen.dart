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
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: loadInfo(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
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
    var value = await Utils().getCategories();
    listaCategorias = value.map((e) => Categoria.fromJson(e)).toList();

    var value2 = await Utils().getProducts();
    productos = value2.map((e) {
      Producto producto = Producto.fromJson(e);
      producto.cantidad = e["inventario_producto"][0]["cantidad"];
      return producto;
    }).toList();
    
  }

  void createPDF() async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Center(
            child: pw.Table(
              border: pw.TableBorder.all(color: PdfColors.black),
              children: [
                pw.TableRow(
                  decoration: pw.BoxDecoration(color: PdfColors.grey300),
                  children: [
                    pw.Text(
                      LocaleKeys.InventoryScreen_category.tr(),
                      style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                    ),
                    pw.Text(
                      LocaleKeys.InventoryScreen_name.tr(),
                      style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                    ),
                    pw.Text(
                      LocaleKeys.InventoryScreen_price.tr(),
                      style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                    ),
                    pw.Text(
                      LocaleKeys.InventoryScreen_quantity.tr(),
                      style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                    ),
                    pw.Text(
                      LocaleKeys.InventoryScreen_precio_total.tr(),
                      style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                    ),
                  ],
                ),
                ...productos.map((producto) {
                  return pw.TableRow(
                    children: [
                      pw.Text(
                        listaCategorias
                            .firstWhere((categoria) =>
                                categoria.id_categoria == producto.id_categoria)
                            .nombre,
                      ),
                      pw.Text(producto.nombre),
                      pw.Text(producto.precio.toStringAsFixed(2),
                          textAlign: pw.TextAlign.right),
                      pw.Text(producto.cantidad.toString(),
                          textAlign: pw.TextAlign.center),
                      pw.Text(
                        (producto.precio * producto.cantidad).toString(),
                        textAlign: pw.TextAlign.right,
                      ),
                    ],
                  );
                }),
              ],
            ),
          );
        },
      ),
    );

    DateTime now = DateTime.now();
    String formattedDate =
        "${now.year}_${now.month}_${now.day}_${now.hour}_${now.minute}_${now.second}";
    String fileName = "Inv_${formattedDate}.pdf";
    final file = File("/storage/emulated/0/Download/$fileName");

    await file.writeAsBytes(await pdf.save());
    mostrarNotificacion(
        titulo: LocaleKeys.InventoryScreen_download.tr(), cuerpo: fileName);
  }
}
