class LeaveModel {
  final int? id;
  final int? userId;
  final int leaveTypeId;
  final DateTime? fromDate;
  final DateTime? toDate;
  final int? totalDays;
  final String dayType;
  final String reason;
  final String? status;
  final String? remarks;
  final String? document;
  final UserModel? user;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  LeaveModel({
    this.id,
    this.userId,
    required this.leaveTypeId,
    this.fromDate,
    this.toDate,
    this.totalDays,
    required this.dayType,
    required this.reason,
    this.status,
    this.remarks,
    this.document,
    this.user,
    this.createdAt,
    this.updatedAt,
  });

  factory LeaveModel.fromJson(Map<String, dynamic> json) {
    return LeaveModel(
      id: json['id'],
      userId: json['user_id'] != null ? int.tryParse(json['user_id'].toString()) : null,
      leaveTypeId: json['leave_type_id'] is int ? json['leave_type_id'] : int.tryParse(json['leave_type_id'].toString()) ?? 0,
      fromDate: json['from_date'] != null ? DateTime.parse(json['from_date']) : null,
      toDate: json['to_date'] != null ? DateTime.parse(json['to_date']) : null,
      totalDays: json['total_days'] is int ? json['total_days'] : int.tryParse(json['total_days']?.toString() ?? ''),
      dayType: json['day_type'] ?? 'full',
      reason: json['reason'] ?? '',
      status: json['status'],
      remarks: json['remarks'],
      document: json['document'],
      user: json['user'] != null ? UserModel.fromJson(json['user']) : null,
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at']) : null,
      updatedAt: json['updated_at'] != null ? DateTime.parse(json['updated_at']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'leave_type_id': leaveTypeId,
      'from_date': fromDate?.toIso8601String().substring(0, 10),
      'to_date': toDate?.toIso8601String().substring(0, 10),
      'day_type': dayType,
      'reason': reason,
      if (remarks != null) 'remarks': remarks,
    };
  }
}

class UserModel {
  final int id;
  final String? employeeId;
  final String? name;
  final String? email;
  final String? avatar;

  UserModel({
    required this.id,
    this.employeeId,
    this.name,
    this.email,
    this.avatar,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      employeeId: json['employee_id'],
      name: json['name'],
      email: json['email'],
      avatar: json['avatar'],
    );
  }
}
