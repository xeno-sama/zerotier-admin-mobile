class UserInvitation {
  final String orgId;
  final String email;
  final String id;
  final int creationTime;
  final String status;
  final int updateTime;
  final String ownerEmail;

  const UserInvitation({
    required this.orgId,
    required this.email,
    required this.id,
    required this.creationTime,
    required this.status,
    required this.updateTime,
    required this.ownerEmail,
  });

  factory UserInvitation.fromJson(Map<String, dynamic> json) {
    int parseTimestamp(dynamic value) {
      if (value is int) return value;
      if (value is String) {
        final date = DateTime.tryParse(value);
        if (date != null) return date.millisecondsSinceEpoch;
        return int.tryParse(value) ?? 0;
      }
      return 0;
    }

    return UserInvitation(
      orgId: json['orgId'] as String,
      email: json['email'] as String,
      id: json['id'] as String,
      creationTime: parseTimestamp(json['creation_time']),
      status: json['status'] as String,
      updateTime: parseTimestamp(json['update_time']),
      ownerEmail: json['ownerEmail'] as String,
    );
  }

  DateTime get creationDateTime =>
      DateTime.fromMillisecondsSinceEpoch(creationTime);
  DateTime get updateDateTime =>
      DateTime.fromMillisecondsSinceEpoch(updateTime);
}
