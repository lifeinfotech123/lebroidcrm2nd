import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lebroid_crm/feaure/Admin/branch_management/bloc/branch_bloc.dart';
import 'package:lebroid_crm/feaure/Admin/branch_management/bloc/branch_event.dart';
import 'package:lebroid_crm/feaure/Admin/branch_management/bloc/branch_state.dart';
import 'package:lebroid_crm/feaure/Admin/branch_management/data/repository/branch_repository.dart';
import 'package:lebroid_crm/feaure/Admin/branch_management/data/model/branch_model.dart';
import 'add_branch_screen.dart';
import 'branch_details_screen.dart';

class BranchListScreen extends StatelessWidget {
  const BranchListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    context.read<BranchBloc>().add(LoadBranchesEvent());

    return Scaffold(
      backgroundColor: const Color(0xfff5f6fa),
      appBar: AppBar(
        title: const Text('Branches'),
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black,
      ),
      body: BlocConsumer<BranchBloc, BranchState>(
          listener: (context, state) {
            if (state is BranchOperationSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message), backgroundColor: Colors.green),
              );
            } else if (state is BranchError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message), backgroundColor: Colors.red),
              );
            }
          },
          builder: (context, state) {
            if (state is BranchLoading || state is BranchInitial) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is BranchLoaded) {
              final branches = state.branches;
              final activeCount = branches.where((b) => b.isActive).length;
              
              return Column(
                children: [
                  /// ================= SUMMARY =================
                  SizedBox(
                    height: 90,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.all(16),
                      children: [
                        _SummaryCard(title: "Total", value: branches.length.toString()),
                        _SummaryCard(title: "Active", value: activeCount.toString()),
                        _SummaryCard(title: "Inactive", value: (branches.length - activeCount).toString()),
                      ],
                    ),
                  ),

                  /// ================= LIST =================
                  Expanded(
                    child: branches.isEmpty
                        ? const Center(child: Text("No Branches Found"))
                        : ListView.builder(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            itemCount: branches.length,
                            itemBuilder: (context, index) {
                              final branch = branches[index];
                              return _BranchCard(
                                branch: branch,
                                parentContext: context,
                              );
                            },
                          ),
                  )
                ],
              );
            } else if (state is BranchError) {
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
                  MaterialPageRoute(builder: (_) => const AddBranchScreen()),
                ).then((value) {
                  if (value == true) {
                    context.read<BranchBloc>().add(LoadBranchesEvent());
                  }
                });
              },
              child: const Icon(Icons.add),
            );
          }
        ),
    );
  }
}

/// ================= SUMMARY CARD =================
///
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
      padding: const EdgeInsets.all(5),
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

/// ================= BRANCH CARD =================
class _BranchCard extends StatelessWidget {
  final BranchModel branch;
  final BuildContext parentContext;

  const _BranchCard({
    required this.branch,
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
                backgroundColor: Colors.blue,
                child: Icon(Icons.location_on, color: Colors.white),
              ),
              const SizedBox(width: 12),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(branch.name ?? "-",
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 15)),
                    Text(branch.code ?? "-",
                        style: const TextStyle(color: Colors.grey)),
                  ],
                ),
              ),

              _statusChip(branch.isActive),
            ],
          ),

          const SizedBox(height: 12),

          /// INFO ROWS
          _infoRow(Icons.location_on, branch.city ?? "-"),
          _infoRow(Icons.person, "Manager: ${branch.manager?['name'] ?? '—'}"),
          _infoRow(Icons.group, "Employees: 0"),
          _infoRow(Icons.gps_fixed, "Geo: ${branch.geoRadiusMeters != null ? branch.geoRadiusMeters! + 'm' : '-'}"),

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
                      builder: (_) => AddBranchScreen(branch: branch),
                    ),
                  ).then((value) {
                    if (value == true) {
                      parentContext.read<BranchBloc>().add(LoadBranchesEvent());
                    }
                  });
                },
              ),
              IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: () {
                  _showDeleteConfirm(parentContext, branch.id);
                },
              ),
              IconButton(
                 icon: const Icon(Icons.remove_red_eye_rounded, color: Colors.blue),
                 onPressed: () {
                   Navigator.push(
                      parentContext,
                      MaterialPageRoute(
                        builder: (_) => BranchDetailsScreen(branchId: branch.id),
                      ),
                   );
                 },
              )
            ],
          )
        ],
      ),
    );
  }

  void _showDeleteConfirm(BuildContext context, int branchId) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Delete Branch"),
        content: const Text("Are you sure you want to delete this branch?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () {
              Navigator.pop(ctx);
              context.read<BranchBloc>().add(DeleteBranchEvent(branchId));
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
            child: Text(
              text,
              style: const TextStyle(fontSize: 13),
            ),
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