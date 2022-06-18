import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:readee/_core/navigation.gr.dart';
import 'package:readee/depencency_injection.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  configureDependencies();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final _router = AppRouter();

  MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Readee',
      theme: ThemeData(
        brightness: Brightness.light,
        scaffoldBackgroundColor: const Color(0xffF7F7F7),
        fontFamily: 'CharisSIL',
        colorScheme: const ColorScheme(
          primary: Color(0xff222831),
          secondary: Color(0xff222831),
          surface: Color(0xff222831),
          background: Color(0xff222831),
          error: Color(0xff222831),
          onPrimary: Color(0xff222831),
          onSecondary: Color(0xff222831),
          onSurface: Color(0xff222831),
          onBackground: Color(0xff222831),
          onError: Color(0xff222831),
          brightness: Brightness.light,
        ),
        textTheme: const TextTheme(
          bodyText2: TextStyle(color: Color(0xff222831)),
          subtitle1: TextStyle(color: Color(0xff9D9D9D), fontSize: 12),
        ),
      ),
      themeMode: ThemeMode.system,
      routerDelegate: _router.delegate(),
      routeInformationParser: _router.defaultRouteParser(),
    );
  }
}
