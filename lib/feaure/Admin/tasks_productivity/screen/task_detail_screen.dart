import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:file_picker/file_picker.dart';
import '../../../auth/data/services/permission_service.dart';
import '../bloc/task_bloc.dart';
import '../bloc/task_event.dart';
import '../bloc/task_state.dart';
import '../data/model/task_model.dart';
import '../widget/task_widgets.dart';

class TaskDetailScreen extends StatefulWidget {
  final TaskModel task;
  const TaskDetailScreen({super.key, required this.task});

  @override
  State<TaskDetailScreen> createState() => _TaskDetailScreenState();
}

class _TaskDetailScreenState extends State<TaskDetailScreen> {
  late TaskModel _currentTask;
  String? _newStatus;
  final TextEditingController _commentController = TextEditingController();
  String? _selectedFilePath;
  String? _selectedFileName;
  List<String> _permissions = [];
  bool _isLoadingPermissions = true;

  @override
  void initState() {
    super.initState();
    _currentTask = widget.task;
    _newStatus = _currentTask.status;
    _loadPermissions();
  }

  Future<void> _loadPermissions() async {
    final permissions = await PermissionService.getPermissions();
    if (mounted) {
      setState(() {
        _permissions = permissions;
        _isLoadingPermissions = false;
      });
    }
  }

  bool _hasPermission(String name) {
    return PermissionService.hasPermission(_permissions, name);
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  Future<void> _pickFile() async {
    FilePickerResult? result = await FilePicker.pickFiles();
    if (result != null) {
      setState(() {
        _selectedFilePath = result.files.single.path;
        _selectedFileName = result.files.single.name;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TaskBloc, TaskState>(
      listener: (context, state) {
        if (state is TaskOperationSuccess) {
          if (state.task != null) {
            setState(() {
              _currentTask = state.task!;
              _newStatus = _currentTask.status;
            });
          }
          Get.snackbar("Success", state.message,
              backgroundColor: Colors.green, colorText: Colors.white);
        } else if (state is TaskError) {
          Get.snackbar("Error", state.message,
              backgroundColor: Colors.red, colorText: Colors.white);
        }
      },
      builder: (context, state) {
        return Scaffold(
          backgroundColor: const Color(0xFFF8F9FA),
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 1,
            title: const Text("Task Detail", style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.w600)),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.black),
              onPressed: () => Get.back(),
            ),
          ),
          body: Stack(
            children: [
              SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    _buildMainDetailsCard(),
                    const SizedBox(height: 16),
                    if (_currentTask.rejectionRemarks != null) _buildRejectedBanner(),
                    const SizedBox(height: 16),
                    _buildDocumentsCard(),
                    const SizedBox(height: 16),
                    _buildCommentsCard(),
                    const SizedBox(height: 16),
                    _buildTaskInfoCard(),
                    if (_hasPermission('task.update')) ...[
                      const SizedBox(height: 16),
                      _buildUpdateStatusCard(),
                    ],
                    const SizedBox(height: 16),
                    _buildStatusFlowCard(),
                    if (_currentTask.status == 'completed_pending_approval' && _hasPermission('task.approve')) ...[
                      const SizedBox(height: 16),
                      _buildAdminActionButtons(),
                    ],
                    const SizedBox(height: 40),
                  ],
                ),
              ),
              if (state is TaskLoading)
                Container(
                  color: Colors.black12,
                  child: const Center(child: CircularProgressIndicator()),
                ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildMainDetailsCard() {
    Color priorityColor = _currentTask.priority.toLowerCase() == 'high' ? Colors.red : (_currentTask.priority.toLowerCase() == 'medium' ? Colors.orange : Colors.green);
    
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(color: Colors.grey[200]!),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    _currentTask.title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF334155),
                    ),
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    TaskBadge(
                      label: '${_currentTask.priority.capitalizeFirst} Priority',
                      backgroundColor: priorityColor.withOpacity(0.1),
                      textColor: priorityColor,
                    ),
                    const SizedBox(height: 8),
                    TaskBadge(
                      label: _currentTask.status.replaceAll('_', ' ').capitalizeFirst!,
                      backgroundColor: const Color(0xFFEFF6FF),
                      textColor: const Color(0xFF1D4ED8),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),
            Divider(color: Colors.grey[100]),
            const SizedBox(height: 16),
            Text(
              _currentTask.description,
              style: const TextStyle(color: Colors.blueGrey, fontSize: 14, height: 1.5),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRejectedBanner() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFFEF2F2),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFFEE2E2)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.error_outline, color: Color(0xFF991B1B), size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Rejected — Please revise and resubmit',
                  style: TextStyle(
                    color: Color(0xFF991B1B),
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  _currentTask.rejectionRemarks ?? "No remarks provided.",
                  style: const TextStyle(color: Color(0xFF991B1B), fontSize: 13),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDocumentsCard() {
    bool hasDoc = _currentTask.completionAttachment != null;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 30),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        children: [
          Icon(hasDoc ? Icons.description_outlined : Icons.attach_file, color: hasDoc ? Colors.blue : Colors.grey[400], size: 24),
          const SizedBox(height: 12),
          Text(
            hasDoc ? 'Completion Document attached' : 'No documents attached',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.blueGrey,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            hasDoc ? 'Click to view attachment' : 'This task has no uploaded documents.',
            style: TextStyle(color: Colors.grey[400], fontSize: 12),
          ),
        ],
      ),
    );
  }

