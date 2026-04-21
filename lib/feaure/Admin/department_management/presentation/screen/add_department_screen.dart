import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lebroid_crm/feaure/Admin/department_management/logics/department_bloc.dart';
import 'package:lebroid_crm/feaure/Admin/department_management/logics/department_event.dart';
import 'package:lebroid_crm/feaure/Admin/department_management/data/model/department_model.dart';

class AddDepartmentScreen extends StatefulWidget {
  final DepartmentModel? department; // If provided, we are editing

  const AddDepartmentScreen({super.key, this.department});

  @override
  State<AddDepartmentScreen> createState() => _AddDepartmentScreenState();
}

class _AddDepartmentScreenState extends State<AddDepartmentScreen> {
  final _nameController = TextEditingController();
  final _codeController = TextEditingController();
  final _descriptionController = TextEditingController();

  bool isActive = true;
  String? selectedHead;

  final List<String> heads = [
    "— No head assigned —",
    "System Administrator",
    "HR Manager",
  ];

  @override
  void initState() {
    super.initState();
    selectedHead = heads.first;

    if (widget.department != null) {
      _nameController.text = widget.department!.name ?? '';
      _codeController.text = widget.department!.code ?? '';
      _descriptionController.text = widget.department!.description ?? '';
      isActive = widget.department!.isActive;
      // If the department has a head, try to show the name
      if (widget.department!.head != null && widget.department!.head!['name'] != null) {
        final headName = widget.department!.head!['name'];
        if (heads.contains(headName)) {
          selectedHead = headName;
        }
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _codeController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _saveDepartment() {
    if (_nameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Department Name is required')),
      );
      return;
    }

    final departmentData = {
      "name": _nameController.text.trim(),
      "code": _codeController.text.trim(),
      "description": _descriptionController.text.trim().isNotEmpty
          ? _descriptionController.text.trim()
          : null,
      "head_id": selectedHead != "— No head assigned —" ? 1 : null,
      "is_active": isActive,
    };

    if (widget.department != null) {
      context.read<DepartmentBloc>().add(UpdateDepartmentEvent(widget.department!.id, departmentData));
    } else {
      context.read<DepartmentBloc>().add(AddDepartmentEvent(departmentData));
    }
    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff5f6fa),
      appBar: AppBar(
        title: Text(widget.department != null ? 'Edit Department' : 'Add Department'),
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            /// ================= HEADER =================
            const Text(
              "Department Information",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 20),

            /// ================= NAME =================
            _buildTextField(
              label: "Department Name *",
              hint: "e.g. Human Resources",
              controller: _nameController,
            ),

            /// ================= CODE =================
            _buildTextField(
              label: "Code *",
              hint: "e.g. HR",
              helperText: "Max 10 characters",
              controller: _codeController,
            ),

            const SizedBox(height: 10),

            /// ================= ACTIVE =================
            Row(
              children: [
                const Text(
                  "Active",
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                const Spacer(),
                Switch(
                  value: isActive,
                  onChanged: (val) {
                    setState(() => isActive = val);
                  },
                ),
              ],
            ),

            const SizedBox(height: 16),

            /// ================= DESCRIPTION =================
            _buildTextField(
              label: "Description",
              hint: "Brief description of this department's responsibilities…",
              maxLines: 3,
              controller: _descriptionController,
            ),

            const SizedBox(height: 16),

            /// ================= DEPARTMENT HEAD =================
            _buildDropdown(
              label: "Department Head",
              value: selectedHead!,
              items: heads,
              onChanged: (val) {
                setState(() => selectedHead = val);
              },
            ),

            const SizedBox(height: 6),

            Text(
              "Only active employees are listed.",
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey.shade600,
              ),
            ),

            const SizedBox(height: 30),

            /// ================= BUTTON =================
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _saveDepartment,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  widget.department != null ? "Update Department" : "Save Department",
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  /// ================= TEXT FIELD =================
  Widget _buildTextField({
    required String label,
    required String hint,
    required TextEditingController controller,
    String? helperText,
    int maxLines = 1,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
              style: const TextStyle(
                  fontWeight: FontWeight.w600, fontSize: 13)),
          const SizedBox(height: 6),
          TextField(
            controller: controller,
            maxLines: maxLines,
            decoration: InputDecoration(
              hintText: hint,
              helperText: helperText,
              filled: true,
              fillColor: Colors.white,
              contentPadding:
              const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide:
                BorderSide(color: Colors.grey.shade300),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide:
                BorderSide(color: Colors.grey.shade300),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// ================= DROPDOWN =================
  Widget _buildDropdown({
    required String label,
    required String value,
    required List<String> items,
    required Function(String?) onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
              style: const TextStyle(
                  fontWeight: FontWeight.w600, fontSize: 13)),
          const SizedBox(height: 6),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: DropdownButton<String>(
              value: items.contains(value) ? value : items.first,
              isExpanded: true,
              underline: const SizedBox(),
              items: items
                  .map((e) => DropdownMenuItem(
                value: e,
                child: Text(e),
              ))
                  .toList(),
              onChanged: onChanged,
            ),
          ),
        ],
      ),
    );
  }
}
