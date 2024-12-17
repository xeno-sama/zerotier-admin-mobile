import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rive/rive.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zerotier_manager/bloc/auth_network_bloc/auth_network_bloc.dart';
import 'package:zerotier_manager/bloc/settings_bloc/settings_bloc.dart';
import 'package:zerotier_manager/common/custom_paint/background.dart';
import 'package:zerotier_manager/common/custom_paint/painter.dart';
import 'package:zerotier_manager/common/l10n/locale.dart';
import 'package:zerotier_manager/common/models/network.dart';
import 'package:zerotier_manager/common/widgets/widgets.dart';
import 'package:zerotier_manager/repository/data_repository.dart';
import 'package:zerotier_manager/repository/zerotier_repository.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  List<Map<String, String>> _savedTokens = [];

  late String authToken;
  late String networkID;

  ZeroTierRepository zeroApi = ZeroTierRepository(token: '');
  Future<List<Network>>? networks;
  TextEditingController nameController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  late DataRepository authRepository;

  Future<void> _loadSavedTokens() async {
    final prefs = await SharedPreferences.getInstance();
    try {
      final savedTokensStrings = prefs.getStringList('saved_tokens') ?? [];
      setState(() {
        _savedTokens = savedTokensStrings
            .map((String s) {
              try {
                return Map<String, String>.from(json.decode(s) as Map);
              } catch (e) {
                debugPrint('Error decoding token: $e');
                return <String, String>{};
              }
            })
            .where((map) => map.isNotEmpty)
            .toList();
      });
    } catch (e) {
      debugPrint('Error loading saved tokens: $e');
      setState(() {
        _savedTokens = [];
      });
    }
  }

  Future<void> _saveToken(String name, String token) async {
    if (name.isNotEmpty &&
        token.isNotEmpty &&
        !_savedTokens.any((t) => t['token'] == token)) {
      try {
        final prefs = await SharedPreferences.getInstance();
        _savedTokens.add({'name': name, 'token': token});
        await prefs.setStringList(
          'saved_tokens',
          _savedTokens.map((t) => json.encode(t)).toList(),
        );
        setState(() {});
      } catch (e) {
        debugPrint('Error saving token: $e');
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('l10n.errorSavingToken')),
          );
        }
      }
    }
  }

  Future<void> _removeToken(Map<String, String> tokenMap) async {
    final prefs = await authRepository.getPrefs(); // Используем новый метод
    _savedTokens.removeWhere((t) => t['token'] == tokenMap['token']);
    await prefs.setStringList(
      'saved_tokens',
      _savedTokens.map((t) => json.encode(t)).toList(),
    );
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    _initializeRepository();
    _loadSavedTokens();
  }

  Future<void> _initializeRepository() async {
    authRepository = await DataRepository.create();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = Lang.of(context);
    final themeMode = context.read<SettingsBloc>().themeMode;

    // ignore: deprecated_member_use
    return WillPopScope(
      onWillPop: () async {
        // Выполняем необходимые действия перед выходом
        unawaited(SystemNavigator.pop()); // Закрываем приложение
        return false; // Отменяем стандартное поведение кнопки "Назад"
      },
      child: Scaffold(
        //
        drawer: _buildDrawer(context),

        ///
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Theme.of(context).colorScheme.onSurfaceVariant,
          title: Row(
            children: [
              DecoratedBox(
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 252, 188, 93),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: CustomPaint(
                  size: const Size(
                    30,
                    30,
                  ), // Можно изменить размер при необходимости
                  painter: LogoPainter(),
                ),
              ),
              const SizedBox(
                width: 8,
              ), // Добавьте отступ между логотипом и текстом
              Text(
                'ZEROTIER',
                style: theme.textTheme.titleLarge
                    ?.copyWith(letterSpacing: 1.5)
                    .copyWith(
                      color: Theme.of(context).colorScheme.surface,
                    ),
              ),
            ],
          ),
          actions: [
            Builder(
              builder: (context) {
                return IconButton(
                  icon: Icon(
                    Icons.menu,
                    color: Theme.of(context).colorScheme.surface,
                  ),
                  onPressed: () {
                    Scaffold.of(context).openDrawer();
                    // _scaffoldKey.currentState?.openEndDrawer();
                  },
                  tooltip: 'Open Menu',
                );
              },
            ),
          ],
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(20),
            child: ColoredBox(
              color: Theme.of(context).colorScheme.outline,
              child: SizedBox(
                height: 30,
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 5),
                    child: Text(
                      'ZeroTier: Mobile network management',
                      style: theme.textTheme.titleSmall?.copyWith(
                        color: Theme.of(context).colorScheme.surface,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),

        ///
        body: CustomPaint(
          painter: BackgroundPainter(themeMode: themeMode),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 8),
                // Add token
                Card(
                  child: ListTile(
                    title: Text(
                      l10n.addToken,
                      style: theme.textTheme.titleLarge,
                    ),
                    trailing: const Icon(Icons.add),
                    onTap: () => _showAddTokenDialog(context),
                  ),
                ),

                ///
                const SizedBox(height: 12),
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: Text(
                    _savedTokens.isNotEmpty
                        ? l10n.savedTokens
                        : l10n.noSavedTokens,
                    style: theme.textTheme.bodyMedium,
                  ),
                ),

                ///
                if (_savedTokens.isNotEmpty)
                  Expanded(
                    child: ListView.builder(
                      itemCount: _savedTokens.length,
                      itemBuilder: (context, index) {
                        final tokenMap = _savedTokens[index];
                        final token = tokenMap['token'];
                        return Card(
                          child: ExpansionTile(
                            shape: const Border(),
                            title: Text(
                              tokenMap['name'] ?? '',
                              style:
                                  TextStyle(color: theme.colorScheme.primary),
                            ),
                            subtitle: Text(
                              '${tokenMap['token']!.substring(0, 2)}${List.filled(tokenMap['token']!.length - 4, '*').join()}${tokenMap['token']!.substring(tokenMap['token']!.length - 2)}',
                              overflow: TextOverflow.ellipsis,
                            ),
                            onExpansionChanged: (expanded) {
                              if (expanded) {
                                setState(() {
                                  zeroApi = ZeroTierRepository(token: token);
                                });
                              }
                            },
                            children: [
                              /// Actions with token
                              standartDivider(context),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Text(
                                    Lang.of(context).token,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  // edit
                                  TextButton.icon(
                                    icon: const Icon(Icons.edit),
                                    label: Text(l10n.edit),
                                    onPressed: () {
                                      _showEditDialog(context, tokenMap);
                                    },
                                  ),
                                  // delete
                                  TextButton.icon(
                                    icon: const Icon(Icons.delete),
                                    label: Text(l10n.delete),
                                    onPressed: () {
                                      showDialog<void>(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            title: Text(l10n.warning),
                                            content: Text(l10n.removeConfirm),
                                            actions: <Widget>[
                                              TextButton(
                                                onPressed: () =>
                                                    Navigator.pop(context),
                                                child: Text(l10n.cancel),
                                              ),
                                              TextButton(
                                                onPressed: () {
                                                  _removeToken(tokenMap);
                                                  Navigator.pop(context);
                                                },
                                                child: Text(l10n.delete),
                                              ),
                                            ],
                                          );
                                        },
                                      );
                                    },
                                    style: TextButton.styleFrom(
                                      foregroundColor: theme.colorScheme.error,
                                    ),
                                  ),
                                ],
                              ),

                              standartDivider(context),

                              /// Add new network
                              TextButton.icon(
                                icon: const Icon(Icons.add),
                                label: Text(l10n.createNetwork),
                                onPressed: () async {
                                  await showDialog<String>(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: Text(l10n.newNetwork),
                                        content: SingleChildScrollView(
                                          child: Column(
                                            children: [
                                              TextField(
                                                autofocus: true,
                                                decoration: InputDecoration(
                                                  labelText: l10n.networkName,
                                                  border:
                                                      const OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.all(
                                                      Radius.circular(12),
                                                    ),
                                                  ),
                                                ),
                                                controller:
                                                    nameController, // Add controller
                                              ),
                                              const SizedBox(height: 16),
                                              TextField(
                                                autofocus: true,
                                                decoration: InputDecoration(
                                                  labelText: l10n.description,
                                                  border:
                                                      const OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.all(
                                                      Radius.circular(12),
                                                    ),
                                                  ),
                                                ),
                                                controller:
                                                    descriptionController, // Add controller
                                              ),
                                            ],
                                          ),
                                        ),
                                        actions: [
                                          TextButton(
                                            onPressed: () =>
                                                Navigator.of(context).pop(),
                                            child: Text(l10n.cancel),
                                          ),
                                          TextButton(
                                            onPressed: () async {
                                              if (nameController
                                                  .text.isNotEmpty) {
                                                final result = await zeroApi
                                                    .networkService
                                                    .createNetwork(
                                                  token: tokenMap['token']!,
                                                  name: nameController.text,
                                                  description:
                                                      descriptionController
                                                          .text,
                                                );
                                                result
                                                    ? print('Created OK')
                                                    : print('not created');

                                                if (context.mounted) {
                                                  Navigator.of(context).pop();
                                                }
                                              }
                                            },
                                            child: Text(l10n.confirm),
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                },
                              ),
                              standartDivider(context),

                              /// заголовки
                              Padding(
                                padding:
                                    const EdgeInsets.only(left: 16, right: 16),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(l10n.networkName),
                                    // Text(l10n.onlineAndQtyOfNodes),
                                  ],
                                ),
                              ),

                              /// Networks List
                              OverflowBar(
                                alignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  StreamBuilder<List<Network>>(
                                    stream: zeroApi.networkService
                                        .fetchNetworksStream(token: token!),
                                    builder: (context, snapshot) {
                                      if (snapshot.hasData) {
                                        final networks = snapshot.data!;
                                        if (networks.isNotEmpty) {
                                          return Column(
                                            children: networks.map((network) {
                                              return Column(
                                                children: [
                                                  standartDivider(context),
                                                  ListTile(
                                                    onTap: () {
                                                      // print(network);
                                                      authRepository
                                                        ..setCurrentNetworkID(
                                                          network.id,
                                                        )
                                                        ..setCurrentNetwork(
                                                          network,
                                                        );
                                                      context
                                                          .read<
                                                              AuthNetworkBloc>()
                                                          .add(
                                                            AuthLoginRequested(
                                                              token: tokenMap[
                                                                      'token'] ??
                                                                  '',
                                                              network: network,
                                                            ),
                                                          );
                                                    },
                                                    title: Text(network.name),
                                                    subtitle: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          network.description,
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          maxLines: 1,
                                                        ),
                                                        // Text('id: ${network.id}'),
                                                      ],
                                                    ),
                                                    trailing: const Icon(
                                                      Icons.arrow_forward_ios,
                                                      size: 14,
                                                    ),
                                                  ),
                                                ],
                                              );
                                            }).toList(),
                                          );
                                        } else {
                                          return Text(l10n.noNetworkFound);
                                        }
                                      } else if (snapshot.hasError) {
                                        return Text(
                                          l10n.networkConnectionError,
                                          // '${l10n.error}: ${snapshot.error}',
                                        );
                                      }
                                      return Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 8),
                                        child: Text(l10n.loading),
                                      );
                                    },
                                  ),

                                  ///
                                ],
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  )
                else
                  const SizedBox.shrink(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showEditDialog(BuildContext context, Map<String, String> tokenMap) {
    final nameController = TextEditingController(text: tokenMap['name']);
    final tokenController = TextEditingController(text: tokenMap['token']);
    final l10n = Lang.of(context);
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.edit),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: InputDecoration(labelText: l10n.tokenName),
            ),
            TextField(
              controller: tokenController,
              decoration: InputDecoration(labelText: l10n.token),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.cancel),
          ),
          TextButton(
            onPressed: () async {
              await _removeToken(tokenMap);
              await _saveToken(nameController.text, tokenController.text);

              if (context.mounted) Navigator.pop(context);
            },
            child: Text(l10n.save),
          ),
        ],
      ),
    );
  }

  void _showAddTokenDialog(BuildContext context) {
    final nameController = TextEditingController();
    final tokenController = TextEditingController();
    final l10n = Lang.of(context);

    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.add),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: InputDecoration(labelText: l10n.tokenName),
            ),
            TextField(
              controller: tokenController,
              decoration: InputDecoration(labelText: l10n.token),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.cancel),
          ),
          TextButton(
            onPressed: () async {
              final isValid = await zeroApi.networkService
                  .validateToken(token: tokenController.text);
              if (isValid) {
                await _saveToken(nameController.text, tokenController.text);
                if (context.mounted) Navigator.pop(context);
              } else {
                // Show error message if token is invalid
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(l10n.invalidToken),
                    ),
                  );
                }
              }
            },
            child: Text(l10n.save),
          ),
        ],
      ),
    );
  }
}

