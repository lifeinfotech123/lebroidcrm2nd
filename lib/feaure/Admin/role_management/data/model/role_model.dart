class RoleModel {
  final int id;
  final String? name;
  final String? guardName;
  final String? createdAt;
  final String? updatedAt;
  final int? usersCount;
  final List<PermissionModel>? permissions;

  RoleModel({
    required this.id,
    this.name,
    this.guardName,
    this.createdAt,
    this.updatedAt,
    this.usersCount,
    this.permissions,
  });

  factory RoleModel.fromJson(Map<String, dynamic> json) {
    var rawPermissions = json['permissions'] as List?;
    List<PermissionModel>? parsedPermissions;
    if (rawPermissions != null) {
      parsedPermissions = rawPermissions.map((e) => PermissionModel.fromJson(e)).toList();
    }

    return RoleModel(
      id: json['id'] is int ? json['id'] : int.tryParse(json['id'].toString()) ?? 0,
      name: json['name'],
      guardName: json['guard_name'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      usersCount: json['users_count'] is int ? json['users_count'] : (json['users_count'] != null ? int.tryParse(json['users_count'].toString()) : null),
      permissions: parsedPermissions,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'guard_name': guardName,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'users_count': usersCount,
      'permissions': permissions?.map((e) => e.toJson()).toList(),
    };
  }
}

class PermissionModel {
  final int id;
  final String? name;
  final String? guardName;

  PermissionModel({
    required this.id,
    this.name,
    this.guardName,
  });

  factory PermissionModel.fromJson(Map<String, dynamic> json) {
    return PermissionModel(
      id: json['id'] is int ? json['id'] : int.tryParse(json['id'].toString()) ?? 0,
      name: json['name'],
      guardName: json['guard_name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'guard_name': guardName,
    };
  }
}
