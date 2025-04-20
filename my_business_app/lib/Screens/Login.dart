import 'dart:async';
import 'dart:ffi' hide Size;
import 'dart:math';
import 'package:flutter/material.dart';

import 'package:MyBusiness/Class/Empresa.dart';
import 'package:MyBusiness/Class/Usuario.dart';
import 'package:MyBusiness/Constants/constants.dart';
import 'package:MyBusiness/Screens/MainScreen.dart';
import 'package:MyBusiness/Screens/Register.dart';
import 'package:MyBusiness/generated/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:wc_form_validators/wc_form_validators.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool showPassword = false;
  Icon lockIcon = Icon(Icons.lock_outline);
  int colorChange1 = 20;
  int colorChange2 = 20;
  Timer? _timer;

  final GlobalKey<FormFieldState> _emailKey = GlobalKey<FormFieldState>();
  final GlobalKey<FormFieldState> _passwordKey = GlobalKey<FormFieldState>();

  @override
  void initState() {
    super.initState();
    _startColorChange();
  }

  void _startColorChange() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        colorChange1 = Random().nextInt(200);
        colorChange2 = Random().nextInt(200);
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Fondo animado
          AnimatedContainer(
            duration: Duration(seconds: 2),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color.fromARGB(255, 38, colorChange2, 132),
                  Color.fromARGB(255, colorChange1, 148, 38)
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32.0),
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                physics: BouncingScrollPhysics(),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(
                      lockIcon.icon,
                      size: 50,
                      color: Colors.white,
                    ),
                    SizedBox(height: 20),
                    TextFormField(
                      validator: Validators.compose([
                        Validators.required(
                            LocaleKeys.Register_required_field.tr()),
                        Validators.email(LocaleKeys.Register_invalid_mail.tr()),
                      ]),
                      key: _emailKey,
                      keyboardType: TextInputType.emailAddress,
                      controller: _emailController,
                      decoration: InputDecoration(
                        hintText: LocaleKeys.Login_mail.tr(),
                        filled: true,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    TextFormField(
                      validator: Validators.compose([
                        Validators.required(
                            LocaleKeys.Register_required_field.tr()),
                        Validators.minLength(
                            6, LocaleKeys.Register_password_lenght.tr()),
                      ]),
                      key: _passwordKey,
                      keyboardType: TextInputType.visiblePassword,
                      controller: _passwordController,
                      obscureText: !showPassword,
                      decoration: InputDecoration(
                        hintText: LocaleKeys.Login_password.tr(),
                        filled: true,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                    CheckboxListTile(
                        value: showPassword,
                        onChanged: (value) {
                          setState(() {
                            showPassword = value!;
                            if (showPassword) {
                              lockIcon = Icon(Icons.lock_open);
                            } else {
                              lockIcon = Icon(Icons.lock_outline);
                            }
                          });
                        },
                        title: Text(LocaleKeys.Login_showpass.tr())),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        iniciarSesion();
                      },
                      style: ElevatedButton.styleFrom(
                        minimumSize: Size(double.infinity, 50),
                        padding:
                            EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: Text(
                        LocaleKeys.Login_login.tr(),
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        registro();
                      },
                      style: ElevatedButton.styleFrom(
                        minimumSize: Size(double.infinity, 50),
                        padding:
                            EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: Text(
                        LocaleKeys.Login_register.tr(),
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void iniciarSesion() async {
    String mail = _emailController.text;
    String password = _passwordController.text;

    if (_emailKey.currentState?.validate() == true &&
        _passwordKey.currentState?.validate() == true) {
      // Recuperar usuario
      var user = await Utils().getUserLogin(mail, password);
      if (user.isEmpty) {
        customErrorSnackbar(LocaleKeys.Login_error.tr(), context);
        return;
      }
      // Si el usuario existe, guardar en la variable usuario
      usuario = Usuario.fromJson(user[0]);
      await Utils().setSharedString(shared_mail, mail);

      // Recuperar empresa
      var userEmpresa =
          await Utils().getUserEmpresa(usuario.id_usuario.toString());
      if (userEmpresa.isNotEmpty) {
        var empresaList =
            await Utils().getEmpresa(userEmpresa[0]['id_empresa'].toString());
        empresa = Empresa.fromJson(empresaList[0]);
      }
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => MainScreen(),
        ),
        (Route<dynamic> route) => false,
      );
    }
  }

  void registro() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Register(),
      ),
    );
  }
}
