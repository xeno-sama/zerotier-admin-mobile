import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zerotier_manager/bloc/auth_network_bloc/auth_network_bloc.dart';
import 'package:zerotier_manager/bloc/settings_bloc/settings_bloc.dart';
import 'package:zerotier_manager/common/l10n/locale.dart';
import 'package:zerotier_manager/common/widgets/widgets.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = Lang.of(context);
    return BlocBuilder<SettingsBloc, SettingsState>(
      builder: (context, state) {
        final bloc = context.read<SettingsBloc>();
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Theme.of(context).colorScheme.onSurfaceVariant,
            automaticallyImplyLeading: false,
            titleSpacing: 8,
            title: Row(
              children: [
                Text(
                  l10n.settings,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.surface,
                  ),
                ),
              ],
            ),
          ),

          ///
          body: ListView(
            children: [
              const SizedBox(height: 16),

              /// Dark Theme
              ListTile(
                title: Text(l10n.darkTheme),
                trailing: Transform.scale(
                  scale: 0.8,
                  child: Switch(
                    value: state.themeMode == ThemeMode.dark,
                    onChanged: (bool value) {
                      bloc.add(
                        UpdateThemeModeEvent(
                          value ? ThemeMode.dark : ThemeMode.light,
                        ),
                      );
                    },
                  ),
                ),
              ),

              /// Language
              ListTile(
                title: Text(l10n.language),
                trailing: DropdownButton<String>(
                  value: state.language,
                  onChanged: (String? newValue) {
                    if (newValue != null) {
                      bloc.add(UpdateLanguageEvent(newValue));
                    }
                  },
                  items: const [
                    DropdownMenuItem(value: 'en', child: Text('English')),
                    DropdownMenuItem(value: 'ru', child: Text('Русский')),
                  ],
                ),
              ),

              /// Font Size
              ListTile(
                title: Text(l10n.fontSize),
                trailing: DropdownButton<double>(
                  alignment: Alignment.centerRight,
                  value: state.fontSizeFactor,
                  onChanged: (double? newValue) {
                    if (newValue != null) {
                      bloc.add(UpdateFontSizeFactorEvent(newValue));
                    }
                  },
                  items: [
                    DropdownMenuItem(
                      alignment: Alignment.centerRight,
                      value: 1,
                      child: Text(l10n.standart),
                    ),
                    DropdownMenuItem(
                      alignment: Alignment.centerRight,
                      value: 1.1,
                      child: Text(l10n.medium),
                    ),
                    DropdownMenuItem(
                      alignment: Alignment.centerRight,
                      value: 1.2,
                      child: Text(l10n.large),
                    ),
                  ],
                ),
              ),

              /// Primary Color
              ListTile(
                title: Text(l10n.primaryColor),
                trailing: PopupMenuButton<Color>(
                  icon: Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      color: state.primaryColor,
                      shape: BoxShape.circle,
                    ),
                  ),
                  onSelected: (Color color) {
                    bloc.add(UpdatePrimaryColorEvent(color));
                  },
                  itemBuilder: (BuildContext context) =>
                      <PopupMenuEntry<Color>>[
                    const PopupMenuItem(
                      value: Colors.blue,
                      child: ColorOption(color: Colors.blue),
                    ),
                    const PopupMenuItem(
                      value: Colors.red,
                      child: ColorOption(color: Colors.red),
                    ),
                    const PopupMenuItem(
                      value: Colors.green,
                      child: ColorOption(color: Colors.green),
                    ),
                    const PopupMenuItem(
                      value: Colors.purple,
                      child: ColorOption(color: Colors.purple),
                    ),
                    const PopupMenuItem(
                      value: Colors.orange,
                      child: ColorOption(color: Colors.orange),
                    ),
                  ],
                ),
              ),
              wideDivider(context),

              /// Logout
              ListTile(
                title: Text(l10n.logOut),
                onTap: () =>
                    context.read<AuthNetworkBloc>().add(AuthLogoutRequested()),
                trailing: const Icon(Icons.logout),
              ),
            ],
          ),
        );
      },
    );
  }
}
