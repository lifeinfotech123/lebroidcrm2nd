import 'package:equatable/equatable.dart';

abstract class ExpenseEvent extends Equatable {
  const ExpenseEvent();

  @override
  List<Object?> get props => [];
}

class FetchExpenses extends ExpenseEvent {
  final String? status;
  final String? month;
  final int page;
  final bool isRefresh;

  const FetchExpenses({this.status, this.month, this.page = 1, this.isRefresh = false});

  @override
  List<Object?> get props => [status, month, page, isRefresh];
}

class FetchExpenseCategories extends ExpenseEvent {}

class CreateExpense extends ExpenseEvent {
  final Map<String, dynamic> data;
  const CreateExpense(this.data);
}

class UpdateExpense extends ExpenseEvent {
  final int id;
  final Map<String, dynamic> data;
  const UpdateExpense(this.id, this.data);
}

class ApproveExpense extends ExpenseEvent {
  final int id;
  const ApproveExpense(this.id);
}

class RejectExpense extends ExpenseEvent {
  final int id;
  final String reason;
  const RejectExpense(this.id, this.reason);
}

class ReimburseExpense extends ExpenseEvent {
  final int id;
  const ReimburseExpense(this.id);
}

class DeleteExpense extends ExpenseEvent {
  final int id;
  const DeleteExpense(this.id);
}

class CreateCategory extends ExpenseEvent {
  final Map<String, dynamic> data;
  const CreateCategory(this.data);
}

class UpdateCategory extends ExpenseEvent {
  final int id;
  final Map<String, dynamic> data;
  const UpdateCategory(this.id, this.data);
}

class DeleteCategory extends ExpenseEvent {
  final int id;
  const DeleteCategory(this.id);
}
