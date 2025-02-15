import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:zerotier_manager/bloc/users_bloc/users_bloc.dart';
import 'package:zerotier_manager/common/enums.dart';
import 'package:zerotier_manager/common/functions/text_func.dart';
import 'package:zerotier_manager/common/l10n/locale.dart';
import 'package:zerotier_manager/common/models/user.dart';
import 'package:zerotier_manager/common/widgets/widgets.dart';
import 'package:zerotier_manager/repository/data_repository.dart';
import 'package:zerotier_manager/repository/zerotier_repository.dart';

class UsersPage extends StatefulWidget {
  final String token;
  final String networkId;

  const UsersPage({required this.token, required this.networkId, super.key});

  @override
  _UsersPageState createState() => _UsersPageState();
}

class _UsersPageState extends State<UsersPage> {
  final TextEditingController searchController = TextEditingController();
  String searchText = '';
  FocusNode focusNode = FocusNode();
  // Переменная для хранения текущего состояния авторизации
  AuthStatus authStatus = AuthStatus.all;
  ActivityStatus activityStatus = ActivityStatus.all;
  Map<String, bool> loadingStates =
      {}; // Добавляем состояние загрузки для каждого пользователя
  late DataRepository _dataRepository;
  final Map<String, bool> _favoriteStatus = {};
  bool _showOnlyFavorites = false;

  @override
  void initState() {
    super.initState();
    _initializeRepository();
  }

  Future<void> _initializeRepository() async {
    _dataRepository = await DataRepository.create();
  }

  // Обновляем статус избранного для конкретного пользователя
  Future<void> _updateFavoriteStatus(String nodeId) async {
    final isFavorite = await _dataRepository.isUserFavorite(nodeId);
    if (mounted) {
      setState(() {
        _favoriteStatus[nodeId] = isFavorite;
      });
    }
  }

