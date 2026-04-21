import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../bloc/mark_attendance/mark_attendance_bloc.dart';
import '../bloc/mark_attendance/mark_attendance_event.dart';
import '../bloc/mark_attendance/mark_attendance_state.dart';
import '../data/repository/employee_attendance_repository.dart';
import '../../employees_management/data/repository/employee_repository.dart';
import '../../employees_management/data/model/employee_model.dart';
import '../data/model/manual_attendance_model.dart';

class MarkAttendanceScreen extends StatefulWidget {
  const MarkAttendanceScreen({super.key});

  @override
  State<MarkAttendanceScreen> createState() => _MarkAttendanceScreenState();
}

class _MarkAttendanceScreenState extends State<MarkAttendanceScreen> {
  final _dateController = TextEditingController();
  final _checkInController = TextEditingController();
  final _checkOutController = TextEditingController();
  final _notesController = TextEditingController();

  EmployeeModel? _selectedEmployee;
  ShiftModel? _selectedShift;
  String _selectedStatus = 'Present';

  @override
  void initState() {
    super.initState();
    _dateController.text = DateFormat('yyyy-MM-dd').format(DateTime.now());
  }

  @override
  void dispose() {
    _dateController.dispose();
    _checkInController.dispose();
    _checkOutController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() {
        _dateController.text = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }

  Future<void> _selectTime(BuildContext context, TextEditingController controller) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      final now = DateTime.now();
      final dt = DateTime(now.year, now.month, now.day, picked.hour, picked.minute);
      setState(() {
        controller.text = DateFormat('HH:mm').format(dt);
      });
    }
  }

  void _showEmployeeSelection(List<EmployeeModel> employees) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(16),
          height: MediaQuery.of(context).size.height * 0.7,
          child: Column(
            children: [
              const Text('Select Employee', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
              const SizedBox(height: 16),
              Expanded(
                child: ListView.builder(
                  itemCount: employees.length,
                  itemBuilder: (context, index) {
                    final employee = employees[index];
                    return ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Colors.indigo.shade50,
                        child: Text(employee.initials),
                      ),
                      title: Text(employee.name ?? 'No Name'),
                      subtitle: Text(employee.employeeId ?? ''),
                      onTap: () {
                        setState(() {
                          _selectedEmployee = employee;
                        });
                        Navigator.pop(context);
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => MarkAttendanceBloc(
        attendanceRepository: EmployeeAttendanceRepository(),
        employeeRepository: EmployeeRepository(),
      )..add(FetchMarkAttendanceInitialData()),
      child: BlocListener<MarkAttendanceBloc, MarkAttendanceState>(
        listener: (context, state) {
          if (state is MarkAttendanceSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message), backgroundColor: Colors.green),
            );
          } else if (state is MarkAttendanceError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message), backgroundColor: Colors.red),
            );
          }
        },
        child: BlocBuilder<MarkAttendanceBloc, MarkAttendanceState>(
          builder: (context, state) {
            final isLoading = state is MarkAttendanceLoading || state is MarkAttendanceSubmitting;
            List<EmployeeModel> employees = [];
            List<ShiftModel> shifts = [];

            if (state is MarkAttendanceDataLoaded) {
              employees = state.employees;
              shifts = state.shifts;
              if (_selectedShift == null && shifts.isNotEmpty) {
                _selectedShift = shifts.first;
              }
            }

            return Scaffold(
              backgroundColor: Colors.grey[50],
              appBar: AppBar(
                title: const Text('Mark Attendance', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18)),
                backgroundColor: Colors.white,
                foregroundColor: Colors.black,
                elevation: 1,
                shadowColor: Colors.black12,
              ),
              body: isLoading && state is MarkAttendanceLoading
                  ? const Center(child: CircularProgressIndicator())
                  : SingleChildScrollView(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          _buildSelectEmployeeDateCard(employees),
                          const SizedBox(height: 16),
                          _buildAttendanceStatusCard(),
                          const SizedBox(height: 16),
                          _buildManualOverrideCard(shifts, context),
                          const SizedBox(height: 32),
                        ],
                      ),
                    ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildCardHeader(IconData icon, String title, {Widget? trailing}) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.indigo[400]),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.black87),
            ),
          ),
          if (trailing != null) trailing,
        ],
      ),
    );
  }

  Widget _buildSelectEmployeeDateCard(List<EmployeeModel> employees) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildCardHeader(Icons.people_alt_outlined, 'Select Employee & Date'),
          const Divider(height: 1),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: LayoutBuilder(
              builder: (context, constraints) {
                bool isMobile = constraints.maxWidth < 600;
                if (isMobile) {
                  return Column(
                    children: [
                      _buildComplexField(
                        'EMPLOYEE',
                        _selectedEmployee?.name ?? 'Select Employee',
                        Icons.person_outline,
                        onTap: () => _showEmployeeSelection(employees),
                      ),
                      const SizedBox(height: 16),
                      _buildComplexField(
                        'DATE',
                        _dateController.text,
                        Icons.calendar_today_outlined,
                        suffixIcon: Icons.calendar_month,
                        onTap: () => _selectDate(context),
                      ),
                    ],
                  );
                }
                return Row(
                  children: [
                    Expanded(
                      flex: 3,
                      child: _buildComplexField(
                        'EMPLOYEE',
                        _selectedEmployee?.name ?? 'Select Employee',
                        Icons.person_outline,
                        onTap: () => _showEmployeeSelection(employees),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      flex: 2,
                      child: _buildComplexField(
                        'DATE',
                        _dateController.text,
                        Icons.calendar_today_outlined,
                        suffixIcon: Icons.calendar_month,
                        onTap: () => _selectDate(context),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAttendanceStatusCard() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildCardHeader(Icons.access_time, 'Attendance Status — ${_dateController.text}'),
          const Divider(height: 1),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 40.0, horizontal: 16.0),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.person_off_outlined, size: 32, color: Colors.grey.shade400),
                ),
                const SizedBox(height: 16),
                const Text('No Attendance Record', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                const SizedBox(height: 4),
                Text('No record found for ${_dateController.text}.', style: TextStyle(color: Colors.grey.shade500, fontSize: 13)),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: ElevatedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.login_outlined, size: 18),
                label: Text('CHECK IN NOW — ${DateFormat('hh:mm a').format(DateTime.now())}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2ECA75),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                  elevation: 0,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildManualOverrideCard(List<ShiftModel> shifts, BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildCardHeader(
            Icons.edit_outlined,
            'Manual Override',
            trailing: Text(
              'Overwrites existing record for the selected date.',
              style: TextStyle(fontSize: 11, color: Colors.grey.shade500),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const Divider(height: 1),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: LayoutBuilder(
              builder: (context, constraints) {
                bool isMobile = constraints.maxWidth < 600;
                if (isMobile) {
                  return Column(
                    children: [
                      _buildComplexField(
                        'CHECK IN TIME',
                        _checkInController.text.isEmpty ? '--:--' : _checkInController.text,
                        Icons.login_outlined,
                        suffixIcon: Icons.access_time,
                        onTap: () => _selectTime(context, _checkInController),
                      ),
                      const SizedBox(height: 16),
                      _buildComplexField(
                        'CHECK OUT TIME',
                        _checkOutController.text.isEmpty ? '--:--' : _checkOutController.text,
                        Icons.logout_outlined,
                        suffixIcon: Icons.access_time,
                        onTap: () => _selectTime(context, _checkOutController),
                      ),
                      const SizedBox(height: 16),
                      _buildComplexField(
                        'SHIFT',
                        _selectedShift?.name ?? '— No Shift —',
                        Icons.wb_sunny_outlined,
                        isDropdown: true,
                        dropdownItems: shifts.map((e) => e.name).toList(),
                        onChanged: (val) {
                          setState(() {
                            _selectedShift = shifts.firstWhere((e) => e.name == val);
                          });
                        },
                      ),
                      const SizedBox(height: 16),
                      _buildComplexField(
                        'STATUS *',
                        _selectedStatus,
                        Icons.local_offer_outlined,
                        isDropdown: true,
                        dropdownItems: ['Present', 'Absent', 'Late', 'On Leave'],
                        onChanged: (val) {
                          setState(() {
                            _selectedStatus = val!;
                          });
                        },
                      ),
                      const SizedBox(height: 16),
                      _buildComplexField(
                        'NOTES',
                        'Optional notes...',
                        Icons.description_outlined,
                        controller: _notesController,
                        readOnly: false,
                      ),
                    ],
                  );
                }
                return Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                            child: _buildComplexField(
                          'CHECK IN TIME',
                          _checkInController.text.isEmpty ? '--:--' : _checkInController.text,
                          Icons.login_outlined,
                          suffixIcon: Icons.access_time,
                          onTap: () => _selectTime(context, _checkInController),
                        )),
                        const SizedBox(width: 16),
                        Expanded(
                            child: _buildComplexField(
                          'CHECK OUT TIME',
                          _checkOutController.text.isEmpty ? '--:--' : _checkOutController.text,
                          Icons.logout_outlined,
                          suffixIcon: Icons.access_time,
                          onTap: () => _selectTime(context, _checkOutController),
                        )),
                        const SizedBox(width: 16),
                        Expanded(
                            child: _buildComplexField(
                          'SHIFT',
                          _selectedShift?.name ?? '— No Shift —',
                          Icons.wb_sunny_outlined,
                          isDropdown: true,
                          dropdownItems: shifts.map((e) => e.name).toList(),
                          onChanged: (val) {
                            setState(() {
                              _selectedShift = shifts.firstWhere((e) => e.name == val);
                            });
                          },
                        )),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                            child: _buildComplexField(
                          'STATUS *',
                          _selectedStatus,
                          Icons.local_offer_outlined,
                          isDropdown: true,
                          dropdownItems: ['Present', 'Absent', 'Late', 'On Leave'],
                          onChanged: (val) {
                            setState(() {
                              _selectedStatus = val!;
                            });
                          },
                        )),
                        const SizedBox(width: 16),
                        Expanded(
                            flex: 2,
                            child: _buildComplexField(
                              'NOTES',
                              'Optional notes...',
                              Icons.description_outlined,
                              controller: _notesController,
                              readOnly: false,
                            )),
                      ],
                    ),
                  ],
                );
              },
            ),
          ),
          const Divider(height: 1),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Builder(builder: (context) {
                  final blocState = context.watch<MarkAttendanceBloc>().state;
                  final isSubmitting = blocState is MarkAttendanceSubmitting;

                  return ElevatedButton.icon(
                    onPressed: isSubmitting
                        ? null
                        : () {
                            if (_selectedEmployee == null) {
                              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please select an employee')));
                              return;
                            }
                            if (_checkInController.text.isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please select check-in time')));
                              return;
                            }
                            if (_checkOutController.text.isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please select check-out time')));
                              return;
                            }

                            context.read<MarkAttendanceBloc>().add(SubmitManualAttendance(
                                  userId: _selectedEmployee!.id,
                                  date: _dateController.text,
                                  checkIn: _checkInController.text,
                                  checkOut: _checkOutController.text,
                                  status: _selectedStatus.toLowerCase(),
                                  reason: _notesController.text,
                                  shiftId: _selectedShift?.id ?? 1,
                                ));
                          },
                    icon: isSubmitting ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white)) : const Icon(Icons.save_outlined, size: 16),
                    label: Text(isSubmitting ? 'SAVING...' : 'SAVE ATTENDANCE', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.indigo[600],
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                      elevation: 0,
                    ),
                  );
                }),
                Row(
                  children: [
                    Icon(Icons.info_outline, size: 14, color: Colors.grey.shade500),
                    const SizedBox(width: 6),
                    Text(
                      'All changes are audit logged.',
                      style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildComplexField(
    String label,
    String hint,
    IconData prefixIcon, {
    bool isDropdown = false,
    IconData? suffixIcon,
    VoidCallback? onTap,
    List<String>? dropdownItems,
    Function(String?)? onChanged,
    TextEditingController? controller,
    bool readOnly = true,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.grey[500], letterSpacing: 0.5),
        ),
        const SizedBox(height: 6),
        InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(6),
          child: Container(
            height: 48,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(6),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: Row(
              children: [
                Container(
                  width: 46,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade50,
                    borderRadius: const BorderRadius.horizontal(left: Radius.circular(5)),
                    border: Border(right: BorderSide(color: Colors.grey.shade200)),
                  ),
                  child: Center(
                    child: Icon(prefixIcon, size: 18, color: Colors.indigo.shade300),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0),
                    child: isDropdown
                        ? DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              isExpanded: true,
                              icon: Icon(Icons.keyboard_arrow_down, color: Colors.grey.shade400, size: 20),
                              value: dropdownItems?.contains(hint) == true ? hint : null,
                              hint: Text(hint, style: TextStyle(fontSize: 13, color: Colors.grey.shade800, fontWeight: FontWeight.w500)),
                              style: TextStyle(fontSize: 13, color: Colors.grey.shade800, fontWeight: FontWeight.w500),
                              items: dropdownItems?.map((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                              onChanged: onChanged,
                            ),
                          )
                        : TextField(
                            controller: controller,
                            readOnly: readOnly,
                            onTap: onTap,
                            decoration: InputDecoration(
                              hintText: hint,
                              hintStyle: TextStyle(fontSize: 13, color: Colors.grey.shade800, fontWeight: FontWeight.w500),
                              border: InputBorder.none,
                              isDense: true,
                              contentPadding: EdgeInsets.zero,
                            ),
                          ),
                  ),
                ),
                if (suffixIcon != null)
                  Padding(
                    padding: const EdgeInsets.only(right: 12.0),
                    child: Icon(suffixIcon, size: 16, color: Colors.grey.shade400),
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
