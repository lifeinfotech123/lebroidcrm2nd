import 'package:equatable/equatable.dart';
import '../data/model/expense_model.dart';
import '../data/model/expense_category_model.dart';

abstract class ExpenseState extends Equatable {
  const ExpenseState();

  @override
  List<Object?> get props => [];
}

class ExpenseInitial extends ExpenseState {}

class ExpenseLoading extends ExpenseState {}

class ExpenseLoaded extends ExpenseState {
  final List<ExpenseModel> expenses;
  final int currentPage;
  final int lastPage;
  final bool hasMore;

  const ExpenseLoaded({
    required this.expenses,
    required this.currentPage,
    required this.lastPage,
    this.hasMore = true,
  });

  @override
  List<Object?> get props => [expenses, currentPage, lastPage, hasMore];
}

class CategoriesLoaded extends ExpenseState {
  final List<ExpenseCategoryModel> categories;
  const CategoriesLoaded(this.categories);

  @override
  List<Object?> get props => [categories];
}

class ExpenseActionSuccess extends ExpenseState {
  final String message;
  const ExpenseActionSuccess(this.message);

  @override
  List<Object?> get props => [message];
}

class ExpenseError extends ExpenseState {
  final String message;
  const ExpenseError(this.message);

  @override
  List<Object?> get props => [message];
}
