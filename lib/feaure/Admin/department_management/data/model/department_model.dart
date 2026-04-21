class DepartmentModel {
  final int id;
  final String? name;
  final String? code;
  final String? description;
  final int? headId;
  final bool isActive;
  final String? createdAt;
  final String? updatedAt;
  final Map<String, dynamic>? head;

  DepartmentModel({
    required this.id,
    this.name,
    this.code,
    this.description,
    this.headId,
    required this.isActive,
    this.createdAt,
    this.updatedAt,
    this.head,
  });

  factory DepartmentModel.fromJson(Map<String, dynamic> json) {
    return DepartmentModel(
      id: json['id'] is int ? json['id'] : int.tryParse(json['id'].toString()) ?? 0,
      name: json['name'],
      code: json['code'],
      description: json['description'],
      headId: json['head_id'] is int ? json['head_id'] : (json['head_id'] != null ? int.tryParse(json['head_id'].toString()) : null),
      isActive: json['is_active'] == 1 || json['is_active'] == '1' || json['is_active'] == true,
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      head: json['head'] != null ? Map<String, dynamic>.from(json['head']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'code': code,
      'description': description,
      'head_id': headId,
      'is_active': isActive,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'head': head,
    };
  }
}
