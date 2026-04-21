abstract class AuthEvent {}

class UserLoginEvent extends AuthEvent {
  final String email;
  final String password;
  UserLoginEvent(this.email, this.password);
}

class AdminLoginEvent extends AuthEvent {
  final String email;
  final String password;
  final String? fcmToken;
  AdminLoginEvent(this.email, this.password, this.fcmToken);
}

class FetchProfileEvent extends AuthEvent {}
class LogoutEvent extends AuthEvent {}
