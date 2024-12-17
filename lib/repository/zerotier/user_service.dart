import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:zerotier_manager/common/models/invitation.dart';
import 'package:zerotier_manager/common/models/user.dart';
import 'package:zerotier_manager/repository/zerotier_repository.dart';

// ruslan_d@inbox.ru
// 'orgId': '800bec6d-b6b5-43f8-bd06-5425796afc38',
// zerotier_openapi.yaml

class UserService {
  final ZeroTierRepository repository;

  UserService(this.repository);
  final String baseUrl = 'https://api.zerotier.com/api/v1';

  /// Работа с юзерами

  /// Получение членов конкретной сети
  Future<List<User>> fetchUsers({
    required String token,
    required String networkId,
  }) async {
    final response = await http.get(
      Uri.parse('$baseUrl/network/$networkId/member'),
      headers: {
        'Authorization': 'token $token',
      },
    );

    if (response.statusCode == 200) {
      // Декодируем тело ответа в строку с использованием utf8
      final decodedBody = utf8.decode(response.bodyBytes);
      // Преобразуем Map<String, dynamic> в объекты User
      return (jsonDecode(decodedBody) as List)
          .cast<Map<String, dynamic>>()
          .map(
            (member) => User.fromJson({...member}),
          )
          .toList();
    } else if (response.statusCode == 401) {
      // Возвращаем пустой список при ошибке авторизации
      return [const User.empty()];
    } else {
      throw Exception(
        'Failed to load network members: ${response.statusCode} - ${response.body}',
      );
    }
  }

  /// Получение информации о конкретном члене сети
  Future<User> fetchUser({
    required String token,
    required String networkId,
    required String memberId,
  }) async {
    final response = await http.get(
      Uri.parse('$baseUrl/network/$networkId/member/$memberId'),
      headers: {
        'Authorization': 'token $token',
      },
    );

    if (response.statusCode == 200) {
      return User.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
    } else {
      throw Exception(
        'Failed to load member data: ${response.statusCode} - ${response.body}',
      );
    }
  }

  /// Получение членов конкретной сети в режиме стрима
  Stream<List<User>> fetchUsersStream({
    required String token,
    required String networkId,
  }) async* {
    while (true) {
      final response = await http.get(
        Uri.parse('$baseUrl/network/$networkId/member'),
        headers: {
          'Authorization': 'token $token',
        },
      );

      if (response.statusCode == 200) {
        final decodedBody = utf8.decode(response.bodyBytes);
        yield (jsonDecode(decodedBody) as List)
            .cast<Map<String, dynamic>>()
            .map((member) => User.fromJson({...member}))
            .toList();
      } else if (response.statusCode == 401) {
        yield [const User.empty()];
      } else {
        throw Exception(
          'Failed to load network members: ${response.statusCode} - ${response.body}',
        );
      }
      // print('fetchUsersStream Tick');
      await Future.delayed(const Duration(milliseconds: 3050));
    }
  }

  /// Получение идентификатора организации
  Future<String> fetchOrgId({required String token}) async {
    const baseUrl = 'https://api.zerotier.com/api/v1';
    final response = await http.get(
      Uri.parse('$baseUrl/org'),
      headers: {
        'Authorization': 'token $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      // Проверяем структуру ответа и получаем orgId
      if (data != null) {
        print('Org ID - ${data['id']}');
        return data['id'] as String;
      }
      throw Exception('Organization ID not found in response');
    } else {
      throw Exception(
        'Failed to fetch organization ID: ${response.statusCode}',
      );
    }
  }

  /// Отправка приглашения по email
  Future<UserInvitation> inviteUserByEmail({
    required String token,
    // required String orgId, // Добавляем orgId
    required String email,
  }) async {
    final orgId = await fetchOrgId(token: token);
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/org-invitation'),
        headers: {
          'Authorization': 'token $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'orgId': orgId, // Добавляем orgId в тело запроса
          'email': email.trim(),
        }),
      );

