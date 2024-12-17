import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:zerotier_manager/common/models/network.dart';
import 'package:zerotier_manager/repository/zerotier_repository.dart';

class NetworkService {
  final ZeroTierRepository repository;
  final String baseUrl = 'https://api.zerotier.com/api/v1';

  NetworkService(this.repository);

  /// Проверка валидности токена
  Future<bool> validateToken({
    required String token,
  }) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/network'),
        headers: {
          'Authorization': 'token $token',
        },
      );
      if (response.statusCode != 200) {
        return false;
      } else {
        return true;
      }
    } catch (e) {
      print('Failed to validate token: $e');
      return false;
    }
  }

  /// Получение списка всех сетей
  Future<List<Network>> fetchNetworks({
    required String token,
  }) async {
    final response = await http.get(
      Uri.parse('$baseUrl/network'),
      headers: {
        'Authorization': 'token $token',
      },
    );
    // print(response.body); // через стрим печатает при остановке апки

    if (response.statusCode == 200) {
      // Декодируем тело ответа в строку с использованием utf8
      final decodedBody = utf8.decode(response.bodyBytes);
      // Преобразуйте Map<String, dynamic> в объекты Network
      return (jsonDecode(decodedBody) as List)
          .cast<Map<String, dynamic>>()
          .map(Network.fromJson)
          .toList();
    } else if (response.statusCode == 401) {
      // Возвращаем пустой список и сообщение об ошибке
      return [
        const Network.empty(),
      ]; // Предполагается, что у Network есть поле message
    } else {
      throw Exception(
        'Failed to load networks: ${response.statusCode} - ${response.body}',
      );
    }
  }

  /// Стрим списка всех сетей
  Stream<List<Network>> fetchNetworksStream({
    required String token,
  }) async* {
    while (true) {
      yield await fetchNetworks(token: token);
      // print('fetchNetworksStream Tick');
      await Future.delayed(const Duration(milliseconds: 3050));
    }
  }

  /// Стрим определенной сети по токену и networkID
  Stream<Network> fetchNetworkStream({
    required String token,
    required String networkId,
  }) async* {
    while (true) {
      final response = await http.get(
        Uri.parse('$baseUrl/network/$networkId'),
        headers: {
          'Authorization': 'token $token',
        },
      );

      if (response.statusCode == 200) {
        yield Network.fromJson(
          jsonDecode(response.body)
              as Map<String, dynamic>, // Исправлено: явное приведение типа
        );
      } else {
        throw Exception(
          'Failed to load network: ${response.statusCode} - ${response.body}',
        );
      }
      await Future.delayed(
        const Duration(milliseconds: 3050),
      ); // Задержка перед следующим запросом
    }
  }

  /// Создание новой сети
  Future<bool> createNetwork({
    required String token,
    required String name,
    required String description,
  }) async {
    // Создаем базовую конфигурацию сети
    final networkConfig = <String, dynamic>{
      'config': {
        'name': name,
        'enableBroadcast': false,
        'private': true,
        'multicastLimit': 32,
        'routes': [
          {'target': '10.100.0.0/16'},
        ],
        'ipAssignmentPools': [
          {
            'ipRangeStart': '10.100.0.100',
            'ipRangeEnd': '10.100.0.254',
          },
        ],
        'v6AssignMode': {'6plane': false, 'rfc4193': false, 'zt': false},
      },
      'description': description,
    };

    final response = await http.post(
      Uri.parse('$baseUrl/network'),
      headers: {
        'Authorization': 'token $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(networkConfig),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return true;
    } else {
      print(
        'Failed to create network: ${response.statusCode} - ${response.body}',
      );
      return false;
    }
  }

  /// Редактирование существующей сети
  Future<bool> updateNetwork({
    required String token,
    required String networkId,
    required Network network,
  }) async {
    // Создаем map только с теми полями, которые были переданы
    final updateData = <String, dynamic>{
      'config': {
        'name': network.name,
        'enableBroadcast': network.enableBroadcast,
        'private': network.private, //network.private,
        'multicastLimit': network.multicastLimit,
        'routes': [
          {'target': network.routeTarget},
        ],
        'ipAssignmentPools': [
          {
            'ipRangeStart': network.ipRangeStart,
            'ipRangeEnd': network.ipRangeEnd,
          },
        ],
        // 'v6AssignMode': {'6plane': false, 'rfc4193': false, 'zt': false},
      },
      'description': network.description,
    };

    final response = await http.post(
      // Некоторые API используют PUT, но Zerotier использует POST для обновления
      Uri.parse('$baseUrl/network/$networkId'),
      headers: {
        'Authorization': 'token $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(updateData),
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      print(
        'Failed to update network: ${response.statusCode} - ${response.body}',
      );
      return false;
    }
  }

  /// Удаление сети
  Future<void> deleteNetwork({
    required String token,
    required String networkId,
  }) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/network/$networkId'),
      headers: {
        'Authorization': 'token $token',
      },
    );

    if (response.statusCode != 200 && response.statusCode != 204) {
      throw Exception(
        'Failed to delete network: ${response.statusCode} - ${response.body}',
      );
    }
  }

  //
}
