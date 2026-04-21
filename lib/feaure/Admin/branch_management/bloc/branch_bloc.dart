import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lebroid_crm/feaure/Admin/branch_management/data/repository/branch_repository.dart';
import 'branch_event.dart';
import 'branch_state.dart';

class BranchBloc extends Bloc<BranchEvent, BranchState> {
  final BranchRepository branchRepository;

  BranchBloc({required this.branchRepository}) : super(BranchInitial()) {
    on<LoadBranchesEvent>(_onLoadBranches);
    on<FetchSingleBranchEvent>(_onFetchSingleBranch);
    on<AddBranchEvent>(_onAddBranch);
    on<UpdateBranchEvent>(_onUpdateBranch);
    on<DeleteBranchEvent>(_onDeleteBranch);
  }

  Future<void> _onLoadBranches(
    LoadBranchesEvent event,
    Emitter<BranchState> emit,
  ) async {
    emit(BranchLoading());
    try {
      final branches = await branchRepository.getAllBranches();
      emit(BranchLoaded(branches));
    } catch (e) {
      emit(BranchError(e.toString()));
    }
  }

  Future<void> _onFetchSingleBranch(
    FetchSingleBranchEvent event,
    Emitter<BranchState> emit,
  ) async {
    emit(BranchLoading());
    try {
      final branch = await branchRepository.getSingleBranch(event.id);
      emit(SingleBranchLoaded(branch));
    } catch (e) {
      emit(BranchError(e.toString()));
    }
  }

  Future<void> _onAddBranch(
    AddBranchEvent event,
    Emitter<BranchState> emit,
  ) async {
    emit(BranchLoading());
    try {
      await branchRepository.createBranch(event.branchData);
      emit(const BranchOperationSuccess('Branch created successfully.'));
      add(LoadBranchesEvent());
    } catch (e) {
      emit(BranchError(e.toString()));
    }
  }

  Future<void> _onUpdateBranch(
    UpdateBranchEvent event,
    Emitter<BranchState> emit,
  ) async {
    emit(BranchLoading());
    try {
      await branchRepository.updateBranch(event.id, event.branchData);
      emit(const BranchOperationSuccess('Branch updated successfully.'));
      add(LoadBranchesEvent());
    } catch (e) {
      emit(BranchError(e.toString()));
    }
  }

  Future<void> _onDeleteBranch(
    DeleteBranchEvent event,
    Emitter<BranchState> emit,
  ) async {
    emit(BranchLoading());
    try {
      await branchRepository.deleteBranch(event.branchId);
      emit(const BranchOperationSuccess('Branch deleted successfully.'));
      add(LoadBranchesEvent());
    } catch (e) {
      emit(BranchError(e.toString()));
    }
  }
}

