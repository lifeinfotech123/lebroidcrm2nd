class AttendanceSummaryResponse {
  final bool? success;
  final AttendanceSummaryModel? data;

  AttendanceSummaryResponse({this.success, this.data});

  factory AttendanceSummaryResponse.fromJson(Map<String, dynamic> json) {
    return AttendanceSummaryResponse(
      success: json['success'],
      data: json['data'] != null ? AttendanceSummaryModel.fromJson(json['data']) : null,
    );
  }
}

class AttendanceSummaryModel {
  final int? total;
  final int? present;
  final int? absent;
  final int? late;
  final int? halfDay;
  final int? onLeave;
  final num? avgWorkingHrs;
  final String? totalLateMinutes;

  AttendanceSummaryModel({
    this.total,
    this.present,
    this.absent,
    this.late,
    this.halfDay,
    this.onLeave,
    this.avgWorkingHrs,
    this.totalLateMinutes,
  });

  factory AttendanceSummaryModel.fromJson(Map<String, dynamic> json) {
    return AttendanceSummaryModel(
      total: json['total'],
      present: json['present'],
      absent: json['absent'],
      late: json['late'],
      halfDay: json['half_day'],
      onLeave: json['on_leave'],
      avgWorkingHrs: json['avg_working_hrs'],
      totalLateMinutes: json['total_late_minutes']?.toString(),
    );
  }
}
