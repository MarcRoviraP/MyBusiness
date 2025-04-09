import 'dart:async';
import 'dart:math';

import 'package:flutter_animate/flutter_animate.dart';
import 'package:MyBusiness/Constants/constants.dart';
import 'package:MyBusiness/Screens/MainScreen.dart';
import 'package:MyBusiness/Screens/Register.dart';
import 'package:MyBusiness/generated/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:wc_form_validators/wc_form_validators.dart';

class Login extends StatefulWidget {
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
                    ).animate().scale(duration: 500.ms).fadeIn(),
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
                    ).animate().slideY(begin: -1, duration: 600.ms),
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
                    ).animate().slideY(begin: 1, duration: 600.ms),
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
                            title: Text(LocaleKeys.Login_showpass.tr()))
                        .animate()
                        .slideY(begin: 1, duration: 600.ms),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        iniciarSesion();
                      },
                      style: ElevatedButton.styleFrom(
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
                    ).animate().scale(duration: 400.ms),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        registro();
                      },
                      style: ElevatedButton.styleFrom(
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
                    ).animate().scale(duration: 400.ms),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void iniciarSesion() {
    String mail = _emailController.text;
    String password = _passwordController.text;

    if (_emailKey.currentState?.validate() == true &&
        _passwordKey.currentState?.validate() == true) {

      Utils().getUser(mail, password).then((value) {
        if (value.isNotEmpty) {
          String id = value[0]['id_usuario'].toString();

          Utils().setSharedString(shared_mail, mail);
          Utils().setSharedString(shared_id, id);
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) => MainScreen(),
            ),
            (Route<dynamic> route) => false,
          );
        } else {
          // Si el usuario no existe, mostrar un mensaje de error
          customErrorSnackbar(LocaleKeys.Login_error.tr(), context);
        }
      });
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
