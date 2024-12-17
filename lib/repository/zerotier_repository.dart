import 'package:zerotier_manager/repository/zerotier/network_service.dart';
import 'package:zerotier_manager/repository/zerotier/user_service.dart';

class ZeroTierRepository {
  static final ZeroTierRepository _singleton = ZeroTierRepository._internal();
  factory ZeroTierRepository({required String token}) {
    // Use the authToken as needed, e.g., store it in a field
    _singleton._authToken = token; // Store the authToken
    return _singleton;
  }
  ZeroTierRepository._internal();

  NetworkService get networkService => NetworkService(this);
  UserService get userService => UserService(this);

  ///
  late String _authToken; // Add a field to store the authToken

  String getAuthToken() {
    return _authToken; // Теперь _authToken используется
  }
}
