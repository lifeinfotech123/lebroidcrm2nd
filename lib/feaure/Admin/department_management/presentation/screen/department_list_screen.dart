import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lebroid_crm/feaure/Admin/department_management/logics/department_bloc.dart';
import 'package:lebroid_crm/feaure/Admin/department_management/logics/department_event.dart';
import 'package:lebroid_crm/feaure/Admin/department_management/logics/department_state.dart';
import 'package:lebroid_crm/feaure/Admin/department_management/data/model/department_model.dart';
import 'add_department_screen.dart';
import 'department_detail_screen.dart';

class DepartmentListScreen extends StatelessWidget {
  const DepartmentListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    context.read<DepartmentBloc>().add(LoadDepartmentsEvent());

    return Scaffold(
      backgroundColor: const Color(0xfff5f6fa),
      appBar: AppBar(
        title: const Text('Departments'),
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black,
      ),
      body: BlocConsumer<DepartmentBloc, DepartmentState>(
        listener: (context, state) {
          if (state is DepartmentOperationSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message), backgroundColor: Colors.green),
            );
          } else if (state is DepartmentError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message), backgroundColor: Colors.red),
            );
          }
        },
        builder: (context, state) {
          if (state is DepartmentLoading || state is DepartmentInitial) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is DepartmentLoaded) {
            final departments = state.departments;
            final activeCount = departments.where((d) => d.isActive).length;

            return Column(
              children: [
                /// ================= SUMMARY =================
                SizedBox(
                  height: 90,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.all(16),
                    children: [
                      _SummaryCard(title: "Total", value: departments.length.toString()),
                      _SummaryCard(title: "Active", value: activeCount.toString()),
                      _SummaryCard(title: "Inactive", value: (departments.length - activeCount).toString()),
                    ],
                  ),
                ),

                /// ================= HEADER =================
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: [
                      const Text(
                        "All Departments",
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      const Spacer(),
                      Text("${departments.length} Departments", style: const TextStyle(color: Colors.grey)),
                    ],
                  ),
                ),

                const SizedBox(height: 10),

                /// ================= LIST =================
                Expanded(
                  child: departments.isEmpty
                      ? const Center(child: Text("No Departments Found"))
                      : ListView.builder(
                          padding: const EdgeInsets.all(16),
                          itemCount: departments.length,
                          itemBuilder: (context, index) {
                            final department = departments[index];
                            return _DepartmentCard(
                              department: department,
                              parentContext: context,
                            );
                          },
                        ),
                ),
              ],
            );
          } else if (state is DepartmentError) {
            return Center(child: Text(state.message));
          }
          return const SizedBox();
        },
      ),

      floatingActionButton: Builder(
        builder: (context) {
          return FloatingActionButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const AddDepartmentScreen()),
              ).then((value) {
                if (value == true) {
                  context.read<DepartmentBloc>().add(LoadDepartmentsEvent());
                }
              });
            },
            backgroundColor: Colors.orange,
            child: const Icon(Icons.add),
          );
        },
      ),
    );
  }
}

/// ================= SUMMARY CARD =================
class _SummaryCard extends StatelessWidget {
  final String title;
  final String value;

  const _SummaryCard({
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 90,
      margin: const EdgeInsets.only(right: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(value,
              style: const TextStyle(
                  fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Text(title,
              style: const TextStyle(fontSize: 12, color: Colors.grey)),
        ],
      ),
    );
  }
}

/// ================= DEPARTMENT CARD =================
class _DepartmentCard extends StatelessWidget {
  final DepartmentModel department;
  final BuildContext parentContext;

  const _DepartmentCard({
    required this.department,
    required this.parentContext,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          /// TOP ROW
          Row(
            children: [
              const CircleAvatar(
                backgroundColor: Colors.orange,
                child: Icon(Icons.layers, color: Colors.white),
              ),
              const SizedBox(width: 12),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(department.name ?? "-",
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 15)),
                    Text(department.code ?? "-",
                        style: const TextStyle(color: Colors.grey)),
                  ],
                ),
              ),

              _statusChip(department.isActive),
            ],
          ),

          const SizedBox(height: 12),

          /// INFO
          _infoRow(Icons.person, "Head: ${department.head?['name'] ?? '—'}"),
          _infoRow(Icons.description, "Description: ${department.description ?? '—'}"),

          const SizedBox(height: 12),

          /// ACTIONS
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              IconButton(
                icon: const Icon(Icons.edit),
                onPressed: () {
                  Navigator.push(
                    parentContext,
                    MaterialPageRoute(
                      builder: (_) => AddDepartmentScreen(department: department),
                    ),
                  ).then((value) {
                    if (value == true) {
                      parentContext.read<DepartmentBloc>().add(LoadDepartmentsEvent());
                    }
                  });
                },
              ),
              IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: () {
                  _showDeleteConfirm(parentContext, department.id);
                },
              ),
              IconButton(
                icon: const Icon(Icons.remove_red_eye_rounded, color: Colors.blue),
                onPressed: () {
                  Navigator.push(
                    parentContext,
                    MaterialPageRoute(
                      builder: (_) => DepartmentDetailScreen(departmentId: department.id),
                    ),
                  );
                },
              ),
            ],
          )
        ],
      ),
    );
  }

  void _showDeleteConfirm(BuildContext context, int departmentId) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Delete Department"),
        content: const Text("Are you sure you want to delete this department?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () {
              Navigator.pop(ctx);
              context.read<DepartmentBloc>().add(DeleteDepartmentEvent(departmentId));
            },
            child: const Text("Delete", style: TextStyle(color: Colors.white)),
          )
        ],
      ),
    );
  }

  Widget _infoRow(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        children: [
          Icon(icon, size: 16, color: Colors.grey),
          const SizedBox(width: 8),
          Expanded(
            child: Text(text, style: const TextStyle(fontSize: 13)),
          ),
        ],
      ),
    );
  }

  Widget _statusChip(bool isActive) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: isActive ? Colors.green.shade100 : Colors.red.shade100,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        isActive ? "Active" : "Inactive",
        style: TextStyle(
          color: isActive ? Colors.green : Colors.red,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}