import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

@lazySingleton
class Preferences {
  late SharedPreferences _preferences;

  @PostConstruct(preResolve: true)
  Future<void> initialize() async {
    _preferences = await SharedPreferences.getInstance();
  }

  Future<void> setAccessToken(String accessToken) async {
    await _preferences.setString(_accessToken, accessToken);
  }

  Future<void> setRefreshToken(String refreshToken) async {
    await _preferences.setString(_refreshToken, refreshToken);
  }

  String getAccessToken() {
    return _preferences.getString(_accessToken) ?? '';
  }

  String getRefreshToken() {
    return _preferences.getString(_refreshToken) ?? '';
  }

  Future<void> clear() async {
    await _preferences.clear();
  }

  final String _accessToken = 'access_token';
  final String _refreshToken = 'refresh_token';
}
