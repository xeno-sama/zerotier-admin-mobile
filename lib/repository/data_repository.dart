import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zerotier_manager/common/models/network.dart';
import 'package:zerotier_manager/common/vars.dart';

class DataRepository {
  static const String _tokenKey = 'auth_token';
  static const String _savedTokensKey = 'saved_tokens';
  static const String _favoriteUsersKey = 'favorite_users';

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

  // Загрузить список сохранённых токенов
  Future<List<Map<String, String>>> loadSavedTokens() async {
    try {
      final savedTokensStrings = _prefs.getStringList(_savedTokensKey) ?? [];
      return savedTokensStrings
          .map((String s) {
            try {
              return Map<String, String>.from(json.decode(s) as Map);
            } catch (e) {
              print('Error decoding token: $e');
              return <String, String>{};
            }
          })
          .where((map) => map.isNotEmpty)
          .toList();
    } catch (e) {
      print('Error loading saved tokens: $e');
      return [];
    }
  }

  // Сохранить новый токен в список
  Future<bool> addSavedToken(String name, String token) async {
    try {
      final currentTokens = await loadSavedTokens();
      if (name.isNotEmpty &&
          token.isNotEmpty &&
          !currentTokens.any((t) => t['token'] == token)) {
        currentTokens.add({'name': name, 'token': token});
        await _prefs.setStringList(
          _savedTokensKey,
          currentTokens.map((t) => json.encode(t)).toList(),
        );
        return true;
      }
      return false;
    } catch (e) {
      print('Error saving token: $e');
      return false;
    }
  }

  // Удалить токен из списка
  Future<bool> removeSavedToken(Map<String, String> tokenMap) async {
    try {
      final currentTokens = await loadSavedTokens();
      currentTokens.removeWhere((t) => t['token'] == tokenMap['token']);
      await _prefs.setStringList(
        _savedTokensKey,
        currentTokens.map((t) => json.encode(t)).toList(),
      );
      return true;
    } catch (e) {
      print('Error removing token: $e');
      return false;
    }
  }

  // Получить список избранных пользователей
  Future<List<String>> getFavoriteUsers() async {
    return _prefs.getStringList(_favoriteUsersKey) ?? [];
  }

  // Проверить, находится ли пользователь в избранном
  Future<bool> isUserFavorite(String nodeId) async {
    final favorites = await getFavoriteUsers();
    return favorites.contains(nodeId);
  }

  // Добавить/удалить пользователя из избранного
  Future<bool> toggleFavoriteUser(String nodeId) async {
    final favorites = await getFavoriteUsers();

    if (favorites.contains(nodeId)) {
      favorites.remove(nodeId);
    } else {
      favorites.add(nodeId);
    }

    return _prefs.setStringList(_favoriteUsersKey, favorites);
  }
}
