import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lebroid_crm/feaure/Admin/employees_management/bloc/employee_bloc.dart';
import 'package:lebroid_crm/feaure/Admin/employees_management/bloc/employee_event.dart';
import 'package:lebroid_crm/feaure/Admin/employees_management/bloc/employee_state.dart';

class EmployeeDetailScreen extends StatefulWidget {
  final int employeeId;

  const EmployeeDetailScreen({super.key, required this.employeeId});

  @override
  State<EmployeeDetailScreen> createState() => _EmployeeDetailScreenState();
}

class _EmployeeDetailScreenState extends State<EmployeeDetailScreen> {
  @override
  void initState() {
    super.initState();
    context.read<EmployeeBloc>().add(FetchSingleEmployeeEvent(widget.employeeId));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: const Text('Employee Profile'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 1,
      ),
      body: BlocBuilder<EmployeeBloc, EmployeeState>(
        builder: (context, state) {
          if (state is EmployeeLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is SingleEmployeeLoaded) {
            final emp = state.employee;
            final isActive = emp.status?.toLowerCase() == 'active';

            return SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// ================= PROFILE HEADER =================
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        )
                      ],
                    ),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 36,
                          backgroundColor: Colors.indigo.shade50,
                          child: Text(
                            emp.initials,
                            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.indigo.shade700),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(emp.name ?? 'N/A', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                              const SizedBox(height: 4),
                              Text(emp.designation ?? '-', style: TextStyle(fontSize: 14, color: Colors.grey.shade600)),
                              const SizedBox(height: 4),
                              Text(emp.employeeId ?? '-', style: TextStyle(fontSize: 13, color: Colors.grey.shade500)),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: isActive ? Colors.green.shade50 : Colors.red.shade50,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            (emp.status ?? 'unknown').toUpperCase(),
                            style: TextStyle(
                              color: isActive ? Colors.green : Colors.red,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  /// ================= PERSONAL INFO =================
                  const Text("Personal Information", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  const SizedBox(height: 12),
                  _buildInfoRow(Icons.email, "Email", emp.email ?? "-"),
                  _buildInfoRow(Icons.phone, "Phone", emp.phone ?? "-"),
                  _buildInfoRow(Icons.person, "Gender", emp.gender ?? "-"),
                  _buildInfoRow(Icons.cake, "Date of Birth", emp.dateOfBirth ?? "-"),
                  _buildInfoRow(Icons.location_on, "Address", emp.address ?? "-"),

                  const SizedBox(height: 24),

                  /// ================= EMPLOYMENT INFO =================
                  const Text("Employment Details", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  const SizedBox(height: 12),
                  _buildInfoRow(Icons.business, "Department", emp.department?['name'] ?? "-"),
                  _buildInfoRow(Icons.location_city, "Branch", emp.branch?['name'] ?? "-"),
                  _buildInfoRow(Icons.work, "Employment Type", emp.employmentType ?? "-"),
                  _buildInfoRow(Icons.calendar_today, "Joining Date", emp.joiningDate?.substring(0, 10) ?? "-"),

                  const SizedBox(height: 24),

                  /// ================= ROLES =================
                  if (emp.roles != null && emp.roles!.isNotEmpty) ...[
                    const Text("Roles", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: emp.roles!.map((role) {
                        final roleName = role is Map ? role['name'] ?? 'Unknown' : role.toString();
                        return Chip(
                          label: Text(roleName.toString().toUpperCase(), style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                          backgroundColor: Colors.indigo.shade50,
                          labelStyle: TextStyle(color: Colors.indigo.shade700),
                        );
                      }).toList(),
                    ),
                  ],

                  const SizedBox(height: 24),

                  /// ================= TIMESTAMPS =================
                  const Text("Timestamps", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  const SizedBox(height: 12),
                  _buildInfoRow(Icons.access_time, "Created At", emp.createdAt ?? "-"),
                  _buildInfoRow(Icons.update, "Updated At", emp.updatedAt ?? "-"),
                ],
              ),
            );
          } else if (state is EmployeeError) {
            return Center(child: Text(state.message, style: const TextStyle(color: Colors.red)));
          }
          return const Center(child: Text("Loading..."));
        },
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 20, color: Colors.indigo),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: TextStyle(color: Colors.grey.shade500, fontSize: 13, fontWeight: FontWeight.w500)),
                const SizedBox(height: 4),
                Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Colors.black87)),
              ],
            ),
          )
        ],
      ),
    );
  }
}
