import 'package:flutter_bloc/flutter_bloc.dart';
import '../data/repository/expense_repository.dart';
import '../data/model/expense_model.dart';
import 'expense_event.dart';
import 'expense_state.dart';

class ExpenseBloc extends Bloc<ExpenseEvent, ExpenseState> {
  final ExpenseRepository expenseRepository;
  
  List<ExpenseModel> _allExpenses = [];
  int _currentPage = 1;
  int _lastPage = 1;

  ExpenseBloc({required this.expenseRepository}) : super(ExpenseInitial()) {
    on<FetchExpenses>(_onFetchExpenses);
    on<FetchExpenseCategories>(_onFetchCategories);
    on<CreateExpense>(_onCreateExpense);
    on<UpdateExpense>(_onUpdateExpense);
    on<ApproveExpense>(_onApproveExpense);
    on<RejectExpense>(_onRejectExpense);
    on<ReimburseExpense>(_onReimburseExpense);
    on<DeleteExpense>(_onDeleteExpense);
    on<CreateCategory>(_onCreateCategory);
    on<UpdateCategory>(_onUpdateCategory);
    on<DeleteCategory>(_onDeleteCategory);
  }

  Future<void> _onFetchExpenses(FetchExpenses event, Emitter<ExpenseState> emit) async {
    try {
      if (event.isRefresh) {
        emit(ExpenseLoading());
        _allExpenses = [];
        _currentPage = 1;
      } else if (state is ExpenseLoaded && (state as ExpenseLoaded).currentPage >= (state as ExpenseLoaded).lastPage) {
        return;
      }

      final response = await expenseRepository.getExpenses(
        status: event.status,
        month: event.month,
        page: event.page,
      );

      if (event.isRefresh || event.page == 1) {
        _allExpenses = response.data;
      } else {
        _allExpenses.addAll(response.data);
      }

      _currentPage = response.currentPage;
      _lastPage = response.lastPage;

      emit(ExpenseLoaded(
        expenses: List.from(_allExpenses),
        currentPage: _currentPage,
        lastPage: _lastPage,
        hasMore: _currentPage < _lastPage,
      ));
    } catch (e) {
      emit(ExpenseError(e.toString()));
    }
  }

  Future<void> _onFetchCategories(FetchExpenseCategories event, Emitter<ExpenseState> emit) async {
    try {
      emit(ExpenseLoading());
      final categories = await expenseRepository.getExpenseCategories();
      emit(CategoriesLoaded(categories));
    } catch (e) {
      emit(ExpenseError(e.toString()));
    }
  }

  Future<void> _onCreateExpense(CreateExpense event, Emitter<ExpenseState> emit) async {
    try {
      emit(ExpenseLoading());
      await expenseRepository.createExpense(event.data);
      emit(const ExpenseActionSuccess('Expense submitted successfully.'));
    } catch (e) {
      emit(ExpenseError(e.toString()));
    }
  }

  Future<void> _onUpdateExpense(UpdateExpense event, Emitter<ExpenseState> emit) async {
    try {
      emit(ExpenseLoading());
      await expenseRepository.updateExpense(event.id, event.data);
      emit(const ExpenseActionSuccess('Expense updated successfully.'));
    } catch (e) {
      emit(ExpenseError(e.toString()));
    }
  }

  Future<void> _onApproveExpense(ApproveExpense event, Emitter<ExpenseState> emit) async {
    try {
      await expenseRepository.approveExpense(event.id);
      emit(const ExpenseActionSuccess('Expense approved.'));
      // Option: Auto-refresh list or let UI handle it via listener
    } catch (e) {
      emit(ExpenseError(e.toString()));
    }
  }

  Future<void> _onRejectExpense(RejectExpense event, Emitter<ExpenseState> emit) async {
    try {
      await expenseRepository.rejectExpense(event.id, event.reason);
      emit(const ExpenseActionSuccess('Expense rejected.'));
    } catch (e) {
      emit(ExpenseError(e.toString()));
    }
  }

  Future<void> _onReimburseExpense(ReimburseExpense event, Emitter<ExpenseState> emit) async {
    try {
      await expenseRepository.reimburseExpense(event.id);
      emit(const ExpenseActionSuccess('Expense reimbursed.'));
    } catch (e) {
      emit(ExpenseError(e.toString()));
    }
  }

  Future<void> _onDeleteExpense(DeleteExpense event, Emitter<ExpenseState> emit) async {
    try {
      await expenseRepository.deleteExpense(event.id);
      emit(const ExpenseActionSuccess('Expense deleted successfully.'));
    } catch (e) {
      emit(ExpenseError(e.toString()));
    }
  }

  Future<void> _onCreateCategory(CreateCategory event, Emitter<ExpenseState> emit) async {
    try {
      emit(ExpenseLoading());
      await expenseRepository.createExpenseCategory(event.data);
      emit(const ExpenseActionSuccess('Category created successfully.'));
    } catch (e) {
      emit(ExpenseError(e.toString()));
    }
  }

  Future<void> _onUpdateCategory(UpdateCategory event, Emitter<ExpenseState> emit) async {
    try {
      emit(ExpenseLoading());
      await expenseRepository.updateExpenseCategory(event.id, event.data);
      emit(const ExpenseActionSuccess('Category updated successfully.'));
    } catch (e) {
      emit(ExpenseError(e.toString()));
    }
  }

  Future<void> _onDeleteCategory(DeleteCategory event, Emitter<ExpenseState> emit) async {
    try {
      emit(ExpenseLoading());
      await expenseRepository.deleteExpenseCategory(event.id);
      emit(const ExpenseActionSuccess('Category deleted successfully.'));
    } catch (e) {
      emit(ExpenseError(e.toString()));
    }
  }
}
