import 'package:MyBusiness/Class/Empresa.dart';
import 'package:MyBusiness/Class/Usuario.dart';
import 'package:MyBusiness/Constants/constants.dart';
import 'package:MyBusiness/Screens/Login.dart';
import 'package:MyBusiness/Screens/MainScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Splashscreen extends StatefulWidget {
  const Splashscreen({super.key});

  @override
  State<Splashscreen> createState() => _SplashscreenState();
}

class _SplashscreenState extends State<Splashscreen> {
  @override
  void initState() {
    super.initState();
    _cargarApp();
  }

  Future<String> preInitMainScreen() async {
    var mail = await Utils().getSharedString(shared_mail);
    try {
      var userMailList = await Utils().getUserMail(mail);

      usuario = Usuario.fromJson(userMailList[0]);
      var userEmpresaList =
          await Utils().getUserEmpresa(usuario.id_usuario.toString());
      if (userEmpresaList.isNotEmpty) {
        var empresaList = await Utils()
            .getEmpresa(userEmpresaList[0]['id_empresa'].toString());
        empresa = Empresa.fromJson(empresaList[0]);
      }
      String notif = await Utils().getSharedString(shared_notifications);
      notifications = notif == "true" || notif == "";
    } catch (e) {}

    return mail;
  }

  Future<void> _cargarApp() async {
    final mail = await preInitMainScreen();
    // Esperamos un poco para que el usuario vea el splash
    await Future.delayed(const Duration(milliseconds: 1200));

    if (!mounted) return;

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => mail.isNotEmpty ? MainScreen() : const Login(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Center(
          child: Opacity(
            opacity: 0.3,
            child: Image.asset(
              'assets/img/logo_mb_no_bg.png',
              width: 300,
              height: 300,
              fit: BoxFit.contain,
            ),
          ),
        ),
        Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: 200),
              SpinKitWanderingCubes(
                color: Theme.of(context).colorScheme.primaryContainer,
                size: 50.0,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
