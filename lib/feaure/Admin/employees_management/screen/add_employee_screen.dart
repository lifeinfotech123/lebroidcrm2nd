import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lebroid_crm/feaure/Admin/employees_management/bloc/employee_bloc.dart';
import 'package:lebroid_crm/feaure/Admin/employees_management/bloc/employee_event.dart';
import 'package:lebroid_crm/feaure/Admin/employees_management/data/model/employee_model.dart';

class AddEmployeeScreen extends StatefulWidget {
  final EmployeeModel? employee; // If provided, we are editing

  const AddEmployeeScreen({super.key, this.employee});

  @override
  State<AddEmployeeScreen> createState() => _AddEmployeeScreenState();
}

class _AddEmployeeScreenState extends State<AddEmployeeScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _employeeIdController = TextEditingController();
  final _designationController = TextEditingController();
  final _addressController = TextEditingController();
  final _dobController = TextEditingController();
  final _joiningDateController = TextEditingController();

  String _selectedGender = 'male';
  String _selectedDepartment = '1';
  String _selectedBranch = '1';
  String _selectedType = 'full-time';
  String _selectedStatus = 'active';
  String _selectedRole = 'employee';

  bool get isEditing => widget.employee != null;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);

    if (isEditing) {
      final emp = widget.employee!;
      _nameController.text = emp.name ?? '';
      _emailController.text = emp.email ?? '';
      _phoneController.text = emp.phone ?? '';
      _employeeIdController.text = emp.employeeId ?? '';
      _designationController.text = emp.designation ?? '';
      _addressController.text = emp.address ?? '';
      _dobController.text = emp.dateOfBirth ?? '';
      _joiningDateController.text = emp.joiningDate?.substring(0, 10) ?? '';
      _selectedGender = emp.gender ?? 'male';
      _selectedDepartment = emp.departmentId?.toString() ?? '1';
      _selectedBranch = emp.branchId?.toString() ?? '1';
      _selectedType = emp.employmentType ?? 'full-time';
      _selectedStatus = emp.status ?? 'active';
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _employeeIdController.dispose();
    _designationController.dispose();
    _addressController.dispose();
    _dobController.dispose();
    _joiningDateController.dispose();
    super.dispose();
  }

  void _saveEmployee() {
    if (_nameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Full Name is required')),
      );
      return;
    }
    if (_emailController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Email is required')),
      );
      return;
    }

    final employeeData = <String, dynamic>{
      "name": _nameController.text.trim(),
      "email": _emailController.text.trim(),
      "employee_id": _employeeIdController.text.trim(),
      "branch_id": int.tryParse(_selectedBranch) ?? 1,
      "department_id": int.tryParse(_selectedDepartment) ?? 1,
      "role": _selectedRole,
    };

    // Only include password for creation or if explicitly changed
    if (!isEditing && _passwordController.text.trim().isNotEmpty) {
      employeeData["password"] = _passwordController.text.trim();
    } else if (isEditing && _passwordController.text.trim().isNotEmpty) {
      employeeData["password"] = _passwordController.text.trim();
    }

    // Optional fields
    if (_phoneController.text.trim().isNotEmpty) {
      employeeData["phone"] = _phoneController.text.trim();
    }
    if (_designationController.text.trim().isNotEmpty) {
      employeeData["designation"] = _designationController.text.trim();
    }
    if (_addressController.text.trim().isNotEmpty) {
      employeeData["address"] = _addressController.text.trim();
    }
    employeeData["gender"] = _selectedGender;
    employeeData["employment_type"] = _selectedType;
    employeeData["status"] = _selectedStatus;

    if (isEditing) {
      context.read<EmployeeBloc>().add(UpdateEmployeeEvent(widget.employee!.id, employeeData));
    } else {
      context.read<EmployeeBloc>().add(AddEmployeeEvent(employeeData));
    }
    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text(isEditing ? 'Edit Employee' : 'Add Employee', style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 18)),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 1,
        shadowColor: Colors.black12,
        bottom: TabBar(
          controller: _tabController,
          labelColor: Colors.indigo,
          unselectedLabelColor: Colors.grey[600],
          indicatorColor: Colors.indigo,
          indicatorWeight: 3,
          labelStyle: const TextStyle(fontWeight: FontWeight.bold),
          tabs: const [
            Tab(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [Icon(Icons.person_outline, size: 20), SizedBox(width: 8), Text('Personal Info')],
              ),
            ),
            Tab(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [Icon(Icons.work_outline, size: 20), SizedBox(width: 8), Text('Employment')],
              ),
            ),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildPersonalInfoTab(),
          _buildEmploymentTab(),
        ],
      ),
      bottomNavigationBar: _buildBottomBar(),
    );
  }

  Widget _buildPersonalInfoTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Personal Information', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 4),
          Text('Basic details about the employee.', style: TextStyle(color: Colors.grey[600], fontSize: 13)),
          const SizedBox(height: 24),
          Center(
            child: Column(
              children: [
                Stack(
                  alignment: Alignment.bottomRight,
                  children: [
                    CircleAvatar(
                      radius: 40,
                      backgroundColor: Colors.grey.shade200,
                      child: Icon(Icons.camera_alt_outlined, size: 30, color: Colors.grey.shade500),
                    ),
                    Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(color: Colors.indigo, shape: BoxShape.circle),
                      child: const Icon(Icons.add, color: Colors.white, size: 16),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text('Upload profile photo', style: TextStyle(color: Colors.indigo.shade700, fontWeight: FontWeight.w600, fontSize: 13)),
                const SizedBox(height: 4),
                Text('Max size: 2MB (PNG, JPG, JPEG)', style: TextStyle(color: Colors.grey[500], fontSize: 11)),
              ],
            ),
          ),
          const SizedBox(height: 32),
          _buildTextFieldWithController('Full Name *', 'Enter full name', Icons.person_outline, _nameController),
          const SizedBox(height: 16),
          _buildTextFieldWithController('Email Address *', 'admin@example.com', Icons.email_outlined, _emailController),
          const SizedBox(height: 16),
          _buildTextFieldWithController('Phone Number', 'Enter phone', Icons.phone_outlined, _phoneController),
          const SizedBox(height: 16),
          _buildDropdownWithValue('Gender', _selectedGender, ['male', 'female', 'other'], (val) {
            if (val != null) setState(() => _selectedGender = val);
          }),
          const SizedBox(height: 16),
          _buildTextFieldWithController('Date of Birth', 'yyyy-mm-dd', Icons.calendar_today_outlined, _dobController),
          const SizedBox(height: 16),
          _buildTextFieldWithController('Address', 'Enter address', Icons.location_on_outlined, _addressController, maxLines: 3),
          const SizedBox(height: 32),
          const Text('Set Password *', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 4),
          Text(isEditing ? 'Leave blank to keep current password.' : 'Employee will use this password to login.',
              style: TextStyle(color: Colors.grey[600], fontSize: 13)),
          const SizedBox(height: 16),
          _buildTextFieldWithController('Password', '••••••••', Icons.lock_outline, _passwordController, obscureText: true),
          const SizedBox(height: 16),
          _buildTextFieldWithController('Confirm Password', 'Re-enter password', Icons.lock_outline, _confirmPasswordController, obscureText: true),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildEmploymentTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Employment Details', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 4),
          Text('Work-related information for this employee.', style: TextStyle(color: Colors.grey[600], fontSize: 13)),
          const SizedBox(height: 24),
          _buildTextFieldWithController('Employee ID', 'e.g. EMP001', Icons.tag, _employeeIdController),
          const SizedBox(height: 16),
          _buildTextFieldWithController('Designation / Role', 'e.g. Software Engineer', Icons.badge_outlined, _designationController),
          const SizedBox(height: 16),
          _buildDropdownWithValue('Department', _selectedDepartment, ['1', '2', '3', '4', '5'], (val) {
            if (val != null) setState(() => _selectedDepartment = val);
          }),
          const SizedBox(height: 16),
          _buildDropdownWithValue('Employment Type *', _selectedType, ['full-time', 'part-time', 'contract'], (val) {
            if (val != null) setState(() => _selectedType = val);
          }),
          const SizedBox(height: 16),
          _buildDropdownWithValue('Status *', _selectedStatus, ['active', 'inactive', 'on_leave', 'terminated'], (val) {
            if (val != null) setState(() => _selectedStatus = val);
          }),
          const SizedBox(height: 16),
          _buildTextFieldWithController('Joining Date', 'yyyy-mm-dd', Icons.calendar_today_outlined, _joiningDateController),
          const SizedBox(height: 16),
          _buildDropdownWithValue('Branch', _selectedBranch, ['1', '2', '3'], (val) {
            if (val != null) setState(() => _selectedBranch = val);
          }),
          const SizedBox(height: 16),
          _buildDropdownWithValue('Role', _selectedRole, ['employee', 'manager', 'admin'], (val) {
            if (val != null) setState(() => _selectedRole = val);
          }),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildTextFieldWithController(String label, String hint, IconData icon, TextEditingController controller, {int maxLines = 1, bool obscureText = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(label.replaceAll(' *', ''), style: TextStyle(fontWeight: FontWeight.w500, fontSize: 13, color: Colors.grey.shade800)),
            if (label.contains('*')) const Text(' *', style: TextStyle(color: Colors.red, fontSize: 13)),
          ],
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          maxLines: maxLines,
          obscureText: obscureText,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 14),
            prefixIcon: maxLines == 1 ? Icon(icon, color: Colors.grey.shade500, size: 20) : null,
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: Colors.grey.shade300)),
            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: Colors.grey.shade300)),
            focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Colors.indigo, width: 2)),
          ),
        ),
      ],
    );
  }

  Widget _buildDropdownWithValue(String label, String value, List<String> items, Function(String?) onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(label.replaceAll(' *', ''), style: TextStyle(fontWeight: FontWeight.w500, fontSize: 13, color: Colors.grey.shade800)),
            if (label.contains('*')) const Text(' *', style: TextStyle(color: Colors.red, fontSize: 13)),
          ],
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              isExpanded: true,
              value: items.contains(value) ? value : items.first,
              icon: const Icon(Icons.keyboard_arrow_down, color: Colors.grey),
              items: items.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
              onChanged: onChanged,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBottomBar() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton(
              onPressed: () => Navigator.pop(context),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 14),
                side: BorderSide(color: Colors.grey.shade300),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              child: Text('Cancel', style: TextStyle(color: Colors.grey.shade700, fontWeight: FontWeight.bold)),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: ElevatedButton.icon(
              onPressed: _saveEmployee,
              icon: const Icon(Icons.save_outlined, size: 20),
              label: Text(isEditing ? 'Update Employee' : 'Save Employee', style: const TextStyle(fontWeight: FontWeight.bold)),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.indigo,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                elevation: 0,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
