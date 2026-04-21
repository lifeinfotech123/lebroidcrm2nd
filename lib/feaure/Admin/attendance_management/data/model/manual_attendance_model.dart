class ManualAttendanceRequest {
  final int userId;
  final String date;
  final String checkIn;
  final String checkOut;
  final String status;
  final String reason;
  final int shiftId;
  final String? selfie;
  final double? latitude;
  final double? longitude;

  ManualAttendanceRequest({
    required this.userId,
    required this.date,
    required this.checkIn,
    required this.checkOut,
    required this.status,
    required this.reason,
    required this.shiftId,
    this.selfie,
    this.latitude,
    this.longitude,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      'user_id': userId,
      'date': date,
      'check_in': checkIn,
      'check_out': checkOut,
      'status': status,
      'reason': reason,
      'shift_id': shiftId,
    };
    if (selfie != null) data['selfie'] = selfie;
    if (latitude != null) data['Latitude'] = latitude;
    if (longitude != null) data['Longitude'] = longitude;
    return data;
  }
}

class ManualAttendanceResponse {
  final bool success;
  final String message;
  final ManualAttendanceData? data;

  ManualAttendanceResponse({
    required this.success,
    required this.message,
    this.data,
  });

  factory ManualAttendanceResponse.fromJson(Map<String, dynamic> json) {
    return ManualAttendanceResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: json['data'] != null ? ManualAttendanceData.fromJson(json['data']) : null,
    );
  }
}

class ManualAttendanceData {
  final int id;
  final String userId;
  final String? shiftId;
  final String date;
  final String checkIn;
  final String? checkOut;
  final String status;
  final int? workingMinutes;
  final String? notes;

  ManualAttendanceData({
    required this.id,
    required this.userId,
    this.shiftId,
    required this.date,
    required this.checkIn,
    this.checkOut,
    required this.status,
    this.workingMinutes,
    this.notes,
  });

  factory ManualAttendanceData.fromJson(Map<String, dynamic> json) {
    return ManualAttendanceData(
      id: json['id'] is int ? json['id'] : int.tryParse(json['id'].toString()) ?? 0,
      userId: json['user_id']?.toString() ?? '',
      shiftId: json['shift_id']?.toString(),
      date: json['date'] ?? '',
      checkIn: json['check_in'] ?? '',
      checkOut: json['check_out']?.toString(),
      status: json['status'] ?? '',
      workingMinutes: json['working_minutes'] is int ? json['working_minutes'] : int.tryParse(json['working_minutes']?.toString() ?? ''),
      notes: json['notes'],
    );
  }
}

class ShiftModel {
  final int id;
  final String name;

  ShiftModel({required this.id, required this.name});

  factory ShiftModel.fromJson(Map<String, dynamic> json) {
    return ShiftModel(
      id: json['id'] is int ? json['id'] : int.tryParse(json['id'].toString()) ?? 0,
      name: json['name'] ?? '',
    );
  }
}
