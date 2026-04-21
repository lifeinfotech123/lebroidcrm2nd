import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:lebroid_crm/feaure/Admin/payroll/bloc/salary_bloc.dart';
import 'package:lebroid_crm/feaure/Admin/payroll/bloc/salary_event.dart';
import 'package:lebroid_crm/feaure/Admin/payroll/bloc/salary_state.dart';
import 'package:lebroid_crm/feaure/Admin/payroll/data/model/salary_model.dart';
import 'package:lebroid_crm/feaure/Admin/payroll/screen/salary_stucture_screen.dart';
import 'package:lebroid_crm/feaure/auth/data/services/permission_service.dart';

class SalaryManagementScreen extends StatefulWidget {
  const SalaryManagementScreen({super.key});

  @override
  State<SalaryManagementScreen> createState() => _SalaryManagementScreenState();
}

class _SalaryManagementScreenState extends State<SalaryManagementScreen> {
  final currencyFormat = NumberFormat.currency(locale: 'en_IN', symbol: '₹');
  String _searchQuery = '';
  List<String> _permissions = [];

  @override
  void initState() {
    super.initState();
    _loadPermissions();
    context.read<SalaryBloc>().add(FetchSalaryOverview());
  }

  Future<void> _loadPermissions() async {
    final permissions = await PermissionService.getPermissions();
    if (mounted) {
      setState(() {
        _permissions = permissions;
      });
    }
  }