  Widget _buildCommentsCard() {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(color: Colors.grey[200]!),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(Icons.chat_bubble_outline, size: 18, color: Color(0xFF1E293B)),
                SizedBox(width: 8),
                Text(
                  'Submission & Comments',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Color(0xFF1E293B)),
                ),
              ],
            ),
            const SizedBox(height: 20),
            if (_currentTask.completionRemarks != null)
              CommentTile(
                name: 'Submission Remarks',
                initials: 'SR',
                timeAgo: 'Latest',
                comment: _currentTask.completionRemarks!,
                avatarColor: Colors.blue,
              ),
            const SizedBox(height: 16),
            Divider(color: Colors.grey[100]),
            const SizedBox(height: 16),
            TextField(
              controller: _commentController,
              maxLines: 3,
              decoration: InputDecoration(
                hintText: 'Add remarks for submission...',
                hintStyle: TextStyle(color: Colors.grey[400], fontSize: 13),
                fillColor: Colors.white,
                filled: true,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: Colors.grey[200]!)),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: _pickFile,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey[200]!),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Row(
                        children: [
                          Text('Choose File', style: TextStyle(color: Colors.grey[700], fontSize: 13)),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              _selectedFileName ?? 'No file chosen',
                              style: TextStyle(color: Colors.grey[400], fontSize: 13),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                ElevatedButton.icon(
                  onPressed: () {
                    if (_commentController.text.isNotEmpty) {
                      context.read<TaskBloc>().add(SubmitTask(_currentTask.id, _commentController.text, _selectedFilePath));
                    } else {
                      Get.snackbar("Error", "Please add remarks before submitting", backgroundColor: Colors.orange);
                    }
                  },
                  icon: const Icon(Icons.send, size: 14),
                  label: const Text('SUBMIT'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF3B82F6),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTaskInfoCard() {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(color: Colors.grey[200]!),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Task Info',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Color(0xFF1E293B)),
            ),
            const SizedBox(height: 16),
            Divider(color: Colors.grey[100]),
            TaskInfoRow(icon: Icons.person_outline, label: 'Assigned By', value: _currentTask.assignedBy?.name ?? 'Unknown'),
            TaskInfoRow(icon: Icons.person_add_alt, label: 'Assigned To', value: _currentTask.assignee),
            TaskInfoRow(icon: Icons.location_on_outlined, label: 'Branch ID', value: _currentTask.branchId ?? 'N/A'),
            TaskInfoRow(icon: Icons.calendar_today_outlined, label: 'Deadline', value: _currentTask.deadline),
            TaskInfoRow(icon: Icons.access_time, label: 'Created', value: _currentTask.createdAt?.split('T')[0] ?? 'N/A'),
            if (_currentTask.verifiedBy != null)
              TaskInfoRow(icon: Icons.check_circle_outline, label: 'Verified By', value: _currentTask.verifiedBy!.name, valueColor: Colors.green),
            if (_currentTask.verifiedAt != null)
              TaskInfoRow(icon: Icons.history, label: 'Verified At', value: _currentTask.verifiedAt!.split('T')[0]),
          ],
        ),
      ),
    );
  }

  Widget _buildUpdateStatusCard() {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(color: Colors.grey[200]!),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(Icons.sync, size: 18, color: Colors.blue),
                SizedBox(width: 8),
                Text(
                  'Update Status',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ],
            ),
            const SizedBox(height: 20),
            const Text('NEW STATUS', style: TextStyle(color: Colors.grey, fontSize: 11, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              value: _newStatus,
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: Colors.grey[200]!)),
              ),
              items: ['pending', 'in_progress', 'completed_pending_approval', 'approved'].map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value.replaceAll('_', ' ').capitalizeFirst!, style: const TextStyle(fontSize: 14)),
                );
              }).toList(),
              onChanged: (val) {
                setState(() => _newStatus = val);
              },
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                ElevatedButton.icon(
                  onPressed: () {
                    context.read<TaskBloc>().add(UpdateTask(_currentTask.id, {'status': _newStatus}));
                  },
                  icon: const Icon(Icons.save, size: 14),
                  label: const Text('UPDATE STATUS', style: TextStyle(fontSize: 12)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF3B82F6),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                  ),
                ),
                const SizedBox(width: 12),
                Text('Current:', style: TextStyle(color: Colors.grey[500], fontSize: 11)),
                const SizedBox(width: 4),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(color: Colors.blue[50], borderRadius: BorderRadius.circular(4)),
                  child: Text(_currentTask.status.replaceAll('_', ' ').capitalizeFirst!, style: TextStyle(color: Colors.blue[700], fontSize: 11, fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAdminActionButtons() {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton(
            onPressed: () => _showApproveDialog(),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 12),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            child: const Text("APPROVE TASK"),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: ElevatedButton(
            onPressed: () => _showRejectDialog(),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 12),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            child: const Text("REJECT TASK"),
          ),
        ),
      ],
    );
  }

  void _showApproveDialog() {
    final controller = TextEditingController();
    Get.defaultDialog(
      title: "Approve Task",
      content: TextField(controller: controller, decoration: const InputDecoration(hintText: "Add approval remarks...")),
      onConfirm: () {
        context.read<TaskBloc>().add(ApproveTask(_currentTask.id, controller.text));
        Get.back();
      },
    );
  }

  void _showRejectDialog() {
    final controller = TextEditingController();
    Get.defaultDialog(
      title: "Reject Task",
      content: TextField(controller: controller, decoration: const InputDecoration(hintText: "Add rejection reason...")),
      onConfirm: () {
        context.read<TaskBloc>().add(RejectTask(_currentTask.id, controller.text));
        Get.back();
      },
    );
  }

  Widget _buildStatusFlowCard() {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(color: Colors.grey[200]!),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Status Flow', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 20),
            StatusFlowStep(label: 'Pending', isCompleted: _currentTask.progressVal >= 0.0),
            _buildFlowConnector(_currentTask.progressVal > 0.0),
            StatusFlowStep(label: 'In Progress', isCurrent: _currentTask.status == 'in_progress', isCompleted: _currentTask.progressVal >= 0.5),
            _buildFlowConnector(_currentTask.progressVal > 0.5),
            StatusFlowStep(label: 'Awaiting Approval', isCurrent: _currentTask.status == 'completed_pending_approval', isCompleted: _currentTask.progressVal >= 0.8),
            _buildFlowConnector(_currentTask.progressVal > 0.8),
            StatusFlowStep(label: 'Approved', isLast: true, isCompleted: _currentTask.status == 'approved'),
          ],
        ),
      ),
    );
  }

  Widget _buildFlowConnector(bool isDone) {
    return Padding(
      padding: const EdgeInsets.only(left: 14.0),
      child: Container(width: 1, height: 20, color: isDone ? Colors.blue : Colors.grey[300]),
    );
  }
}
