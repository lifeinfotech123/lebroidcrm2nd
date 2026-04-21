import 'package:flutter_bloc/flutter_bloc.dart';
import '../data/model/admin_dashboard_model.dart';
import '../data/repositories/admin_dashboard_repository.dart';
import 'admin_dashboard_event.dart';
import 'admin_dashboard_state.dart';

class AdminDashboardBloc extends Bloc<AdminDashboardEvent, AdminDashboardState> {
  final AdminDashboardRepository repository;

  AdminDashboardBloc(this.repository) : super(AdminDashboardInitial()) {
    on<FetchAdminDashboardDataEvent>(_onFetchData);
  }

  Future<void> _onFetchData(
    FetchAdminDashboardDataEvent event,
    Emitter<AdminDashboardState> emit,
  ) async {
    emit(AdminDashboardLoading());
    try {
      final AdminDashboardResponse response = await repository.fetchDashboardData();
      if (response.success) {
         emit(AdminDashboardSuccess(response));
      } else {
         emit(AdminDashboardFailure("Failed to load dashboard"));
      }
    } catch (e) {
      emit(AdminDashboardFailure(e.toString()));
    }
  }
}
