class EmployeeModel {
  final int id;
  final String? employeeId;
  final int? departmentId;
  final int? branchId;
  final int? shiftId;
  final String? designation;
  final String? phone;
  final String? avatar;
  final String? joiningDate;
  final String? employmentType;
  final String? status;
  final String? gender;
  final String? dateOfBirth;
  final String? address;
  final String? name;
  final String? email;
  final String? createdAt;
  final String? updatedAt;
  final Map<String, dynamic>? department;
  final Map<String, dynamic>? branch;
  final List<dynamic>? roles;

  EmployeeModel({
    required this.id,
    this.employeeId,
    this.departmentId,
    this.branchId,
    this.shiftId,
    this.designation,
    this.phone,
    this.avatar,
    this.joiningDate,
    this.employmentType,
    this.status,
    this.gender,
    this.dateOfBirth,
    this.address,
    this.name,
    this.email,
    this.createdAt,
    this.updatedAt,
    this.department,
    this.branch,
    this.roles,
  });

  factory EmployeeModel.fromJson(Map<String, dynamic> json) {
    return EmployeeModel(
      id: json['id'] is int ? json['id'] : int.tryParse(json['id'].toString()) ?? 0,
      employeeId: json['employee_id']?.toString(),
      departmentId: json['department_id'] is int ? json['department_id'] : (json['department_id'] != null ? int.tryParse(json['department_id'].toString()) : null),
      branchId: json['branch_id'] is int ? json['branch_id'] : (json['branch_id'] != null ? int.tryParse(json['branch_id'].toString()) : null),
      shiftId: json['shift_id'] is int ? json['shift_id'] : (json['shift_id'] != null ? int.tryParse(json['shift_id'].toString()) : null),
      designation: json['designation'],
      phone: json['phone'],
      avatar: json['avatar'],
      joiningDate: json['joining_date'],
      employmentType: json['employment_type'],
      status: json['status'],
      gender: json['gender'],
      dateOfBirth: json['date_of_birth'],
      address: json['address'],
      name: json['name'],
      email: json['email'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      department: json['department'] != null ? Map<String, dynamic>.from(json['department']) : null,
      branch: json['branch'] != null ? Map<String, dynamic>.from(json['branch']) : null,
      roles: json['roles'],
    );
  }

  /// Helper to get initials for avatar
  String get initials {
    if (name == null || name!.isEmpty) return '?';
    final parts = name!.trim().split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return name![0].toUpperCase();
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'employee_id': employeeId,
      'department_id': departmentId,
      'branch_id': branchId,
      'shift_id': shiftId,
      'designation': designation,
      'phone': phone,
      'avatar': avatar,
      'joining_date': joiningDate,
      'employment_type': employmentType,
      'status': status,
      'gender': gender,
      'date_of_birth': dateOfBirth,
      'address': address,
      'name': name,
      'email': email,
    };
  }
}
