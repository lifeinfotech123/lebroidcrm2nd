import 'package:bloc/bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../data/repositories/auth_repository.dart';
import '../data/services/auth_service.dart';
import '../data/services/permission_service.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository repository;

  AuthBloc(this.repository) : super(AuthInitial()) {
    on<UserLoginEvent>(_onUserLogin);
    on<AdminLoginEvent>(_onAdminLogin);
    on<FetchProfileEvent>(_onFetchProfile);
    on<LogoutEvent>(_onLogout);
  }

  Future<void> _onUserLogin(
    UserLoginEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      final result = await repository.loginUser(event.email, event.password);
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('user_id', result.userId);
      await prefs.setString('user_validity', result.validity);
      emit(AuthUserSuccess(userId: result.userId, validity: result.validity));
    } catch (e) {
      emit(AuthFailure(e.toString()));
    }
  }

  Future<void> _onAdminLogin(
    AdminLoginEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      final result = await repository.loginAdmin(event.email, event.password, event.fcmToken.toString());
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', result.token);
      await prefs.setString('admin_id', result.user.id.toString());
      await prefs.setString('employee_id', result.user.employeeId);
      await prefs.setString('name', result.user.name);
      await prefs.setString('email', result.user.email);
      await prefs.setString('password', event.password);
      await prefs.setString('fcm_token', event.fcmToken ?? '');

      // Save role name
      await PermissionService.saveRole(result.role);

      // Fetch permissions for the user's role and save them
      if (result.user.roleIds.isNotEmpty) {
        try {
          final roleId = result.user.roleIds.first;
          final authService = AuthService();
          final roleResponse = await authService.get('roles/$roleId');
          if (roleResponse['success'] == true) {
            final roleData = roleResponse['data'];
            final permissions = (roleData['permissions'] as List?)
                ?.map((p) => p['name'].toString())
                .toList() ?? [];
            await PermissionService.savePermissions(permissions);
            print('PERMISSIONS SAVED: $permissions');
          }
        } catch (e) {
          print('Failed to fetch permissions: $e');
          // Don't block login if permission fetch fails
        }
      }

      emit(AuthAdminSuccess(token: result.token, user: result.user, role: result.role));
    } catch (e) {
      emit(AuthFailure(e.toString()));
    }
  }

  Future<void> _onFetchProfile(
    FetchProfileEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      final user = await repository.getProfile();

      // Also refresh permissions if roleIds are available
      if (user.roleIds.isNotEmpty) {
        try {
          final roleId = user.roleIds.first;
          final authService = AuthService();
          final roleResponse = await authService.get('roles/$roleId');
          if (roleResponse['success'] == true) {
            final roleData = roleResponse['data'];
            final permissions = (roleData['permissions'] as List?)
                ?.map((p) => p['name'].toString())
                .toList() ?? [];
            await PermissionService.savePermissions(permissions);
          }
        } catch (e) {
          print('Failed to refresh permissions: $e');
        }
      }

      emit(AuthProfileSuccess(user: user));
    } catch (e) {
      emit(AuthFailure(e.toString()));
    }
  }

  Future<void> _onLogout(
    LogoutEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      final prefs = await SharedPreferences.getInstance();
      final email = prefs.getString('email') ?? '';
      final password = prefs.getString('password') ?? '';
      final fcmToken = prefs.getString('fcm_token') ?? '';

      await repository.logout(email, password, fcmToken);

      // Clear all saved data
      await prefs.clear();
      
      emit(AuthLogoutSuccess());
    } catch (e) {
      emit(AuthFailure(e.toString()));
    }
  }
}

