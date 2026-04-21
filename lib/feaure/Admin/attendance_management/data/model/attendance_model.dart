class AttendanceResponse {
  final bool? success;
  final AttendanceResponseData? data;

  AttendanceResponse({this.success, this.data});

  factory AttendanceResponse.fromJson(Map<String, dynamic> json) {
    return AttendanceResponse(
      success: json['success'],
      data: json['data'] != null ? AttendanceResponseData.fromJson(json['data']) : null,
    );
  }
}

class AttendanceResponseData {
  final int? currentPage;
  final List<AttendanceModel>? data;

  AttendanceResponseData({this.currentPage, this.data});

  factory AttendanceResponseData.fromJson(Map<String, dynamic> json) {
    return AttendanceResponseData(
      currentPage: json['current_page'],
      data: json['data'] != null
          ? (json['data'] as List).map((i) => AttendanceModel.fromJson(i)).toList()
          : null,
    );
  }
}

class AttendanceModel {
  final int? id;
  final String? userId;
  final String? branchId;
  final String? shiftId;
  final String? date;
  final String? checkIn;
  final String? checkOut;
  final String? status;
  final num? workingMinutes;
  final int? lateMinutes;
  final bool? isLate;
  final AttendanceUser? user;
  final dynamic shift;
  final bool? correctionRequested;
  final String? correctionReason;
  final String? requestedCheckIn;
  final String? requestedCheckOut;
  final String? correctionStatus;

  AttendanceModel({
    this.id,
    this.userId,
    this.branchId,
    this.shiftId,
    this.date,
    this.checkIn,
    this.checkOut,
    this.status,
    this.workingMinutes,
    this.lateMinutes,
    this.isLate,
    this.user,
    this.shift,
    this.correctionRequested,
    this.correctionReason,
    this.requestedCheckIn,
    this.requestedCheckOut,
    this.correctionStatus,
  });

  factory AttendanceModel.fromJson(Map<String, dynamic> json) {
    return AttendanceModel(
      id: json['id'],
      userId: json['user_id']?.toString(),
      branchId: json['branch_id']?.toString(),
      shiftId: json['shift_id']?.toString(),
      date: json['date'],
      checkIn: json['check_in'],
      checkOut: json['check_out'],
      status: json['status'],
      workingMinutes: json['working_minutes'],
      lateMinutes: json['late_minutes'],
      isLate: json['is_late'] == 1 || json['is_late'] == true,
      user: json['user'] != null ? AttendanceUser.fromJson(json['user']) : null,
      shift: json['shift'],
      correctionRequested: json['correction_requested'] == 1 || json['correction_requested'] == true,
      correctionReason: json['correction_reason'],
      requestedCheckIn: json['requested_check_in'],
      requestedCheckOut: json['requested_check_out'],
      correctionStatus: json['correction_status'],
    );
  }
}

class AttendanceUser {
  final int? id;
  final String? name;
  final String? empId;

  AttendanceUser({this.id, this.name, this.empId});

  factory AttendanceUser.fromJson(Map<String, dynamic> json) {
    return AttendanceUser(
      id: json['id'],
      name: json['name'],
      empId: json['emp_id'], // Adjust according to API, maybe it's employee_code
    );
  }
}
