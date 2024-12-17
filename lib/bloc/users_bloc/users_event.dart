part of 'users_bloc.dart';

abstract class UserEvent {}

class FetchUsers extends UserEvent {
  final String token;
  final String networkId;

  FetchUsers(this.token, this.networkId);
}
