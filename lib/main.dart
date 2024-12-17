import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zerotier_manager/bloc/auth_network_bloc/auth_network_bloc.dart';
import 'package:zerotier_manager/bloc/settings_bloc/settings_bloc.dart';
import 'package:zerotier_manager/common/l10n/locale.dart';
import 'package:zerotier_manager/common/theme/app_theme.dart';
import 'package:zerotier_manager/repository/data_repository.dart';
import 'package:zerotier_manager/repository/settings_repository.dart';
import 'package:zerotier_manager/router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await SystemChrome.setPreferredOrientations(
    [DeviceOrientation.portraitDown, DeviceOrientation.portraitUp],
  );

  final settingsRepository = await SettingsRepository.create();
  final dataRepository = await DataRepository.create();

  final settingsBloc = SettingsBloc(settingsRepository)
    ..add(LoadSettingsEvent());
  final authBloc = AuthNetworkBloc(dataApi: dataRepository)
    ..add(AuthCheckRequested());

  runApp(
    MultiRepositoryProvider(
      providers: [
        RepositoryProvider.value(value: settingsRepository),
        RepositoryProvider.value(value: dataRepository),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider.value(value: settingsBloc),
          BlocProvider.value(value: authBloc),
        ],
        child: const MyApp(),
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsBloc, SettingsState>(
      builder: (context, state) {
        final lightTheme = AppTheme.createTheme(
          brightness: Brightness.light,
          primaryColor: state.primaryColor,
          fontSizeFactor: state.fontSizeFactor,
        );

        final darkTheme = AppTheme.createTheme(
          brightness: Brightness.dark,
          primaryColor: state.primaryColor,
          fontSizeFactor: state.fontSizeFactor,
        );

        return MaterialApp.router(
          debugShowCheckedModeBanner: false,
          title: 'ZeroTier Admin',
          themeMode: state.themeMode,
          theme: lightTheme,
          darkTheme: darkTheme,
          locale: Locale(state.language),
          localizationsDelegates: Lang.localizationsDelegates,
          supportedLocales: Lang.supportedLocales,
          routerConfig: router,
        );
      },
    );
  }
}
