import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:zerotier_manager/bloc/auth_network_bloc/auth_network_bloc.dart';
import 'package:zerotier_manager/common/l10n/locale.dart';
import 'package:zerotier_manager/common/models/network.dart';

class NetworkPage extends StatelessWidget {
  const NetworkPage({required this.network, required this.token, super.key});
  final String token;
  final Network network;

  @override
  Widget build(BuildContext context) {
    final l10n = Lang.of(context);
    final formKey = GlobalKey<FormState>();
    final theme = Theme.of(context);

    // Инициализируем контроллеры
    final nameController = TextEditingController(text: network.name);
    final descriptionController =
        TextEditingController(text: network.description);
    final multicastLimitController =
        TextEditingController(text: network.multicastLimit.toString());
    final routeTargetController =
        TextEditingController(text: network.routeTarget);
    final ipRangeStartController =
        TextEditingController(text: network.ipRangeStart);
    final ipRangeEndController =
        TextEditingController(text: network.ipRangeEnd);

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (bool didPop, Object? result) {
        if (didPop) {
          return;
        }
        SystemNavigator.pop();
      },
      child: BlocBuilder<AuthNetworkBloc, AuthState>(
        builder: (context, state) {
          if (state is AuthLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is AuthAuthenticated) {
            return Scaffold(
              appBar: AppBar(
                backgroundColor: theme.colorScheme.onSurfaceVariant,
                automaticallyImplyLeading: false,
                titleSpacing: 0,
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Title
                    Padding(
                      padding: const EdgeInsets.only(left: 8),
                      child: Text(
                        l10n.networkConfiguration,
                        style: TextStyle(
                          color: theme.colorScheme.surface,
                        ),
                      ),
                    ),

                    /// Delete Network
                    Row(
                      children: [
                        SizedBox(
                          width: 50,
                          height: 50,
                          child: IconButton(
                            icon: Icon(
                              FontAwesomeIcons.trashCan,
                              color: theme.colorScheme.surface,
                              size: 20,
                            ),
                            onPressed: () => _showNetworkDeleteDialog(
                              context,
                              network,
                              token,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),

                        /// Update Network
                        SizedBox(
                          width: 50,
                          height: 50,
                          child: IconButton(
                            icon: Icon(
                              FontAwesomeIcons.floppyDisk,
                              color: theme.colorScheme.surface,
                              size: 20,
                            ),
                            onPressed: () {
                              if (formKey.currentState?.validate() ?? false) {
                                final updatedNetwork = network.copyWith(
                                  name: nameController.text,
                                  multicastLimit: int.parse(
                                    multicastLimitController.text,
                                  ),
                                  routeTarget: routeTargetController.text,
                                  ipRangeStart: ipRangeStartController.text,
                                  ipRangeEnd: ipRangeEndController.text,
                                  description: descriptionController.text,
                                  enableBroadcast: network.enableBroadcast,
                                  private: network.private,
                                );
                                // Добавить событие обновления сети
                                context.read<AuthNetworkBloc>().add(
                                      NetworkUpdated(
                                        token: token,
                                        networkId: network.id,
                                        network: updatedNetwork,
                                      ),
                                    );
                                if (context.mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      backgroundColor:
                                          theme.colorScheme.onSurfaceVariant,
                                      content: Text(
                                        l10n.networkSaved,
                                        style: TextStyle(
                                          color: theme.colorScheme.surface,
                                        ),
                                      ),
                                      duration:
                                          const Duration(milliseconds: 900),
                                    ),
                                  );
                                }
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              ///
              body: Form(
                key: formKey,
                child: ListView(
                  children: [
                    const SizedBox(height: 8),
                    Padding(
                      padding: const EdgeInsets.all(5),
                      child: Card(
                        color: theme.colorScheme.surfaceContainerHigh,
                        child: Padding(
                          padding: const EdgeInsets.all(8),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('Network ID'),
                              Text(network.id),
                            ],
                          ),
                        ),
                      ),
                    ),

                    /// Имя сети
                    Padding(
                      padding: const EdgeInsets.all(12),
                      child: TextFormField(
                        controller: nameController,
                        decoration: InputDecoration(
                          labelText: l10n.networkName,
                          errorBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: theme.colorScheme.error,
                            ),
                          ),
                          focusedErrorBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: theme.colorScheme.error,
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
                    ),

                    /// Описание сети
                    Padding(
                      padding: const EdgeInsets.all(12),
                      child: TextFormField(
                        controller: descriptionController,
                        decoration: InputDecoration(
                          labelText: l10n.description,
                          errorBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: theme.colorScheme.error,
                            ),
                          ),
                          focusedErrorBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: theme.colorScheme.error,
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
                    ),

                    /// Route Target
                    Padding(
                      padding: const EdgeInsets.all(12),
                      child: TextFormField(
                        controller: routeTargetController,
                        decoration: InputDecoration(
                          labelText: l10n.routeTarget,
                          errorBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: theme.colorScheme.error,
                            ),
                          ),
                          focusedErrorBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: theme.colorScheme.error,
                              width: 2,
                            ),
                          ),
                        ),
                        validator: (value) {
                          final cidrRegex = RegExp(
                            r'^(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)(\/[0-9]{1,2}|3[0-2])$',
                          );
                          if (value == null || value.isEmpty) {
                            return l10n.routeTargetValidationError;
                          }
                          if (!cidrRegex.hasMatch(value)) {
                            return l10n.invalidCIDR;
                          }
                          return null;
                        },
                      ),
                    ),

                    /// ipRangeStart
                    Padding(
                      padding: const EdgeInsets.all(12),
                      child: TextFormField(
                        controller: ipRangeStartController,
                        decoration: InputDecoration(
                          labelText: l10n.ipRangeStart,
                          errorBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: theme.colorScheme.error,
                            ),
                          ),
                          focusedErrorBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: theme.colorScheme.error,
                              width: 2,
                            ),
                          ),
                        ),
                        validator: (value) {
                          final ipRegex = RegExp(
                            r'^(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)$',
                          );
                          if (value == null || value.isEmpty) {
                            return l10n.invalidIpRange;
                          }
                          if (!ipRegex.hasMatch(value)) {
                            return l10n.invalidIP;
                          }
                          return null;
                        },
                      ),
                    ),

                    /// ipRangeEnd
                    Padding(
                      padding: const EdgeInsets.all(12),
                      child: TextFormField(
                        controller: ipRangeEndController,
                        decoration: InputDecoration(
                          labelText: l10n.ipRangeEnd,
                          errorBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: theme.colorScheme.error,
                            ),
                          ),
                          focusedErrorBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: theme.colorScheme.error,
                              width: 2,
                            ),
                          ),
                        ),
                        validator: (value) {
                          final ipRegex = RegExp(
                            r'^(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)$',
                          );
                          if (value == null || value.isEmpty) {
                            return l10n.invalidIpRange;
                          }
                          if (!ipRegex.hasMatch(value)) {
                            return l10n.invalidIP;
                          }
                          return null;
                        },
                      ),
                    ),

                    /// Multicast Limit
                    // Padding(
                    //   padding: const EdgeInsets.all(12),
                    //   child: TextFormField(
                    //     controller: multicastLimitController,
                    //     decoration: InputDecoration(
                    //       labelText: l10n.multicastLimit,
                    //       errorBorder: OutlineInputBorder(
                    //         borderSide: BorderSide(
                    //           color: theme.colorScheme.error,
                    //         ),
                    //       ),
                    //       focusedErrorBorder: OutlineInputBorder(
                    //         borderSide: BorderSide(
                    //           color: theme.colorScheme.error,
                    //           width: 2,
                    //         ),
                    //       ),
                    //     ),
                    //     keyboardType: TextInputType.number,
                    //     validator: (value) {
                    //       if (value == null || value.isEmpty) {
                    //         return l10n.multicastLimitError;
                    //       }
                    //       final number = int.tryParse(value);
                    //       if (number == null || number <= 0) {
                    //         return l10n.numberShouldBeGreaterThanZero;
                    //       }
                    //       return null;
                    //     },
                    //   ),
                    // ),

                    // ///! Delete button
                    // Row(
                    //   children: [
                    //     Padding(
                    //       padding: const EdgeInsets.only(
                    //         left: 12,
                    //         top: 24,
                    //         right: 12,
                    //       ),
                    //       child: ElevatedButton(
                    //         onPressed: () => _showNetworkDeleteDialog(
                    //           context,
                    //           network,
                    //           token,
                    //         ),
                    //         child: Text(
                    //           l10n.deleteNetwork,
                    //           style: TextStyle(color: theme.colorScheme.error),
                    //         ),
                    //         style: ButtonStyle(
                    //           backgroundColor: WidgetStateProperty.all(
                    //             theme.colorScheme.surfaceContainerHigh,
                    //           ),
                    //         ),
                    //       ),
                    //     ),
                    //     const SizedBox.shrink(),
                    //   ],
                    // ),

                    ///
                  ],
                ),
              ),
            );
          } else if (state is AuthFailure) {
            return Center(child: Text(state.error));
          }
          return Center(child: Text(l10n.stateEmpty));
        },
      ),
    );
  }

  void _showNetworkDeleteDialog(
    BuildContext context,
    Network network,
    String token,
  ) {
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
            onPressed: () {
              Navigator.pop(context);
              context.read<AuthNetworkBloc>().add(
                    NetworkDeleted(
                      token: token,
                      network: network,
                    ),
                  );
            },
            child: Text(l10n.delete),
          ),
        ],
      ),
    );
  }
}
