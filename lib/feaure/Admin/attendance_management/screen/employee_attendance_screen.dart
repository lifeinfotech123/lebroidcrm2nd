import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:intl/intl.dart';
import 'package:lebroid_crm/feaure/Admin/attendance_management/screen/request_attendence_correction_screen.dart';
import '../bloc/employee_attendance/employee_attendance_bloc.dart';
import '../bloc/employee_attendance/employee_attendance_event.dart';
import '../bloc/employee_attendance/employee_attendance_state.dart';
import '../data/model/attendance_model.dart';
import '../data/model/attendance_summary_model.dart';
import '../data/repository/employee_attendance_repository.dart';
import 'attendence_correction_screen.dart';

class EmployeeAttendanceScreen extends StatefulWidget {
  const EmployeeAttendanceScreen({super.key});

  @override
  State<EmployeeAttendanceScreen> createState() => _EmployeeAttendanceScreenState();
}

class _EmployeeAttendanceScreenState extends State<EmployeeAttendanceScreen> {
  String _selectedMonth = 'March, 2026';
  String _selectedStatus = 'All Status';
  String _selectedBranch = 'All Branches';
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }



  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => EmployeeAttendanceBloc(repository: EmployeeAttendanceRepository())..add(FetchEmployeeAttendances()),
      child: Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text('Employee Attendance', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18)),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 1,
        shadowColor: Colors.black12,
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: () {},
          ),
        ],
      ),
      body: BlocBuilder<EmployeeAttendanceBloc, EmployeeAttendanceState>(
        builder: (context, state) {
          if (state is EmployeeAttendanceLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is EmployeeAttendanceError) {
            return Center(child: Text('Error: ${state.message}', style: const TextStyle(color: Colors.red)));
          } else if (state is EmployeeAttendanceLoaded) {
            final summary = state.summary;
            final attendances = state.attendances;

            // Apply selected filters
            final filteredAttendances = attendances.where((record) {
              final name = record.user?.name?.toLowerCase() ?? '';
              final empCode = record.user?.empId?.toLowerCase() ?? '';
              
              if (_searchQuery.isNotEmpty && 
                  !name.contains(_searchQuery.toLowerCase()) && 
                  !empCode.contains(_searchQuery.toLowerCase())) {
                return false;
              }
              
              if (_selectedStatus != 'All Status' && record.status?.toLowerCase() != _selectedStatus.toLowerCase()) {
                return false;
              }
              return true;
            }).toList();

            return RefreshIndicator(
              onRefresh: () async {
                context.read<EmployeeAttendanceBloc>().add(FetchEmployeeAttendances());
              },
              child: CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildStatsSection(summary),
                        const SizedBox(height: 24),
                        const Text('Attendance Records', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                        const SizedBox(height: 12),
                        _buildSearchBar(),
                        const SizedBox(height: 16),
                        _buildFilters(),
                        const SizedBox(height: 12),
                        Text(
                          'Showing ${filteredAttendances.length} records',
                          style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13, color: Colors.grey[600]),
                        ),
                      ],
                    ),
                  ),
                ),
                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0).copyWith(bottom: 24.0),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        return _buildRecordCardFromModel(filteredAttendances[index]);
                      },
                      childCount: filteredAttendances.length,
                    ),
                  ),
                ),
              ],
              )
            );
          }
          return const SizedBox();
        },
      )
      )
    );
  }

  Widget _buildStatsSection(AttendanceSummaryModel summary) {
    return Column(

      children: [
        Row(
          children: [
            Expanded(child: _buildStatCard('Present', (summary.present ?? 0).toString(), Colors.green, Icons.check_circle_outline)),
            const SizedBox(width: 12),
            Expanded(child: _buildStatCard('Absent', (summary.absent ?? 0).toString(), Colors.red, Icons.cancel_outlined)),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(child: _buildStatCard('Late', (summary.late ?? 0).toString(), Colors.orange, Icons.timer_outlined)),
            const SizedBox(width: 12),
            Expanded(child: _buildStatCard('On Leave', (summary.onLeave ?? 0).toString(), Colors.purple, Icons.beach_access_outlined)),
          ],
        ),
      ],
    );
  }

  Widget _buildStatCard(String title, String value, Color color, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: color, size: 20),
              ),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            title,
            style: TextStyle(
              fontSize: 13,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return TextField(
      controller: _searchController,
      onChanged: (value) {
        setState(() {
          _searchQuery = value;
        });
      },
      decoration: InputDecoration(
        hintText: 'Search employee...',
        hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 14),
        prefixIcon: Icon(Icons.search, color: Colors.grey.shade500),
        suffixIcon: _searchQuery.isNotEmpty 
          ? IconButton(
              icon: const Icon(Icons.clear, size: 20),
              onPressed: () {
                _searchController.clear();
                setState(() {
                  _searchQuery = '';
                });
              },
            )
          : null,
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(20), borderSide: BorderSide(color: Colors.grey.shade300)),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(20), borderSide: BorderSide(color: Colors.grey.shade300)),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(20), borderSide: const BorderSide(color: Colors.indigo)),
      ),
    );
  }

  Widget _buildFilters() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      child: Row(
        children: [
          _buildFilterDropdown(
            value: _selectedMonth,
            items: ['March, 2026', 'February, 2026', 'January, 2026'],
            onChanged: (val) {
              if (val != null) setState(() => _selectedMonth = val);
            },
            icon: Icons.calendar_today_outlined,
          ),
          const SizedBox(width: 8),
          _buildFilterDropdown(
            value: _selectedStatus,
            items: ['All Status', 'Present', 'Absent', 'Late', 'On Leave'],
            onChanged: (val) {
              if (val != null) setState(() => _selectedStatus = val);
            },
            icon: Icons.filter_alt_outlined,
          ),
          const SizedBox(width: 8),
          _buildFilterDropdown(
            value: _selectedBranch,
            items: ['All Branches', 'Main Branch', 'Branch A', 'Branch B'],
            onChanged: (val) {
              if (val != null) setState(() => _selectedBranch = val);
            },
            icon: Icons.business_outlined,
          ),
        ],
      ),
    );
  }

  Widget _buildFilterDropdown({
    required String value,
    required List<String> items,
    required Function(String?) onChanged,
    required IconData icon,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          icon: const Icon(Icons.arrow_drop_down, color: Colors.indigo),
          iconSize: 20,
          elevation: 4,
          style: TextStyle(color: Colors.grey.shade800, fontSize: 13, fontWeight: FontWeight.w500),
          onChanged: onChanged,
          items: items.map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Row(
                children: [
                  Icon(icon, size: 16, color: Colors.grey.shade600),
                  const SizedBox(width: 6),
                  Text(value),
                ],
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildRecordCardFromModel(AttendanceModel record) {
    String name = record.user?.name ?? 'Unknown';
    String empCode = record.user?.empId ?? '—';
    String initial = name.isNotEmpty ? name[0].toUpperCase() : '?';
    
    String dateStr = '—';
    try {
      if (record.date != null) {
        dateStr = DateFormat('dd MMM yyyy').format(DateTime.parse(record.date!));
      }
    } catch (e) {
      dateStr = record.date ?? '—';
    }

    String checkIn = '—';
    if (record.checkIn != null && record.checkIn!.length >= 5) {
      checkIn = record.checkIn!.substring(0, 5);
    }

    String checkOut = '—';
    if (record.checkOut != null && record.checkOut!.length >= 5) {
      checkOut = record.checkOut!.substring(0, 5);
    }

    String workingHrs = '—';
    if (record.workingMinutes != null) {
      workingHrs = '${(record.workingMinutes! / 60).toStringAsFixed(1)}h';
    }

    String status = record.status ?? 'Present';
    String shift = 'General Shift'; 
    String? lateNote = (record.lateMinutes != null && record.lateMinutes! > 0) ? 'Late ${record.lateMinutes}m' : null;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 22,
                  backgroundColor: Colors.indigo.shade50,
                  foregroundColor: Colors.indigo.shade700,
                  child: Text(
                    initial,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Colors.black87),
                      ),
                      const SizedBox(height: 2),
                      Row(
                        children: [
                          Text(
                            empCode,
                            style: TextStyle(color: Colors.grey[600], fontSize: 12, fontWeight: FontWeight.w600),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            width: 4,
                            height: 4,
                            decoration: BoxDecoration(color: Colors.grey.shade400, shape: BoxShape.circle),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            dateStr,
                            style: TextStyle(color: Colors.grey[500], fontSize: 12),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                _buildStatusBadge(status),
              ],
            ),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 14.0),
              child: Divider(height: 1),
            ),
            Row(
              children: [
                Expanded(
                  child: _buildTimeSection('Check In', checkIn, Icons.login, lateNote: lateNote),
                ),
                Container(
                  height: 40,
                  width: 1,
                  color: Colors.grey.shade300,
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                ),
                Expanded(
                  child: _buildTimeSection('Check Out', checkOut, Icons.logout),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.grey.shade100),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Working Hrs', style: TextStyle(color: Colors.grey[500], fontSize: 11)),
                        const SizedBox(height: 4),
                        Text(
                          workingHrs,
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 13,
                            color: status.toLowerCase() == 'absent' ? Colors.red.shade400 : Colors.black87,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Shift', style: TextStyle(color: Colors.grey[500], fontSize: 11)),
                        const SizedBox(height: 4),
                        Text(
                          shift,
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 13,
                            color: status.toLowerCase() == 'absent' ? Colors.grey.shade500 : Colors.black87,
                          ),
                        ),
                      ],
                    ),
                  ),
                  InkWell(
                    onTap: () {},
                    borderRadius: BorderRadius.circular(8),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.indigo.shade50,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: InkWell(
                          onTap: (){
                            Get.to(RequestAttendenceCorrectionScreen(attendanceId: record.id.toString()));
                          },
                          child: Icon(Icons.edit_note_outlined, size: 20, color: Colors.indigo.shade600)),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimeSection(String title, String time, IconData icon, {String? lateNote}) {
    bool isMissing = time == '—';
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 14, color: Colors.grey.shade400),
            const SizedBox(width: 4),
            Text(title, style: TextStyle(color: Colors.grey[500], fontSize: 11)),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          time,
          style: TextStyle(
            fontWeight: isMissing ? FontWeight.normal : FontWeight.w600,
            fontSize: 14,
            color: isMissing ? Colors.grey.shade400 : Colors.black87,
          ),
        ),
        if (lateNote != null)
          Padding(
            padding: const EdgeInsets.only(top: 2.0),
            child: Text(
              lateNote,
              style: TextStyle(
                color: Colors.orange.shade700,
                fontSize: 11,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildStatusBadge(String status) {
    Color bgColor;
    Color textColor;
    switch (status.toLowerCase()) {
      case 'present':
        bgColor = Colors.green.shade50;
        textColor = Colors.green.shade700;
        break;
      case 'absent':
        bgColor = Colors.red.shade50;
        textColor = Colors.red.shade700;
        break;
      case 'late':
        bgColor = Colors.orange.shade50;
        textColor = Colors.orange.shade700;
        break;
      default:
        bgColor = Colors.grey.shade100;
        textColor = Colors.grey.shade700;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        status.toUpperCase(),
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.bold,
          color: textColor,
        ),
      ),
    );
  }
}
