class UserLoginModel {
  final String status;
  final String message;
  final String userId;
  final String validity;

  UserLoginModel({
    required this.status,
    required this.message,
    required this.userId,
    required this.validity,
  });

  factory UserLoginModel.fromJson(Map<String, dynamic> json) {
    return UserLoginModel(
      status: json['status'] ?? '',
      message: json['message'] ?? '',
      userId: json['user_id'] ?? '',
      validity: json['validity'] ?? '',
    );
  }
}
