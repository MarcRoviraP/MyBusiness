import 'dart:io';

import 'package:MyBusiness/Constants/constants.dart';
import 'package:MyBusiness/generated/locale_keys.g.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class Editbusinessdialog extends StatefulWidget {
  const Editbusinessdialog({super.key});

  @override
  State<Editbusinessdialog> createState() => _EditbusinessdialogState();
}

class _EditbusinessdialogState extends State<Editbusinessdialog> {
  TextEditingController nameController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  XFile? picture;
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(LocaleKeys.BusinessScreen_edit_business.tr()),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            empresa.url_img != ""
                ? GestureDetector(
                    onTap: () {
                      takePhoto().then((value) {
                        picture = value;
                        setState(() {
                          picture;
                        });
                      });
                    },
                    child: ClipOval(
                      child: picture == null
                          ? CachedNetworkImage(
                              imageUrl: 
                                  "https://$idSupabase.supabase.co/storage/v1/object/public/$bucketBusiness/${empresa.url_img}",
                              width: 200,
                              height: 200,
                              fit: BoxFit.cover,
                              placeholder: (context, url) =>
                                  CircularProgressIndicator(),
                              errorWidget: (context, url, error) =>
                                  Icon(Icons.error),
                            )
                          : Image.file(
                              File(picture!.path),
                              width: 200,
                              height: 200,
                              fit: BoxFit.cover,
                            ),
                    ))
                : const SizedBox(),
            const SizedBox(height: 20),
            TextButton(
              onPressed: () {
                takePhotoGallery().then((value) {
                  picture = value;
                  setState(() {
                    picture;
                  });
                });
              },
              child: Text(LocaleKeys.BussinesChat_select_from_gallery.tr()),
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: nameController,
              decoration: InputDecoration(
                labelText: LocaleKeys.EditBusinessDialog_business_name.tr(),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: descriptionController,
              decoration: InputDecoration(
                labelText: LocaleKeys.EditBusinessDialog_description.tr(),
                border: OutlineInputBorder(),
              ),
              maxLines: 4,
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: Text(LocaleKeys.CreateProducts_cancel.tr()),
        ),
        ElevatedButton(
          onPressed: () {
            guardarProducto().then((value) {
              Navigator.of(context).pop(true);
            });
          },
          child: Text(LocaleKeys.SettingsDialog_save.tr()),
        ),
      ],
    );
  }

  Future<void> guardarProducto() async {
    String name =
        nameController.text.isEmpty ? empresa.nombre : nameController.text;
    String description = descriptionController.text.isEmpty
        ? empresa.descripcion
        : descriptionController.text;

    String url = picture == null
        ? empresa.url_img
        : "${DateTime.now().millisecondsSinceEpoch}.png";
    if (picture != null) {
      await uploadImage(File(picture!.path), url, bucketBusiness);
    }
    await Utils().saveBusiness({
      "nombre": name,
      "descripcion": description,
      "url_img": url,
    });
    picture = null;
  }
}
