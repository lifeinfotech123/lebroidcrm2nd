import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/correction/correction_admin_bloc.dart';
import '../bloc/correction/correction_admin_event.dart';
import '../bloc/correction/correction_admin_state.dart';
import '../data/repository/employee_attendance_repository.dart';
import '../data/model/attendance_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AttendanceCorrectionScreen extends StatefulWidget {
  const AttendanceCorrectionScreen({super.key});

  @override
  State<AttendanceCorrectionScreen> createState() =>
      _AttendanceCorrectionScreenState();
}

class _AttendanceCorrectionScreenState
    extends State<AttendanceCorrectionScreen> {

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CorrectionAdminBloc(
        repository: EmployeeAttendanceRepository(),
      )..add(FetchCorrectionRequests()),
      child: BlocListener<CorrectionAdminBloc, CorrectionAdminState>(
        listener: (context, state) {
          if (state is CorrectionAdminSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.green,
              ),
            );
          } else if (state is CorrectionAdminError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        child: Scaffold(
          backgroundColor: Colors.grey.shade100,
          appBar: AppBar(
            elevation: 0,
            backgroundColor: Colors.white,
            title: const Text(
              "Attendance Corrections",
              style: TextStyle(color: Colors.black),
            ),
            iconTheme: const IconThemeData(color: Colors.black),
          ),
          body: BlocBuilder<CorrectionAdminBloc, CorrectionAdminState>(
            builder: (context, state) {
              if (state is CorrectionAdminLoading) {
                return const Center(child: CircularProgressIndicator());
              }

              List<AttendanceModel> requests = [];
              if (state is CorrectionAdminLoaded) {
                requests = state.requests;
              }

              if (requests.isEmpty) {
                return const Center(
                  child: Text("No correction requests found"),
                );
              }

              return ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: requests.length,
                itemBuilder: (context, index) {
                  final item = requests[index];
                  return _buildCard(context, item);
                },
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildCard(BuildContext context, AttendanceModel item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            blurRadius: 8,
            color: Colors.black.withOpacity(0.05),
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            /// 👤 Employee Info
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: Colors.blue.shade100,
                  child: Text(
                    (item.user?.name ?? "U")[0],
                    style: const TextStyle(color: Colors.blue),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.user?.name ?? "Unknown",
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        item.user?.empId ?? "",
                        style: TextStyle(color: Colors.grey.shade600),
                      ),
                    ],
                  ),
                ),
                statusChip(item.correctionStatus ?? "Pending"),
              ],
            ),

            const SizedBox(height: 16),

            /// 📅 Date
            Row(
              children: [
                const Icon(Icons.calendar_today, size: 16),
                const SizedBox(width: 6),
                Text(item.date ?? ""),
              ],
            ),

            const SizedBox(height: 12),

            /// ⏰ Time Comparison
            Row(
              children: [
                Expanded(
                  child: _timeBox(
                    "Original In",
                    item.checkIn ?? "-",
                    Colors.grey,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _timeBox(
                    "Requested In",
                    item.requestedCheckIn ?? "-",
                    Colors.blue,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 8),

            Row(
              children: [
                Expanded(
                  child: _timeBox(
                    "Original Out",
                    item.checkOut ?? "-",
                    Colors.grey,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _timeBox(
                    "Requested Out",
                    item.requestedCheckOut ?? "-",
                    Colors.blue,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            /// 📝 Reason
            Text(
              "Reason",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.grey.shade700,
              ),
            ),
            const SizedBox(height: 4),
            Text(item.correctionReason ?? "-"),

            const SizedBox(height: 16),

            /// ✅ Actions
            if (item.correctionStatus?.toLowerCase() == "pending")
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        context.read<CorrectionAdminBloc>().add(
                          ProcessCorrectionRequest(
                            attendanceId: item.id!,
                            action: 'approved',
                            note: 'Approved',
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text("Approve"),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        context.read<CorrectionAdminBloc>().add(
                          ProcessCorrectionRequest(
                            attendanceId: item.id!,
                            action: 'rejected',
                            note: 'Rejected',
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text("Reject"),
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }

  Widget _timeBox(String label, String time, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          Text(
            label,
            style: TextStyle(fontSize: 12, color: color),
          ),
          const SizedBox(height: 4),
          Text(
            time,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Color statusColor(String status) {
    switch (status.toLowerCase()) {
      case "approved":
        return Colors.green;
      case "rejected":
        return Colors.red;
      default:
        return Colors.orange;
    }
  }

  Widget statusChip(String status) {
    final color = statusColor(status);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        status,
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}