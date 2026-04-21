class TaskModel {
  final int id;
  final String title;
  final String description;
  final String priority;
  final String deadline;
  final String status;
  final UserBrief? assignedBy;
  final UserBrief? assignedTo;
  final String? branchId;
  final String? createdAt;
  final String? updatedAt;
  final String? verifiedAt;
  final UserBrief? verifiedBy;
  final String? rejectionRemarks;
  final String? completionRemarks;
  final String? completionAttachment;

  TaskModel({
    required this.id,
    required this.title,
    required this.description,
    required this.priority,
    required this.deadline,
    required this.status,
    this.assignedBy,
    this.assignedTo,
    this.branchId,
    this.createdAt,
    this.updatedAt,
    this.verifiedAt,
    this.verifiedBy,
    this.rejectionRemarks,
    this.completionRemarks,
    this.completionAttachment,
  });

  factory TaskModel.fromJson(Map<String, dynamic> json) {
    return TaskModel(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      priority: json['priority'] ?? '',
      deadline: json['deadline'] ?? '',
      status: json['status'] ?? '',
      assignedBy: json['assigned_by'] != null ? (json['assigned_by'] is Map<String, dynamic> ? UserBrief.fromJson(json['assigned_by']) : null) : null,
      assignedTo: json['assigned_to'] != null ? (json['assigned_to'] is Map<String, dynamic> ? UserBrief.fromJson(json['assigned_to']) : null) : null,
      branchId: json['branch_id']?.toString(),
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      verifiedAt: json['verified_at'],
      verifiedBy: json['verified_by'] != null ? (json['verified_by'] is Map<String, dynamic> ? UserBrief.fromJson(json['verified_by']) : null) : null,
      rejectionRemarks: json['rejection_remarks'],
      completionRemarks: json['completion_remarks'],
      completionAttachment: json['completion_attachment'],
    );
  }

  // Simplified version of the model to keep it consistent with the UI
  String get initials => assignedTo?.name.split(' ').map((e) => e[0]).take(2).join('').toUpperCase() ?? 'NA';
  String get assignee => assignedTo?.name ?? 'Unassigned';
  double get progressVal {
    switch (status.toLowerCase()) {
      case 'pending': return 0.0;
      case 'in_progress': return 0.5;
      case 'completed_pending_approval': return 0.8;
      case 'approved': return 1.0;
      default: return 0.0;
    }
  }
  String get progress => "${(progressVal * 100).toInt()}%";
}

class UserBrief {
  final int id;
  final String name;
  final String email;
  final String? designation;
  final String? avatar;

  UserBrief({
    required this.id,
    required this.name,
    required this.email,
    this.designation,
    this.avatar,
  });

  factory UserBrief.fromJson(Map<String, dynamic> json) {
    return UserBrief(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      designation: json['designation'],
      avatar: json['avatar'],
    );
  }
}
