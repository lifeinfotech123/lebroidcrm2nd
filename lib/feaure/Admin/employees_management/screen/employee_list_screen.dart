import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lebroid_crm/feaure/Admin/employees_management/bloc/employee_bloc.dart';
import 'package:lebroid_crm/feaure/Admin/employees_management/bloc/employee_event.dart';
import 'package:lebroid_crm/feaure/Admin/employees_management/bloc/employee_state.dart';
import 'package:lebroid_crm/feaure/Admin/employees_management/data/model/employee_model.dart';
import 'add_employee_screen.dart';
import 'employee_detail_screen.dart';

class EmployeeListScreen extends StatefulWidget {
  const EmployeeListScreen({super.key});

  @override
  State<EmployeeListScreen> createState() => _EmployeeListScreenState();
}

class _EmployeeListScreenState extends State<EmployeeListScreen> {
  String _selectedDepartment = 'All Departments';
  String _selectedStatus = 'All Status';
  String _selectedType = 'All Types';
  String _searchQuery = '';

  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    context.read<EmployeeBloc>().add(LoadEmployeesEvent());
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent * 0.9) {
      context.read<EmployeeBloc>().add(LoadMoreEmployeesEvent());
    }
  }

  List<EmployeeModel> _filterEmployees(List<EmployeeModel> employees) {
    return employees.where((emp) {
      // Search filter
      if (_searchQuery.isNotEmpty) {
        final q = _searchQuery.toLowerCase();
        final matchesSearch = (emp.name?.toLowerCase().contains(q) ?? false) ||
            (emp.email?.toLowerCase().contains(q) ?? false) ||
            (emp.employeeId?.toLowerCase().contains(q) ?? false);
        if (!matchesSearch) return false;
      }

      // Department filter
      if (_selectedDepartment != 'All Departments') {
        if (emp.department?['name'] != _selectedDepartment) return false;
      }

      // Status filter
      if (_selectedStatus != 'All Status') {
        if (emp.status?.toLowerCase() != _selectedStatus.toLowerCase()) return false;
      }

      // Type filter
      if (_selectedType != 'All Types') {
        if (emp.employmentType?.toLowerCase() != _selectedType.toLowerCase()) return false;
      }

      return true;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text('All Employees', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18)),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 1,
        shadowColor: Colors.black12,
        actions: [
          IconButton(
            icon: const Icon(Icons.add, color: Colors.indigo),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const AddEmployeeScreen()),
              ).then((value) {
                if (value == true) {
                  context.read<EmployeeBloc>().add(LoadEmployeesEvent());
                }
              });
            },
          ),
        ],
      ),
      body: BlocConsumer<EmployeeBloc, EmployeeState>(
        listener: (context, state) {
          if (state is EmployeeOperationSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message), backgroundColor: Colors.green),
            );
          } else if (state is EmployeeError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message), backgroundColor: Colors.red),
            );
          }
        },
        builder: (context, state) {
          if (state is EmployeeLoading || state is EmployeeInitial) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is EmployeeLoaded) {
            final allEmployees = state.employees;
            final filtered = _filterEmployees(allEmployees);
            final activeCount = allEmployees.where((e) => e.status?.toLowerCase() == 'active').length;
            final onLeaveCount = allEmployees.where((e) => e.status?.toLowerCase() == 'on_leave').length;
            final terminatedCount = allEmployees.where((e) => e.status?.toLowerCase() == 'terminated').length;

            return CustomScrollView(
              controller: _scrollController,
              slivers: [
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildStatsSection(allEmployees.length, activeCount, onLeaveCount, terminatedCount),
                        const SizedBox(height: 20),
                        _buildSearchBar(),
                        const SizedBox(height: 12),
                        _buildFilters(allEmployees),
                        const SizedBox(height: 8),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 8.0),
                          child: Text(
                            '${filtered.length} Employee(s)',
                            style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15, color: Colors.grey[800]),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                filtered.isEmpty
                    ? const SliverFillRemaining(
                        child: Center(child: Text("No employees found")),
                      )
                    : SliverPadding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        sliver: SliverList(
                          delegate: SliverChildBuilderDelegate(
                            (context, index) {
                              return _buildEmployeeCard(filtered[index]);
                            },
                            childCount: filtered.length,
                          ),
                        ),
                      ),
                if (state.isLoadingMore)
                  const SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 20),
                      child: Center(child: CircularProgressIndicator()),
                    ),
                  ),
                const SliverToBoxAdapter(child: SizedBox(height: 24)),
              ],
            );
          } else if (state is EmployeeError) {
            return Center(child: Text(state.message));
          }
          return const SizedBox();
        },
      ),
    );
  }

  Widget _buildStatsSection(int total, int active, int onLeave, int terminated) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(child: _buildStatCard('Total Employees', total.toString(), Colors.indigo, Icons.group_outlined)),
            const SizedBox(width: 12),
            Expanded(child: _buildStatCard('Active', active.toString(), Colors.green, Icons.check_circle_outline)),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(child: _buildStatCard('On Leave', onLeave.toString(), Colors.orange, Icons.beach_access_outlined)),
            const SizedBox(width: 12),
            Expanded(child: _buildStatCard('Terminated', terminated.toString(), Colors.red, Icons.block_outlined)),
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
      onChanged: (value) {
        setState(() {
          _searchQuery = value;
        });
      },
      decoration: InputDecoration(
        hintText: 'Search name, email, ID...',
        hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 14),
        prefixIcon: Icon(Icons.search, color: Colors.grey.shade500),
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(20), borderSide: BorderSide(color: Colors.grey.shade300)),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(20), borderSide: BorderSide(color: Colors.grey.shade300)),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(20), borderSide: const BorderSide(color: Colors.indigo)),
      ),
    );
  }

  Widget _buildFilters(List<EmployeeModel> employees) {
    // Build unique department names from live data
    final deptNames = employees
        .map((e) => e.department?['name']?.toString())
        .where((n) => n != null && n.isNotEmpty)
        .toSet()
        .toList();
    deptNames.sort();

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      child: Row(
        children: [
          _buildFilterDropdown(
            value: _selectedDepartment,
            items: ['All Departments', ...deptNames.cast<String>()],
            onChanged: (val) {
              if (val != null) setState(() => _selectedDepartment = val);
            },
            icon: Icons.business_outlined,
          ),
          const SizedBox(width: 8),
          _buildFilterDropdown(
            value: _selectedStatus,
            items: ['All Status', 'active', 'inactive', 'on_leave', 'terminated'],
            onChanged: (val) {
              if (val != null) setState(() => _selectedStatus = val);
            },
            icon: Icons.check_circle_outline,
          ),
          const SizedBox(width: 8),
          _buildFilterDropdown(
            value: _selectedType,
            items: ['All Types', 'full-time', 'part-time', 'contract'],
            onChanged: (val) {
              if (val != null) setState(() => _selectedType = val);
            },
            icon: Icons.work_outline,
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
          value: items.contains(value) ? value : items.first,
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

  Widget _buildEmployeeCard(EmployeeModel employee) {
    final joiningFormatted = employee.joiningDate != null
        ? employee.joiningDate!.substring(0, 10)
        : '-';

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
                  radius: 26,
                  backgroundColor: Colors.indigo.shade50,
                  foregroundColor: Colors.indigo.shade700,
                  child: Text(
                    employee.initials,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        employee.name ?? '-',
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.black87),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        employee.email ?? '-',
                        style: TextStyle(color: Colors.grey[600], fontSize: 13),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        employee.employeeId ?? '-',
                        style: TextStyle(color: Colors.grey.shade800, fontWeight: FontWeight.w600, fontSize: 11),
                      ),
                    ),
                    const SizedBox(height: 6),
                    _buildStatusBadge(employee.status ?? 'unknown'),
                  ],
                ),
              ],
            ),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 14.0),
              child: Divider(height: 1),
            ),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Department', style: TextStyle(color: Colors.grey[500], fontSize: 11)),
                      const SizedBox(height: 2),
                      Text(employee.department?['name'] ?? '-', style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 13, color: Colors.black87)),
                      const SizedBox(height: 12),
                      Text('Type', style: TextStyle(color: Colors.grey[500], fontSize: 11)),
                      const SizedBox(height: 2),
                      Text(employee.employmentType ?? '-', style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 13, color: Colors.black87)),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Designation', style: TextStyle(color: Colors.grey[500], fontSize: 11)),
                      const SizedBox(height: 2),
                      Text(employee.designation ?? '-', style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 13, color: Colors.black87)),
                      const SizedBox(height: 12),
                      Text('Joined Date', style: TextStyle(color: Colors.grey[500], fontSize: 11)),
                      const SizedBox(height: 2),
                      Text(joiningFormatted, style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 13, color: Colors.black87)),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                OutlinedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => AddEmployeeScreen(employee: employee)),
                    ).then((value) {
                      if (value == true) {
                        context.read<EmployeeBloc>().add(LoadEmployeesEvent());
                      }
                    });
                  },
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    minimumSize: const Size(0, 32),
                    side: BorderSide(color: Colors.indigo.shade300),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  child: Text('Edit', style: TextStyle(fontSize: 12, color: Colors.indigo.shade600, fontWeight: FontWeight.bold)),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => EmployeeDetailScreen(employeeId: employee.id)),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.indigo,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    minimumSize: const Size(0, 32),
                    elevation: 0,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  child: const Text('View Profile', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.delete_outline, color: Colors.red, size: 22),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  onPressed: () {
                    _showDeleteConfirm(context, employee);
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showDeleteConfirm(BuildContext context, EmployeeModel employee) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Delete Employee"),
        content: Text("Are you sure you want to delete '${employee.name}'?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () {
              Navigator.pop(ctx);
              context.read<EmployeeBloc>().add(DeleteEmployeeEvent(employee.id));
            },
            child: const Text("Delete", style: TextStyle(color: Colors.white)),
          )
        ],
      ),
    );
  }

  Widget _buildStatusBadge(String status) {
    bool isActive = status.toLowerCase() == 'active';
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: isActive ? Colors.green.shade50 : Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        status.toUpperCase(),
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.bold,
          color: isActive ? Colors.green.shade700 : Colors.grey.shade700,
        ),
      ),
    );
  }
}
