import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:offline_engine/locator/locator.config.dart';
import 'package:offline_engine/service/sync_manager/sync_manager.dart';

GetIt locator = GetIt.instance;

Future<void> setupLocator() async {
  await configureDependencies();
  locator<SyncManager>();
}

@injectableInit
Future<void> configureDependencies() => locator.init();