  bool _hasPermission(String name) {
    return PermissionService.hasPermission(_permissions, name);
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 1,
      child: Scaffold(
        backgroundColor: const Color(0xFFF8FAFC),
        appBar: AppBar(
          title: const Text('Salary Management'),
          backgroundColor: Colors.white,
          foregroundColor: Colors.black87,
          elevation: 0,
          centerTitle: false,
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(48),
            child: Container(
              decoration: BoxDecoration(
                border: Border(bottom: BorderSide(color: Colors.grey.shade100, width: 1)),
              ),
              child: const Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  child: TabBar(
                    isScrollable: true,
                    labelColor: Colors.indigo,
                    unselectedLabelColor: Colors.grey,
                    indicatorColor: Colors.indigo,
                    indicatorWeight: 3,
                    labelStyle: TextStyle(fontWeight: FontWeight.bold),
                    tabs: [
                      Tab(text: 'Payroll Salary'),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
        body: BlocBuilder<SalaryBloc, SalaryState>(
          builder: (context, state) {
            if (state is SalaryOverviewLoading) {
              return const Center(child: CircularProgressIndicator(color: Colors.indigo));
            }
            if (state is SalaryOverviewError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.error_outline, size: 48, color: Colors.red.shade300),
                    const SizedBox(height: 12),
                    Text('Failed to load salary data', style: TextStyle(color: Colors.grey.shade700, fontSize: 16)),
                    const SizedBox(height: 4),
                    Text(state.message, style: TextStyle(fontSize: 12, color: Colors.grey.shade500), textAlign: TextAlign.center),
                    const SizedBox(height: 16),
                    ElevatedButton.icon(
                      onPressed: () => context.read<SalaryBloc>().add(FetchSalaryOverview()),
                      icon: const Icon(Icons.refresh),
                      label: const Text('Retry'),
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.indigo, foregroundColor: Colors.white),
                    ),
                  ],
                ),
              );
            }
            if (state is SalaryOverviewLoaded) {
              return _buildLoadedView(state.overview);
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }

  Widget _buildLoadedView(SalaryOverviewModel overview) {
    final filteredEmployees = overview.employees.where((emp) {
      if (_searchQuery.isEmpty) return true;
      final q = _searchQuery.toLowerCase();
      return emp.name.toLowerCase().contains(q) ||
          (emp.empCode?.toLowerCase().contains(q) ?? false) ||
          (emp.department?.toLowerCase().contains(q) ?? false);
    }).toList();

    final salarySetCount = overview.employees.where((e) => e.grossSalary > 0).length;
    final noSalaryCount = overview.employees.where((e) => e.grossSalary == 0).length;

    return RefreshIndicator(
      color: Colors.indigo,
      onRefresh: () async {
        context.read<SalaryBloc>().add(FetchSalaryOverview());
      },
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GridView.count(
              shrinkWrap: true,
              crossAxisCount: MediaQuery.of(context).size.width > 800 ? 4 : 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 1.6,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                _buildStatCard('Employees', '${overview.totalEmployees}', Icons.people_rounded, Colors.indigo),
                _buildStatCard('Salary Set', '$salarySetCount', Icons.check_circle_rounded, Colors.teal),
                _buildStatCard('No Salary', '$noSalaryCount', Icons.error_rounded, Colors.orange),
                _buildStatCard('Monthly Cost', currencyFormat.format(overview.totals.net), Icons.account_balance_wallet_rounded, Colors.purple),
              ],
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    onChanged: (val) => setState(() => _searchQuery = val),
                    decoration: InputDecoration(
                      hintText: 'Search employee...',
                      prefixIcon: const Icon(Icons.search, color: Colors.indigo),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      fillColor: Colors.white,
                      filled: true,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.filter_list_rounded, color: Colors.indigo),
                    onPressed: () {},
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Employee Salaries (${filteredEmployees.length})',
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87),
                ),
                TextButton(
                  onPressed: () {},
                  child: const Text('View All'),
                ),
              ],
            ),
            const SizedBox(height: 8),
            ...filteredEmployees.map((emp) => _buildEmployeeCard(emp)),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
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
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  value,
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87),
                ),
              ),
              Text(
                title,
                style: TextStyle(fontSize: 12, color: Colors.grey.shade600, fontWeight: FontWeight.w500),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEmployeeCard(SalaryEmployeeModel emp) {
    return GestureDetector(
      onTap: () async {
        if (_hasPermission('salary.view') || _hasPermission('salary.viewOwn')) {
          await Get.to(() => SalaryStuctureScreen(
                employeeId: emp.employeeId,
                employeeName: emp.name,
                empCode: emp.empCode,
                department: emp.department,
                branch: emp.branch,
                basicSalary: emp.basicSalary,
                grossSalary: emp.grossSalary,
                netSalary: emp.netSalary,
                salaryType: emp.salaryType,
              ));
          if (mounted) {
            context.read<SalaryBloc>().add(FetchSalaryOverview());
          }
        } else {
          Get.snackbar("Access Denied", "You don't have permission to view salary details.",
              backgroundColor: Colors.orange, colorText: Colors.white);
        }
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 10,
              offset: const Offset(0, 2),
            )
          ],
        ),
        child: Column(
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 24,
                  backgroundColor: Colors.indigo.shade50,
                  child: Text(
                    emp.initials,
                    style: TextStyle(color: Colors.indigo.shade700, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        emp.name,
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      Text(
                        "${emp.empCode ?? 'N/A'} • ${emp.department ?? 'N/A'}",
                        style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                      ),
                    ],
                  ),
                ),
                if (_hasPermission('salary.update'))
                  IconButton(
                    icon: const Icon(Icons.edit_note_rounded, color: Colors.indigo),
                    onPressed: () async {
                      await Get.to(() => SalaryStuctureScreen(
                            employeeId: emp.employeeId,
                            employeeName: emp.name,
                            empCode: emp.empCode,
                            department: emp.department,
                            branch: emp.branch,
                            basicSalary: emp.basicSalary,
                            grossSalary: emp.grossSalary,
                            netSalary: emp.netSalary,
                            salaryType: emp.salaryType,
                          ));
                      if (mounted) {
                        context.read<SalaryBloc>().add(FetchSalaryOverview());
                      }
                    },
                    style: IconButton.styleFrom(
                      backgroundColor: Colors.indigo.shade50,
                      padding: const EdgeInsets.all(8),
                    ),
                  ),
              ],
            ),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 12.0),
              child: Divider(height: 1),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildSalaryInfo('Basic', currencyFormat.format(emp.basicSalary)),
                _buildSalaryInfo('Gross', currencyFormat.format(emp.grossSalary)),
                _buildSalaryInfo('Net Pay', currencyFormat.format(emp.netSalary)),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                if (emp.branch != null) ...[
                  Icon(Icons.location_on_rounded, size: 14, color: Colors.grey.shade500),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      emp.branch!,
                      style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: emp.salaryType == 'monthly'
                        ? Colors.green.shade50
                        : Colors.blue.shade50,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    emp.salaryType.capitalizeFirst ?? emp.salaryType,
                    style: TextStyle(
                      color: emp.salaryType == 'monthly'
                          ? Colors.green.shade700
                          : Colors.blue.shade700,
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSalaryInfo(String label, String amount) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(fontSize: 11, color: Colors.grey.shade500, fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 2),
        Text(
          amount,
          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.black87),
        ),
      ],
    );
  }
}
