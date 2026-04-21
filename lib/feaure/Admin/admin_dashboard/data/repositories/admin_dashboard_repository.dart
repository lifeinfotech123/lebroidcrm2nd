import '../../../../auth/data/services/auth_service.dart';
// import '../../../auth/data/services/auth_service.dart';
import '../model/admin_dashboard_model.dart';

class AdminDashboardRepository {
  final AuthService service;

  AdminDashboardRepository(this.service);

  Future<AdminDashboardResponse> fetchDashboardData() async {
    final Map<String, dynamic> response = await service.get("dashboard");
    return AdminDashboardResponse.fromJson(response);
  }
}
