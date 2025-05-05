import 'dart:ffi';
import 'dart:io';

import 'package:MyBusiness/Class/Empresa.dart';
import 'package:MyBusiness/Constants/constants.dart';
import 'package:MyBusiness/Screens/BusinessScreen.dart';
import 'package:MyBusiness/generated/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:wc_form_validators/wc_form_validators.dart';

class Createbusiness extends StatefulWidget {
  const Createbusiness({super.key});

  @override
  State<Createbusiness> createState() => _CreatebusinessState();
}

class _CreatebusinessState extends State<Createbusiness> {
  XFile? picture;

  GlobalKey<FormFieldState> businessKey = GlobalKey<FormFieldState>();
  TextEditingController businessNameController = TextEditingController();
  TextEditingController businessDescriptionController = TextEditingController();

  GlobalKey<FormFieldState> telefonKey = GlobalKey<FormFieldState>();
  TextEditingController telefonController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Padding(
      padding: const EdgeInsets.all(8.0),
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
            Center(
              child: Text(
                'create_business'.tr(),
                style: const TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            TextFormField(
              controller: businessNameController,
              key: businessKey,
              validator:
                  Validators.required(LocaleKeys.Register_required_field.tr()),
              decoration: InputDecoration(
                labelText: LocaleKeys.CreateBusiness_business_name.tr(),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            TextFormField(
              controller: telefonController,
              key: telefonKey,
              validator:
                  Validators.required(LocaleKeys.Register_required_field.tr()),
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                labelText: LocaleKeys.CreateBusiness_phone.tr(),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            TextFormField(
              controller: businessDescriptionController,
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                labelText: LocaleKeys.CreateBusiness_description.tr(),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
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
                  ? Icon(Icons.add_a_photo, size: 300)
                  : Image.file(
                      File(picture!.path),
                      width: 300,
                      height: 300,
                      fit: BoxFit.cover,
                    ),
            ),
            SizedBox(
              height: 30,
              child: FloatingActionButton.extended(
                elevation: 20,
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
            const SizedBox(
              height: 20,
            ),
            SizedBox(
                height: 250,
                width: double.infinity,
                child: MapaEmpresaWidget()),
            const SizedBox(
              height: 40,
            ),
            ElevatedButton(
              onPressed: () {
                createBusiness();
              },
              child: Text(LocaleKeys.SettingsDialog_save.tr()),
            ),
          ],
        ),
      ),
    ));
  }

  Future<XFile?> takePhoto() async {
    XFile? picture = await ImagePicker().pickImage(source: ImageSource.camera);

    return picture;
  }

  Future<XFile?> takePhotoGallery() async {
    XFile? picture = await ImagePicker().pickImage(source: ImageSource.gallery);
    return picture;
  }

  void createBusiness() async {
    if (businessKey.currentState!.validate() &&
        telefonKey.currentState!.validate()) {
      String direccionBusiness = direccion;
      String telefon = telefonController.text;
      String businessName = businessNameController.text;
      String name = "";
      if (picture != null) {
        // Guarda la imagen en el servidor
        name =
            "${DateTime.now().millisecondsSinceEpoch}.png";
      }

      var user_empresa =
          await Utils().getUserEmpresa(usuario.id_usuario.toString());
      if (user_empresa.isNotEmpty) {
        await Utils().refreshBusiness();
        customErrorSnackbar(
            LocaleKeys.CreateBusiness_belong_to_a_business.tr(), context);
        openNewScreen(context, Businessscreen());
        return;
      }
      var value = await Utils().insertInTable({
        'nombre': businessName,
        'direccion': direccionBusiness,
        'telefono': telefon,
        'descripcion': businessDescriptionController.text,
        'url_img': name,
      }, 'empresas');

      if (value.isEmpty) {
        customErrorSnackbar(
            LocaleKeys.CreateBusiness_business_error.tr(), context);
      } else {
        await uploadImage(File(picture!.path), name,bucketBusiness);
        empresa = Empresa.fromJson(value[0]);
        String idEmpresa = value[0]['id_empresa'].toString();
        await Utils().insertInTable({
          'id_usuario': int.parse(usuario.id_usuario.toString()),
          'id_empresa': int.parse(idEmpresa),
          'rol': Administrador_empresa,
        }, 'usuario_empresa');

        customSuccessSnackbar(
            LocaleKeys.CreateBusiness_business_created.tr(), context);
        rol = Administrador_empresa;
        openNewScreen(context, Businessscreen());
      }
    }
  }
}
