import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:zerotier_manager/common/models/network.dart';
import 'package:zerotier_manager/common/vars.dart';

class DataRepository {
  static const String _tokenKey = 'auth_token';

  // Фабричный асинхронный конструктор
  static Future<DataRepository> create() async {
    final prefs = await SharedPreferences.getInstance();
    return DataRepository._internal(prefs);
  }

  // Приватный конструктор
  DataRepository._internal(this._prefs);

  final SharedPreferences _prefs;

  // Приватный метод для получения экземпляра SharedPreferences
  Future<SharedPreferences> getPrefs() async {
    return _prefs; // Используем уже полученный экземпляр
  }

  Future<bool> saveToken(String token) async {
    final prefs = await getPrefs();
    await prefs.setString(_tokenKey, token);
    return true;
  }

  Future<void> removeToken() async {
    final prefs = await getPrefs();
    await prefs.remove(_tokenKey);
  }

  Future<String?> getToken() async {
    final prefs = await getPrefs();
    return prefs.getString(_tokenKey);
  }

  // create/update temp currentNetworkID
  Future<void> setCurrentNetworkID(String networkID) async {
    final prefs = await getPrefs();
    currentNetworkID = networkID;
    await prefs.setString('currentNetworkID', networkID);
  }

  // get temp currentNetworkID
  Future<String?> getCurrentNetworkID() async {
    final prefs = await getPrefs();
    return prefs.getString('currentNetworkID');
  }

  // set current Network model
  Future<void> setCurrentNetwork(Network network) async {
    final prefs = await getPrefs();
    await prefs.setString('currentNetwork', jsonEncode(network.toJson()));
  }

  // get current Network model
  Future<Network?> getCurrentNetwork() async {
    final prefs = await getPrefs();
    final networkJson = prefs.getString('currentNetwork');
    return networkJson != null
        ? Network.fromJson(jsonDecode(networkJson) as Map<String, dynamic>)
        : null;
  }
}
