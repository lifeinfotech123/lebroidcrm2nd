import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import '../bloc/task_bloc.dart';
import '../bloc/task_event.dart';
import '../bloc/task_state.dart';

class CreateTaskScreen extends StatefulWidget {
  const CreateTaskScreen({super.key});

  @override
  State<CreateTaskScreen> createState() => _CreateTaskScreenState();
}

class _CreateTaskScreenState extends State<CreateTaskScreen> {
  final List<String> _subTasks = [];
  final TextEditingController _subTaskController = TextEditingController();

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descController = TextEditingController();
  final TextEditingController _deadlineController = TextEditingController();
  String? _assignedTo = "2"; // Using "2" as default as per sample API mapping
  String? _branchId = "1"; // Using "1" as default

  String _selectedPriority = 'medium';
  final Map<String, String> _priorities = {
    'high': '🔴 High Priority',
    'medium': '🟡 Medium Priority',
    'low': '🟢 Low Priority'
  };

  @override
  void dispose() {
    _subTaskController.dispose();
    _titleController.dispose();
    _descController.dispose();
    _deadlineController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text('Create Task', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18)),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 1,
        shadowColor: Colors.black12,
      ),
      body: BlocListener<TaskBloc, TaskState>(
        listener: (context, state) {
          if (state is TaskOperationSuccess) {
            Get.back();
            Get.snackbar("Success", state.message, backgroundColor: Colors.green, colorText: Colors.white);
          } else if (state is TaskError) {
            Get.snackbar("Error", state.message, backgroundColor: Colors.red, colorText: Colors.white);
          }
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildSectionTitle('Task Details'),
              const SizedBox(height: 16),
              _buildInputField(label: 'Task Title *', hint: 'Enter clear task title...', controller: _titleController),
              const SizedBox(height: 16),
              _buildInputField(label: 'Description', hint: 'Describe the task in detail...', maxLines: 4, controller: _descController),
              const SizedBox(height: 16),
              _buildDropdownField(label: 'Assign To *', hint: 'Employee (ID: 2)', value: _assignedTo, items: {'2': 'Sneh Khare', '1': 'Admin'}, onChanged: (v) => setState(()=> _assignedTo = v)),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(child: _buildInputField(label: 'Deadline *', hint: 'YYYY-MM-DD', icon: Icons.calendar_today_outlined, controller: _deadlineController)),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildPriorityDropdown(),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              _buildDropdownField(label: 'Parent Task (Optional)', hint: '— None (Top-level task) —', items: {}),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildSectionTitle('Sub-Tasks'),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(color: Colors.indigo.shade50, borderRadius: BorderRadius.circular(12)),
                    child: Text('${_subTasks.length}', style: TextStyle(color: Colors.indigo.shade700, fontSize: 12, fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              _buildSubTasksField(),
              const SizedBox(height: 32),
              _buildPriorityGuide(),
              const SizedBox(height: 80), // Padding for bottom button
            ],
          ),
        ),
      ),
      bottomSheet: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, -4))],
        ),
        child: BlocBuilder<TaskBloc, TaskState>(
          builder: (context, state) {
            return ElevatedButton(
              onPressed: state is TaskLoading ? null : () {
                if (_titleController.text.isEmpty || _deadlineController.text.isEmpty || _assignedTo == null) {
                   Get.snackbar("Error", "Please fill required fields (Title, Assign To, Deadline)", backgroundColor: Colors.orange);
                   return;
                }
                
                final taskData = {
                  "title": _titleController.text,
                  "assigned_to": int.tryParse(_assignedTo!) ?? 2,
                  "branch_id": int.tryParse(_branchId!) ?? 1,
                  "description": _descController.text,
                  "priority": _selectedPriority,
                  "deadline": _deadlineController.text, // Expecting YYYY-MM-DD
                };
                context.read<TaskBloc>().add(CreateTask(taskData));
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.indigo,
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: state is TaskLoading 
                  ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white))
                  : const Text('Create Task', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            );
          }
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.black87));
  }

  Widget _buildInputField({required String label, required String hint, int maxLines = 1, IconData? icon, TextEditingController? controller}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.grey.shade700)),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          maxLines: maxLines,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 14),
            filled: true,
            fillColor: Colors.white,
            suffixIcon: icon != null ? Icon(icon, color: Colors.grey.shade400, size: 20) : null,
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey.shade200)),
            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey.shade200)),
            focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Colors.indigo)),
          ),
        ),
      ],
    );
  }

  Widget _buildDropdownField({required String label, required String hint, Map<String, String>? items, String? value, Function(String?)? onChanged}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.grey.shade700)),
        const SizedBox(height: 6),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          height: 50,
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: Colors.grey.shade200),
            borderRadius: BorderRadius.circular(12),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              isExpanded: true,
              value: value,
              hint: Text(hint, style: TextStyle(color: Colors.grey.shade400, fontSize: 14)),
              icon: const Icon(Icons.keyboard_arrow_down, color: Colors.grey),
              items: items?.entries.map((e) => DropdownMenuItem(value: e.key, child: Text(e.value))).toList() ?? [],
              onChanged: onChanged ?? (val) {},
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPriorityDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Priority *', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.grey.shade700)),
        const SizedBox(height: 6),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          height: 50,
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: Colors.grey.shade200),
            borderRadius: BorderRadius.circular(12),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              isExpanded: true,
              value: _selectedPriority,
              icon: const Icon(Icons.keyboard_arrow_down, color: Colors.grey),
              items: _priorities.entries.map((e) {
                return DropdownMenuItem(value: e.key, child: Text(e.value, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)));
              }).toList(),
              onChanged: (val) {
                if(val != null) setState(() => _selectedPriority = val);
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSubTasksField() {
    return Column(
      children: [
        TextField(
          controller: _subTaskController,
          decoration: InputDecoration(
            hintText: 'Type sub-task and press Enter or click Add...',
            hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 13),
            filled: true,
            fillColor: Colors.white,
            suffixIcon: IconButton(
              icon: const Icon(Icons.add_circle, color: Colors.indigo),
              onPressed: () {
                if (_subTaskController.text.isNotEmpty) {
                  setState(() {
                    _subTasks.add(_subTaskController.text);
                    _subTaskController.clear();
                  });
                }
              },
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey.shade200)),
            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey.shade200)),
            focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Colors.indigo)),
          ),
          onSubmitted: (val) {
             if (val.isNotEmpty) {
                  setState(() {
                    _subTasks.add(val);
                    _subTaskController.clear();
                  });
              }
          },
        ),
        if (_subTasks.isNotEmpty) const SizedBox(height: 12),
        ..._subTasks.map((t) => Container(
          margin: const EdgeInsets.only(bottom: 8),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(color: Colors.grey.shade100, borderRadius: BorderRadius.circular(8)),
          child: Row(
            children: [
              Icon(Icons.subdirectory_arrow_right, size: 16, color: Colors.grey.shade500),
              const SizedBox(width: 8),
              Expanded(child: Text(t, style: const TextStyle(fontSize: 13))),
              GestureDetector(
                onTap: () => setState(() => _subTasks.remove(t)),
                child: Icon(Icons.close, size: 16, color: Colors.red.shade400)
              ),
            ],
          ),
        )),
      ],
    );
  }

  Widget _buildPriorityGuide() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.blueGrey.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.blueGrey.shade100),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.info_outline, size: 16, color: Colors.blueGrey.shade700),
              const SizedBox(width: 8),
              Text('Priority Guide', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.blueGrey.shade800)),
            ],
          ),
          const SizedBox(height: 12),
          _buildGuideRow('🔴', 'High Priority', 'Urgent — must be completed ASAP'),
          const SizedBox(height: 8),
          _buildGuideRow('🟡', 'Medium Priority', 'Important — complete within deadline'),
          const SizedBox(height: 8),
          _buildGuideRow('🟢', 'Low Priority', 'Flexible — handle when time permits'),
        ],
      ),
    );
  }

  Widget _buildGuideRow(String emoji, String title, String desc) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(emoji),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.black87)),
              Text(desc, style: TextStyle(fontSize: 11, color: Colors.blueGrey.shade600, height: 1.3)),
            ],
          ),
        ),
      ],
    );
  }
}

