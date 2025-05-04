import 'package:MyBusiness/Class/Empresa.dart';
import 'package:MyBusiness/Class/Usuario.dart';
import 'package:MyBusiness/Screens/SplashScreen.dart';
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
import 'package:flutter_launcher_icons/logger.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:open_file/open_file.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  await solicitarPermisoNotificaciones();

  await supabaseService.init();

  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/launcher_icon');
  const InitializationSettings initializationSettings =
      InitializationSettings(android: initializationSettingsAndroid);
  await flutterLocalNotificationsPlugin.initialize(initializationSettings,
      onDidReceiveNotificationResponse: (details) async {
    if (details.payload == null) {
      return;
    }
    if (details.payload!.contains(".pdf")) {
      await OpenFile.open(
        details.payload!,
      );
    }
  });

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
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future: Utils().getSharedString(shared_theme),
      builder: (context, snapshot) {
       if (snapshot.hasData) {
          final theme = snapshot.data!;
          switch (theme) {
            case "#FFDE3F": // Amarillo
              temaLight = ThemeFFDE3F.lightScheme();
              temaDark = ThemeFFDE3F.darkHighContrastScheme();
              break;
            case "#949CAE": // Gris
              temaLight = Theme949CAE.lightScheme();
              temaDark = Theme949CAE.darkHighContrastScheme();
              break;
            case "#FF6D66": // Rojo
              temaLight = ThemeFF6D66.lightScheme();
              temaDark = ThemeFF6D66.darkHighContrastScheme();
              break;
            case "#63A002": // Verde
              temaLight = Theme63A002.lightScheme();
              temaDark = Theme63A002.darkHighContrastScheme();
              break;
            case "#0063D8": // Azul
              temaLight = Theme0063D8.lightScheme();
              temaDark = Theme0063D8.darkHighContrastScheme();
              break;
            case "#B11AC1": // Rosa
              temaLight = ThemeB11AC1.lightScheme();
              temaDark = ThemeB11AC1.darkHighContrastScheme();
              break;
          }

          lightTextTheme = createTextTheme(
              context: context,
              bodyFontString: "Afacad",
              displayFontString: "Afacad",
              isDarkMode: false);
          darkTextTheme = createTextTheme(
              context: context,
              bodyFontString: "Afacad",
              displayFontString: "Afacad",
              isDarkMode: true);
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme:
                ThemeData.from(colorScheme: temaLight, textTheme: lightTextTheme),
            darkTheme:
                ThemeData.from(colorScheme: temaDark, textTheme: darkTextTheme),
            localizationsDelegates: context.localizationDelegates,
            supportedLocales: context.supportedLocales,
            locale: context.locale,
            home: const Splashscreen(),
          );
        } else {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            home: const Center(
              child: SpinKitFadingCircle(
                color: Colors.blue,
                size: 50.0,
              ),
            ),
          );
        }
      },
    );
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
