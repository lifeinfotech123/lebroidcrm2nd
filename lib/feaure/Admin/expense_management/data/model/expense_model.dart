import 'expense_category_model.dart';

class ExpenseModel {
  final int id;
  final String? userId;
  final String? branchId;
  final String? expenseCategoryId;
  final String? amount;
  final String? expenseDate;
  final String? purpose;
  final String? receipt;
  final String? status;
  final bool isPolicyViolated;
  final ExpenseUser? approvedBy;
  final String? approvedAt;
  final String? rejectionReason;
  final String? createdAt;
  final String? updatedAt;
  final ExpenseUser? user;
  final ExpenseCategoryModel? expenseCategory;

  ExpenseModel({
    required this.id,
    this.userId,
    this.branchId,
    this.expenseCategoryId,
    this.amount,
    this.expenseDate,
    this.purpose,
    this.receipt,
    this.status,
    this.isPolicyViolated = false,
    this.approvedBy,
    this.approvedAt,
    this.rejectionReason,
    this.createdAt,
    this.updatedAt,
    this.user,
    this.expenseCategory,
  });

  factory ExpenseModel.fromJson(Map<String, dynamic> json) {
    return ExpenseModel(
      id: json['id'] is int ? json['id'] : int.parse(json['id'].toString()),
      userId: json['user_id']?.toString(),
      branchId: json['branch_id']?.toString(),
      expenseCategoryId: json['expense_category_id']?.toString(),
      amount: json['amount']?.toString(),
      expenseDate: json['expense_date'],
      purpose: json['purpose'],
      receipt: json['receipt'],
      status: json['status'],
      isPolicyViolated: json['is_policy_violated'] == 1 || json['is_policy_violated'] == true,
      approvedBy: json['approved_by'] != null && json['approved_by'] is Map<String, dynamic>
          ? ExpenseUser.fromJson(json['approved_by'])
          : null,
      approvedAt: json['approved_at'],
      rejectionReason: json['rejection_reason'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      user: json['user'] != null ? ExpenseUser.fromJson(json['user']) : null,
      expenseCategory: json['expense_category'] != null
          ? ExpenseCategoryModel.fromJson(json['expense_category'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'branch_id': branchId,
      'expense_category_id': expenseCategoryId,
      'amount': amount,
      'expense_date': expenseDate,
      'purpose': purpose,
      'receipt': receipt,
      'status': status,
    };
  }
}

class ExpenseUser {
  final int id;
  final String? employeeId;
  final String? name;
  final String? email;
  final String? designation;
  final String? phone;
  final String? avatar;
  final ExpenseDepartment? department;

  ExpenseUser({
    required this.id,
    this.employeeId,
    this.name,
    this.email,
    this.designation,
    this.phone,
    this.avatar,
    this.department,
  });

  factory ExpenseUser.fromJson(Map<String, dynamic> json) {
    return ExpenseUser(
      id: json['id'] is int ? json['id'] : int.parse(json['id'].toString()),
      employeeId: json['employee_id'],
      name: json['name'],
      email: json['email'],
      designation: json['designation'],
      phone: json['phone'],
      avatar: json['avatar'],
      department: json['department'] != null ? ExpenseDepartment.fromJson(json['department']) : null,
    );
  }

  String get initials {
    if (name == null || name!.isEmpty) return '?';
    final parts = name!.trim().split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return name![0].toUpperCase();
  }
}

class ExpenseDepartment {
  final int id;
  final String? name;
  final String? code;

  ExpenseDepartment({required this.id, this.name, this.code});

  factory ExpenseDepartment.fromJson(Map<String, dynamic> json) {
    return ExpenseDepartment(
      id: json['id'] is int ? json['id'] : int.parse(json['id'].toString()),
      name: json['name'],
      code: json['code'],
    );
  }
}

class ExpensePaginatedResponse {
  final List<ExpenseModel> data;
  final int currentPage;
  final int lastPage;
  final int total;

  ExpensePaginatedResponse({
    required this.data,
    required this.currentPage,
    required this.lastPage,
    required this.total,
  });

  factory ExpensePaginatedResponse.fromJson(Map<String, dynamic> json) {
    return ExpensePaginatedResponse(
      data: (json['data'] as List).map((i) => ExpenseModel.fromJson(i)).toList(),
      currentPage: json['current_page'] ?? 1,
      lastPage: json['last_page'] ?? 1,
      total: json['total'] ?? 0,
    );
  }
}
