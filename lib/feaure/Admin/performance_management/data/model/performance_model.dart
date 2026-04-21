class PerformanceModel {
  final int id;
  final String userId;
  final UserBriefPerf? ratedBy;
  final String month;
  final String? period;
  final int ratingAttendance;
  final int ratingTaskQuality;
  final int ratingPunctuality;
  final int ratingTeamwork;
  final int ratingCommunication;
  final int ratingInitiative;
  final int totalScore;
  final String grade;
  final String? managerRemarks;
  final String? improvementAreas;
  final String? createdAt;
  final String? updatedAt;
  final UserBriefPerf? user;

  PerformanceModel({
    required this.id,
    required this.userId,
    this.ratedBy,
    required this.month,
    this.period,
    required this.ratingAttendance,
    required this.ratingTaskQuality,
    required this.ratingPunctuality,
    required this.ratingTeamwork,
    required this.ratingCommunication,
    required this.ratingInitiative,
    required this.totalScore,
    required this.grade,
    this.managerRemarks,
    this.improvementAreas,
    this.createdAt,
    this.updatedAt,
    this.user,
  });

  factory PerformanceModel.fromJson(Map<String, dynamic> json) {
    return PerformanceModel(
      id: json['id'] ?? 0,
      userId: json['user_id']?.toString() ?? '',
      ratedBy: json['rated_by'] != null && json['rated_by'] is Map<String, dynamic>
          ? UserBriefPerf.fromJson(json['rated_by'])
          : null,
      month: json['month'] ?? '',
      period: json['period'],
      ratingAttendance: _toInt(json['rating_attendance']),
      ratingTaskQuality: _toInt(json['rating_task_quality']),
      ratingPunctuality: _toInt(json['rating_punctuality']),
      ratingTeamwork: _toInt(json['rating_teamwork']),
      ratingCommunication: _toInt(json['rating_communication']),
      ratingInitiative: _toInt(json['rating_initiative']),
      totalScore: _toInt(json['total_score']),
      grade: json['grade'] ?? '',
      managerRemarks: json['manager_remarks'],
      improvementAreas: json['improvement_areas'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      user: json['user'] != null && json['user'] is Map<String, dynamic>
          ? UserBriefPerf.fromJson(json['user'])
          : null,
    );
  }

  static int _toInt(dynamic val) {
    if (val == null) return 0;
    if (val is int) return val;
    if (val is double) return val.toInt();
    return int.tryParse(val.toString()) ?? 0;
  }

  // Helpers for UI
  String get ratedByName => ratedBy?.name ?? 'Unknown';
  String get userName => user?.name ?? 'User #$userId';
  String get initials {
    final name = userName;
    final parts = name.split(' ');
    if (parts.length >= 2) return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    return name.substring(0, name.length >= 2 ? 2 : name.length).toUpperCase();
  }
}

class GoalModel {
  final int id;
  final String userId;
  final UserBriefPerf? setBy;
  final String title;
  final String description;
  final String category;
  final String deadline;
  final int target;
  final String unit;
  final int current;
  final String status;
  final String? notes;
  final String? createdAt;
  final String? updatedAt;
  final UserBriefPerf? user;

  GoalModel({
    required this.id,
    required this.userId,
    this.setBy,
    required this.title,
    required this.description,
    required this.category,
    required this.deadline,
    required this.target,
    required this.unit,
    required this.current,
    required this.status,
    this.notes,
    this.createdAt,
    this.updatedAt,
    this.user,
  });

  factory GoalModel.fromJson(Map<String, dynamic> json) {
    return GoalModel(
      id: json['id'] ?? 0,
      userId: json['user_id']?.toString() ?? '',
      setBy: json['set_by'] != null && json['set_by'] is Map<String, dynamic>
          ? UserBriefPerf.fromJson(json['set_by'])
          : null,
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      category: json['category'] ?? '',
      deadline: json['deadline'] ?? '',
      target: _toInt(json['target']),
      unit: json['unit'] ?? '',
      current: _toInt(json['current']),
      status: json['status'] ?? '',
      notes: json['notes'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      user: json['user'] != null && json['user'] is Map<String, dynamic>
          ? UserBriefPerf.fromJson(json['user'])
          : null,
    );
  }

  static int _toInt(dynamic val) {
    if (val == null) return 0;
    if (val is int) return val;
    if (val is double) return val.toInt();
    return int.tryParse(val.toString()) ?? 0;
  }

  double get progressPercent => target > 0 ? (current / target).clamp(0.0, 1.0) : 0.0;
  String get setByName => setBy?.name ?? 'Unknown';
}

class UserBriefPerf {
  final int id;
  final String name;
  final String email;
  final String? designation;
  final String? avatar;
  final String? employeeId;
  final String? departmentId;

  UserBriefPerf({
    required this.id,
    required this.name,
    required this.email,
    this.designation,
    this.avatar,
    this.employeeId,
    this.departmentId,
  });

  factory UserBriefPerf.fromJson(Map<String, dynamic> json) {
    return UserBriefPerf(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      designation: json['designation'],
      avatar: json['avatar'],
      employeeId: json['employee_id'],
      departmentId: json['department_id']?.toString(),
    );
  }
}
