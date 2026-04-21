import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lebroid_crm/feaure/Admin/role_management/bloc/role_bloc.dart';
import 'package:lebroid_crm/feaure/Admin/role_management/bloc/role_event.dart';
import 'package:lebroid_crm/feaure/Admin/role_management/bloc/role_state.dart';
import 'package:lebroid_crm/feaure/Admin/role_management/data/model/role_model.dart';

class AddRoleScreen extends StatefulWidget {
  final RoleModel? role;

  const AddRoleScreen({super.key, this.role});

  @override
  State<AddRoleScreen> createState() => _AddRoleScreenState();
}

class _AddRoleScreenState extends State<AddRoleScreen> {
  final TextEditingController _roleNameController = TextEditingController();

  final Map<String, List<String>> _permissionCategories = {
    'ADMIN': ['systemConfig', 'userManagement'],
    'ALLOWANCE': ['manage'],
    'ATTENDANCE': ['correction', 'create', 'delete', 'export', 'update', 'view', 'viewAny', 'viewOwn'],
    'AUDIT': ['export', 'view'],
    'BRANCH': ['create', 'delete', 'update', 'view', 'viewAny'],
    'BREAK': ['create', 'update', 'viewAny', 'viewOwn'],
    'BREAKTYPE': ['manage'],
    'COMPLIANCE': ['view'],
    'DASHBOARD': ['admin', 'employee', 'manager'],
    'DEDUCTION': ['manage'],
    'DEPARTMENT': ['create', 'delete', 'update', 'view', 'viewAny'],
    'EMPLOYEE': ['create', 'delete', 'export', 'update', 'view', 'viewAny'],
    'EXPENSE': ['approve', 'create', 'delete', 'export', 'update', 'view', 'viewAny', 'viewOwn'],
    'EXPENSECATEGORY': ['manage'],
    'HOLIDAY': ['manage'],
    'KPI': ['manage'],
    'LEAVE': ['approve', 'create', 'delete', 'export', 'reject', 'update', 'view', 'viewAny', 'viewOwn'],
    'LEAVETYPE': ['manage'],
    'NOTIFICATION': ['manage', 'viewAll', 'viewOwn'],
    'OVERTIME': ['approve', 'create', 'viewAny', 'viewOwn'],
    'PAYROLL': ['approve', 'create', 'export', 'process', 'view', 'viewAny', 'viewOwn'],
    'PERFORMANCE': ['create', 'update', 'view', 'viewAny', 'viewOwn'],
    'PERMISSION': [],
    'REPORT': ['custom', 'export', 'view'],
    'ROLE': ['viewAny', 'create', 'update', 'delete'],
    'SALARY': ['create', 'update', 'view', 'viewAny', 'viewOwn', 'payslip'],
    'SETTINGS': ['update', 'view'],
    'SHIFT': ['assign', 'create', 'delete', 'update', 'view', 'viewAny'],
    'TASK': ['approve', 'create', 'delete', 'export', 'reassign', 'update', 'view', 'viewAny', 'viewOwn'],
    'TICKET': ['assign', 'close', 'create', 'update', 'viewAny', 'viewOwn'],
  };

  final Set<String> _selectedPermissions = {};
  int _totalPermissions = 0;

  @override
  void initState() {
    super.initState();
    _totalPermissions = _permissionCategories.values.fold(0, (sum, list) => sum + list.length);

    if (widget.role != null) {
      _roleNameController.text = widget.role!.name ?? '';
      if (widget.role!.permissions != null) {
        for (var perm in widget.role!.permissions!) {
           // JSON gives name like 'employee.viewAny'
           if (perm.name != null && perm.name!.contains('.')) {
              _selectedPermissions.add(perm.name!);
           }
        }
      }
    }
  }

  @override
  void dispose() {
    _roleNameController.dispose();
    super.dispose();
  }

  String _formatKey(String category, String permission) {
    // We convert 'ADMIN_systemConfig' to 'admin.systemConfig' essentially.
    return '${category.toLowerCase()}.$permission';
  }

