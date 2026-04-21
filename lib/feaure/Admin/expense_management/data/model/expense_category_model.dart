class ExpenseCategoryModel {
  final int id;
  final String name;
  final String? monthlyLimit;
  final bool isActive;
  final String? createdAt;
  final String? updatedAt;

  ExpenseCategoryModel({
    required this.id,
    required this.name,
    this.monthlyLimit,
    this.isActive = true,
    this.createdAt,
    this.updatedAt,
  });

  factory ExpenseCategoryModel.fromJson(Map<String, dynamic> json) {
    return ExpenseCategoryModel(
      id: json['id'] is int ? json['id'] : int.parse(json['id'].toString()),
      name: json['name'] ?? '',
      monthlyLimit: json['monthly_limit']?.toString(),
      isActive: json['is_active'] == 1 || json['is_active'] == true,
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'monthly_limit': monthlyLimit,
      'is_active': isActive,
    };
  }
}
