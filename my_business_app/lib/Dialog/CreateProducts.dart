import 'dart:io';
import 'dart:math';

import 'package:MyBusiness/Constants/constants.dart';
import 'package:MyBusiness/generated/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:wc_form_validators/wc_form_validators.dart';

class Createproducts extends StatefulWidget {
  List<String> listaCategorias;
  Createproducts({super.key, required this.listaCategorias});

  @override
  State<Createproducts> createState() => _CreateproductsState();
}

class _CreateproductsState extends State<Createproducts> {
  XFile? picture;
  TextEditingController productNameController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController categoryController = TextEditingController();
  TextEditingController priceController = TextEditingController();

  GlobalKey<FormFieldState> nameKey = GlobalKey<FormFieldState>();
  GlobalKey<FormFieldState> priceKey = GlobalKey<FormFieldState>();
  GlobalKey<FormFieldState> categoryKey = GlobalKey<FormFieldState>();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(LocaleKeys.CreateProducts_add_product.tr()),
      content: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          IconButton(
            onPressed: () {
              takePhoto().then((value) {
                picture = value;
                setState(() {
                  picture;
                });
              });
            },
            icon: picture == null
                ? Icon(Icons.add_a_photo, size: 100)
                : Image.file(
                    File(picture!.path),
                    width: 100,
                    height: 100,
                    fit: BoxFit.cover,
                  ),
          ),
          SizedBox(
            height: 30,
            child: FloatingActionButton.extended(
              onPressed: () {
                takePhotoGallery().then((value) {
                  picture = value;
                  setState(() {
                    picture;
                  });
                });
              },
              label: Text(LocaleKeys.ProductsScreen_add_gallery.tr()),
            ),
          ),
          TextFormField(
            key: nameKey,
            validator:
                Validators.required(LocaleKeys.Register_required_field.tr()),
            controller: productNameController,
            decoration: InputDecoration(
                labelText: LocaleKeys.ProductsScreen_product_name.tr()),
          ),
          SizedBox(
            height: 10,
          ),
          TextField(
            controller: descriptionController,
            decoration: InputDecoration(
                labelText: LocaleKeys.CreateProducts_description.tr()),
          ),
          SizedBox(
            height: 10,
          ),
          TextFormField(
            key: priceKey,
            validator: Validators.compose([
              Validators.required(LocaleKeys.Register_required_field.tr()),
              Validators.patternString(r'^[0-9]+(\.[0-9]{1,2})?$',
                  LocaleKeys.CreateProducts_invalid_price.tr()),
            ]),
            controller: priceController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
                labelText: LocaleKeys.CreateProducts_price.tr()),
          ),
          SizedBox(
            height: 10,
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
            fieldViewBuilder: (BuildContext context,
                TextEditingController textEditingController,
                FocusNode focusNode,
                VoidCallback onFieldSubmitted) {
              categoryController = textEditingController;
              return TextFormField(
                controller: textEditingController,
                focusNode: focusNode,
                key: categoryKey,
                validator: Validators.required(
                    LocaleKeys.Register_required_field.tr()),
                // onSubmitted: (String value) => onFieldSubmitted(),
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.search),
                  labelText: LocaleKeys.CreateProducts_category.tr(),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                ),
              );
            },
            optionsViewBuilder: (context, onSelected, options) {
              return Material(
                color: Theme.of(context).colorScheme.surface,
                elevation: 4.0,
                borderRadius: BorderRadius.circular(8),
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      maxHeight: 200.0,
                    ),
                    child: ListView.builder(
                      padding: const EdgeInsets.all(8.0),
                      itemCount: options.length,
                      itemBuilder: (context, index) {
                        final option = options.elementAt(index);
                        return ListTile(
                          title: Text(option.toString(),
                              style: TextStyle(
                                  color:
                                      Theme.of(context).colorScheme.onSurface)),
                          onTap: () => onSelected(option),
                        );
                      },
                    ),
                  ),
                ),
              );
            },
          ),
          SizedBox(
            height: 10,
          ),
        ]),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text(LocaleKeys.CreateProducts_cancel.tr()),
        ),
        TextButton(
          onPressed: () {
            agregarProducto();
          },
          child: Text(LocaleKeys.CreateProducts_add.tr()),
        ),
      ],
    );
  }

  Future<XFile?> takePhoto() async {
    XFile? picture = await ImagePicker().pickImage(source: ImageSource.camera);

    return picture;
  }

  Future<XFile?> takePhotoGallery() async {
    XFile? picture = await ImagePicker().pickImage(source: ImageSource.gallery);
    return picture;
  }

  Future<void> agregarProducto() async {
    if (nameKey.currentState!.validate() &&
        priceKey.currentState!.validate() &&
        categoryKey.currentState!.validate()) {
      String nombre = productNameController.text;
      String descripcion = descriptionController.text;
      String categoria = categoryController.text;
      String precio = priceController.text;
      String name = "";
      if (picture != null) {
        name = DateTime.now().millisecondsSinceEpoch.toString() +
            productNameController.text +
            ".jpg";
        await uploadImage(File(picture!.path), name);
      }
      int id_categoria = 0;
      var response = await Utils().getCategory(categoria);
      if (response.isEmpty) {
        var responses = await Utils().insertInTable(
            {'nombre': categoria, 'id_empresa': empresa.id_empresa},
            "categorias");

        id_categoria = responses[0]['id_categoria'];
      } else {
        id_categoria = response[0]['id_categoria'];
      }

      var response2 = await Utils().insertInTable({
        'nombre': nombre,
        'descripcion': descripcion,
        'precio': precio,
        'url_img': name,
        'id_empresa': empresa.id_empresa,
        'id_categoria': id_categoria,
      }, "productos");
      if (response2.isEmpty) {
        customErrorSnackbar(LocaleKeys.CreateProducts_error.tr(), context);
      } else {
        Navigator.of(context).pop();
        customSuccessSnackbar(LocaleKeys.CreateProducts_succes.tr(), context);
      }
    }
  }
}
