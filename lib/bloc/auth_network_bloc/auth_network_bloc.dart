import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zerotier_manager/common/models/network.dart';
import 'package:zerotier_manager/repository/data_repository.dart';
import 'package:zerotier_manager/repository/zerotier_repository.dart';

part 'auth_network_event.dart';
part 'auth_network_state.dart';

class AuthNetworkBloc extends Bloc<AuthEvent, AuthState> {
  final DataRepository dataApi;
  late ZeroTierRepository zeroApi; // Изменено на late

  AuthNetworkBloc({required this.dataApi}) : super(AuthInitial()) {
    zeroApi = ZeroTierRepository(token: ''); // Инициализация репозитория
    on<AuthLoginRequested>(_onAuthLoginRequested);
    on<AuthLogoutRequested>(_onAuthLogoutRequested);
    on<AuthCheckRequested>(_onAuthCheckRequested);
    on<FetchNetworkData>(_onFetchNetworkData);
    on<NetworkDeleted>(_onNetworkDeleted);
    on<NetworkUpdated>(_onNetworkUpdated); // Добавлено событие <NetworkUpdated>
  }

  Future<void> _onAuthLoginRequested(
    AuthLoginRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      final token = event.token;
      final network = event.network;

      await dataApi.saveToken(token);
      await dataApi.setCurrentNetwork(network);
      //
      emit(AuthAuthenticated(token: token, network: network));
    } catch (e) {
      emit(AuthFailure(e.toString()));
    }
  }

  Future<void> _onAuthLogoutRequested(
    AuthLogoutRequested event,
    Emitter<AuthState> emit,
  ) async {
    await dataApi.removeToken();
    emit(AuthUnauthenticated());
  }

  Future<void> _onAuthCheckRequested(
    AuthCheckRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    final currentToken = await dataApi.getToken();
    final currentNetwork = await dataApi.getCurrentNetwork();
    final isValid =
        await zeroApi.networkService.validateToken(token: currentToken ?? '');
    if (isValid) {
      emit(
        AuthAuthenticated(
          token: currentToken!,
          network: currentNetwork!,
        ),
      );
    } else {
      emit(AuthUnauthenticated());
    }
  }

  StreamSubscription<Network>? _networkSubscription;

  Future<void> _onFetchNetworkData(
    FetchNetworkData event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      await _networkSubscription
          ?.cancel(); // Отменяем предыдущую подписку, если она есть
      _networkSubscription = zeroApi.networkService
          .fetchNetworkStream(
        token: event.token,
        networkId: event.network.id,
      )
          .listen(
        (network) {
          emit(
            NetworkDataLoaded(
              network,
            ),
          ); // Эмитируем состояние с полученной сетью
        },
      );
    } catch (e) {
      emit(AuthFailure(e.toString()));
    }
  }

  Future<void> _onNetworkUpdated(
    NetworkUpdated event,
    Emitter<AuthState> emit,
  ) async {
    try {
      await zeroApi.networkService.updateNetwork(
        token: event.token,
        networkId: event.network.id,
        network: event.network,
      );

      emit(
        AuthAuthenticated(
          token: event.token,
          network: event.network,
        ),
      ); // Эмитируем состояние успешного обновления
    } catch (e) {
      emit(AuthFailure(e.toString()));
    }
  }

  Future<void> _onNetworkDeleted(
    NetworkDeleted event,
    Emitter<AuthState> emit,
  ) async {
    try {
      await zeroApi.networkService.deleteNetwork(
        token: event.token,
        networkId: event.network.id,
      );
      await dataApi.removeToken();

      emit(AuthUnauthenticated()); // Эмитируем состояние выхода
    } catch (e) {
      emit(AuthFailure(e.toString()));
    }
  }

  @override
  Future<void> close() {
    _networkSubscription?.cancel(); // Отменяем подписку при закрытии блока
    return super.close();
  }
}
