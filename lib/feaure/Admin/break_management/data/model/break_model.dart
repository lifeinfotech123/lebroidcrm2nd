class BreakRecord {
  final int? id;
  final int attendanceId;
  final int userId;
  final int breakTypeId;
  final DateTime? startedAt;
  final DateTime? endedAt;
  final int durationMinutes;
  final bool isOverLimit;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final BreakUser? user;
  final BreakType? breakType;
  final BreakAttendance? attendance;

  BreakRecord({
    this.id,
    required this.attendanceId,
    required this.userId,
    required this.breakTypeId,
    this.startedAt,
    this.endedAt,
    this.durationMinutes = 0,
    this.isOverLimit = false,
    this.createdAt,
    this.updatedAt,
    this.user,
    this.breakType,
    this.attendance,
  });

  factory BreakRecord.fromJson(Map<String, dynamic> json) {
    return BreakRecord(
      id: json['id'],
      attendanceId: json['attendance_id'] is int ? json['attendance_id'] : int.tryParse(json['attendance_id'].toString()) ?? 0,
      userId: json['user_id'] is int ? json['user_id'] : int.tryParse(json['user_id'].toString()) ?? 0,
      breakTypeId: json['break_type_id'] is int ? json['break_type_id'] : int.tryParse(json['break_type_id'].toString()) ?? 0,
      startedAt: json['started_at'] != null ? DateTime.parse(json['started_at']) : null,
      endedAt: json['ended_at'] != null ? DateTime.parse(json['ended_at']) : null,
      durationMinutes: json['duration_minutes'] ?? 0,
      isOverLimit: json['is_over_limit'] ?? false,
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at']) : null,
      updatedAt: json['updated_at'] != null ? DateTime.parse(json['updated_at']) : null,
      user: json['user'] != null ? BreakUser.fromJson(json['user']) : null,
      breakType: json['break_type'] != null ? BreakType.fromJson(json['break_type']) : null,
      attendance: json['attendance'] != null ? BreakAttendance.fromJson(json['attendance']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'attendance_id': attendanceId,
      'user_id': userId,
      'break_type_id': breakTypeId,
      if (startedAt != null) 'started_at': startedAt!.toIso8601String(),
      if (endedAt != null) 'ended_at': endedAt!.toIso8601String(),
      'duration_minutes': durationMinutes,
      'is_over_limit': isOverLimit,
    };
  }
}

class BreakUser {
  final int id;
  final String? name;
  final String? employeeId;
  final String? departmentId;

  BreakUser({required this.id, this.name, this.employeeId, this.departmentId});

  factory BreakUser.fromJson(Map<String, dynamic> json) {
    return BreakUser(
      id: json['id'],
      name: json['name'],
      employeeId: json['employee_id'],
      departmentId: json['department_id']?.toString(),
    );
  }
}

class BreakType {
  final int id;
  final String? name;
  final String? type;
  final int? maxMinutes;

  BreakType({required this.id, this.name, this.type, this.maxMinutes});

  factory BreakType.fromJson(Map<String, dynamic> json) {
    return BreakType(
      id: json['id'],
      name: json['name'],
      type: json['type'],
      maxMinutes: json['max_minutes'],
    );
  }
}

class BreakAttendance {
  final int id;
  final DateTime? date;

  BreakAttendance({required this.id, this.date});

  factory BreakAttendance.fromJson(Map<String, dynamic> json) {
    return BreakAttendance(
      id: json['id'],
      date: json['date'] != null ? DateTime.parse(json['date']) : null,
    );
  }
}