  void _selectAll() {
    setState(() {
      _selectedPermissions.clear();
      for (var category in _permissionCategories.keys) {
        for (var permission in _permissionCategories[category]!) {
          _selectedPermissions.add(_formatKey(category, permission));
        }
      }
    });
  }

  void _clearAll() {
    setState(() {
      _selectedPermissions.clear();
    });
  }

  void _toggleCategory(String category) {
    setState(() {
      final permissions = _permissionCategories[category];
      if (permissions == null || permissions.isEmpty) return;
      
      bool allSelected = permissions.every((p) => _selectedPermissions.contains(_formatKey(category, p)));
      if (allSelected) {
        for (var p in permissions) {
          _selectedPermissions.remove(_formatKey(category, p));
        }
      } else {
        for (var p in permissions) {
          _selectedPermissions.add(_formatKey(category, p));
        }
      }
    });
  }

  void _togglePermission(String category, String permission) {
    setState(() {
      final key = _formatKey(category, permission);
      if (_selectedPermissions.contains(key)) {
        _selectedPermissions.remove(key);
      } else {
        _selectedPermissions.add(key);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text(widget.role == null ? 'Add Role' : 'Edit Role', style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 18)),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 1,
        shadowColor: Colors.black12,
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildRoleDetailsSection(),
                  const SizedBox(height: 24),
                  _buildPermissionMatrixSection(),
                ],
              ),
            ),
          ),
          _buildBottomBar(),
        ],
      ),
    );
  }

  Widget _buildRoleDetailsSection() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.info_outline, color: Colors.indigo[400], size: 20),
              const SizedBox(width: 8),
              const Text(
                'Role Details',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ],
          ),
          const SizedBox(height: 24),
          const Text.rich(
            TextSpan(
              text: 'Role Name ',
              style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
              children: [
                TextSpan(
                  text: '*',
                  style: TextStyle(color: Colors.red),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          TextFormField(
            controller: _roleNameController,
            decoration: InputDecoration(
              hintText: 'e.g. hr-manager',
              hintStyle: TextStyle(color: Colors.grey[400]),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Colors.indigo[200]!),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Colors.indigo[200]!),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Colors.indigo[400]!, width: 2),
              ),
            ),
          ),
          const SizedBox(height: 8),
          if (_roleNameController.text.isEmpty)
            const Text(
              'The name field is required.',
              style: TextStyle(color: Colors.red, fontSize: 12),
            ),
          const SizedBox(height: 4),
          Text(
            'Use lowercase with hyphens (e.g. hr-manager)',
            style: TextStyle(color: Colors.grey[600], fontSize: 12),
          ),
        ],
      ),
    );
  }

  Widget _buildPermissionMatrixSection() {
    final progress = _totalPermissions > 0 ? _selectedPermissions.length / _totalPermissions : 0.0;
    
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Row 1: icon + title
                Row(
                  children: [
                    Icon(Icons.key, color: Colors.indigo[400], size: 20),
                    const SizedBox(width: 8),
                    const Text(
                      'Permission Matrix',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.indigo[50],
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    '${_selectedPermissions.length} selected',
                    style: TextStyle(color: Colors.indigo[700], fontSize: 12, fontWeight: FontWeight.bold),
                  ),
                ),
                // Row 2: badge + spacer + action buttons
                Row(
                  children: [

                    const Spacer(),
                    TextButton.icon(
                      onPressed: _selectAll,
                      icon: const Icon(Icons.check_box_outlined, size: 18),
                      label: const Text('SELECT ALL'),
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.grey[700],
                      ),
                    ),
                    TextButton.icon(
                      onPressed: _clearAll,
                      icon: const Icon(Icons.check_box_outline_blank, size: 18),
                      label: const Text('CLEAR ALL'),
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.grey[700],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${_selectedPermissions.length} of $_totalPermissions permissions assigned',
                      style: TextStyle(color: Colors.grey[600], fontSize: 12),
                    ),
                    Text(
                      '${(progress * 100).toInt()}%',
                      style: TextStyle(color: Colors.grey[600], fontSize: 12),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                LinearProgressIndicator(
                  value: progress,
                  backgroundColor: Colors.grey[200],
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.indigo[400]!),
                  minHeight: 6,
                  borderRadius: BorderRadius.circular(3),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: LayoutBuilder(
              builder: (context, constraints) {
                // Determine number of columns based on width
                int crossAxisCount = 1;
                if (constraints.maxWidth > 1200) {
                  crossAxisCount = 4;
                } else if (constraints.maxWidth > 800) {
                  crossAxisCount = 3;
                } else if (constraints.maxWidth > 500) {
                  crossAxisCount = 2;
                }
                
                return GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: crossAxisCount,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    mainAxisExtent: 320, // fixed height for cards
                  ),
                  itemCount: _permissionCategories.length,
                  itemBuilder: (context, index) {
                    final category = _permissionCategories.keys.elementAt(index);
                    final permissions = _permissionCategories[category]!;
                    return _buildCategoryCard(category, permissions);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryCard(String category, List<String> permissions) {
    bool isAllSelected = permissions.isNotEmpty && permissions.every((p) => _selectedPermissions.contains(_formatKey(category, p)));
    
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
              border: Border(bottom: BorderSide(color: Colors.grey.shade200)),
            ),
            child: Row(
              children: [
                Icon(Icons.widgets_outlined, size: 16, color: Colors.grey[600]),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    category,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                      color: Colors.grey[800],
                    ),
                  ),
                ),
                SizedBox(
                  width: 24,
                  height: 24,
                  child: Checkbox(
                    value: isAllSelected,
                    onChanged: permissions.isEmpty ? null : (_) => _toggleCategory(category),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                    activeColor: Colors.indigo,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 8),
              itemCount: permissions.length,
              itemBuilder: (context, index) {
                final permission = permissions[index];
                final isSelected = _selectedPermissions.contains(_formatKey(category, permission));
                return InkWell(
                  onTap: () => _togglePermission(category, permission),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Row(
                      children: [
                        SizedBox(
                          width: 20,
                          height: 20,
                          child: Checkbox(
                            value: isSelected,
                            onChanged: (_) => _togglePermission(category, permission),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                            activeColor: Colors.indigo,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: _getPermissionColor(permission).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            permission,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: _getPermissionColor(permission),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Color _getPermissionColor(String permission) {
    switch (permission.toLowerCase()) {
      case 'create':
      case 'assign':
        return Colors.green;
      case 'delete':
      case 'reject':
        return Colors.red;
      case 'update':
      case 'correction':
        return Colors.orange;
      case 'view':
      case 'viewany':
      case 'viewown':
      case 'viewall':
      case 'payslip':
        return Colors.blue;
      case 'export':
      case 'custom':
        return Colors.purple;
      case 'approve':
        return Colors.teal;
      case 'systemconfig':
      case 'usermanagement':
      case 'admin':
      case 'employee':
      case 'manager':
        return Colors.indigo;
      case 'manage':
        return Colors.black87;
      default:
        return Colors.grey.shade700;
    }
  }

  Widget _buildBottomBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            offset: const Offset(0, -2),
            blurRadius: 10,
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              foregroundColor: Colors.grey[800],
            ),
            child: const Text('CANCEL', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
          const SizedBox(width: 16),
          ElevatedButton.icon(
            onPressed: () {
              final roleData = {
                'name': _roleNameController.text.trim(),
                'permissions': _selectedPermissions.toList(),
              };

              if (widget.role != null) {
                context.read<RoleBloc>().add(UpdateRoleEvent(widget.role!.id, roleData));
              } else {
                context.read<RoleBloc>().add(AddRoleEvent(roleData));
              }

              Navigator.pop(context, true);
            },
            icon: const Icon(Icons.shield_outlined, size: 20),
            label: Text(widget.role != null ? 'UPDATE ROLE' : 'CREATE ROLE', style: const TextStyle(fontWeight: FontWeight.bold)),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.indigo,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
