import 'package:equatable/equatable.dart';

class Network extends Equatable {
  final String id;
  final String name;
  final String description;
  final String creationTime;
  final String routeTarget;
  final String ipRangeStart;
  final String ipRangeEnd;
  final bool enableBroadcast;
  final bool private;
  final int multicastLimit;

  const Network({
    required this.id,
    required this.name,
    required this.description,
    required this.creationTime,
    required this.routeTarget,
    required this.ipRangeStart,
    required this.ipRangeEnd,
    required this.enableBroadcast,
    required this.private,
    required this.multicastLimit,
  });

  // Add this constructor
  const Network.empty()
      : id = '',
        name = '',
        description = '',
        creationTime = '',
        routeTarget = '',
        ipRangeStart = '',
        ipRangeEnd = '',
        enableBroadcast = false,
        private = false,
        multicastLimit = 32;

  factory Network.fromJson(Map<String, dynamic> json) {
    return Network(
      id: json['config']['id'] as String? ?? '--',
      name: json['config']['name'] as String? ?? '--',
      description: json['description'] as String? ?? '--',
      creationTime:
          _formatDateTime(json['config']['creationTime'] as int? ?? 0),
      routeTarget: (() {
        try {
          return json['config']['routes'][0]['target'] as String? ?? '--';
        } catch (e) {
          return '--';
        }
      })(),
      ipRangeStart: (() {
        try {
          return json['config']['ipAssignmentPools'][0]['ipRangeStart']
                  as String? ??
              '--';
        } catch (e) {
          return '--';
        }
      })(),
      ipRangeEnd: (() {
        try {
          return json['config']['ipAssignmentPools'][0]['ipRangeEnd']
                  as String? ??
              '--';
        } catch (e) {
          return '--';
        }
      })(),
      enableBroadcast: json['config']['enableBroadcast'] as bool? ?? false,
      private: json['config']['private'] as bool? ?? false,
      multicastLimit: json['config']['multicastLimit'] as int? ?? 32,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'config': {
        'id': id,
        'name': name,
        'description': description,
        'private': private,
        'creationTime': _parseDateTime(creationTime),
        'routes': [
          {'target': routeTarget},
        ],
        'ipAssignmentPools': [
          {
            'ipRangeStart': ipRangeStart,
            'ipRangeEnd': ipRangeEnd,
          },
        ],
        'multicastLimit': multicastLimit,
        'enableBroadcast': enableBroadcast,
      },
    };
  }

  static String _formatDateTime(int timestamp) {
    final date = DateTime.fromMillisecondsSinceEpoch(timestamp);
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')} '
        '${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}:${date.second.toString().padLeft(2, '0')}';
  }

  static int _parseDateTime(String dateTimeString) {
    final date = DateTime.parse(dateTimeString);
    return date.millisecondsSinceEpoch;
  }

  @override
  List<Object?> get props => [
        id,
        name,
        description,
        creationTime,
        routeTarget,
        ipRangeStart,
        ipRangeEnd,
        multicastLimit,
        enableBroadcast,
        private,
      ];

  Network copyWith({
    String? id,
    String? name,
    String? description,
    String? creationTime,
    String? routeTarget,
    String? ipRangeStart,
    String? ipRangeEnd,
    bool? enableBroadcast,
    bool? private,
    int? multicastLimit,
  }) {
    return Network(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      creationTime: creationTime ?? this.creationTime,
      routeTarget: routeTarget ?? this.routeTarget,
      ipRangeStart: ipRangeStart ?? this.ipRangeStart,
      ipRangeEnd: ipRangeEnd ?? this.ipRangeEnd,
      enableBroadcast: enableBroadcast ?? this.enableBroadcast,
      private: private ?? this.private,
      multicastLimit: multicastLimit ?? this.multicastLimit,
    );
  }
}
