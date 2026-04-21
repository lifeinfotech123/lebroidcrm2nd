import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import '../../../auth/data/services/permission_service.dart';
import '../bloc/task_bloc.dart';
import '../bloc/task_event.dart';
import '../bloc/task_state.dart';
import '../data/model/task_model.dart';
import 'task_detail_screen.dart';

class TaskAssignmentScreen extends StatefulWidget {
  const TaskAssignmentScreen({super.key});

  @override
  State<TaskAssignmentScreen> createState() => _TaskAssignmentScreenState();
}

class _TaskAssignmentScreenState extends State<TaskAssignmentScreen> {
  List<String> _permissions = [];
  bool _isPermissionsLoading = true;

  @override
  void initState() {
    super.initState();
    _loadPermissions();
    context.read<TaskBloc>().add(FetchTasks());
  }

  Future<void> _loadPermissions() async {
    final permissions = await PermissionService.getPermissions();
    if (mounted) {
      setState(() {
        _permissions = permissions;
        _isPermissionsLoading = false;
      });
    }
  }

  bool _hasPermission(String name) {
    return PermissionService.hasPermission(_permissions, name);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text('Task Management',
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18)),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 1,
        shadowColor: Colors.black12,
        actions: [
          if (_hasPermission('task.create'))
            IconButton(icon: const Icon(Icons.add_task), onPressed: () {
              // Navigate to create task screen
              Get.toNamed('/create-task'); 
            }),
        ],
      ),
      body: BlocConsumer<TaskBloc, TaskState>(
        listener: (context, state) {
          if (state is TaskOperationSuccess) {
            Get.snackbar("Success", state.message,
                backgroundColor: Colors.green, colorText: Colors.white);
          } else if (state is TaskError) {
            Get.snackbar("Error", state.message,
                backgroundColor: Colors.red, colorText: Colors.white);
          }
        },
        builder: (context, state) {
          if (state is TaskLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is TaskLoaded) {
            return CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        _buildStatsScroll(state.tasks),
                        const SizedBox(height: 16),
                        _buildSearchAndFilters(),
                        const SizedBox(height: 16),
                      ],
                    ),
                  ),
                ),
                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0)
                      .copyWith(bottom: 24.0),
                  sliver: state.tasks.isEmpty
                      ? const SliverFillRemaining(
                          child: Center(child: Text("No tasks found")),
                        )
                      : SliverList(
                          delegate: SliverChildBuilderDelegate(
                            (context, index) {
                              return _buildTaskCard(state.tasks[index]);
                            },
                            childCount: state.tasks.length,
                          ),
                        ),
                ),
              ],
            );
          }

          return const Center(child: Text("Initializing..."));
        },
      ),
    );
  }

  Widget _buildStatsScroll(List<TaskModel> tasks) {
    int total = tasks.length;
    int pending = tasks.where((t) => t.status.toLowerCase() == 'pending').length;
    int inProgress = tasks.where((t) => t.status.toLowerCase() == 'in_progress').length;
    int awaiting = tasks.where((t) => t.status.toLowerCase() == 'completed_pending_approval').length;

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          _buildStatPill('Total', '$total', Colors.blue),
          _buildStatPill('Pending', '$pending', Colors.grey),
          _buildStatPill('In Progress', '$inProgress', Colors.indigo),
          _buildStatPill('Awaiting Approval', '$awaiting', Colors.orange),
          _buildStatPill('Overdue', '0', Colors.red),
        ],
      ),
    );
  }

  Widget _buildStatPill(String title, String value, MaterialColor color) {
    return Container(
      margin: const EdgeInsets.only(right: 12),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: color.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.shade200),
      ),
      child: Row(
        children: [
          Text(title,
              style: TextStyle(
                  color: color.shade700,
                  fontSize: 12,
                  fontWeight: FontWeight.bold)),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(10)),
            child: Text(value,
                style: TextStyle(
                    color: color.shade700,
                    fontSize: 12,
                    fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchAndFilters() {
    return Column(
      children: [
        TextField(
          decoration: InputDecoration(
            hintText: 'Search tasks...',
            hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 13),
            prefixIcon:
                Icon(Icons.search, color: Colors.grey.shade400, size: 20),
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.symmetric(vertical: 0),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.grey.shade200)),
            enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.grey.shade200)),
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Colors.indigo)),
          ),
        ),
        const SizedBox(height: 12),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              _buildFilterPill('All Status', () {
                context.read<TaskBloc>().add(FetchTasks());
              }),
              _buildFilterPill('Pending Tasks', () {
                context.read<TaskBloc>().add(FetchPendingTasks());
              }),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildFilterPill(String title, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(right: 8),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(title,
                style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade700,
                    fontWeight: FontWeight.w500)),
            const SizedBox(width: 4),
            Icon(Icons.keyboard_arrow_down,
                size: 14, color: Colors.indigo.shade400),
          ],
        ),
      ),
    );
  }

  Widget _buildTaskCard(TaskModel item) {
    Color priorityColor = item.priority.toLowerCase() == 'high'
        ? Colors.red
        : (item.priority.toLowerCase() == 'medium' ? Colors.orange : Colors.green);

    Color statusColor;
    String statusLabel = item.status.replaceAll('_', ' ').capitalizeFirst!;
    
    if (item.status.toLowerCase() == 'pending') {
      statusColor = Colors.grey;
    } else if (item.status.toLowerCase() == 'in_progress') {
      statusColor = Colors.indigo;
    } else if (item.status.toLowerCase() == 'completed_pending_approval') {
      statusColor = Colors.orange;
      statusLabel = "Pending Approval";
    } else {
      statusColor = Colors.green;
    }

    return InkWell(
      onTap: () {
        if (_hasPermission('task.view') || _hasPermission('task.viewOwn')) {
          Get.to(() => TaskDetailScreen(task: item));
        } else {
          Get.snackbar("Access Denied", "You don't have permission to view task details.",
              backgroundColor: Colors.orange, colorText: Colors.white);
        }
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey.shade200),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.02),
                blurRadius: 10,
                offset: const Offset(0, 4)),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          item.title,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: Colors.black87),
                        ),
                      ),
                      if (_hasPermission('task.delete'))
                        IconButton(
                          onPressed: () {
                            _showDeleteDialog(item.id);
                          },
                          icon: const Icon(Icons.delete_outline,
                              color: Colors.redAccent, size: 20),
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                        ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    item.description,
                    style: TextStyle(
                        color: Colors.grey.shade600, fontSize: 13, height: 1.4),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            const Divider(height: 1),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 12,
                            backgroundColor: Colors.indigo.shade50,
                            child: Text(item.initials,
                                style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.indigo.shade700)),
                          ),
                          const SizedBox(width: 8),
                          Text(item.assignee,
                              style: const TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black87)),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                            color: priorityColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(6)),
                        child: Row(
                          children: [
                            Icon(Icons.flag, size: 12, color: priorityColor),
                            const SizedBox(width: 4),
                            Text(item.priority.capitalizeFirst!,
                                style: TextStyle(
                                    color: priorityColor,
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.calendar_today_outlined,
                              size: 14, color: Colors.grey.shade500),
                          const SizedBox(width: 6),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(item.deadline,
                                  style: TextStyle(
                                      color: Colors.grey.shade700,
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold)),
                            ],
                          ),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                            color: statusColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(6)),
                        child: Text(statusLabel,
                            style: TextStyle(
                                color: statusColor,
                                fontSize: 10,
                                fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
                borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(16),
                    bottomRight: Radius.circular(16)),
                border: Border(top: BorderSide(color: Colors.grey.shade200)),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        value: item.progressVal,
                        backgroundColor: Colors.grey.shade200,
                        valueColor: AlwaysStoppedAnimation<Color>(
                            item.progressVal == 1.0
                                ? Colors.green
                                : Colors.indigo),
                        minHeight: 6,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    item.progress,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                        color: Colors.black87),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showDeleteDialog(int taskId) {
    Get.defaultDialog(
      title: "Delete Task",
      middleText: "Are you sure you want to delete this task?",
      textConfirm: "Delete",
      textCancel: "Cancel",
      confirmTextColor: Colors.white,
      buttonColor: Colors.red,
      onConfirm: () {
        context.read<TaskBloc>().add(DeleteTask(taskId));
        Get.back();
      },
    );
  }
}
