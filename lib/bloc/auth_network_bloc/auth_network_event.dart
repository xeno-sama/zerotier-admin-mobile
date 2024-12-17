part of 'auth_network_bloc.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object> get props => [];
}

class AuthLoginRequested extends AuthEvent {
  final String token;
  final Network network;

  const AuthLoginRequested({required this.token, required this.network});

  @override
  List<Object> get props => [token, network];
}

class AuthLogoutRequested extends AuthEvent {}

class AuthCheckRequested extends AuthEvent {}

class FetchNetworkData extends AuthEvent {
  final String token;
  final Network network;

  const FetchNetworkData({required this.token, required this.network});

  @override
  List<Object> get props => [token, network];
}

class NetworkDeleted extends AuthEvent {
  final String token;
  final Network network;

  const NetworkDeleted({required this.token, required this.network});
}

class NetworkUpdated extends AuthEvent {
  final String token;
  final String networkId;
  final Network network;

  const NetworkUpdated({
    required this.token,
    required this.network,
    required this.networkId,
  });
}
