import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:todus/locator/locator.config.dart';
import 'package:todus/service/sync/sync_manager/sync_manager.dart';

GetIt locator = GetIt.instance;

Future<void> setupLocator() async {
  await configureDependencies();
  locator<SyncManager>();
}

@injectableInit
Future<void> configureDependencies() => locator.init();
