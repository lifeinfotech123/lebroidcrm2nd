class AttendanceReportResponse {
  final List<AttendanceReportRow> rows;
  final AttendanceReportStats stats;

  AttendanceReportResponse({required this.rows, required this.stats});

  factory AttendanceReportResponse.fromJson(Map<String, dynamic> json) {
    return AttendanceReportResponse(
      rows: (json['rows'] as List).map((i) => AttendanceReportRow.fromJson(i)).toList(),
      stats: AttendanceReportStats.fromJson(json['stats']),
    );
  }
}

class AttendanceReportRow {
  final String? employeeId;
  final String? name;
  final String? department;
  final String? branch;
  final int? workingDays;
  final int? present;
  final int? absent;
  final int? late;
  final int? halfDay;
  final int? onLeave;
  final double? totalHrs;
  final double? avgHrs;
  final int? lateMinutes;
  final double? attendancePct;

  AttendanceReportRow({
    this.employeeId,
    this.name,
    this.department,
    this.branch,
    this.workingDays,
    this.present,
    this.absent,
    this.late,
    this.halfDay,
    this.onLeave,
    this.totalHrs,
    this.avgHrs,
    this.lateMinutes,
    this.attendancePct,
  });

  factory AttendanceReportRow.fromJson(Map<String, dynamic> json) {
    return AttendanceReportRow(
      employeeId: json['employee_id'],
      name: json['name'],
      department: json['department'],
      branch: json['branch'],
      workingDays: json['working_days'],
      present: json['present'],
      absent: json['absent'],
      late: json['late'],
      halfDay: json['half_day'],
      onLeave: json['on_leave'],
      totalHrs: (json['total_hrs'] as num?)?.toDouble(),
      avgHrs: (json['avg_hrs'] as num?)?.toDouble(),
      lateMinutes: json['late_minutes'],
      attendancePct: (json['attendance_pct'] as num?)?.toDouble(),
    );
  }
}

class AttendanceReportStats {
  final double? avgPct;
  final int? totalPresent;
  final int? totalAbsent;
  final int? totalLate;
  final double? totalHrs;
  final int? below80pct;

  AttendanceReportStats({
    this.avgPct,
    this.totalPresent,
    this.totalAbsent,
    this.totalLate,
    this.totalHrs,
    this.below80pct,
  });

  factory AttendanceReportStats.fromJson(Map<String, dynamic> json) {
    return AttendanceReportStats(
      avgPct: (json['avg_pct'] as num?)?.toDouble(),
      totalPresent: json['total_present'],
      totalAbsent: json['total_absent'],
      totalLate: json['total_late'],
      totalHrs: (json['total_hrs'] as num?)?.toDouble(),
      below80pct: json['below_80pct'],
    );
  }
}
