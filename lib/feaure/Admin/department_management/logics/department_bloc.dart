import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lebroid_crm/feaure/Admin/department_management/data/repositiores/department_repository.dart';
import 'department_event.dart';
import 'department_state.dart';

class DepartmentBloc extends Bloc<DepartmentEvent, DepartmentState> {
  final DepartmentRepository departmentRepository;

  DepartmentBloc({required this.departmentRepository}) : super(DepartmentInitial()) {
    on<LoadDepartmentsEvent>(_onLoadDepartments);
    on<FetchSingleDepartmentEvent>(_onFetchSingleDepartment);
    on<AddDepartmentEvent>(_onAddDepartment);
    on<UpdateDepartmentEvent>(_onUpdateDepartment);
    on<DeleteDepartmentEvent>(_onDeleteDepartment);
  }

  Future<void> _onLoadDepartments(
    LoadDepartmentsEvent event,
    Emitter<DepartmentState> emit,
  ) async {
    emit(DepartmentLoading());
    try {
      final departments = await departmentRepository.getAllDepartments();
      emit(DepartmentLoaded(departments));
    } catch (e) {
      emit(DepartmentError(e.toString()));
    }
  }

  Future<void> _onFetchSingleDepartment(
    FetchSingleDepartmentEvent event,
    Emitter<DepartmentState> emit,
  ) async {
    emit(DepartmentLoading());
    try {
      final department = await departmentRepository.getSingleDepartment(event.id);
      emit(SingleDepartmentLoaded(department));
    } catch (e) {
      emit(DepartmentError(e.toString()));
    }
  }

  Future<void> _onAddDepartment(
    AddDepartmentEvent event,
    Emitter<DepartmentState> emit,
  ) async {
    emit(DepartmentLoading());
    try {
      await departmentRepository.createDepartment(event.departmentData);
      emit(const DepartmentOperationSuccess('Department created successfully.'));
      add(LoadDepartmentsEvent());
    } catch (e) {
      emit(DepartmentError(e.toString()));
    }
  }

  Future<void> _onUpdateDepartment(
    UpdateDepartmentEvent event,
    Emitter<DepartmentState> emit,
  ) async {
    emit(DepartmentLoading());
    try {
      await departmentRepository.updateDepartment(event.id, event.departmentData);
      emit(const DepartmentOperationSuccess('Department updated successfully.'));
      add(LoadDepartmentsEvent());
    } catch (e) {
      emit(DepartmentError(e.toString()));
    }
  }

  Future<void> _onDeleteDepartment(
    DeleteDepartmentEvent event,
    Emitter<DepartmentState> emit,
  ) async {
    emit(DepartmentLoading());
    try {
      await departmentRepository.deleteDepartment(event.departmentId);
      emit(const DepartmentOperationSuccess('Department deleted successfully.'));
      add(LoadDepartmentsEvent());
    } catch (e) {
      emit(DepartmentError(e.toString()));
    }
  }
}
