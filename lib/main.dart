import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:readee/_core/navigation/navigation.gr.dart';
import 'package:readee/_core/theme/theme_data.dart';
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
      theme: lightTheme,
      routerDelegate: _router.delegate(),
      routeInformationParser: _router.defaultRouteParser(),
    );
  }
}
