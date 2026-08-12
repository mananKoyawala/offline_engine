import 'package:offline_engine/core/shared_preferences.dart';
import 'package:offline_engine/locator/locator.dart';
import 'package:offline_engine/service/sync/sync_manager/sync_manager.dart';

Preferences get prefsInstance => locator<Preferences>();
SyncManager get syncManagerInstance => locator<SyncManager>();
