import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:readee/depencency_injection.config.dart';

final getIt = GetIt.instance;

@InjectableInit()
GetIt configureDependencies() => $initGetIt(getIt);