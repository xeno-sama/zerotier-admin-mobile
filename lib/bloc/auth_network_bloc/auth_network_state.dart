part of 'auth_network_bloc.dart';

abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object> get props => [];
}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthUnauthenticated extends AuthState {}

class AuthAuthenticated extends AuthState {
  final String token;
  final Network network;

  const AuthAuthenticated({required this.token, required this.network});

  @override
  List<Object> get props => [token, network];
}

class AuthFailure extends AuthState {
  final String error;

  const AuthFailure(this.error);

  @override
  List<Object> get props => [error];
}

class NetworkDataLoaded extends AuthState {
  final Network network;

  const NetworkDataLoaded(this.network);

  @override
  List<Object> get props => [network];
}

class NetworkDeletedSuccess extends AuthState {}

class NetworkUpdatedSuccess extends AuthState {
  final String token;
  final Network network;

  const NetworkUpdatedSuccess({required this.token, required this.network});
}
