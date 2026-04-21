class PerformanceReportModel {
  final String? employeeId;
  final String? name;
  final String? department;
  final String? branch;
  final String? month;
  final int? attendanceScore;
  final int? taskScore;
  final int? punctuality;
  final int? teamwork;

  PerformanceReportModel({
    this.employeeId,
    this.name,
    this.department,
    this.branch,
    this.month,
    this.attendanceScore,
    this.taskScore,
    this.punctuality,
    this.teamwork,
  });

  factory PerformanceReportModel.fromJson(Map<String, dynamic> json) {
    return PerformanceReportModel(
      employeeId: json['employee_id'],
      name: json['name'],
      department: json['department'],
      branch: json['branch'],
      month: json['month'],
      attendanceScore: json['attendance_score'],
      taskScore: json['task_score'],
      punctuality: json['punctuality'],
      teamwork: json['teamwork'],
    );
  }
}
