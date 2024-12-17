import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:zerotier_manager/app.dart';
import 'package:zerotier_manager/bloc/auth_network_bloc/auth_network_bloc.dart';
import 'package:zerotier_manager/common/models/user.dart';
import 'package:zerotier_manager/features/auth/auth_page.dart';
import 'package:zerotier_manager/features/network/network_page.dart';
import 'package:zerotier_manager/features/settings/settings_page.dart';
import 'package:zerotier_manager/features/users/user_edit.dart';
import 'package:zerotier_manager/features/users/users_page.dart';
import 'package:zerotier_manager/splash_screen.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _shellNavigatorKey = GlobalKey<NavigatorState>();

final router = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: '/splash',
  routes: [
    // Сплешскрин
    GoRoute(
      path: '/splash',
      builder: (context, state) => const SplashScreen(),
    ),
    GoRoute(
      path: '/auth',
      builder: (context, state) => const AuthPage(),
    ),

    ///
    ShellRoute(
      navigatorKey: _shellNavigatorKey,
      builder: (context, state, child) {
        return BlocBuilder<AuthNetworkBloc, AuthState>(
          builder: (context, authState) {
            if (authState is AuthAuthenticated) {
              return App(child: child);
            }
            return const AuthPage();
          },
        );
      },
      routes: [
        GoRoute(
          path: '/',
          pageBuilder: (context, state) {
            final authState = context.read<AuthNetworkBloc>().state;
            if (authState is AuthAuthenticated) {
              return NoTransitionPage(
                child: UsersPage(
                  token: authState.token,
                  networkId: authState.network.id,
                ),
              );
            } else {
              // Redirect to auth page if not authenticated
              return const NoTransitionPage(child: AuthPage());
            }
          },
        ),

        ///
        GoRoute(
          path: '/network',
          pageBuilder: (context, state) {
            final authState = context.read<AuthNetworkBloc>().state;
            if (authState is AuthAuthenticated) {
              return NoTransitionPage(
                child: NetworkPage(
                  token: authState.token,
                  network: authState.network,
                ),
              );
            } else {
              // Redirect to auth page if not authenticated
              return const NoTransitionPage(child: AuthPage());
            }
          },
        ),

        /// Users
        GoRoute(
          path: '/users',
          pageBuilder: (context, state) {
            final authState = context.read<AuthNetworkBloc>().state;
            if (authState is AuthAuthenticated) {
              return NoTransitionPage(
                child: UsersPage(
                  token: authState.token,
                  networkId: authState.network.id,
                ),
              );
            } else {
              // Redirect to auth page if not authenticated
              return const NoTransitionPage(child: AuthPage());
            }
          },
        ),

        ///
        GoRoute(
          path: '/settings',
          pageBuilder: (context, state) => const NoTransitionPage(
            child: SettingsPage(),
          ),
        ),

        /// User Edit
        GoRoute(
          path: '/user_edit',
          pageBuilder: (context, state) {
            final args = state.extra! as Map<String, dynamic>;
            final user = args['user'] as User;
            final token = args['token'] as String;
            return NoTransitionPage(
              child: UserEdit(
                token: token,
                user: user,
              ),
            );
          },
        ),

        /// Exit
        GoRoute(
          path: '/exit',
          pageBuilder: (context, state) {
            context.read<AuthNetworkBloc>().add(AuthLogoutRequested());
            return const NoTransitionPage(child: AuthPage());
          },
        ),

        ///
      ],
    ),
  ],
);
