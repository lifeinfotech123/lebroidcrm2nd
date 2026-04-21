class AdminLoginUser {
  final int id;
  final String employeeId;
  final String departmentId;
  final String branchId;
  final String shiftId;
  final String designation;
  final String phone;
  final String avatar;
  final String joiningDate;
  final String employmentType;
  final String status;
  final String gender;
  final String? dateOfBirth;
  final String? address;
  final String name;
  final String email;
  final List<int> roleIds;

  AdminLoginUser({
    required this.id,
    required this.employeeId,
    required this.departmentId,
    required this.branchId,
    required this.shiftId,
    required this.designation,
    required this.phone,
    required this.avatar,
    required this.joiningDate,
    required this.employmentType,
    required this.status,
    required this.gender,
    this.dateOfBirth,
    this.address,
    required this.name,
    required this.email,
    this.roleIds = const [],
  });

  factory AdminLoginUser.fromJson(Map<String, dynamic> json) {
    List<int> parsedRoleIds = [];

    if (json['roles'] != null && json['roles'] is List) {
      parsedRoleIds = (json['roles'] as List)
          .map<int>((r) {
        final id = r['id'];
        if (id is int) return id;
        return int.tryParse(id.toString()) ?? 0;
      })
          .toList();
    }

    return AdminLoginUser(
      id: json['id'] ?? 0,
      employeeId: json['employee_id']?.toString() ?? '',
      departmentId: json['department_id']?.toString() ?? '',
      branchId: json['branch_id']?.toString() ?? '',
      shiftId: json['shift_id']?.toString() ?? '',
      designation: json['designation']?.toString() ?? '',
      phone: json['phone']?.toString() ?? '',
      avatar: json['avatar']?.toString() ?? '',
      joiningDate: json['joining_date']?.toString() ?? '',
      employmentType: json['employment_type']?.toString() ?? '',
      status: json['status']?.toString() ?? '',
      gender: json['gender']?.toString() ?? '',
      dateOfBirth: json['date_of_birth']?.toString(),
      address: json['address']?.toString(),
      name: json['name']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      roleIds: parsedRoleIds,
    );
  }
}

class AdminLoginModel {
  final bool success;
  final String message;
  final String token;
  final String tokenType;
  final int expiresIn;
  final String role;
  final AdminLoginUser user;

  AdminLoginModel({
    required this.success,
    required this.message,
    required this.token,
    required this.tokenType,
    required this.expiresIn,
    required this.role,
    required this.user,
  });

  factory AdminLoginModel.fromJson(Map<String, dynamic> json) {
    return AdminLoginModel(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      token: json['token'] ?? '',
      tokenType: json['token_type'] ?? 'bearer',
      expiresIn: json['expires_in'] ?? 3600,
      role: json['role']?.toString() ?? '',
      user: AdminLoginUser.fromJson(json['user'] ?? {}),
    );
  }
}
