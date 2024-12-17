import 'package:flutter/material.dart';
import 'package:zerotier_manager/common/l10n/locale.dart';
import 'package:zerotier_manager/common/models/user.dart';
import 'package:zerotier_manager/repository/zerotier_repository.dart';

class UserEdit extends StatefulWidget {
  const UserEdit({required this.user, required this.token, super.key});
  final User user;
  final String token;

  @override
  State<UserEdit> createState() => _UserEditState();
}

class _UserEditState extends State<UserEdit> {
  late TextEditingController nameController;
  late TextEditingController descriptionController;
  late TextEditingController ipAssignmentsController;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.user.name);
    descriptionController =
        TextEditingController(text: widget.user.description);
    ipAssignmentsController =
        TextEditingController(text: widget.user.ipAssignments.join(', '));
  }

  @override
  Widget build(BuildContext context) {
    final l10n = Lang.of(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.onSurfaceVariant,
        automaticallyImplyLeading: false,
        titleSpacing: 8,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Назад к выбору сетей и токенов
            GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () => Navigator.of(context).pushReplacementNamed('/users'),
              child: Row(
                children: [
                  Icon(
                    Icons.arrow_back_ios,
                    color: Theme.of(context).colorScheme.surface,
                  ),
                  Text(
                    l10n.networks,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.surface,
                    ),
                  ),
                ],
              ),
            ),

            /// Сохранить
            Text(
              l10n.users,
              style: TextStyle(
                color: Theme.of(context).colorScheme.surface,
              ),
            ),
          ],
        ),
      ),

      ///
      body: Column(
        children: [
          Expanded(
            child: ListView(
              children: [
                TextFormField(
                  controller: TextEditingController(text: nameController.text),
                  decoration: InputDecoration(
                    labelText: l10n.name,
                    errorBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Theme.of(context).colorScheme.error,
                      ),
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Theme.of(context).colorScheme.error,
                        width: 2,
                      ),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return l10n.nameValidationError;
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller:
                      TextEditingController(text: descriptionController.text),
                  decoration: const InputDecoration(
                    labelText: 'Description',
                  ),
                ),
                TextFormField(
                  controller: TextEditingController(
                    text: ipAssignmentsController.text,
                  ),
                  decoration: const InputDecoration(
                    labelText: 'IP Assignments',
                  ),
                ),
                ElevatedButton(
                  onPressed: () async {
                    // создаем обновленную версию пользователя
                    final updatedUser = widget.user.copyWith(
                      name: nameController.text,
                      description: descriptionController.text,
                      ipAssignments: ipAssignmentsController.text
                          .split(',')
                          .map((ip) => ip.trim())
                          .toList(),
                    );

                    /// Вызовите метод обновления пользователя
                    try {
                      await ZeroTierRepository(token: widget.token)
                          .userService
                          .updateUser(
                            token: widget.token,
                            user: updatedUser,
                          );
                      // Обновите состояние или выполните другие действия после успешного обновления
                    } catch (e) {
                      // Обработка ошибок
                      debugPrint('Error updating user: $e');
                    }
                  },
                  child: const Text('Save'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
