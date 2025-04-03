import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:my_business_app/API_SUPABASE/supabase_service.dart';
import 'package:my_business_app/Constants/constants.dart';
import 'package:my_business_app/Screens/Login.dart';
import 'package:my_business_app/Screens/MainScreen.dart';
import 'package:my_business_app/Theme/theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();

  await supabaseService.init();

  runApp(
    EasyLocalization(
        child: MyApp(),
        supportedLocales: const [
          Locale('en'),
          Locale('es'),
        ],
        path: "assets/translations",
        useFallbackTranslations: true,
        fallbackLocale: Locale('en')),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: ThemeData.from(colorScheme: MaterialTheme.lightScheme()),
        darkTheme: ThemeData.from(colorScheme: MaterialTheme.darkScheme()),
        localizationsDelegates: context.localizationDelegates,
        supportedLocales: context.supportedLocales,
        locale: context.locale,
        home: Login());
  }
}
