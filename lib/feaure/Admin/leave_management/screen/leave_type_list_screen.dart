import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/leave_type_bloc.dart';
import '../bloc/leave_type_event.dart';
import '../bloc/leave_type_state.dart';
import '../data/model/leave_type_model.dart';
import '../data/repository/leave_repository.dart';
import 'add_leave_type_screen.dart';

class LeaveTypeListScreen extends StatelessWidget {
  const LeaveTypeListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LeaveTypeBloc(
        leaveRepository: LeaveRepository(),
      )..add(FetchLeaveTypes()),
      child: Scaffold(
        backgroundColor: Colors.grey[50],
        appBar: AppBar(
          title: const Text('Leave Type Manager', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18)),
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          elevation: 1,
          shadowColor: Colors.black12,
          actions: [
            Builder(
              builder: (context) => IconButton(
                icon: const Icon(Icons.add_circle_outline),
                onPressed: () async {
                  final result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const AddLeaveTypeScreen(),
                    ),
                  );
                  if (result == true) {
                    context.read<LeaveTypeBloc>().add(FetchLeaveTypes());
                  }
                },
              ),
            ),
          ],
        ),
        floatingActionButton: Builder(
          builder: (context) => FloatingActionButton(
            onPressed: () async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AddLeaveTypeScreen(),
                ),
              );
              if (result == true) {
                context.read<LeaveTypeBloc>().add(FetchLeaveTypes());
              }
            },
            backgroundColor: Colors.indigo,
            child: const Icon(Icons.add, color: Colors.white),
          ),
        ),
        body: BlocConsumer<LeaveTypeBloc, LeaveTypeState>(
          listener: (context, state) {
            if (state.status == LeaveTypeStatus.failure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.errorMessage ?? 'An error occurred')),
              );
            }
            if (state.status == LeaveTypeStatus.actionSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Action completed successfully')),
              );
            }
          },
          builder: (context, state) {
            if (state.status == LeaveTypeStatus.loading && state.leaveTypes.isEmpty) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state.leaveTypes.isEmpty) {
              return const Center(child: Text('No leave types found'));
            }

            return ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
              itemCount: state.leaveTypes.length,
              itemBuilder: (context, index) {
                final leaveType = state.leaveTypes[index];
                final List<Color> colors = [
                  Colors.blue,
                  Colors.orange,
                  Colors.teal,
                  Colors.deepOrange,
                  Colors.pink,
                  Colors.purple,
                  Colors.red,
                  Colors.grey,
                ];
                final color = colors[index % colors.length];

                return _buildLeaveTypeCard(context, leaveType, color);
              },
            );
          },
        ),
      ),
    );
  }

  Widget _buildLeaveTypeCard(BuildContext context, LeaveTypeModel config, Color color) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10, offset: const Offset(0, 4)),
        ],
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(color: color.withOpacity(0.1), shape: BoxShape.circle),
                  child: Icon(Icons.label_outline, color: color, size: 20),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(config.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Colors.black87)),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(color: Colors.grey.shade100, borderRadius: BorderRadius.circular(4)),
                            child: Text(config.code, style: TextStyle(color: Colors.grey.shade700, fontSize: 10, fontWeight: FontWeight.w600)),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: config.isActive ? Colors.green.shade50 : Colors.red.shade50,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Row(
                              children: [
                                Icon(Icons.circle, size: 6, color: config.isActive ? Colors.green.shade600 : Colors.red.shade600),
                                const SizedBox(width: 4),
                                Text(
                                  config.isActive ? 'Active' : 'Inactive',
                                  style: TextStyle(
                                    color: config.isActive ? Colors.green.shade700 : Colors.red.shade700,
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      onPressed: () async {
                        final result = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AddLeaveTypeScreen(leaveType: config),
                          ),
                        );
                        if (result == true) {
                          context.read<LeaveTypeBloc>().add(FetchLeaveTypes());
                        }
                      },
                      icon: Icon(Icons.edit_outlined, color: Colors.grey.shade400, size: 20),
                      constraints: const BoxConstraints(),
                      padding: EdgeInsets.zero,
                    ),
                    const SizedBox(width: 12),
                    IconButton(
                      onPressed: () {
                        _showDeleteDialog(context, config.id!, config.name);
                      },
                      icon: Icon(Icons.delete_outline, color: Colors.red.shade300, size: 20),
                      constraints: const BoxConstraints(),
                      padding: EdgeInsets.zero,
                    ),
                  ],
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  flex: 3,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('${config.daysPerYear}', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 36, color: color, height: 1.0)),
                      const SizedBox(height: 4),
                      Text('Days / Year', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.grey.shade500)),
                    ],
                  ),
                ),
                Container(width: 1, height: 60, color: Colors.grey.shade200, margin: const EdgeInsets.symmetric(horizontal: 16)),
                Expanded(
                  flex: 5,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildRuleRow(
                        config.isPaid ? 'Paid' : 'Unpaid',
                        config.isPaid ? Icons.check_circle : Icons.cancel,
                        config.isPaid ? Colors.green : Colors.red,
                      ),
                      const SizedBox(height: 8),
                      _buildRuleRow(
                        config.carryForward ? 'Carry Forward' : 'No Carry',
                        config.carryForward ? Icons.check_circle : Icons.cancel,
                        config.carryForward ? Colors.green : Colors.red,
                      ),
                      const SizedBox(height: 8),
                      _buildRuleRow(
                        config.requiresDocument ? 'Doc Required' : 'No Doc Needed',
                        config.requiresDocument ? Icons.attach_file : Icons.do_not_disturb_alt,
                        config.requiresDocument ? Colors.blue : Colors.grey.shade500,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRuleRow(String text, IconData icon, Color color) {
    return Row(
      children: [
        Icon(icon, size: 14, color: color),
        const SizedBox(width: 8),
        Text(text, style: TextStyle(color: Colors.grey.shade700, fontSize: 12, fontWeight: FontWeight.w500)),
      ],
    );
  }

  void _showDeleteDialog(BuildContext context, int id, String name) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Delete Leave Type'),
        content: Text('Are you sure you want to delete "$name"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              context.read<LeaveTypeBloc>().add(DeleteLeaveType(id));
              Navigator.pop(dialogContext);
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
