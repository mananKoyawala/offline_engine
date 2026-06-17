import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:offline_engine/locator/locator.config.dart';

GetIt locator = GetIt.instance;

void setupLocator() {
  configureDependencies();
}

@injectableInit
void configureDependencies() => locator.init();
