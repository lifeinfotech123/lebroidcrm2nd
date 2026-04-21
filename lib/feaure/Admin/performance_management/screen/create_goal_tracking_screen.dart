import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import '../bloc/performance_bloc.dart';
import '../bloc/performance_event.dart';
import '../bloc/performance_state.dart';
import '../data/model/performance_model.dart';

class CreateGoalTrackingScreen extends StatefulWidget {
  final GoalModel? goal; // null = create, non-null = edit
  const CreateGoalTrackingScreen({super.key, this.goal});

  @override
  State<CreateGoalTrackingScreen> createState() => _CreateGoalTrackingScreenState();
}

class _CreateGoalTrackingScreenState extends State<CreateGoalTrackingScreen> {
  bool get isEditing => widget.goal != null;

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descController = TextEditingController();
  final TextEditingController _deadlineController = TextEditingController();
  final TextEditingController _targetController = TextEditingController(text: '100');
  final TextEditingController _unitController = TextEditingController(text: '%');
  final TextEditingController _currentController = TextEditingController(text: '0');
  final TextEditingController _notesController = TextEditingController();
  final TextEditingController _userIdController = TextEditingController(text: '2');

  String _selectedCategory = 'performance';
  String _selectedStatus = 'active';

  final List<String> _categories = ['performance', 'learning', 'project', 'other'];
  final List<String> _statuses = ['active', 'achieved', 'missed', 'paused'];

  @override
  void initState() {
    super.initState();
    if (isEditing) {
      final g = widget.goal!;
      _titleController.text = g.title;
      _descController.text = g.description;
      _deadlineController.text = g.deadline.split('T')[0];
      _targetController.text = g.target.toString();
      _unitController.text = g.unit;
      _currentController.text = g.current.toString();
      _notesController.text = g.notes ?? '';
      _userIdController.text = g.userId;
      _selectedCategory = g.category;
      _selectedStatus = g.status;
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    _deadlineController.dispose();
    _targetController.dispose();
    _unitController.dispose();
    _currentController.dispose();
    _notesController.dispose();
    _userIdController.dispose();
    super.dispose();
  }

  void _saveGoal() {
    if (_titleController.text.isEmpty || _deadlineController.text.isEmpty) {
      Get.snackbar("Error", "Please fill Title and Deadline", backgroundColor: Colors.orange);
      return;
    }

    final data = {
      "user_id": int.tryParse(_userIdController.text) ?? 2,
      "title": _titleController.text,
      "description": _descController.text,
      "category": _selectedCategory,
      "deadline": _deadlineController.text,
      "target": int.tryParse(_targetController.text) ?? 100,
      "unit": _unitController.text,
      "current": int.tryParse(_currentController.text) ?? 0,
      "notes": _notesController.text,
    };

    if (isEditing) {
      data["status"] = _selectedStatus;
      context.read<PerformanceBloc>().add(UpdateGoal(widget.goal!.id, data));
    } else {
      context.read<PerformanceBloc>().add(CreateGoal(data));
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<PerformanceBloc, PerformanceState>(
      listener: (context, state) {
        if (state is PerformanceOperationSuccess) {
          Get.back();
          Get.snackbar("Success", state.message, backgroundColor: Colors.green, colorText: Colors.white);
        } else if (state is PerformanceError) {
          Get.snackbar("Error", state.message, backgroundColor: Colors.red, colorText: Colors.white);
        }
      },
      child: Scaffold(
        backgroundColor: Colors.grey[50],
        appBar: AppBar(
          title: Text(isEditing ? 'Edit Goal' : 'Create Goal', style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 18)),
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          elevation: 1,
          shadowColor: Colors.black12,
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildLabel('Goal Title *'),
              const SizedBox(height: 6),
              _buildTextField(_titleController, 'Enter goal title...'),
              const SizedBox(height: 16),
              _buildLabel('Description'),
              const SizedBox(height: 6),
              _buildTextField(_descController, 'Describe the goal...', maxLines: 3),
              const SizedBox(height: 16),
              _buildLabel('Assign To (User ID) *'),
              const SizedBox(height: 6),
              _buildTextField(_userIdController, 'User ID'),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildLabel('Category'),
                        const SizedBox(height: 6),
                        _buildDropdown(_selectedCategory, _categories, (val) => setState(() => _selectedCategory = val!)),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildLabel('Status'),
                        const SizedBox(height: 6),
                        _buildDropdown(_selectedStatus, _statuses, (val) => setState(() => _selectedStatus = val!)),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              _buildLabel('Deadline *'),
              const SizedBox(height: 6),
              _buildTextField(_deadlineController, 'YYYY-MM-DD'),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildLabel('Target'),
                        const SizedBox(height: 6),
                        _buildTextField(_targetController, '100'),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildLabel('Unit'),
                        const SizedBox(height: 6),
                        _buildTextField(_unitController, '%'),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildLabel('Current'),
                        const SizedBox(height: 6),
                        _buildTextField(_currentController, '0'),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              _buildLabel('Notes'),
              const SizedBox(height: 6),
              _buildTextField(_notesController, 'Additional notes...', maxLines: 3),
              const SizedBox(height: 32),
              BlocBuilder<PerformanceBloc, PerformanceState>(
                builder: (context, state) {
                  return ElevatedButton(
                    onPressed: state is PerformanceLoading ? null : _saveGoal,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.indigo,
                      foregroundColor: Colors.white,
                      minimumSize: const Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: state is PerformanceLoading
                        ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white))
                        : Text(isEditing ? 'Update Goal' : 'Create Goal', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  );
                },
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Text(text, style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.grey.shade700));
  }

  Widget _buildTextField(TextEditingController controller, String hint, {int maxLines = 1}) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 14),
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey.shade200)),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey.shade200)),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Colors.indigo)),
      ),
    );
  }

  Widget _buildDropdown(String value, List<String> items, ValueChanged<String?> onChanged) {
    return Container(
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
          icon: const Icon(Icons.keyboard_arrow_down, color: Colors.grey),
          items: items.map((e) => DropdownMenuItem(value: e, child: Text(e.capitalizeFirst!, style: const TextStyle(fontSize: 14)))).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }
}