Widget _buildDrawer(BuildContext context) {
  final l10n = Lang.of(context);
  return BlocBuilder<SettingsBloc, SettingsState>(
    builder: (context, state) {
      final bloc = context.read<SettingsBloc>();
      return Drawer(
        child: ListView(
          children: [
            SizedBox(
              height: 60,
              child: DrawerHeader(
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.outlineVariant,
                ),
                child: Text(
                  Lang.of(context).settings,
                  style: TextStyle(
                    fontSize: Theme.of(context).textTheme.titleLarge?.fontSize,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),

            /// Dark Theme
            ListTile(
              contentPadding: const EdgeInsets.only(right: 5, left: 10),
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
              contentPadding: const EdgeInsets.only(right: 5, left: 10),
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
              contentPadding: const EdgeInsets.only(right: 5, left: 10),
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
              contentPadding: const EdgeInsets.only(right: 5, left: 10),
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
                itemBuilder: (BuildContext context) => <PopupMenuEntry<Color>>[
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

            /// Rive Demo
            const SizedBox(
              width: 300,
              height: 300,
              child: ColoredBox(
                color: Color.fromARGB(223, 31, 22, 15),
                child: RiveAnimation.asset(
                  'assets/rive/zerotier.riv', // Путь к файлу .riv
                  animations: [
                    'Timeline 1',
                  ], // Название анимации внутри файла .riv
                  fit: BoxFit.contain,
                ),
              ),
            ),

            ///
          ],
        ),
      );
    },
  );
}
