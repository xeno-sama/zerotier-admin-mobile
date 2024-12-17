import 'dart:async';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zerotier_manager/common/models/user.dart';
import 'package:zerotier_manager/repository/zerotier_repository.dart';

part 'users_event.dart';
part 'users_state.dart';

class UsersBloc extends Bloc<UserEvent, UserState> {
  final ZeroTierRepository zeroApi;
  StreamSubscription<List<User>>? _usersSubscription;

  UsersBloc({required this.zeroApi}) : super(UserInitial()) {
    on<FetchUsers>((event, emit) async {
      // print('Starting FetchUsers event');
      emit(UserLoading());

      await _usersSubscription?.cancel();

      // print('Subscribing to stream');
      try {
        await emit.forEach<List<User>>(
          zeroApi.userService.fetchUsersStream(
            token: event.token,
            networkId: event.networkId,
          ),
          onData: (users) {
            // print('Emitting UserLoaded with ${users.length} users');
            return UserLoaded(users);
          },
        );
      } catch (e) {
        print('Error in bloc: $e');
        emit(UserError(e.toString()));
      }
    });
  }

  @override
  Future<void> close() {
    // print('Closing UsersBloc');
    _usersSubscription?.cancel();
    return super.close();
  }
}
