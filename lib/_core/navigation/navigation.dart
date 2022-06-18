import 'package:auto_route/annotations.dart';
import 'package:readee/screens/detail_screen.dart';
import 'package:readee/screens/home_screen.dart';

@MaterialAutoRouter(
  replaceInRouteName: 'Screen',
  routes: <AutoRoute>[
    AutoRoute(page: HomeScreen, initial: true),
    AutoRoute(page: DetailScreen),
  ],
)

class $AppRouter {}
