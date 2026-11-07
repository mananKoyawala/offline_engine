import 'package:todus/core/database/app_database.dart';
import 'package:todus/core/shared_preferences.dart';
import 'package:todus/locator/locator.dart';
import 'package:todus/service/sync/sync_manager/sync_manager.dart';

Preferences get prefsInstance => locator<Preferences>();
AppDatabase get appDatabaseInstance => locator<AppDatabase>();
SyncManager get syncManagerInstance => locator<SyncManager>();
