import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';
import 'package:geolocator/geolocator.dart';
import '../bloc/user_attendance/user_attendance_bloc.dart';
import '../bloc/user_attendance/user_attendance_event.dart';
import '../bloc/user_attendance/user_attendance_state.dart';

class SelfieAttendanceScreen extends StatefulWidget {
  const SelfieAttendanceScreen({super.key});

  @override
  State<SelfieAttendanceScreen> createState() => _SelfieAttendanceScreenState();
}

class _SelfieAttendanceScreenState extends State<SelfieAttendanceScreen> {
  bool _isCameraReady = false;
  bool _isLocationReady = false;
  bool _isSubmitting = false;
  bool _isLocationLoading = false;
  String? _selfiePath;
  double? _latitude;
  double? _longitude;
  String _userName = '';
  String _employeeId = '';
  String _locationError = '';

  final ImagePicker _imagePicker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _loadUserInfo();
    _fetchLocation();
  }

  Future<void> _loadUserInfo() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _userName = prefs.getString('name') ?? 'User';
      _employeeId = prefs.getString('employee_id') ?? '';
    });
  }

  /// Open camera and capture selfie
  Future<void> _captureSelfe() async {
    try {
      final XFile? photo = await _imagePicker.pickImage(
        source: ImageSource.camera,
        preferredCameraDevice: CameraDevice.front,
        maxWidth: 800,
        maxHeight: 800,
        imageQuality: 85,
      );

      if (photo != null) {
        setState(() {
          _selfiePath = photo.path;
          _isCameraReady = true;
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Camera error: $e'),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  /// Fetch real GPS location using Geolocator
  Future<void> _fetchLocation() async {
    setState(() {
      _isLocationLoading = true;
      _locationError = '';
    });

    try {
      // Check if location services are enabled
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        setState(() {
          _isLocationReady = false;
          _isLocationLoading = false;
          _locationError = 'Location services are disabled. Please enable GPS.';
        });
        return;
      }

      // Check and request permissions
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          setState(() {
            _isLocationReady = false;
            _isLocationLoading = false;
            _locationError = 'Location permission denied.';
          });
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        setState(() {
          _isLocationReady = false;
          _isLocationLoading = false;
          _locationError = 'Location permission permanently denied. Please enable it in app settings.';
        });
        return;
      }

      // Get current position
      Position position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          timeLimit: Duration(seconds: 15),
        ),
      );

      setState(() {
        _latitude = position.latitude;
        _longitude = position.longitude;
        _isLocationReady = true;
        _isLocationLoading = false;
        _locationError = '';
      });
    } catch (e) {
      setState(() {
        _isLocationReady = false;
        _isLocationLoading = false;
        _locationError = 'Failed to get location: $e';
      });
    }
  }

  void _onSubmitAttendance() {
    context.read<UserAttendanceBloc>().add(
      CheckInEvent(
        selfiePath: _selfiePath,
        latitude: _latitude,
        longitude: _longitude,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<UserAttendanceBloc, UserAttendanceState>(
      listener: (context, state) {
        if (state is CheckInLoading) {
          setState(() => _isSubmitting = true);
        } else if (state is CheckInSuccess) {
          setState(() => _isSubmitting = false);
          final data = state.response.data;
          final message = state.response.message ?? 'Checked in successfully!';

          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (ctx) => AlertDialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              title: Row(
                children: [
                  Icon(Icons.check_circle, color: Colors.green.shade600, size: 28),
                  const SizedBox(width: 8),
                  const Expanded(child: Text('Check-In Success', style: TextStyle(fontSize: 18))),
                ],
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(message, style: const TextStyle(fontSize: 14)),
                  if (data != null) ...[
                    const SizedBox(height: 12),
                    _buildInfoRow('Time', data.checkIn ?? '—'),
                    _buildInfoRow('Status', data.status?.toUpperCase() ?? '—'),
                    if (data.isLate == true)
                      _buildInfoRow('Late', '${data.lateMinutes ?? 0} minutes'),
                  ],
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(ctx).pop();
                    Navigator.of(context).pop();
                  },
                  child: const Text('OK'),
                ),
              ],
            ),
          );
        } else if (state is CheckInError) {
          setState(() => _isSubmitting = false);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.red,
              behavior: SnackBarBehavior.floating,
            ),
          );
        } else if (state is CheckOutLoading) {
          setState(() => _isSubmitting = true);
        } else if (state is CheckOutSuccess) {
          setState(() => _isSubmitting = false);
          final data = state.response.data;
          final message = state.response.message ?? 'Checked out successfully!';

          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (ctx) => AlertDialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              title: Row(
                children: [
                  Icon(Icons.logout, color: Colors.orange.shade600, size: 28),
                  const SizedBox(width: 8),
                  const Expanded(child: Text('Check-Out Success', style: TextStyle(fontSize: 18))),
                ],
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(message, style: const TextStyle(fontSize: 14)),
                  if (data != null) ...[
                    const SizedBox(height: 12),
                    _buildInfoRow('Check-In', data.checkIn ?? '—'),
                    _buildInfoRow('Check-Out', data.checkOut ?? '—'),
                    _buildInfoRow('Working', '${data.workingMinutes ?? 0} min'),
                    _buildInfoRow('Status', data.status?.toUpperCase() ?? '—'),
                    if (data.earlyExit == true)
                      _buildInfoRow('Early Exit', 'Yes'),
                  ],
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(ctx).pop();
                    Navigator.of(context).pop();
                  },
                  child: const Text('OK'),
                ),
              ],
            ),
          );
        } else if (state is CheckOutError) {
          setState(() => _isSubmitting = false);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.red,
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      },
      child: Scaffold(
        backgroundColor: Colors.grey[50],
        appBar: AppBar(
          title: const Text('Selfie Attendance', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18)),
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          elevation: 1,
          shadowColor: Colors.black12,
        ),
        body: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _buildEmployeeHeader(),
                    const SizedBox(height: 16),
                    _buildSessionInfo(),
                    const SizedBox(height: 16),
                    _buildCameraSection(),
                    const SizedBox(height: 16),
                    _buildLocationSection(),
                    const SizedBox(height: 24),
                    _buildStatusChecklist(),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
            _buildBottomBar(),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4.0),
      child: Row(
        children: [
          Text('$label: ', style: TextStyle(fontWeight: FontWeight.w600, color: Colors.grey.shade700, fontSize: 13)),
          Expanded(child: Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13))),
        ],
      ),
    );
  }

  Widget _buildEmployeeHeader() {
    final initial = _userName.isNotEmpty ? _userName[0].toUpperCase() : 'U';
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10, offset: const Offset(0, 4)),
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 26,
            backgroundColor: Colors.indigo.shade50,
            foregroundColor: Colors.indigo.shade700,
            child: Text(initial, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _userName,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.black87),
                ),
                const SizedBox(height: 4),
                if (_employeeId.isNotEmpty)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      _employeeId,
                      style: TextStyle(color: Colors.grey.shade800, fontSize: 12, fontWeight: FontWeight.w600),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSessionInfo() {
    final now = DateTime.now();
    final dateStr = DateFormat('dd MMM yyyy').format(now);
    final timeStr = DateFormat('hh:mm a').format(now);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.event_available_outlined, size: 20, color: Colors.indigo.shade400),
              const SizedBox(width: 8),
              const Text('Check-In Session', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
            ],
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 12.0),
            child: Divider(height: 1),
          ),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Date', style: TextStyle(color: Colors.grey.shade500, fontSize: 11)),
                    const SizedBox(height: 4),
                    Text(dateStr, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14, color: Colors.black87)),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Current Time', style: TextStyle(color: Colors.grey.shade500, fontSize: 11)),
                    const SizedBox(height: 4),
                    Text(timeStr, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14, color: Colors.black87)),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Location', style: TextStyle(color: Colors.grey.shade500, fontSize: 11)),
                    const SizedBox(height: 4),
                    _isLocationLoading
                        ? Row(
                            children: [
                              SizedBox(width: 14, height: 14, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.indigo.shade400)),
                              const SizedBox(width: 6),
                              Text('Detecting...', style: TextStyle(fontSize: 12, color: Colors.indigo.shade600)),
                            ],
                          )
                        : Row(
                            children: [
                              Icon(
                                _isLocationReady ? Icons.check_circle : Icons.error_outline,
                                size: 14,
                                color: _isLocationReady ? Colors.green.shade400 : Colors.red.shade400,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                _isLocationReady ? 'Detected' : 'Failed',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                  color: _isLocationReady ? Colors.green.shade600 : Colors.red.shade600,
                                ),
                              ),
                            ],
                          ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCameraSection() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Icon(Icons.camera_alt_outlined, size: 20, color: Colors.indigo.shade400),
                const SizedBox(width: 8),
                const Text('Capture Check-In Selfie', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
              ],
            ),
          ),
          const Divider(height: 1),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                GestureDetector(
                  onTap: _captureSelfe,
                  child: Container(
                    height: 250,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: _isCameraReady && _selfiePath != null
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.file(
                              File(_selfiePath!),
                              width: double.infinity,
                              height: double.infinity,
                              fit: BoxFit.cover,
                            ),
                          )
                        : Stack(
                            alignment: Alignment.center,
                            children: [
                              Container(
                                width: double.infinity,
                                height: double.infinity,
                                decoration: BoxDecoration(
                                  color: Colors.black87,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              Container(
                                width: 180,
                                height: 180,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(color: Colors.white.withOpacity(0.3), width: 2),
                                ),
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.camera_alt_outlined, size: 48, color: Colors.grey.shade400),
                                  const SizedBox(height: 12),
                                  const Text(
                                    'Tap to Open Camera',
                                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                                  ),
                                  const SizedBox(height: 8),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 32.0),
                                    child: Text(
                                      'Position your face inside the circle for a selfie.',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(color: Colors.grey.shade400, fontSize: 12),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  _isCameraReady ? '✅ Selfie captured! Tap image or button to retake.' : 'Tap the area above or the button below to capture selfie.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: _isCameraReady ? Colors.green.shade700 : Colors.grey.shade600,
                    fontSize: 12,
                    fontWeight: _isCameraReady ? FontWeight.w600 : FontWeight.normal,
                  ),
                ),
                const SizedBox(height: 16),
                OutlinedButton.icon(
                  onPressed: _captureSelfe,
                  icon: Icon(_isCameraReady ? Icons.refresh : Icons.camera_alt),
                  label: Text(_isCameraReady ? 'Retake Selfie' : 'Open Camera'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.indigo,
                    side: BorderSide(color: Colors.indigo.shade200),
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLocationSection() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Icon(Icons.location_on_outlined, size: 20, color: Colors.indigo.shade400),
                const SizedBox(width: 8),
                const Text('Location Verification', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
              ],
            ),
          ),
          const Divider(height: 1),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: _isLocationLoading
                        ? Colors.blue.shade50
                        : _isLocationReady
                            ? Colors.green.shade50
                            : Colors.red.shade50,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: _isLocationLoading
                          ? Colors.blue.shade100
                          : _isLocationReady
                              ? Colors.green.shade100
                              : Colors.red.shade100,
                    ),
                  ),
                  child: Row(
                    children: [
                      _isLocationLoading
                          ? SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(strokeWidth: 2, color: Colors.blue.shade600),
                            )
                          : Icon(
                              _isLocationReady ? Icons.gpp_good_outlined : Icons.gpp_maybe_outlined,
                              color: _isLocationReady ? Colors.green.shade600 : Colors.red.shade600,
                              size: 20,
                            ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _isLocationLoading
                                  ? 'Detecting Location...'
                                  : _isLocationReady
                                      ? 'Location Detected Successfully'
                                      : 'Location Access Failed',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: _isLocationLoading
                                    ? Colors.blue.shade800
                                    : _isLocationReady
                                        ? Colors.green.shade800
                                        : Colors.red.shade800,
                                fontSize: 13,
                              ),
                            ),
                            if (_locationError.isNotEmpty) ...[
                              const SizedBox(height: 2),
                              Text(
                                _locationError,
                                style: TextStyle(color: Colors.red.shade700, fontSize: 12),
                              ),
                            ],
                            if (_isLocationReady) ...[
                              const SizedBox(height: 2),
                              Text(
                                'GPS coordinates captured.',
                                style: TextStyle(color: Colors.green.shade700, fontSize: 12),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Latitude', style: TextStyle(color: Colors.grey.shade500, fontSize: 11)),
                          const SizedBox(height: 4),
                          Text(
                            _latitude != null ? _latitude!.toStringAsFixed(6) : '—',
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.black87),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Longitude', style: TextStyle(color: Colors.grey.shade500, fontSize: 11)),
                          const SizedBox(height: 4),
                          Text(
                            _longitude != null ? _longitude!.toStringAsFixed(6) : '—',
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.black87),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                OutlinedButton.icon(
                  onPressed: _isLocationLoading ? null : _fetchLocation,
                  icon: _isLocationLoading
                      ? SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.indigo.shade400))
                      : const Icon(Icons.my_location),
                  label: Text(_isLocationLoading ? 'Detecting...' : 'Refresh Location'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.indigo,
                    side: BorderSide(color: Colors.indigo.shade200),
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusChecklist() {
    return Column(
      children: [
        _buildChecklistItem('Selfie captured', _isCameraReady),
        const SizedBox(height: 12),
        _buildChecklistItem('Location detected', _isLocationReady),
      ],
    );
  }

  Widget _buildChecklistItem(String title, bool isReady) {
    return Row(
      children: [
        Icon(
          isReady ? Icons.check_circle : Icons.radio_button_unchecked,
          color: isReady ? Colors.green : Colors.grey.shade400,
          size: 20,
        ),
        const SizedBox(width: 8),
        Text(
          title,
          style: TextStyle(
            color: isReady ? Colors.black87 : Colors.grey.shade600,
            fontWeight: isReady ? FontWeight.bold : FontWeight.w500,
            fontSize: 14,
          ),
        ),
      ],
    );
  }

  Widget _buildBottomBar() {
    bool isReady = _isCameraReady && _isLocationReady;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Colors.grey.shade200)),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, -4)),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: ElevatedButton(
                onPressed: (_isSubmitting || !isReady) ? null : _onSubmitAttendance,
                style: ElevatedButton.styleFrom(
                  backgroundColor: isReady ? Colors.indigo : Colors.grey.shade300,
                  foregroundColor: isReady ? Colors.white : Colors.grey.shade500,
                  disabledBackgroundColor: Colors.grey.shade300,
                  disabledForegroundColor: Colors.grey.shade500,
                  minimumSize: const Size(double.infinity, 50),
                  elevation: 0,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                child: _isSubmitting
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                      )
                    : const Text('CHECK IN', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, letterSpacing: 1)),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: OutlinedButton(
                onPressed: _isSubmitting
                    ? null
                    : () {
                        context.read<UserAttendanceBloc>().add(CheckOutEvent());
                      },
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.red,
                  side: const BorderSide(color: Colors.red),
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                child: const Text('CHECK OUT', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, letterSpacing: 1)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
