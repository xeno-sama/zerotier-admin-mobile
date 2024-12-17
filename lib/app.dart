import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:zerotier_manager/bloc/auth_network_bloc/auth_network_bloc.dart';
import 'package:zerotier_manager/common/l10n/locale.dart';
import 'package:zerotier_manager/common/widgets/widgets.dart';

class App extends StatelessWidget {
  final Widget child;
  const App({required this.child, super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = Lang.of(context);
    return WebConstraint(
      child: Scaffold(
        body: child,
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: const Icon(FontAwesomeIcons.networkWired),
              label: l10n.network,
            ),
            BottomNavigationBarItem(
              icon: const Icon(FontAwesomeIcons.users),
              label: l10n.users,
            ),
            BottomNavigationBarItem(
              icon: const Icon(FontAwesomeIcons.arrowLeftLong),
              label: l10n.logOut,
            ),
          ],
          currentIndex: _calculateSelectedIndex(context),
          onTap: (int idx) => _onItemTapped(idx, context),
        ),
      ),
    );
  }

  static int _calculateSelectedIndex(BuildContext context) {
    final location = GoRouterState.of(context).matchedLocation;
    if (location.startsWith('/network')) {
      return 0;
    } else if (location.startsWith('/users')) {
      return 1;
    } else if (location.startsWith('/exit')) {
      return 2;
    } else {
      return 1;
    }
  }

  void _onItemTapped(int index, BuildContext context) {
    switch (index) {
      case 0:
        GoRouter.of(context).go('/network');

      case 1:
        GoRouter.of(context).go('/users');

      case 2:
        context.read<AuthNetworkBloc>().add(AuthLogoutRequested());
      // GoRouter.of(context).go('/auth'); //settings

      default:
        GoRouter.of(context).go('/users');
    }
  }
}
