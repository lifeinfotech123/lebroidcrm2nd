import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import '../bloc/user_attendance/user_attendance_bloc.dart';
import '../bloc/user_attendance/user_attendance_event.dart';
import '../bloc/user_attendance/user_attendance_state.dart';
import '../data/model/calendar_attendance_model.dart';

class CalDay {
  final int date;
  final bool isCurrentMonth;
  final String type; // 'Present', 'Late', 'Absent', 'Leave', 'Holiday', 'Weekend', 'Empty'
  final String? checkIn;
  final String? checkOut;
  final String? hrs;
  final String? subtitle;

  CalDay({
    required this.date,
    this.isCurrentMonth = true,
    this.type = 'Empty',
    this.checkIn,
    this.checkOut,
    this.hrs,
    this.subtitle,
  });

  /// Create CalDay from API CalendarDayModel
  factory CalDay.fromApi(CalendarDayModel model) {
    final attendance = model.attendance;
    String? checkIn;
    String? checkOut;
    String? hrs;
    String? subtitle;

    if (attendance != null) {
      checkIn = attendance.formattedCheckIn;
      checkOut = attendance.formattedCheckOut;
      hrs = attendance.workingHours;

      if (attendance.isLate == true && attendance.lateMinutes != null) {
        subtitle = 'Late ${attendance.lateMinutes}m';
      }
    }

    if (model.holiday != null) {
      subtitle = model.holiday!.name;
    }

    if (model.leave != null) {
      subtitle = model.leave!.leaveType ?? 'On Leave';
    }

    // Use label from API if available and no subtitle set
    if (subtitle == null && model.label != null && model.label!.isNotEmpty) {
      subtitle = model.label;
    }

    return CalDay(
      date: model.day ?? 0,
      isCurrentMonth: model.isThisMonth ?? false,
      type: model.uiType,
      checkIn: checkIn,
      checkOut: checkOut,
      hrs: hrs,
      subtitle: subtitle,
    );
  }
}

class AttendanceCalenderScreen extends StatefulWidget {
  const AttendanceCalenderScreen({super.key});

  @override
  State<AttendanceCalenderScreen> createState() => _AttendanceCalenderScreenState();
}

class _AttendanceCalenderScreenState extends State<AttendanceCalenderScreen> {
  final List<String> weekDays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
  int? _userId;
  String _userName = '';
  String _employeeId = '';

  @override
  void initState() {
    super.initState();
    _loadUserAndFetchCalendar();
  }

