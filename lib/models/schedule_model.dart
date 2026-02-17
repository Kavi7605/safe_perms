class Schedule {
  final String key; // Unique ID
  final String appName;
  final String permissionType;
  final String time;
  final bool isActive;

  Schedule({
    required this.key,
    required this.appName,
    required this.permissionType,
    required this.time,
    this.isActive = true,
  });

  // Convert to Map for database storage
  Map<String, dynamic> toMap() {
    return {
      'key': key,
      'appName': appName,
      'permissionType': permissionType,
      'time': time,
      'isActive': isActive,
    };
  }

  // Create Object from Map
  factory Schedule.fromMap(Map<dynamic, dynamic> map) {
    return Schedule(
      key: map['key'],
      appName: map['appName'],
      permissionType: map['permissionType'],
      time: map['time'],
      isActive: map['isActive'] ?? true,
    );
  }
}