      print('Response status: ${response.statusCode}');
      // print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final decodedBody = utf8.decode(response.bodyBytes);
        final data = jsonDecode(decodedBody) as Map<String, dynamic>;
        return UserInvitation.fromJson(data);
      } else if (response.statusCode == 401) {
        throw Exception('Unauthorized: Invalid token');
      } else if (response.statusCode == 403) {
        throw Exception(
          'Access denied: Organization features require a paid account',
        );
      } else if (response.statusCode == 500) {
        throw Exception(
          'Server error: ${response.body}. Please check orgId and email validity',
        );
      } else {
        throw Exception(
          'Failed to send invite: ${response.statusCode} - ${response.body}',
        );
      }
    } catch (e) {
      print('Error sending invitation: $e');
      rethrow;
    }
  }

  /// Добавление пользователя по Node ID (10-значный идентификатор)
  Future<bool> addUserByNodeId({
    required String token,
    required String networkId,
    required String nodeId,
    String? name,
    String? description,
  }) async {
    // Проверяем формат Node ID
    if (nodeId.length != 10) {
      throw Exception('Invalid Node ID format. Must be 10 characters long.');
    }

    final userData = <String, dynamic>{
      'nodeId': nodeId,
      if (name != null) 'name': name.trim(),
      if (description != null) 'description': description.trim(),
      'authorized': true, // По умолчанию авторизуем пользователя
    };

    final response = await http.post(
      Uri.parse('$baseUrl/network/$networkId/member'),
      headers: {
        'Authorization': 'token $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(userData),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return true;
    } else {
      // Обработка ошибок с более подробной информацией
      throw Exception(
        'Failed to add user: ${response.statusCode} - ${response.body}',
      );
    }
  }

  /// Обновление существующего пользователя
  Future<User> updateUser({
    required String token,
    required User user,
  }) async {
    // Создаем обновленную версию пользователя
    final updatedUser = user.copyWith(
      name: user.name,
      description: user.description,
      authorized: user.authorized,
      ipAssignments: user.ipAssignments,
    );

    // Подготавливаем данные для запроса
    final updateData = <String, dynamic>{
      'name': updatedUser.name,
      'description': updatedUser.description,
      'config': {
        'authorized': updatedUser.authorized,
        'ipAssignments': updatedUser.ipAssignments,
      },
    };

    final response = await http.post(
      Uri.parse(
        '$baseUrl/network/${updatedUser.networkId}/member/${updatedUser.nodeId}',
      ),
      headers: {
        'Authorization': 'token $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(updateData),
    );

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body) as Map<String, dynamic>;
      return User.fromJson(responseData);
    } else {
      throw Exception(
        'Failed to update user: ${response.statusCode} - ${response.body}',
      );
    }
  }

  /// Включение/выключение авторизации пользователя
  Future<User> setUserAuthorization({
    required String token,
    required User user,
    required bool authorized,
  }) async {
    // Подготавливаем данные для запроса
    final updateData = <String, dynamic>{
      'config': {
        'authorized': authorized,
      },
    };

    final response = await http.post(
      Uri.parse(
        '$baseUrl/network/${user.networkId}/member/${user.nodeId}',
      ),
      headers: {
        'Authorization': 'token $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(updateData),
    );

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body) as Map<String, dynamic>;
      return User.fromJson(responseData);
    } else {
      throw Exception(
        'Failed to update user authorization: ${response.statusCode} - ${response.body}',
      );
    }
  }

  /// Удаление пользователя из сети
  Future<void> deleteUser({
    required String token,
    required User user,
  }) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/network/${user.networkId}/member/${user.nodeId}'),
      headers: {
        'Authorization': 'token $token',
      },
    );

    if (response.statusCode != 200 && response.statusCode != 204) {
      throw Exception(
        'Failed to delete user: ${response.statusCode} - ${response.body}',
      );
    }
  }

  // Другие методы, связанные с юзерами
}
