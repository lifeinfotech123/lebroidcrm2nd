import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart'as http;
import 'package:lebroid_crm/feaure/auth/data/services/auth_service.dart';
import '../model/attendance_model.dart';
import '../model/attendance_summary_model.dart';
import '../model/calendar_attendance_model.dart';
import '../model/check_in_out_model.dart';
import '../model/manual_attendance_model.dart';

class EmployeeAttendanceRepository {
  final AuthService _authService = AuthService();

  Future<AttendanceResponse> getAllAttendances() async {
    try {
      final response = await _authService.get('attendances');
      return AttendanceResponse.fromJson(response);
    } catch (e) {
      throw Exception('Failed to get attendances: $e');
    }
  }

  Future<AttendanceSummaryResponse> getAttendanceSummary() async {
    try {
      final response = await _authService.get('attendances/summary');
      return AttendanceSummaryResponse.fromJson(response);
    } catch (e) {
      throw Exception('Failed to get attendance summary: $e');
    }
  }

  /// Fetch calendar attendance for a specific user
  /// [userId] - The ID of the user
  Future<CalendarAttendanceResponse> getCalendarAttendance(int userId) async {
    try {
      final response = await _authService.get('attendances/$userId/calendar');
      print("Calendar API Raw Response: $response");
      return CalendarAttendanceResponse.fromJson(response);
    } catch (e) {
      throw Exception('Failed to get calendar attendance: $e');
    }
  }

  /// Check-In with optional selfie and location
  /// [selfiePath] - optional file path for selfie image
  /// [latitude] - optional latitude for location
  /// [longitude] - optional longitude for location
  Future<CheckInResponse> checkIn({
    String? selfiePath,
    double? latitude,
    double? longitude,
  }) async {
    try {
      final body = <String, dynamic>{};

      if (latitude != null) {
        body['Latitude'] = latitude.toString();
      }
      if (longitude != null) {
        body['Longitude'] = longitude.toString();
      }

      if (selfiePath != null) {
        final bytes = await File(selfiePath).readAsBytes();
        final base64Image = base64Encode(bytes);
        body['selfie'] = base64Image;
      }

      final response = await _authService.postWithToken(
        'attendances/check-in',
        body,
      );

      print("Check-In API Raw Response: $response");
      return CheckInResponse.fromJson(response);
    } catch (e) {
      throw Exception('Failed to check in: $e');
    }
  }

  /// Check-Out
  Future<CheckOutResponse> checkOut() async {
    try {
      final response = await _authService.postWithToken('attendances/check-out', {});
      print("Check-Out API Raw Response: $response");
      return CheckOutResponse.fromJson(response);
    } catch (e) {
      throw Exception('Failed to check out: $e');
    }
  }

  /// Mark Attendance Manually
  Future<ManualAttendanceResponse> markAttendanceManually(ManualAttendanceRequest request) async {
    try {
      final response = await _authService.postWithToken('attendances/manual', request.toJson());
      print("Manual Attendance API Raw Response: $response");
      return ManualAttendanceResponse.fromJson(response);
    } catch (e) {
      throw Exception('Failed to mark attendance manually: $e');
    }
  }

  /// Fetch all shifts
  Future<List<ShiftModel>> getShifts() async {
    try {
      // Assuming 'shifts' endpoint exists. If not, we might need to adjust.
      final response = await _authService.get('shifts');
      if (response['success'] == true) {
        final List<dynamic> data = response['data'] ?? [];
        return data.map((json) => ShiftModel.fromJson(json)).toList();
      }
      return [];
    } catch (e) {
      print("Error fetching shifts: $e. Using default shift.");
      // Return a default shift if the call fails, so the user can still submit with shift_id 1
      return [ShiftModel(id: 1, name: 'General Shift')];
    }
  }
  /// Get all attendance correction requests (Admin)
  Future<List<AttendanceModel>> getCorrectionRequests() async {
    try {
      final response = await _authService.get('attendances/corrections');
      if (response['success'] == true) {
        final List<dynamic> data = response['data'] ?? [];
        return data.map((json) => AttendanceModel.fromJson(json)).toList();
      }
      return [];
    } catch (e) {
      throw Exception('Failed to get correction requests: $e');
    }
  }

  /// Request attendance correction (User)
  Future<void> requestCorrection(String attendanceId, Map<String, dynamic> data) async {
    try {
      final response = await _authService.put('attendances/$attendanceId/correction', data);
      if (response['success'] != true) {
        throw Exception(response['message'] ?? 'Failed to request correction');
      }
    } catch (e) {
      throw Exception('Failed to request correction: $e');
    }
  }

  /// Process attendance correction (Admin)
  Future<void> processCorrection(int attendanceId, Map<String, dynamic> data) async {
    try {
      final response = await _authService.put('attendances/$attendanceId/process-correction', data);
      if (response['success'] != true) {
        throw Exception(response['message'] ?? 'Failed to process correction');
      }
    } catch (e) {
      throw Exception('Failed to process correction: $e');
    }
  }
}