  Future<void> _toggleFavorite(String nodeId) async {
    await _dataRepository.toggleFavoriteUser(nodeId);
    if (mounted) {
      await _updateFavoriteStatus(nodeId);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = Lang.of(context);
    final theme = Theme.of(context);

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (bool didPop, Object? result) {
        if (didPop) {
          return;
        }
        SystemNavigator.pop();
      },
      child: BlocProvider<UsersBloc>(
        create: (context) =>
            UsersBloc(zeroApi: ZeroTierRepository(token: widget.token))
              ..add(FetchUsers(widget.token, widget.networkId)),
        child: GestureDetector(
          onTap: () => focusNode.unfocus(),
          child: Scaffold(
            appBar: AppBar(
              backgroundColor: theme.colorScheme.onSurfaceVariant,
              automaticallyImplyLeading: false,
              titleSpacing: 12,
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    l10n.users,
                    style: TextStyle(
                      color: theme.colorScheme.surface,
                    ),
                  ),
                  Row(
                    children: [
                      // Favotite users
                      IconButton(
                        icon: Icon(
                          _showOnlyFavorites
                              ? FontAwesomeIcons.heartCircleCheck
                              : FontAwesomeIcons.heart,
                          color: Theme.of(context).colorScheme.errorContainer,
                        ),
                        onPressed: () {
                          setState(() {
                            _showOnlyFavorites = !_showOnlyFavorites;
                          });
                        },
                      ),
                      const SizedBox(width: 8),
                      GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: () => _userAddDialog(
                          context,
                          widget.networkId,
                          widget.token,
                        ),
                        child: SizedBox(
                          width: 50,
                          height: 50,
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: Icon(
                              FontAwesomeIcons.plus,
                              color: Theme.of(context).colorScheme.surface,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            ///
            body: Padding(
              padding: const EdgeInsets.only(
                left: 12,
                top: 12,
                right: 12,
              ),
              child: Column(
                children: [
                  // Поиск
                  Padding(
                    padding: const EdgeInsets.all(3),
                    child: TextField(
                      focusNode: focusNode,
                      controller: searchController,
                      decoration: InputDecoration(
                        labelText: l10n.search,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: const BorderSide(
                            width: 0.01,
                          ),
                        ),
                      ),
                      onChanged: (value) {
                        setState(() {
                          searchText =
                              value; // Обновляем текст поиска и вызываем setState
                        });
                      },
                    ),
                  ),
                  const SizedBox(height: 10),

                  /// Фильтры
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        l10n.authorization,
                        style: theme.textTheme.bodyLarge,
                      ),
                      // Текст "Авторизация"
                      Row(
                        children: [
                          Radio<AuthStatus>(
                            value: AuthStatus.all,
                            groupValue: authStatus,
                            onChanged: (AuthStatus? value) {
                              setState(() {
                                authStatus = value!;
                              });
                            },
                          ),

                          ///
                          Radio<AuthStatus>(
                            value: AuthStatus.authorized,
                            groupValue: authStatus,
                            activeColor: Colors.green,
                            fillColor: WidgetStateProperty.all(Colors.green),
                            onChanged: (AuthStatus? value) {
                              setState(() {
                                authStatus = value!;
                              });
                            },
                          ),

                          ///
                          Radio<AuthStatus>(
                            value: AuthStatus.unauthorized,
                            activeColor: Colors.red,
                            fillColor: WidgetStateProperty.all(Colors.red),
                            groupValue: authStatus,
                            onChanged: (AuthStatus? value) {
                              setState(() {
                                authStatus = value!;
                              });
                            },
                          ),
                          // Текст для радиокнопки "Неавторизованные"
                        ],
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        l10n.activity,
                        style: theme.textTheme.bodyLarge,
                      ), // Текст "Авторизация"
                      Row(
                        children: [
                          Radio<ActivityStatus>(
                            value: ActivityStatus.all,
                            groupValue: activityStatus,
                            onChanged: (ActivityStatus? value) {
                              setState(() {
                                activityStatus = value!;
                              });
                            },
                          ),

                          ///
                          Radio<ActivityStatus>(
                            value: ActivityStatus.online,
                            groupValue: activityStatus,
                            activeColor: Colors.green,
                            fillColor: WidgetStateProperty.all(Colors.green),
                            onChanged: (ActivityStatus? value) {
                              setState(() {
                                activityStatus = value!;
                              });
                            },
                          ),

                          ///
                          Radio<ActivityStatus>(
                            value: ActivityStatus.offline,
                            activeColor: Colors.red,
                            fillColor: WidgetStateProperty.all(Colors.red),
                            groupValue: activityStatus,
                            onChanged: (ActivityStatus? value) {
                              setState(() {
                                activityStatus = value!;
                              });
                            },
                          ),

                          ///
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),

                  /// Body
                  Expanded(
                    child: BlocBuilder<UsersBloc, UserState>(
                      builder: (context, state) {
                        return switch (state) {
                          UserLoading() =>
                            const Center(child: CircularProgressIndicator()),
                          UserLoaded(members: final members) =>
                            ListView.builder(
                              itemCount: members
                                  .where(
                                    (user) => user.name
                                        .toLowerCase()
                                        .contains(searchText.toLowerCase()),
                                  )
                                  .length,
                              itemBuilder: (context, index) {
                                final user = members
                                    .where(
                                      (user) => user.name
                                          .toLowerCase()
                                          .contains(searchText.toLowerCase()),
                                    )
                                    .toList()[index];

                                // Обновляем статус избранного при построении элемента
                                if (!_favoriteStatus.containsKey(user.nodeId)) {
                                  _updateFavoriteStatus(user.nodeId);
                                }

                                // Фильтр по избранным
                                if (_showOnlyFavorites &&
                                    !(_favoriteStatus[user.nodeId] ?? false)) {
                                  return const SizedBox.shrink();
                                }

                                // Фильтр по статусу авторизации
                                if (authStatus == AuthStatus.authorized &&
                                    !user.authorized) {
                                  return const SizedBox.shrink();
                                } else if (authStatus ==
                                        AuthStatus.unauthorized &&
                                    user.authorized) {
                                  return const SizedBox.shrink();
                                }

                                // Фильтр по активности
                                DateTime lastSeenDate;
                                try {
                                  // Предполагается, что lastSeen в формате строки, которую можно парсить DateTime.parse
                                  lastSeenDate = DateTime.parse(user.lastSeen);
                                } catch (e) {
                                  // Если не удалось преобразовать дату, считаем пользователя офлайн
                                  lastSeenDate = DateTime.now()
                                      .subtract(const Duration(days: 1));
                                }
                                final isOnline = DateTime.now()
                                        .difference(lastSeenDate)
                                        .inHours <
                                    1;

                                if (activityStatus == ActivityStatus.online &&
                                    !isOnline) {
                                  return const SizedBox.shrink();
                                } else if (activityStatus ==
                                        ActivityStatus.offline &&
                                    isOnline) {
                                  return const SizedBox.shrink();
                                }

                                return Card(
                                  child: ExpansionTile(
                                    shape: const Border(),
                                    title: Text(user.name),
                                    subtitle: Text(
                                      formatLastSeen(
                                        user.lastSeen,
                                        Localizations.localeOf(context)
                                            .languageCode,
                                      ),
                                    ),
                                    leading: GestureDetector(
                                      onTap: () async {
                                        setState(() {
                                          loadingStates[user.nodeId] = true;
                                        });
                                        final startTime = DateTime.now();
                                        await ZeroTierRepository(
                                          token: widget.token,
                                        ).userService.setUserAuthorization(
                                              token: widget.token,
                                              user: user,
                                              authorized: !user.authorized,
                                            );
                                        final elapsedTime = DateTime.now()
                                            .difference(startTime);
                                        if (elapsedTime <
                                            const Duration(seconds: 3)) {
                                          await Future.delayed(
                                            const Duration(seconds: 3) -
                                                elapsedTime,
                                          );
                                        }
                                        setState(() {
                                          loadingStates[user.nodeId] = false;
                                        });
                                      },
                                      // ignore: use_if_null_to_convert_nulls_to_bools
                                      child: loadingStates[user.nodeId] == true
                                          ? const CircularProgressIndicator()
                                          : user.authorized
                                              ? const Icon(
                                                  FontAwesomeIcons.circleCheck,
                                                  color: Colors.green,
                                                )
                                              : const Icon(
                                                  FontAwesomeIcons.ban,
                                                  color: Colors.red,
                                                ),
                                    ),
                                    childrenPadding: const EdgeInsets.all(8),
                                    expandedCrossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    expandedAlignment: Alignment.centerLeft,
                                    children: [
                                      // NodeID
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(l10n.nodeID),
                                          Text(user.nodeId),
                                        ],
                                      ),
                                      // DeviceIP
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(l10n.deviceIP),
                                          Text(user.physicalAddress),
                                        ],
                                      ),
                                      // IPAssignments
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(l10n.ipAssignments),
                                          Text(user.ipAssignments.toString()),
                                        ],
                                      ),
                                      // LastSeen
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(l10n.lastSeen),
                                          Text(user.lastSeen),
                                        ],
                                      ),
                                      // Description
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(l10n.description),
                                          const SizedBox(width: 16),
                                          Expanded(
                                            child: Text(
                                              user.description,
                                              textAlign: TextAlign.end,
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 8),

                                      ///
                                      standartDivider(context),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          // Add to Favorites
                                          IconButton(
                                            icon: Icon(
                                              // ignore: use_if_null_to_convert_nulls_to_bools
                                              _favoriteStatus[user.nodeId] ==
                                                      true
                                                  ? Icons.favorite
                                                  : Icons.favorite_outline,

                                              color: theme.colorScheme.error,
                                            ),
                                            onPressed: () =>
                                                _toggleFavorite(user.nodeId),
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: [
                                              TextButton(
                                                onPressed: () =>
                                                    _userEditDialog(
                                                  context,
                                                  user,
                                                  widget.token,
                                                ),
                                                child: Text(l10n.editAlt),
                                              ),
                                              TextButton(
                                                onPressed: () {
                                                  _userDeletetDialog(
                                                    context,
                                                    user,
                                                    widget.token,
                                                  );
                                                },
                                                child: Text(
                                                  l10n.delete,
                                                  style: TextStyle(
                                                    color:
                                                        theme.colorScheme.error,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),

                                      ///
                                    ],
                                  ),
                                );
                              },
                            ),
                          // ignore: unused_local_variable
                          UserError(message: final message) => Center(
                              child: Text(
                                l10n.networkConnectionError,
                                // '${l10n.error}: $message',
                              ),
                            ),
                          _ => Center(child: Text(l10n.userNotFound)),
                        };
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

void _userEditDialog(BuildContext context, User user, String token) {
  final nameController = TextEditingController(text: user.name);
  final descriptionController = TextEditingController(text: user.description);
  final ipAssignmentsController =
      TextEditingController(text: user.ipAssignments.join(', '));

  // Добавляем FocusNode для каждого поля
  final nameFocus = FocusNode();
  final descriptionFocus = FocusNode();
  final ipAssignmentsFocus = FocusNode();

  // Добавляем слушатели для обновления состояния
  void addFocusListeners(StateSetter setState) {
    nameFocus.addListener(() => setState(() {}));
    descriptionFocus.addListener(() => setState(() {}));
    ipAssignmentsFocus.addListener(() => setState(() {}));
  }

  final l10n = Lang.of(context);
  final theme = Theme.of(context);

  showDialog<void>(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(l10n.edit),
      content: ConstrainedBox(
        constraints: BoxConstraints(
          minWidth: MediaQuery.of(context).size.width * 0.8,
        ),
        child: SingleChildScrollView(
          child: StatefulBuilder(
            builder: (context, setState) {
              // Добавляем слушатели при первом построении
              addFocusListeners(setState);

              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: nameController,
                    focusNode: nameFocus,
                    minLines: 1,
                    maxLines: null,
                    decoration: InputDecoration(
                      labelText: l10n.name,
                      suffixIcon: nameFocus.hasFocus
                          ? IconButton(
                              icon: Icon(
                                Icons.cancel,
                                color: theme.colorScheme.error,
                              ),
                              onPressed: nameController.clear,
                            )
                          : null,
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: descriptionController,
                    focusNode: descriptionFocus,
                    minLines: 1,
                    maxLines: null,
                    decoration: InputDecoration(
                      labelText: l10n.description,
                      suffixIcon: descriptionFocus.hasFocus
                          ? IconButton(
                              icon: Icon(
                                Icons.cancel,
                                color: theme.colorScheme.error,
                              ),
                              onPressed: descriptionController.clear,
                            )
                          : null,
                    ),
                  ),
                  const SizedBox(height: 8),

                  /// Назначить IP адреса
                  TextField(
                    controller: ipAssignmentsController,
                    focusNode: ipAssignmentsFocus,
                    minLines: 1,
                    maxLines: null,
                    decoration: InputDecoration(
                      labelText: l10n.ipAssignments,
                      suffixIcon: ipAssignmentsFocus.hasFocus
                          ? IconButton(
                              icon: Icon(
                                Icons.cancel,
                                color: theme.colorScheme.error,
                              ),
                              onPressed: ipAssignmentsController.clear,
                            )
                          : null,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    l10n.addIpToAssignments,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              );
            },
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(l10n.cancel),
        ),
        ElevatedButton(
          onPressed: () async {
            // создаем обновленную версию пользователя
            final updatedUser = user.copyWith(
              name: nameController.text,
              description: descriptionController.text,
              authorized: user.authorized,
              ipAssignments: ipAssignmentsController.text
                  .split(',')
                  .map((ip) => ip.trim())
                  .toList(),
            );

            /// Вызовите метод обновления пользователя
            try {
              await ZeroTierRepository(token: token).userService.updateUser(
                    token: token,
                    user: updatedUser,
                  );

              if (context.mounted) {
                Navigator.pop(context);
              }
            } catch (e) {
              // Обработка ошибок
              print('${l10n.updateUserError}: $e');
            }
          },
          child: Text(l10n.save),
        ),
      ],
    ),
  );
}

void _userAddDialog(BuildContext context, String networkID, String token) {
  // final nodeIdController = TextEditingController(text: '');
  final emailController = TextEditingController(text: '');

  // Добавляем FocusNode для каждого поля
  final nodeIdFocus = FocusNode();
  final emailFocus = FocusNode();

  // Добавляем слушатели для обновления состояния
  void addFocusListeners(StateSetter setState) {
    nodeIdFocus.addListener(() => setState(() {}));
    emailFocus.addListener(() => setState(() {}));
  }

  final l10n = Lang.of(context);
  final theme = Theme.of(context);

  showDialog<void>(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(l10n.inviteUserByEmail),
      content: ConstrainedBox(
        constraints: BoxConstraints(
          minWidth: MediaQuery.of(context).size.width * 0.8,
        ),
        child: SingleChildScrollView(
          child: StatefulBuilder(
            builder: (context, setState) {
              // Добавляем слушатели при первом построении
              addFocusListeners(setState);

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // wideDivider(context),
                  // Text(l10n.inviteUserByEmail),
                  TextField(
                    controller: emailController,
                    focusNode: emailFocus,
                    minLines: 1,
                    maxLines: null,
                    decoration: InputDecoration(
                      labelText: l10n.enterEmail,
                      enabledBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(width: 0.2),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: theme.colorScheme.primary,
                        ),
                      ),
                      suffixIcon: emailFocus.hasFocus
                          ? IconButton(
                              icon: Icon(
                                Icons.cancel,
                                color: theme.colorScheme.error,
                              ),
                              onPressed: emailController.clear,
                            )
                          : null,
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () async {
                      /// Вызовите метод обновления пользователя
                      try {
                        await ZeroTierRepository(token: token)
                            .userService
                            .inviteUserByEmail(
                              token: token,
                              // orgId: '800bec6d-b6b5-43f8-bd06-5425796afc38',
                              email: emailController.text,
                            );
                        // Обовите состояние или выполните другие действия после успешного обновления
                        if (context.mounted) {
                          Navigator.pop(context);
                        }
                      } catch (e) {
                        // Обработка ошибок
                        print('${l10n.error}: $e');
                      }
                    },
                    child: Text(l10n.send),
                  ),
                ],
              );
            },
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(l10n.cancel),
        ),
      ],
    ),
  );
}

void _userDeletetDialog(BuildContext context, User user, String token) {
  final userApi = ZeroTierRepository(token: token).userService;
  final l10n = Lang.of(context);
  showDialog<void>(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(l10n.edit),
      content: Text(l10n.removeConfirm),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(l10n.cancel),
        ),
        ElevatedButton(
          onPressed: () async {
            // Вызовите метод удаления пользователя
            try {
              await userApi
                  .deleteUser(
                token: token,
                user: user,
              )
                  .then((value) {
                if (context.mounted) {
                  Navigator.pop(context);
                }
              });
            } catch (e) {
              // Обработка ошибок
              print('${l10n.deleteUserError}: $e');
            }
          },
          child: Text(l10n.delete),
        ),
      ],
    ),
  );
}
