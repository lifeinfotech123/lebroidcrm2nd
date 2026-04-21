import '../data/model/admin_login_model.dart';

abstract class AuthState {}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthUserSuccess extends AuthState {
  final String userId;
  final String validity;
  AuthUserSuccess({required this.userId, required this.validity});
}

class AuthAdminSuccess extends AuthState {
  final String token;
  final AdminLoginUser user;
  final String role;
  AuthAdminSuccess({required this.token, required this.user, required this.role});
}

class AuthProfileSuccess extends AuthState {
  final AdminLoginUser user;
  AuthProfileSuccess({required this.user});
}

class AuthFailure extends AuthState {
  final String error;
  AuthFailure(this.error);
}

class AuthLogoutSuccess extends AuthState {}
