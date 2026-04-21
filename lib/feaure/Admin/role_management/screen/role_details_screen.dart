import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lebroid_crm/feaure/Admin/role_management/bloc/role_bloc.dart';
import 'package:lebroid_crm/feaure/Admin/role_management/bloc/role_event.dart';
import 'package:lebroid_crm/feaure/Admin/role_management/bloc/role_state.dart';

import '../data/model/role_model.dart';

class RoleDetailsScreen extends StatefulWidget {
  final int roleId;

  const RoleDetailsScreen({super.key, required this.roleId});

  @override
  State<RoleDetailsScreen> createState() => _RoleDetailsScreenState();
}

class _RoleDetailsScreenState extends State<RoleDetailsScreen> {
  Map<String, List<String>> _permissionCategories = {};
  final Set<String> _selectedPermissions = {};
  RoleModel? _role;
  bool _isLoadingPermissions = true;
  bool _isLoadingRole = true;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    context.read<RoleBloc>().add(FetchPermissionsEvent());
    context.read<RoleBloc>().add(FetchSingleRoleEvent(widget.roleId));
  }

  Map<String, List<String>> _groupPermissions(List<PermissionModel> permissions) {
    Map<String, List<String>> categories = {};
    for (var perm in permissions) {
      if (perm.name == null) continue;
      List<String> parts = perm.name!.split('.');
      if (parts.length >= 2) {
        String category = parts[0].toUpperCase();
        String permission = parts.sublist(1).join('.');
        categories.putIfAbsent(category, () => []).add(permission);
      } else {
        categories.putIfAbsent('OTHER', () => []).add(perm.name!);
      }
    }
    // Sort categories alphabetically
    var sortedKeys = categories.keys.toList()..sort();
    return {for (var k in sortedKeys) k: categories[k]!..sort()};
  }

  String _formatKey(String category, String permission) {
    if (category == 'OTHER') return permission;
    return '${category.toLowerCase()}.$permission';
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

  @override
  Widget build(BuildContext context) {
    return BlocListener<RoleBloc, RoleState>(
      listener: (context, state) {
        if (state is RoleOperationSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message), backgroundColor: Colors.green),
          );
        } else if (state is RoleError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message), backgroundColor: Colors.red),
          );
        } else if (state is PermissionsLoaded) {
          setState(() {
            _permissionCategories = _groupPermissions(state.permissions);
            _isLoadingPermissions = false;
          });
        } else if (state is SingleRoleLoaded) {
          setState(() {
            _role = state.role;
            _selectedPermissions.clear();
            if (state.role.permissions != null) {
              for (var perm in state.role.permissions!) {
                if (perm.name != null) {
                  _selectedPermissions.add(perm.name!);
                }
              }
            }
            _isLoadingRole = false;
            _isInitialized = true;
          });
          print("Role Permissions Loaded: $_selectedPermissions");
        }
      },
      child: Scaffold(
        backgroundColor: Colors.grey.shade50,
        appBar: AppBar(
          title: const Text('Role Details', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18)),
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          elevation: 1,
        ),
        body: BlocBuilder<RoleBloc, RoleState>(
          builder: (context, state) {
            if (_isLoadingPermissions || _isLoadingRole) {
              return const Center(child: CircularProgressIndicator());
            }

            if (_role == null) {
              return const Center(child: Text("Failed to load role details"));
            }

            return Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildDetailCard(
                          title: _role!.name ?? "N/A",
                          subtitle: "Guard: ${_role!.guardName ?? 'N/A'}",
                          icon: Icons.shield,
                        ),
                        const SizedBox(height: 24),
                        const Text("Permissions Management", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                        const SizedBox(height: 12),
                        _buildPermissionMatrix(),
                      ],
                    ),
                  ),
                ),
                _buildBottomBar(_role!.id),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildPermissionMatrix() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 1,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        mainAxisExtent: 300, 
      ),
      itemCount: _permissionCategories.length,
      itemBuilder: (context, index) {
        final category = _permissionCategories.keys.elementAt(index);
        final permissions = _permissionCategories[category]!;
        if (permissions.isEmpty) return const SizedBox.shrink();
        return _buildCategoryCard(category, permissions);
      },
    );
  }

  Widget _buildCategoryCard(String category, List<String> permissions) {
    bool isAllSelected = permissions.isNotEmpty && permissions.every((p) => _selectedPermissions.contains(_formatKey(category, p)));

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
              border: Border(bottom: BorderSide(color: Colors.grey.shade200)),
            ),
            child: Row(
              children: [
                Icon(Icons.widgets_outlined, size: 16, color: Colors.indigo[400]),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    category,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                  ),
                ),
                Checkbox(
                  value: isAllSelected,
                  onChanged: (_) => _toggleCategory(category),
                  activeColor: Colors.indigo,
                  visualDensity: VisualDensity.compact,
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 4),
              itemCount: permissions.length,
              itemBuilder: (context, index) {
                final permission = permissions[index];
                final key = _formatKey(category, permission);
                final isSelected = _selectedPermissions.contains(key);
                return InkWell(
                  onTap: () => _togglePermission(category, permission),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                    child: Row(
                      children: [
                        SizedBox(
                          width: 20,
                          height: 20,
                          child: Checkbox(
                            value: isSelected,
                            onChanged: (_) => _togglePermission(category, permission),
                            activeColor: Colors.indigo,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          permission,
                          style: TextStyle(
                            fontSize: 13,
                            color: isSelected ? Colors.black : Colors.grey.shade600,
                            fontWeight: isSelected ? FontWeight.w500 : FontWeight.normal,
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

  Widget _buildDetailCard({
    required String title,
    required String subtitle,
    required IconData icon,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 30,
            backgroundColor: Colors.indigo.shade50,
            child: Icon(icon, size: 30, color: Colors.indigo),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text(subtitle, style: TextStyle(fontSize: 14, color: Colors.grey.shade600)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomBar(int roleId) {
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
        children: [
          Expanded(
            child: ElevatedButton.icon(
              onPressed: () {
                context.read<RoleBloc>().add(SyncPermissionsEvent(roleId, _selectedPermissions.toList()));
              },
              icon: const Icon(Icons.sync, size: 20),
              label: const Text('SYNC PERMISSIONS', style: TextStyle(fontWeight: FontWeight.bold)),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.indigo,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
