import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../bloc/correction/correction_request_bloc.dart';
import '../bloc/correction/correction_request_event.dart';
import '../bloc/correction/correction_request_state.dart';
import '../data/repository/employee_attendance_repository.dart';

class RequestAttendenceCorrectionScreen extends StatefulWidget {
  final String attendanceId;
  const RequestAttendenceCorrectionScreen({super.key, required this.attendanceId});

  @override
  State<RequestAttendenceCorrectionScreen> createState() =>
      _RequestAttendenceCorrectionScreenState();
}

class _RequestAttendenceCorrectionScreenState
    extends State<RequestAttendenceCorrectionScreen> {
  TimeOfDay? checkInTime;
  TimeOfDay? checkOutTime;
  final TextEditingController reasonController = TextEditingController();

  String formatTime(TimeOfDay? time) {
    if (time == null) return "--:--";
    final now = DateTime.now();
    final dt = DateTime(now.year, now.month, now.day, time.hour, time.minute);
    return DateFormat('hh:mm a').format(dt);
  }

  Future<void> pickTime(bool isCheckIn) async {
    TimeOfDay initialTime = TimeOfDay.now();

    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: initialTime,
    );

    if (picked != null) {
      setState(() {
        if (isCheckIn) {
          checkInTime = picked;
        } else {
          checkOutTime = picked;
        }
      });
    }
  }

  void _submit(BuildContext context) {
    if (checkInTime == null || checkOutTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please select both times")),
      );
      return;
    }

    if (reasonController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter reason")),
      );
      return;
    }

    // Format times with current date for simplicity (or should use the attendance date)
    // The API expects "YYYY-MM-DD HH:mm:ss"
    final now = DateTime.now();
    final checkInStr = "${DateFormat('yyyy-MM-dd').format(now)} ${checkInTime!.hour.toString().padLeft(2, '0')}:${checkInTime!.minute.toString().padLeft(2, '0')}:00";
    final checkOutStr = "${DateFormat('yyyy-MM-dd').format(now)} ${checkOutTime!.hour.toString().padLeft(2, '0')}:${checkOutTime!.minute.toString().padLeft(2, '0')}:00";

    context.read<CorrectionRequestBloc>().add(SubmitCorrectionRequest(
      attendanceId: widget.attendanceId,
      requestedCheckIn: checkInStr,
      requestedCheckOut: checkOutStr,
      reason: reasonController.text.trim(),
    ));
  }

  Widget buildTimeTile({
    required String title,
    required String value,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(title, style: const TextStyle(fontSize: 16)),
            Text(
              value,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    reasonController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CorrectionRequestBloc(repository: EmployeeAttendanceRepository()),
      child: BlocListener<CorrectionRequestBloc, CorrectionRequestState>(
        listener: (context, state) {
          if (state is CorrectionRequestSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message), backgroundColor: Colors.green),
            );
            Navigator.pop(context);
          } else if (state is CorrectionRequestError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message), backgroundColor: Colors.red),
            );
          }
        },
        child: Scaffold(
          appBar: AppBar(
            title: const Text("Request Correction"),
            centerTitle: true,
          ),
          body: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                buildTimeTile(
                  title: "Requested Check In",
                  value: formatTime(checkInTime),
                  onTap: () => pickTime(true),
                ),
                buildTimeTile(
                  title: "Requested Check Out",
                  value: formatTime(checkOutTime),
                  onTap: () => pickTime(false),
                ),
                TextField(
                  controller: reasonController,
                  maxLines: 4,
                  decoration: InputDecoration(
                    hintText: "e.g. Incorrect attendance record",
                    labelText: "Correction Reason*",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                const Spacer(),
                BlocBuilder<CorrectionRequestBloc, CorrectionRequestState>(
                  builder: (context, state) {
                    final isSubmitting = state is CorrectionRequestSubmitting;
                    return SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: isSubmitting ? null : () => _submit(context),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: isSubmitting 
                          ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                          : const Text("Submit Request"),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}