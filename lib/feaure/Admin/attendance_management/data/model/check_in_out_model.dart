class CheckInResponse {
  final bool? success;
  final String? message;
  final CheckInData? data;

  CheckInResponse({this.success, this.message, this.data});

  factory CheckInResponse.fromJson(Map<String, dynamic> json) {
    return CheckInResponse(
      success: json['success'],
      message: json['message'],
      data: json['data'] != null ? CheckInData.fromJson(json['data']) : null,
    );
  }
}

class CheckInData {
  final int? id;
  final int? userId;
  final String? date;
  final String? checkIn;
  final String? selfieIn;
  final double? latIn;
  final double? lngIn;
  final bool? isGeoVerified;
  final String? status;
  final bool? isLate;
  final int? lateMinutes;
  final int? shiftId;
  final String? shiftEndTime;
  final int? shiftDurationMinutes;
  final double? perMinuteRate;
  final double? otPerMinuteRate;
  final String? branchId;
  final String? checkInIp;
  final int? markedBy;

  CheckInData({
    this.id,
    this.userId,
    this.date,
    this.checkIn,
    this.selfieIn,
    this.latIn,
    this.lngIn,
    this.isGeoVerified,
    this.status,
    this.isLate,
    this.lateMinutes,
    this.shiftId,
    this.shiftEndTime,
    this.shiftDurationMinutes,
    this.perMinuteRate,
    this.otPerMinuteRate,
    this.branchId,
    this.checkInIp,
    this.markedBy,
  });

  factory CheckInData.fromJson(Map<String, dynamic> json) {
    return CheckInData(
      id: json['id'],
      userId: json['user_id'] is int ? json['user_id'] : int.tryParse(json['user_id']?.toString() ?? ''),
      date: json['date'],
      checkIn: json['check_in'],
      selfieIn: json['selfie_in'],
      latIn: json['lat_in'] != null ? double.tryParse(json['lat_in'].toString()) : null,
      lngIn: json['lng_in'] != null ? double.tryParse(json['lng_in'].toString()) : null,
      isGeoVerified: json['is_geo_verified'] == 1 || json['is_geo_verified'] == true,
      status: json['status'],
      isLate: json['is_late'] == 1 || json['is_late'] == true,
      lateMinutes: json['late_minutes'],
      shiftId: json['shift_id'] is int ? json['shift_id'] : int.tryParse(json['shift_id']?.toString() ?? ''),
      shiftEndTime: json['shift_end_time'],
      shiftDurationMinutes: json['shift_duration_minutes'] is int
          ? json['shift_duration_minutes']
          : int.tryParse(json['shift_duration_minutes']?.toString() ?? ''),
      perMinuteRate: json['per_minute_rate'] != null ? double.tryParse(json['per_minute_rate'].toString()) : null,
      otPerMinuteRate: json['ot_per_minute_rate'] != null ? double.tryParse(json['ot_per_minute_rate'].toString()) : null,
      branchId: json['branch_id']?.toString(),
      checkInIp: json['check_in_ip'],
      markedBy: json['marked_by'] is int ? json['marked_by'] : int.tryParse(json['marked_by']?.toString() ?? ''),
    );
  }
}

class CheckOutResponse {
  final bool? success;
  final String? message;
  final CheckOutData? data;

  CheckOutResponse({this.success, this.message, this.data});

  factory CheckOutResponse.fromJson(Map<String, dynamic> json) {
    return CheckOutResponse(
      success: json['success'],
      message: json['message'],
      data: json['data'] != null ? CheckOutData.fromJson(json['data']) : null,
    );
  }
}

class CheckOutData {
  final int? id;
  final String? userId;
  final String? branchId;
  final String? shiftId;
  final String? date;
  final String? checkIn;
  final String? checkOut;
  final String? shiftEndTime;
  final String? overtimeMinutes;
  final String? earnedAmount;
  final String? otAmount;
  final String? lateDeductionAmount;
  final int? workingMinutes;
  final String? status;
  final bool? isLate;
  final int? lateMinutes;
  final bool? earlyExit;

  CheckOutData({
    this.id,
    this.userId,
    this.branchId,
    this.shiftId,
    this.date,
    this.checkIn,
    this.checkOut,
    this.shiftEndTime,
    this.overtimeMinutes,
    this.earnedAmount,
    this.otAmount,
    this.lateDeductionAmount,
    this.workingMinutes,
    this.status,
    this.isLate,
    this.lateMinutes,
    this.earlyExit,
  });

  factory CheckOutData.fromJson(Map<String, dynamic> json) {
    return CheckOutData(
      id: json['id'],
      userId: json['user_id']?.toString(),
      branchId: json['branch_id']?.toString(),
      shiftId: json['shift_id']?.toString(),
      date: json['date'],
      checkIn: json['check_in'],
      checkOut: json['check_out'],
      shiftEndTime: json['shift_end_time'],
      overtimeMinutes: json['overtime_minutes']?.toString(),
      earnedAmount: json['earned_amount']?.toString(),
      otAmount: json['ot_amount']?.toString(),
      lateDeductionAmount: json['late_deduction_amount']?.toString(),
      workingMinutes: json['working_minutes'] is int
          ? json['working_minutes']
          : int.tryParse(json['working_minutes']?.toString() ?? ''),
      status: json['status'],
      isLate: json['is_late'] == 1 || json['is_late'] == true,
      lateMinutes: json['late_minutes'],
      earlyExit: json['early_exit'] == 1 || json['early_exit'] == true,
    );
  }
}
