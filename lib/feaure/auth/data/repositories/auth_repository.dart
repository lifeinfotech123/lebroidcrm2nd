import '../model/admin_login_model.dart';
import '../model/user_login_model.dart';
import '../services/auth_service.dart';

class AuthRepository {
  final AuthService service;
  AuthRepository(this.service);

  /// returns parsed model for user login
  Future<UserLoginModel> loginUser(String email, String password) async {
    final json = await service.post("check-user-login", {
      "email": email,
      "password": password,
    });

    print("Login Response JSON: $json");
    return UserLoginModel.fromJson(json);
  }

  /// returns parsed model for admin login with FCM token
  Future<AdminLoginModel> loginAdmin(
      String email, String password, String fcmToken) async {
    final json = await service.post("login", {
      "email": email,
      "password": password,
      "fcm_token": fcmToken,
    });
    print("Admin Login Response JSON: $json");
    return AdminLoginModel.fromJson(json);
  }

  /// returns parsed model for profile from `me` endpoint
  Future<AdminLoginUser> getProfile() async {
    final json = await service.get("me");
    print("Profile Response JSON: $json");
    return AdminLoginUser.fromJson(json['user']);
  }

  /// Logout user
  Future<Map<String, dynamic>> logout(String email, String password, String fcmToken) async {
    final json = await service.postWithToken("logout", {
      "email": email,
      "password": password,
      "Fcm_token": fcmToken,
    });
    print("Logout Response JSON: $json");
    return json;
  }
}
