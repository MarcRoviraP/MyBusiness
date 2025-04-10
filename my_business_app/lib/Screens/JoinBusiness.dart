import 'package:MyBusiness/Constants/constants.dart';
import 'package:MyBusiness/generated/locale_keys.g.dart';
import 'package:MyBusiness/widget/ScannerQR.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:wc_form_validators/wc_form_validators.dart';

class Joinbusiness extends StatefulWidget {
  const Joinbusiness({super.key});

  @override
  State<Joinbusiness> createState() => _JoinbusinessState();
}

class _JoinbusinessState extends State<Joinbusiness> {
  GlobalKey<FormFieldState> businessKey = GlobalKey<FormFieldState>();
  TextEditingController businessNameController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            children: [
              const SizedBox(
                height: 20,
              ),
              Center(
                child: Text(
                  LocaleKeys.join_business.tr(),
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
                validator: Validators.required(
                    LocaleKeys.Register_required_field.tr()),
                decoration: InputDecoration(
                  labelText: LocaleKeys.JoinBusiness_enter_business_id.tr(),
                  border: OutlineInputBorder(),
                ),
              ),
              Scannerqr(
                onCodeScanned: (value) {
                  checkIfBusinessExists(value);
                },
              ),
              Text(LocaleKeys.JoinBusiness_scanner_empresa.tr()),
              const SizedBox(
                height: 20,
              ),
              ElevatedButton(
                onPressed: () {
                  checkIfBusinessExists(businessNameController.text);
                },
                child: Text(LocaleKeys.JoinBusiness_join_request.tr()),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void checkIfBusinessExists(String id_empresa) {
    Utils().getEmpresa(id_empresa).then((value) {
      if (value.isNotEmpty) {
        // Si existe, redirigir a la pantalla de empresa
        showDialogSendRequest(context, value[0]['nombre'].toString());
      }
    });
  }

  Future<dynamic> showDialogSendRequest(
      BuildContext context, String nombreEmpresa) {
    return showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        // Cierra el diálogo después de 3 segundos
        Future.delayed(const Duration(seconds: 3), () {
          if (Navigator.of(context).canPop()) {
            Navigator.of(context).pop();
          }
        });
        return AlertDialog(
          title: Text(LocaleKeys.JoinBusiness_request_send_title.tr()),
          content: Text(
              "${LocaleKeys.JoinBusiness_request_send_message.tr()} $nombreEmpresa"),
        );
      },
    );
  }
}
