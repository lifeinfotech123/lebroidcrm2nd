class CalendarAttendanceResponse {
  final bool? success;
  final CalendarData? data;

  CalendarAttendanceResponse({this.success, this.data});

  factory CalendarAttendanceResponse.fromJson(Map<String, dynamic> json) {
    return CalendarAttendanceResponse(
      success: json['success'],
      data: json['data'] != null ? CalendarData.fromJson(json['data']) : null,
    );
  }
}

String? _parseStringOrObject(dynamic value, [String fallbackKey = 'name']) {
  if (value == null) return null;
  if (value is String) return value;
  if (value is Map) return value[fallbackKey]?.toString() ?? value.toString();
  return value.toString();
}

class CalendarData {
  final List<CalendarDayModel> calendar;

  CalendarData({required this.calendar});

  factory CalendarData.fromJson(Map<String, dynamic> json) {
    return CalendarData(
      calendar: json['calendar'] != null
          ? (json['calendar'] as List)
              .map((item) => CalendarDayModel.fromJson(item))
              .toList()
          : [],
    );
  }
}

class CalendarDayModel {
  final String? date;
  final int? day;
  final String? dateStr;
  final bool? isToday;
  final bool? isWeekend;
  final bool? isThisMonth;
  final bool? isFuture;
  final CalendarAttendance? attendance;
  final CalendarHoliday? holiday;
  final CalendarLeave? leave;
  final String? type;   // "present", "late", "absent", "holiday", "weekend", "leave", "other"
  final String? color;  // "success", "warning", "danger", "info", "light", etc.
  final String? label;
  final String? icon;

  CalendarDayModel({
    this.date,
    this.day,
    this.dateStr,
    this.isToday,
    this.isWeekend,
    this.isThisMonth,
    this.isFuture,
    this.attendance,
    this.holiday,
    this.leave,
    this.type,
    this.color,
    this.label,
    this.icon,
  });

  factory CalendarDayModel.fromJson(Map<String, dynamic> json) {
    return CalendarDayModel(
      date: _parseStringOrObject(json['date']),
      day: json['day'] is int ? json['day'] : int.tryParse(json['day']?.toString() ?? ''),
      dateStr: _parseStringOrObject(json['dateStr']),
      isToday: json['isToday'] == true,
      isWeekend: json['isWeekend'] == true,
      isThisMonth: json['isThisMonth'] == true,
      isFuture: json['isFuture'] == true,
      attendance: json['attendance'] is Map<String, dynamic>
          ? CalendarAttendance.fromJson(json['attendance'])
          : null,
      holiday: json['holiday'] is Map<String, dynamic>
          ? CalendarHoliday.fromJson(json['holiday'])
          : null,
      leave: json['leave'] is Map<String, dynamic>
          ? CalendarLeave.fromJson(json['leave'])
          : null,
      type: _parseStringOrObject(json['type']),
      color: _parseStringOrObject(json['color']),
      label: _parseStringOrObject(json['label']),
      icon: _parseStringOrObject(json['icon']),
    );
  }

  /// Map API type to the UI type string used by CalDay
  String get uiType {
    if (isThisMonth != true) return 'Other';
    switch (type?.toLowerCase()) {
      case 'present':
        return 'Present';
      case 'late':
        return 'Late';
      case 'absent':
        return 'Absent';
      case 'holiday':
        return 'Holiday';
      case 'weekend':
        return 'Weekend';
      case 'leave':
        return 'Leave';
      default:
        return 'Empty';
    }
  }
}

class CalendarAttendance {
  final int? id;
  final String? checkIn;
  final String? checkOut;
  final int? workingMinutes;
  final String? status;
  final bool? isLate;
  final int? lateMinutes;

  CalendarAttendance({
    this.id,
    this.checkIn,
    this.checkOut,
    this.workingMinutes,
    this.status,
    this.isLate,
    this.lateMinutes,
  });

  factory CalendarAttendance.fromJson(Map<String, dynamic> json) {
    return CalendarAttendance(
      id: json['id'] is int ? json['id'] : int.tryParse(json['id']?.toString() ?? ''),
      checkIn: _parseStringOrObject(json['check_in']),
      checkOut: _parseStringOrObject(json['check_out']),
      workingMinutes: json['working_minutes'] is int ? json['working_minutes'] : int.tryParse(json['working_minutes']?.toString() ?? ''),
      status: _parseStringOrObject(json['status']),
      isLate: json['is_late'] == 1 || json['is_late'] == true,
      lateMinutes: json['late_minutes'] is int ? json['late_minutes'] : int.tryParse(json['late_minutes']?.toString() ?? ''),
    );
  }

  String? get formattedCheckIn {
    if (checkIn == null) return null;
    // Return time in HH:mm format
    final parts = checkIn!.split(':');
    if (parts.length >= 2) return '${parts[0]}:${parts[1]}';
    return checkIn;
  }

  String? get formattedCheckOut {
    if (checkOut == null) return null;
    final parts = checkOut!.split(':');
    if (parts.length >= 2) return '${parts[0]}:${parts[1]}';
    return checkOut;
  }

  String? get workingHours {
    if (workingMinutes == null || workingMinutes == 0) return null;
    final hours = workingMinutes! / 60;
    return '${hours.toStringAsFixed(1)}h';
  }
}

class CalendarHoliday {
  final int? id;
  final String? name;
  final String? date;
  final String? type;

  CalendarHoliday({this.id, this.name, this.date, this.type});

  factory CalendarHoliday.fromJson(Map<String, dynamic> json) {
    return CalendarHoliday(
      id: json['id'] is int ? json['id'] : int.tryParse(json['id']?.toString() ?? ''),
      name: _parseStringOrObject(json['name']),
      date: _parseStringOrObject(json['date']),
      type: _parseStringOrObject(json['type']),
    );
  }
}

class CalendarLeave {
  final int? id;
  final String? leaveType;
  final String? status;

  CalendarLeave({this.id, this.leaveType, this.status});

  factory CalendarLeave.fromJson(Map<String, dynamic> json) {
    return CalendarLeave(
      id: json['id'] is int ? json['id'] : int.tryParse(json['id']?.toString() ?? ''),
      leaveType: _parseStringOrObject(json['leave_type']),
      status: _parseStringOrObject(json['status']),
    );
  }
}
