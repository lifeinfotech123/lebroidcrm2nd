import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/correction/correction_admin_bloc.dart';
import '../bloc/correction/correction_admin_event.dart';
import '../bloc/correction/correction_admin_state.dart';
import '../data/repository/employee_attendance_repository.dart';
import '../data/model/attendance_model.dart';

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
      create: (context) => CorrectionAdminBloc(repository: EmployeeAttendanceRepository())..add(FetchCorrectionRequests()),
      child: BlocListener<CorrectionAdminBloc, CorrectionAdminState>(
        listener: (context, state) {
          if (state is CorrectionAdminSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message), backgroundColor: Colors.green),
            );
          } else if (state is CorrectionAdminError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message), backgroundColor: Colors.red),
            );
          }
        },
        child: Scaffold(
          appBar: AppBar(
            title: const Text("Attendance Corrections"),
          ),
          body: BlocBuilder<CorrectionAdminBloc, CorrectionAdminState>(
            builder: (context, state) {
              if (state is CorrectionAdminLoading) {
                return const Center(child: CircularProgressIndicator());
              }

              List<AttendanceModel> requests = [];
              if (state is CorrectionAdminLoaded) {
                requests = state.requests;
              } else if (state is CorrectionAdminProcessing) {
                // Keep showing the list during processing if possible, or just loading
                // Actually, the BLoC can be optimized, but for now we'll handle it simply
              }

              if (requests.isEmpty && state is! CorrectionAdminLoading) {
                return const Center(child: Text("No correction requests found."));
              }

              return SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: DataTable(
                    columnSpacing: 20,
                    headingRowColor: MaterialStateProperty.all(Colors.grey.shade200),
                    columns: const [
                      DataColumn(label: Text("Employee")),
                      DataColumn(label: Text("Date")),
                      DataColumn(label: Text("Check In")),
                      DataColumn(label: Text("Check Out")),
                      DataColumn(label: Text("Requested In")),
                      DataColumn(label: Text("Requested Out")),
                      DataColumn(label: Text("Reason")),
                      DataColumn(label: Text("Status")),
                      DataColumn(label: Text("Actions")),
                    ],
                    rows: requests.map((item) {
                      final index = requests.indexOf(item);
                      return DataRow(
                        cells: [
                          DataCell(Text("${item.user?.name ?? 'Unknown'}\n${item.user?.empId ?? ''}")),
                          DataCell(Text(item.date ?? '')),
                          DataCell(Text(item.checkIn ?? '')),
                          DataCell(Text(item.checkOut ?? '')),
                          DataCell(Text(item.requestedCheckIn ?? '')),
                          DataCell(Text(item.requestedCheckOut ?? '')),
                          DataCell(SizedBox(
                            width: 150,
                            child: Text(item.correctionReason ?? ''),
                          )),
                          DataCell(statusChip(item.correctionStatus ?? 'Pending')),
                          DataCell(actionButtons(context, item)),
                        ],
                      );
                    }).toList(),
                  ),
                ),
              );
            },
          ),
        ),
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
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: statusColor(status).withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        status,
        style: TextStyle(
          color: statusColor(status),
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget actionButtons(BuildContext context, AttendanceModel item) {
    if (item.correctionStatus?.toLowerCase() != "pending") return const SizedBox();

    return Row(
      children: [
        ElevatedButton(
          onPressed: () => context.read<CorrectionAdminBloc>().add(
            ProcessCorrectionRequest(attendanceId: item.id!, action: 'approved', note: 'Approved')
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green,
            padding: const EdgeInsets.symmetric(horizontal: 12),
          ),
          child: const Text("Accept"),
        ),
        const SizedBox(width: 8),
        ElevatedButton(
          onPressed: () => context.read<CorrectionAdminBloc>().add(
            ProcessCorrectionRequest(attendanceId: item.id!, action: 'rejected', note: 'Rejected')
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red,
            padding: const EdgeInsets.symmetric(horizontal: 12),
          ),
          child: const Text("Reject"),
        ),
      ],
    );
  }
}