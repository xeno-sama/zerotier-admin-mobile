import 'package:equatable/equatable.dart';

class User extends Equatable {
  final String id;
  final String networkId;
  final String nodeId;
  final String name;
  final String description;
  final String physicalAddress;
  final String clientVersion;
  final bool authorized;
  final String lastSeen;
  final List<String> ipAssignments;

  const User({
    required this.id,
    required this.networkId,
    required this.nodeId,
    required this.name,
    required this.description,
    required this.physicalAddress,
    required this.clientVersion,
    required this.authorized,
    required this.lastSeen,
    required this.ipAssignments,
  });

  const User.empty()
      : id = '',
        networkId = '',
        nodeId = '',
        name = '',
        description = '',
        physicalAddress = '',
        clientVersion = '',
        authorized = false,
        lastSeen = '',
        ipAssignments = const [];

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as String? ?? '--',
      networkId: json['networkId'] as String? ?? '--',
      nodeId: json['nodeId'] as String? ?? '--',
      name: json['name'] as String? ?? '--',
      description: json['description'] as String? ?? '--',
      physicalAddress: json['physicalAddress'] as String? ?? '--',
      clientVersion: json['clientVersion'] as String? ?? '--',
      authorized: json['config']?['authorized'] as bool? ?? false,
      lastSeen: _formatDateTime(json['lastSeen'] as int? ?? 0),
      ipAssignments: (json['config']?['ipAssignments'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'networkId': networkId,
      'nodeId': nodeId,
      'name': name,
      'description': description,
      'physicalAddress': physicalAddress,
      'clientVersion': clientVersion,
      'config': {
        'authorized': authorized,
        'ipAssignments': ipAssignments,
      },
      'lastSeen': _parseDateTime(lastSeen),
    };
  }

  static String _formatDateTime(int timestamp) {
    final date = DateTime.fromMillisecondsSinceEpoch(timestamp);
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')} '
        '${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}'; //:${date.second.toString().padLeft(2, '0')}
  }

  static int _parseDateTime(String dateTimeString) {
    final date = DateTime.parse(dateTimeString);
    return date.millisecondsSinceEpoch;
  }

  // static int _parseDateTime(String dateTimeString) {
  //   final date = DateTime.parse(dateTimeString);
  //   final truncatedDate = DateTime(
  //     date.year,
  //     date.month,
  //     date.day,
  //     date.hour,
  //     date.minute,
  //   );
  //   return truncatedDate.millisecondsSinceEpoch;
  // }

  @override
  List<Object?> get props => [
        id,
        networkId,
        nodeId,
        name,
        description,
        physicalAddress,
        clientVersion,
        authorized,
        lastSeen,
        ipAssignments,
      ];

  User copyWith({
    String? id,
    String? networkId,
    String? nodeId,
    String? name,
    String? description,
    String? physicalAddress,
    String? clientVersion,
    bool? authorized,
    String? lastSeen,
    List<String>? ipAssignments,
  }) {
    return User(
      id: id ?? this.id,
      networkId: networkId ?? this.networkId,
      nodeId: nodeId ?? this.nodeId,
      name: name ?? this.name,
      description: description ?? this.description,
      physicalAddress: physicalAddress ?? this.physicalAddress,
      clientVersion: clientVersion ?? this.clientVersion,
      authorized: authorized ?? this.authorized,
      lastSeen: lastSeen ?? this.lastSeen,
      ipAssignments: ipAssignments ?? this.ipAssignments,
    );
  }

  // Дополнительные полезные методы

  bool get isOnline {
    final lastSeenDate = DateTime.parse(lastSeen);
    final now = DateTime.now();
    final difference = now.difference(lastSeenDate);
    return difference.inMinutes <
        5; // считаем онлайн если был в сети менее 5 минут назад
  }

  String get mainIp {
    return ipAssignments.isNotEmpty ? ipAssignments.first : '--';
  }

  String get status {
    if (!authorized) return 'Unauthorized';
    return isOnline ? 'Online' : 'Offline';
  }

  String get shortNodeId {
    return nodeId.length > 6 ? '${nodeId.substring(0, 6)}...' : nodeId;
  }
}