  Future<void> _loadUserAndFetchCalendar() async {
    final prefs = await SharedPreferences.getInstance();
    final adminId = prefs.getString('admin_id');
    _userName = prefs.getString('name') ?? 'User';
    _employeeId = prefs.getString('employee_id') ?? '';

    if (adminId != null) {
      _userId = int.tryParse(adminId);
    }

    if (_userId != null && mounted) {
      setState(() {});
      context.read<UserAttendanceBloc>().add(FetchCalendarAttendance(userId: _userId!));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text('Attendance Calendar', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18)),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 1,
        shadowColor: Colors.black12,
        actions: [
          IconButton(icon: const Icon(Icons.print_outlined), onPressed: () {}),
        ],
      ),
      body: BlocBuilder<UserAttendanceBloc, UserAttendanceState>(
        builder: (context, state) {
          if (state is CalendarLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is CalendarError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.error_outline, size: 48, color: Colors.red.shade300),
                    const SizedBox(height: 16),
                    Text(
                      'Failed to load calendar',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.grey.shade800),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      state.message,
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton.icon(
                      onPressed: () {
                        if (_userId != null) {
                          context.read<UserAttendanceBloc>().add(FetchCalendarAttendance(userId: _userId!));
                        }
                      },
                      icon: const Icon(Icons.refresh),
                      label: const Text('Retry'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.indigo,
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }

          if (state is CalendarLoaded) {
            final calendarDays = state.calendarDays.map((m) => CalDay.fromApi(m)).toList();
            final thisMonthDays = state.calendarDays.where((d) => d.isThisMonth == true).toList();

            // Compute stats from the API data
            final stats = _computeStats(thisMonthDays);

            // Get current month/year from first isThisMonth day
            String monthYear = _getMonthYear(thisMonthDays);

            // Get holidays
            final holidays = thisMonthDays
                .where((d) => d.type?.toLowerCase() == 'holiday' && d.holiday != null)
                .toList();

            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _buildEmployeeHeader(monthYear),
                    const SizedBox(height: 16),
                    _buildStatsGrid(stats),
                    const SizedBox(height: 16),
                    _buildCalendarCard(calendarDays),
                    const SizedBox(height: 16),
                    _buildLegendsAndHolidays(holidays, monthYear),
                  ],
                ),
              ),
            );
          }

          // Initial state
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

  Map<String, dynamic> _computeStats(List<CalendarDayModel> days) {
    int present = 0, absent = 0, late = 0, leave = 0, holiday = 0;
    int totalMinutes = 0;
    int workingDays = 0;

    for (final day in days) {
      final type = day.type?.toLowerCase();
      if (type == 'present') {
        present++;
        workingDays++;
      } else if (type == 'late') {
        late++;
        workingDays++;
      } else if (type == 'absent') {
        absent++;
        workingDays++;
      } else if (type == 'leave') {
        leave++;
      } else if (type == 'holiday') {
        holiday++;
      }

      if (day.attendance?.workingMinutes != null) {
        totalMinutes += day.attendance!.workingMinutes!;
      }
    }

    final totalHours = totalMinutes / 60;
    final attendancePct = workingDays > 0
        ? ((present + late) / workingDays * 100)
        : 0.0;

    return {
      'present': present,
      'absent': absent,
      'late': late,
      'leave': leave,
      'holiday': holiday,
      'totalHours': totalHours.toStringAsFixed(1),
      'attendancePct': attendancePct.toStringAsFixed(1),
    };
  }

  String _getMonthYear(List<CalendarDayModel> thisMonthDays) {
    if (thisMonthDays.isEmpty) return DateFormat('MMMM yyyy').format(DateTime.now());
    try {
      final dateStr = thisMonthDays.first.dateStr;
      if (dateStr != null) {
        final parsed = DateTime.parse(dateStr);
        return DateFormat('MMMM yyyy').format(parsed);
      }
    } catch (_) {}
    return DateFormat('MMMM yyyy').format(DateTime.now());
  }

  Widget _buildEmployeeHeader(String monthYear) {
    final initials = _userName.isNotEmpty
        ? _userName.split(' ').map((w) => w.isNotEmpty ? w[0] : '').take(2).join().toUpperCase()
        : 'U';

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
            radius: 28,
            backgroundColor: Colors.indigo.shade50,
            foregroundColor: Colors.indigo.shade700,
            child: Text(initials, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _userName,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.black87),
                ),
                const SizedBox(height: 4),
                Text(
                  '${_employeeId.isNotEmpty ? "$_employeeId · " : ""}$monthYear',
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 13, fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsGrid(Map<String, dynamic> stats) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(child: _buildSmallStatCard('Present', stats['present'].toString(), Colors.green, Icons.check_circle_outline)),
            const SizedBox(width: 12),
            Expanded(child: _buildSmallStatCard('Absent', stats['absent'].toString(), Colors.red, Icons.cancel_outlined)),
            const SizedBox(width: 12),
            Expanded(child: _buildSmallStatCard('Late', stats['late'].toString(), Colors.orange, Icons.timer_outlined)),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(child: _buildSmallStatCard('Leave', stats['leave'].toString(), Colors.purple, Icons.beach_access_outlined)),
            const SizedBox(width: 12),
            Expanded(child: _buildSmallStatCard('Holiday', stats['holiday'].toString(), Colors.blue, Icons.celebration_outlined)),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildLargeStatCard('Attendance', '${stats['attendancePct']}%', Colors.teal, Icons.pie_chart_outline),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildLargeStatCard('Total Hours', '${stats['totalHours']}h', Colors.indigo, Icons.av_timer_outlined),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSmallStatCard(String title, String value, Color color, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(color: color.withOpacity(0.1), shape: BoxShape.circle),
            child: Icon(icon, color: color, size: 16),
          ),
          const SizedBox(height: 8),
          Text(value, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 2),
          Text(title, style: TextStyle(fontSize: 11, color: Colors.grey.shade600, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }

  Widget _buildLargeStatCard(String title, String value, Color color, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(10)),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(value, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                const SizedBox(height: 2),
                Text(title, style: TextStyle(fontSize: 13, color: Colors.grey.shade600, fontWeight: FontWeight.w500)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCalendarCard(List<CalDay> calendarDays) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10, offset: const Offset(0, 4)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: weekDays.map((day) {
                bool isWeekend = day == 'Sat' || day == 'Sun';
                return Expanded(
                  child: Center(
                    child: Text(
                      day,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                        color: isWeekend ? Colors.red.shade400 : Colors.grey.shade700,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          const Divider(height: 1),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: calendarDays.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 7,
              childAspectRatio: 0.55,
            ),
            itemBuilder: (context, index) {
              return _buildCalendarCell(calendarDays[index]);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildCalendarCell(CalDay day) {
    if (!day.isCurrentMonth) {
      return Container(
        decoration: BoxDecoration(
          color: Colors.grey.shade50,
          border: Border.all(color: Colors.grey.shade100, width: 0.5),
        ),
        child: Padding(
          padding: const EdgeInsets.all(4.0),
          child: Text(
            day.date.toString(),
            style: TextStyle(color: Colors.grey.shade400, fontSize: 12, fontWeight: FontWeight.bold),
          ),
        ),
      );
    }

    Color bgColor = Colors.white;
    Color topIconColor = Colors.transparent;
    IconData? topIcon;
    bool showEmpty = day.type == 'Empty';

    if (day.type == 'Weekend') bgColor = Colors.grey.shade50;
    if (day.type == 'Present') {
      topIcon = Icons.check_circle;
      topIconColor = Colors.green;
    } else if (day.type == 'Late') {
      topIcon = Icons.access_time_filled;
      topIconColor = Colors.orange;
    } else if (day.type == 'Absent') {
      topIcon = Icons.cancel;
      topIconColor = Colors.red;
    } else if (day.type == 'Holiday') {
      topIcon = Icons.celebration;
      topIconColor = Colors.purple;
      bgColor = Colors.purple.shade50.withOpacity(0.5);
    } else if (day.type == 'Leave') {
      topIcon = Icons.beach_access;
      topIconColor = Colors.blue;
      bgColor = Colors.blue.shade50.withOpacity(0.5);
    }

    return Container(
      decoration: BoxDecoration(
        color: bgColor,
        border: Border.all(color: Colors.grey.shade200, width: 0.5),
      ),
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  day.date.toString(),
                  style: TextStyle(
                    color: day.type == 'Weekend' ? Colors.red.shade400 : Colors.black87,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (topIcon != null) Icon(topIcon, size: 12, color: topIconColor),
              ],
            ),
            const SizedBox(height: 4),
            if (!showEmpty && day.type != 'Weekend' && day.type != 'Holiday' && day.type != 'Absent' && day.type != 'Leave') ...[
              if (day.checkIn != null) _buildTimeRow(day.checkIn!, isLate: day.type == 'Late'),
              if (day.checkOut != null) _buildTimeRow(day.checkOut!),
              const SizedBox(height: 2),
              if (day.hrs != null) _buildBadge(day.hrs!, Colors.indigo),
              if (day.subtitle != null && day.type == 'Late')
                Padding(
                  padding: const EdgeInsets.only(top: 2.0),
                  child: Text(day.subtitle!, style: TextStyle(fontSize: 8, fontWeight: FontWeight.bold, color: Colors.orange.shade700)),
                ),
            ],
            if (day.type == 'Absent') ...[
              const Center(child: Padding(padding: EdgeInsets.only(top: 8.0), child: Text('Absent', style: TextStyle(color: Colors.red, fontSize: 9, fontWeight: FontWeight.bold)))),
              if (day.subtitle != null) Center(child: Text(day.subtitle!, style: TextStyle(color: Colors.red.shade300, fontSize: 8))),
            ],
            if (day.type == 'Holiday') ...[
              if (day.subtitle != null) Center(child: Padding(padding: EdgeInsets.only(top: 8.0), child: Text(day.subtitle!, textAlign: TextAlign.center, style: TextStyle(color: Colors.purple.shade700, fontSize: 9, fontWeight: FontWeight.bold)))),
            ],
            if (day.type == 'Leave') ...[
              Center(child: Padding(padding: EdgeInsets.only(top: 8.0), child: Text(day.subtitle ?? 'Leave', textAlign: TextAlign.center, style: TextStyle(color: Colors.blue.shade700, fontSize: 9, fontWeight: FontWeight.bold)))),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildTimeRow(String time, {bool isLate = false}) {
    return Text(
      time,
      style: TextStyle(
        fontSize: 9,
        fontWeight: FontWeight.w600,
        color: isLate ? Colors.orange.shade700 : Colors.grey.shade700,
      ),
    );
  }

  Widget _buildBadge(String text, MaterialColor color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
      decoration: BoxDecoration(
        color: color.shade50,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        text,
        style: TextStyle(fontSize: 8, fontWeight: FontWeight.bold, color: color.shade700),
      ),
    );
  }

  Widget _buildLegendsAndHolidays(List<CalendarDayModel> holidays, String monthYear) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text('Legend', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          ),
          const Divider(height: 1),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                _buildLegendItem(Icons.check_circle, Colors.green, 'Present'),
                _buildLegendItem(Icons.access_time_filled, Colors.orange, 'Late'),
                _buildLegendItem(Icons.cancel, Colors.red, 'Absent'),
                _buildLegendItem(Icons.beach_access, Colors.blue, 'On Leave'),
                _buildLegendItem(Icons.celebration, Colors.purple, 'Holiday'),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            color: Colors.grey.shade50,
            child: Text('Holidays in $monthYear', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
          ),
          const Divider(height: 1),
          if (holidays.isEmpty)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'No holidays this month',
                style: TextStyle(color: Colors.grey.shade500, fontSize: 13),
              ),
            ),
          ...holidays.map((h) {
            String dateDisplay = '';
            if (h.dateStr != null) {
              try {
                final parsed = DateTime.parse(h.dateStr!);
                dateDisplay = DateFormat('EEEE, dd MMM yyyy').format(parsed);
              } catch (_) {
                dateDisplay = h.dateStr!;
              }
            }
            return ListTile(
              leading: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(color: Colors.purple.shade50, shape: BoxShape.circle),
                child: Icon(Icons.celebration, color: Colors.purple.shade400, size: 20),
              ),
              title: Text(h.holiday?.name ?? 'Holiday', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
              subtitle: Text(
                '$dateDisplay${h.holiday?.type != null ? " · ${h.holiday!.type}" : ""}',
                style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildLegendItem(IconData icon, Color color, String label) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 16, color: color),
        const SizedBox(width: 6),
        Text(label, style: TextStyle(fontSize: 13, color: Colors.grey.shade700, fontWeight: FontWeight.w500)),
      ],
    );
  }
}
