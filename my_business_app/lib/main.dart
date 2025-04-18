import 'package:MyBusiness/Class/Empresa.dart';
import 'package:MyBusiness/Class/Usuario.dart';
import 'package:MyBusiness/Theme/Theme0063D8.dart';
import 'package:MyBusiness/Theme/Theme63A002.dart';
import 'package:MyBusiness/Theme/Theme949CAE.dart';
import 'package:MyBusiness/Theme/ThemeB11AC1.dart';
import 'package:MyBusiness/Theme/ThemeFF6D66.dart';
import 'package:MyBusiness/Theme/ThemeFFDE3F.dart';
import 'package:MyBusiness/Theme/util.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:MyBusiness/API_SUPABASE/supabase_service.dart';
import 'package:MyBusiness/Constants/constants.dart';
import 'package:MyBusiness/Screens/Login.dart';
import 'package:MyBusiness/Screens/MainScreen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();

  await supabaseService.init();

  runApp(
    EasyLocalization(
        supportedLocales: const [
          Locale('en'),
          Locale('es'),
        ],
        path: "assets/translations",
        useFallbackTranslations: true,
        fallbackLocale: Locale('en'),
        child: RestartMain(child: const MyApp())),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    ColorScheme temaLight = ThemeFFDE3F.lightScheme();
    ColorScheme temaDark = ThemeFFDE3F.darkScheme();
    Widget homeScreen = Login();
    return FutureBuilder(
      future: Future.wait(
        [
          preInitMainScreen(),
          Utils().getSharedString(shared_theme),
        ],
      ),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return const Center(child: Text('Error'));
        } else {
          var response = snapshot.data;
          response ??= ["", ""];

          String mail = response[0].toString();
          String theme = response[1].toString();

          if (mail != "") {
            homeScreen = MainScreen();
          }

          switch (theme) {
            case "#FFDE3F":
              temaLight = ThemeFFDE3F.lightScheme();
              temaDark = ThemeFFDE3F.darkHighContrastScheme();
              break;
            case "#949CAE":
              temaLight = Theme949CAE.lightScheme();
              temaDark = Theme949CAE.darkHighContrastScheme();
              break;
            case "#FF6D66":
              temaLight = ThemeFF6D66.lightScheme();
              temaDark = ThemeFF6D66.darkHighContrastScheme();
              break;
            case "#63A002":
              temaLight = Theme63A002.lightScheme();
              temaDark = Theme63A002.darkHighContrastScheme();
              break;
            case "#0063D8":
              temaLight = Theme0063D8.lightScheme();
              temaDark = Theme0063D8.darkHighContrastScheme();
              break;
            case "#B11AC1":
              temaLight = ThemeB11AC1.lightScheme();
              temaDark = ThemeB11AC1.darkHighContrastScheme();
              break;
            default:
              break;
          }
        }

        final lightTextTheme =
            createTextTheme(context, "Afacad", "Afacad", false);
        final darkTextTheme =
            createTextTheme(context, "Afacad", "Afacad", true);
        return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: ThemeData.from(
                colorScheme: temaLight, textTheme: lightTextTheme),
            darkTheme:
                ThemeData.from(colorScheme: temaDark, textTheme: darkTextTheme),
            localizationsDelegates: context.localizationDelegates,
            supportedLocales: context.supportedLocales,
            locale: context.locale,
            home: homeScreen);
      },
    );
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
    } catch (e) {}

    return mail;
  }
}

// Reinicia la app cuando al cambiar la key del widget esto produzca que se vuelva a construir el widget

class RestartMain extends StatefulWidget {
  final Widget child;
  const RestartMain({super.key, required this.child});

  static void restartApp(BuildContext context) {
    _RestartMainState? state =
        context.findAncestorStateOfType<_RestartMainState>();
    state?.restartApp();
  }

  @override
  State<RestartMain> createState() => _RestartMainState();
}

class _RestartMainState extends State<RestartMain> {
  Key _key = UniqueKey();
  void restartApp() {
    setState(() {
      _key = UniqueKey();
    });
  }

  @override
  Widget build(BuildContext context) {
    return KeyedSubtree(
      key: _key,
      child: widget.child,
    );
  }
}
