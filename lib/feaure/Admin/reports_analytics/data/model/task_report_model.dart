class TaskReportModel {
  final String? title;
  final String? assignedTo;
  final String? department;
  final String? branch;
  final String? assignedBy;
  final String? priority;
  final String? status;
  final String? deadline;
  final String? isOverdue;
  final String? completionRemarks;

  TaskReportModel({
    this.title,
    this.assignedTo,
    this.department,
    this.branch,
    this.assignedBy,
    this.priority,
    this.status,
    this.deadline,
    this.isOverdue,
    this.completionRemarks,
  });

  factory TaskReportModel.fromJson(Map<String, dynamic> json) {
    return TaskReportModel(
      title: json['title'],
      assignedTo: json['assigned_to'],
      department: json['department'],
      branch: json['branch'],
      assignedBy: json['assigned_by'],
      priority: json['priority'],
      status: json['status'],
      deadline: json['deadline'],
      isOverdue: json['is_overdue'],
      completionRemarks: json['completion_remarks'],
    );
  }
}
