part of 'users_bloc.dart';

abstract class UserState extends Equatable {
  const UserState();

  @override
  List<Object?> get props => [];
}

class UserInitial extends UserState {}

class UserLoading extends UserState {}

class UserLoaded extends UserState {
  final List<User>
      members; // Убедитесь, что название поля совпадает с тем, что используется в UI

  const UserLoaded(this.members);

  @override
  List<Object?> get props => [members];
}

class UserError extends UserState {
  final String message;

  const UserError(this.message);

  @override
  List<Object?> get props => [message];
}
