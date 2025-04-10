import 'dart:async';
import 'dart:math';

import 'package:MyBusiness/Class/Usuario.dart';
import 'package:MyBusiness/Constants/constants.dart';
import 'package:MyBusiness/Screens/Login.dart';
import 'package:MyBusiness/Screens/MainScreen.dart';
import 'package:MyBusiness/generated/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:wc_form_validators/wc_form_validators.dart';

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool showPassword = false;
  Icon lockIcon = Icon(Icons.lock_outline);
  int colorChange1 = 20;
  int colorChange2 = 20;
  Timer? _timer;

  final GlobalKey<FormFieldState> _emailKey = GlobalKey<FormFieldState>();
  final GlobalKey<FormFieldState> _usernameKey = GlobalKey<FormFieldState>();
  final GlobalKey<FormFieldState> _passwordKey = GlobalKey<FormFieldState>();
  final GlobalKey<FormFieldState> _confirmPasswordKey =
      GlobalKey<FormFieldState>();

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
                      validator: Validators.required(
                          LocaleKeys.Register_required_field.tr()),
                      key: _usernameKey,
                      keyboardType: TextInputType.name,
                      controller: _usernameController,
                      decoration: InputDecoration(
                        hintText: LocaleKeys.Register_username.tr(),
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
                    SizedBox(height: 10),
                    TextFormField(
                      validator: Validators.compose([
                        Validators.required(
                            LocaleKeys.Register_required_field.tr()),
                        Validators.minLength(
                            6, LocaleKeys.Register_password_lenght.tr()),
                        (value) {
                          if (value != _passwordController.text) {
                            return LocaleKeys.Register_no_same_pass.tr();
                          }
                          return null;
                        }
                      ]),
                      key: _confirmPasswordKey,
                      keyboardType: TextInputType.visiblePassword,
                      obscureText: !showPassword,
                      decoration: InputDecoration(
                        hintText: LocaleKeys.Register_confirm_pass.tr(),
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
                        register();
                      },
                      style: ElevatedButton.styleFrom(
                        padding:
                            EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: Text(
                        LocaleKeys.Register_register.tr(),
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        backToLogin();
                      },
                      style: ElevatedButton.styleFrom(
                        padding:
                            EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: Text(
                        LocaleKeys.Register_login.tr(),
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void register() {
    String username = _usernameController.text;
    String mail = _emailController.text;
    String password = _passwordController.text;

    if (_emailKey.currentState?.validate() == true &&
        _passwordKey.currentState?.validate() == true &&
        _confirmPasswordKey.currentState?.validate() == true) {
      Utils().insertInTable(
        {
          "nombre": username,
          "correo": mail,
          "contraseña": Utils().convertToSha256(password),
        },
        "usuarios",
      ).then((value) {
        if (value.isNotEmpty) {
          String mail = value[0]['correo'].toString();

          usuario = Usuario.fromJson(value[0]);
          Utils().setSharedString(shared_mail, mail);
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) => MainScreen(),
            ),
            (Route<dynamic> route) => false,
          );
        } else {
          // Si el usuario no existe, mostrar un mensaje de error
          customErrorSnackbar(LocaleKeys.Register_user_exist.tr(), context);
        }
      });
    }
  }

  void backToLogin() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Login(),
      ),
    );
  }
}
