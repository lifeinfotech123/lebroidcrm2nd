import '../data/model/admin_dashboard_model.dart';

abstract class AdminDashboardState {}

class AdminDashboardInitial extends AdminDashboardState {}

class AdminDashboardLoading extends AdminDashboardState {}

class AdminDashboardSuccess extends AdminDashboardState {
  final AdminDashboardResponse data;

  AdminDashboardSuccess(this.data);
}

class AdminDashboardFailure extends AdminDashboardState {
  final String error;

  AdminDashboardFailure(this.error);
}
