class LeaveTypeModel {
  final int? id;
  final String name;
  final String code;
  final int daysPerYear;
  final bool isPaid;
  final bool carryForward;
  final bool requiresDocument;
  final String? description;
  final bool isActive;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  LeaveTypeModel({
    this.id,
    required this.name,
    required this.code,
    required this.daysPerYear,
    required this.isPaid,
    required this.carryForward,
    required this.requiresDocument,
    this.description,
    required this.isActive,
    this.createdAt,
    this.updatedAt,
  });

  factory LeaveTypeModel.fromJson(Map<String, dynamic> json) {
    return LeaveTypeModel(
      id: json['id'],
      name: json['name'] ?? '',
      code: json['code'] ?? '',
      daysPerYear: json['days_per_year'] is int 
          ? json['days_per_year'] 
          : int.tryParse(json['days_per_year'].toString()) ?? 0,
      isPaid: json['is_paid'] == true || json['is_paid'] == 1,
      carryForward: json['carry_forward'] == true || json['carry_forward'] == 1,
      requiresDocument: json['requires_document'] == true || json['requires_document'] == 1,
      description: json['description'],
      isActive: json['is_active'] == true || json['is_active'] == 1,
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at']) : null,
      updatedAt: json['updated_at'] != null ? DateTime.parse(json['updated_at']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'code': code,
      'days_per_year': daysPerYear,
      'is_paid': isPaid,
      'carry_forward': carryForward,
      'requires_document': requiresDocument,
      'description': description,
      'is_active': isActive,
    };
  }
}
