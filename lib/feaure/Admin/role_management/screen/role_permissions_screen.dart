import 'package:flutter/material.dart';

class UserData {
  final String avatarInitial;
  final String name;
  final String email;
  final String empCode;
  final String department;
  final String designation;
  final String role;
  final String status;

  UserData({
    required this.avatarInitial,
    required this.name,
    required this.email,
    required this.empCode,
    required this.department,
    required this.designation,
    required this.role,
    required this.status,
  });
}

class RolePermissionsScreen extends StatefulWidget {
  const RolePermissionsScreen({super.key});

  @override
  State<RolePermissionsScreen> createState() => _RolePermissionsScreenState();
}

class _RolePermissionsScreenState extends State<RolePermissionsScreen> {
  String _selectedRole = 'All Roles';
  String _selectedDepartment = 'All Departments';
  String _selectedStatus = 'All Status';

  final List<UserData> _users = [
    UserData(avatarInitial: 'A', name: 'Amit Kumar', email: 'employee@gmail.com', empCode: 'LEB-005', department: 'Information Technology', designation: 'Software Developer', role: 'employee', status: 'active'),
    UserData(avatarInitial: 'K', name: 'Kavita Patel', email: 'kavita@gmail.com', empCode: 'LEB-006', department: 'Sales & Marketing', designation: 'Sales Executive', role: 'employee', status: 'active'),
    UserData(avatarInitial: 'N', name: 'Neha Singh', email: 'neha@gmail.com', empCode: 'LEB-008', department: 'Medical Affairs', designation: 'Medical Representative', role: 'employee', status: 'active'),
    UserData(avatarInitial: 'P', name: 'Pooja Verma', email: 'pooja@gmail.com', empCode: 'LEB-010', department: 'Information Technology', designation: 'QA Engineer', role: 'employee', status: 'active'),
    UserData(avatarInitial: 'P', name: 'Priya Sharma', email: 'hr@gmail.com', empCode: 'LEB-002', department: 'Human Resources', designation: 'HR Manager', role: 'manager', status: 'active'),
    UserData(avatarInitial: 'R', name: 'Rahul Mehta', email: 'it.head@gmail.com', empCode: 'LEB-003', department: 'Information Technology', designation: 'IT Head', role: 'manager', status: 'active'),
    UserData(avatarInitial: 'R', name: 'Ravi Gupta', email: 'ravi@gmail.com', empCode: 'LEB-007', department: 'Operations', designation: 'Operations Executive', role: 'employee', status: 'active'),
    UserData(avatarInitial: 'S', name: 'Sunita Rao', email: 'accounts@gmail.com', empCode: 'LEB-004', department: 'Accounts & Finance', designation: 'Accounts Manager', role: 'manager', status: 'active'),
    UserData(avatarInitial: 'S', name: 'Suresh Nair', email: 'suresh@gmail.com', empCode: 'LEB-009', department: 'Accounts & Finance', designation: 'Accountant', role: 'employee', status: 'active'),
    UserData(avatarInitial: 'S', name: 'System Administrator', email: 'admin@gmail.com', empCode: 'LEB-001', department: 'Human Resources', designation: 'System Administrator', role: 'admin', status: 'active'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text('Role Permissions', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18)),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 1,
        shadowColor: Colors.black12,
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {},
          ),
        ],
      ),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildStatsSection(),
                  const SizedBox(height: 20),
                  _buildFilters(),
                  const SizedBox(height: 8),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 8.0),
                    child: Text(
                      '${_users.length} user(s)',
                      style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15, color: Colors.grey[800]),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0).copyWith(bottom: 24.0),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  return _buildEmployeeCard(_users[index]);
                },
                childCount: _users.length,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsSection() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(child: _buildStatCard('Total Users', '10', Colors.blue, Icons.people_outline)),
            const SizedBox(width: 12),
            Expanded(child: _buildStatCard('Role Assigned', '10', Colors.green, Icons.check_circle_outline)),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(child: _buildStatCard('No Role Yet', '0', Colors.orange, Icons.hourglass_empty)),
            const SizedBox(width: 12),
            Expanded(child: _buildStatCard('Total Roles', '3', Colors.purple, Icons.admin_panel_settings_outlined)),
          ],
        ),
      ],
    );
  }

  Widget _buildStatCard(String title, String value, Color color, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: color, size: 20),
              ),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            title,
            style: TextStyle(
              fontSize: 13,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilters() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      child: Row(
        children: [
          _buildFilterDropdown(
            value: _selectedRole,
            items: ['All Roles', 'admin', 'manager', 'employee'],
            onChanged: (val) {
              if (val != null) setState(() => _selectedRole = val);
            },
            icon: Icons.shield_outlined,
          ),
          const SizedBox(width: 10),
          _buildFilterDropdown(
            value: _selectedDepartment,
            items: [
              'All Departments',
              'Information Technology',
              'Sales & Marketing',
              'Medical Affairs',
              'Human Resources',
              'Operations',
              'Accounts & Finance'
            ],
            onChanged: (val) {
              if (val != null) setState(() => _selectedDepartment = val);
            },
            icon: Icons.business_outlined,
          ),
          const SizedBox(width: 10),
          _buildFilterDropdown(
            value: _selectedStatus,
            items: ['All Status', 'active', 'inactive'],
            onChanged: (val) {
              if (val != null) setState(() => _selectedStatus = val);
            },
            icon: Icons.check_circle_outline,
          ),
        ],
      ),
    );
  }

  Widget _buildFilterDropdown({
    required String value,
    required List<String> items,
    required Function(String?) onChanged,
    required IconData icon,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          icon: const Icon(Icons.arrow_drop_down, color: Colors.indigo),
          iconSize: 20,
          elevation: 4,
          style: TextStyle(color: Colors.grey.shade800, fontSize: 13, fontWeight: FontWeight.w500),
          onChanged: onChanged,
          items: items.map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Row(
                children: [
                  Icon(icon, size: 16, color: Colors.grey.shade600),
                  const SizedBox(width: 6),
                  Text(value),
                ],
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildEmployeeCard(UserData user) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 26,
                  backgroundColor: Colors.indigo.shade50,
                  foregroundColor: Colors.indigo,
                  child: Text(
                    user.avatarInitial,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        user.name,
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.black87),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        user.email,
                        style: TextStyle(color: Colors.grey[600], fontSize: 13),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        user.empCode,
                        style: TextStyle(color: Colors.grey.shade800, fontWeight: FontWeight.w600, fontSize: 11),
                      ),
                    ),
                    const SizedBox(height: 6),
                    _buildStatusBadge(user.status),
                  ],
                ),
              ],
            ),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 14.0),
              child: Divider(height: 1),
            ),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Department', style: TextStyle(color: Colors.grey[500], fontSize: 11)),
                      const SizedBox(height: 4),
                      Text(user.department, style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 13, color: Colors.black87)),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Designation', style: TextStyle(color: Colors.grey[500], fontSize: 11)),
                      const SizedBox(height: 4),
                      Text(user.designation, style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 13, color: Colors.black87)),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.grey.shade100),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Text('Role: ', style: TextStyle(color: Colors.grey[600], fontSize: 13)),
                      _buildRoleBadge(user.role),
                    ],
                  ),
                  SizedBox(
                    height: 32,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Assigning role to ${user.name}')),
                        );
                      },
                      icon: const Icon(Icons.shield_outlined, size: 16),
                      label: const Text('Assign', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                      style: ElevatedButton.styleFrom(
                        elevation: 0,
                        backgroundColor: Colors.indigo,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRoleBadge(String role) {
    Color bgColor;
    Color textColor;
    switch (role.toLowerCase()) {
      case 'admin':
        bgColor = Colors.red.shade50;
        textColor = Colors.red.shade700;
        break;
      case 'manager':
        bgColor = Colors.orange.shade50;
        textColor = Colors.orange.shade700;
        break;
      default:
        bgColor = Colors.blue.shade50;
        textColor = Colors.blue.shade700;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: textColor.withOpacity(0.3)),
      ),
      child: Text(
        role.toUpperCase(),
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w800,
          color: textColor,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  Widget _buildStatusBadge(String status) {
    bool isActive = status.toLowerCase() == 'active';
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: isActive ? Colors.green.shade50 : Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        status.toUpperCase(),
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.bold,
          color: isActive ? Colors.green.shade700 : Colors.grey.shade700,
        ),
      ),
    );
  }
}
