import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lebroid_crm/feaure/Admin/role_management/bloc/role_bloc.dart';
import 'package:lebroid_crm/feaure/Admin/role_management/bloc/role_event.dart';
import 'package:lebroid_crm/feaure/Admin/role_management/bloc/role_state.dart';
import 'package:lebroid_crm/feaure/Admin/role_management/data/repository/role_repository.dart';
import 'package:lebroid_crm/feaure/Admin/role_management/data/model/role_model.dart';
import 'add_role_screen.dart';
import 'role_details_screen.dart';

class RoleListScreen extends StatelessWidget {
  const RoleListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    context.read<RoleBloc>().add(LoadRolesEvent());

    return Scaffold(
      backgroundColor: Colors.grey[50], // Match the light background of the image
      appBar: AppBar(
        title: const Text('Role List', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18)),
        backgroundColor: Colors.white,
        elevation: 1,
        foregroundColor: Colors.black,
        shadowColor: Colors.black12,
      ),
      body: BlocConsumer<RoleBloc, RoleState>(
          listener: (context, state) {
            if (state is RoleOperationSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.message), backgroundColor: Colors.green));
            } else if (state is RoleError) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.message), backgroundColor: Colors.red));
            }
          },
          builder: (context, state) {
            if (state is RoleLoading || state is RoleInitial) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is RoleLoaded) {
              final roles = state.roles;
              return SingleChildScrollView(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSummaryRow(context, roles),
                    const SizedBox(height: 32),
                    _buildRoleCardsGrid(context, roles),
                  ],
                ),
              );
            } else if (state is RoleError) {
              return Center(child: Text(state.message));
            }
            return const SizedBox();
          },
        ),
        floatingActionButton: Builder(
          builder: (context) {
            return FloatingActionButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const AddRoleScreen()
                  ),
                ).then((value) {
                  if (value == true) {
                     context.read<RoleBloc>().add(LoadRolesEvent());
                  }
                });
              },
              child: const Icon(Icons.add),
            );
          }
        ),
    );
  }

  Widget _buildSummaryRow(BuildContext context, List<RoleModel> roles) {
    int totalPermissionsAssigned = 0;
    int totalUsers = 0;

    for (var role in roles) {
      totalPermissionsAssigned += role.permissions?.length ?? 0;
      totalUsers += role.usersCount ?? 0;
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        int crossAxisCount = 3;
        if (constraints.maxWidth < 600) {
          crossAxisCount = 1;
        } else if (constraints.maxWidth < 900) {
          crossAxisCount = 2;
        }

        return GridView.count(
          crossAxisCount: crossAxisCount,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: constraints.maxWidth < 600 ? 3 : 2.5,
          children: [
            _buildSummaryCard(
              title: 'Total Roles',
              value: roles.length.toString(),
              icon: Icons.shield_outlined,
              iconColor: Colors.indigo,
              iconBgColor: Colors.indigo.withOpacity(0.1),
            ),
            _buildSummaryCard(
              title: 'Permissions Assigned',
              value: totalPermissionsAssigned.toString(),
              icon: Icons.key_outlined,
              iconColor: Colors.orange,
              iconBgColor: Colors.orange.withOpacity(0.1),
            ),
            _buildSummaryCard(
              title: 'Total Users',
              value: totalUsers.toString(),
              icon: Icons.people_outline,
              iconColor: Colors.teal,
              iconBgColor: Colors.teal.withOpacity(0.1),
            ),
          ],
        );
      },
    );
  }

  Widget _buildSummaryCard({
    required String title,
    required String value,
    required IconData icon,
    required Color iconColor,
    required Color iconBgColor,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                title,
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                value,
                style: const TextStyle(
                  color: Colors.black87,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: iconBgColor,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: iconColor, size: 24),
          ),
        ],
      ),
    );
  }

  Widget _buildRoleCardsGrid(BuildContext context, List<RoleModel> roles) {
    if (roles.isEmpty) {
       return const Center(child: Text("No roles found"));
    }
    return LayoutBuilder(
      builder: (context, constraints) {
        int crossAxisCount = 3;
        if (constraints.maxWidth < 600) {
          crossAxisCount = 1;
        } else if (constraints.maxWidth < 1100) {
          crossAxisCount = 2;
        }

        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 0.9, // Adjust height
          ),
          itemCount: roles.length,
          itemBuilder: (context, index) {
            return _buildRoleCard(context, roles[index]);
          },
        );
      },
    );
  }

  Widget _buildRoleCard(BuildContext context, RoleModel role) {
    final bool isActive = true; // For simulation, assuming all are active currently
    final activeColor = Colors.green; // for active color logic later
    final borderColor = isActive ? activeColor : Colors.grey.shade300;
    final iconColor = isActive ? activeColor : Colors.indigo;
    final iconBgColor = isActive ? activeColor.withOpacity(0.1) : Colors.grey.shade50;
    
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: borderColor, width: isActive ? 1.5 : 1),
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: iconBgColor,
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.shield_outlined, color: iconColor, size: 20),
              ),
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red, size: 20),
                    onPressed: () {
                      _showDeleteConfirm(context, role.id);
                    },
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    icon: const Icon(Icons.edit, color: Colors.blue, size: 20),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => AddRoleScreen(role: role),
                        ),
                      ).then((value) {
                         if (value == true) {
                            context.read<RoleBloc>().add(LoadRolesEvent());
                         }
                      });
                    },
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                ]
              )
            ],
          ),
          const Spacer(),
          Text(
            role.name ?? '-',
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.black87),
          ),
          const SizedBox(height: 4),
          Text(
            '${role.permissions?.length ?? 0} permissions assigned',
            style: TextStyle(color: Colors.grey[500], fontSize: 12),
          ),
          const Spacer(),
          _buildStatsDashedBox(role.permissions?.length ?? 0, role.usersCount ?? 0, isActive, activeColor),
          const Spacer(),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => RoleDetailsScreen(roleId: role.id)
                  ),
                );
              },
              icon: const Icon(Icons.remove_red_eye_rounded, size: 16),
              label: const Text('VIEW DETAILS', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.grey[700],
                side: BorderSide(color: Colors.grey.shade300),
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showDeleteConfirm(BuildContext context, int roleId) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Delete Role"),
        content: const Text("Are you sure you want to delete this role?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () {
              Navigator.pop(ctx);
              context.read<RoleBloc>().add(DeleteRoleEvent(roleId));
            },
            child: const Text("Delete", style: TextStyle(color: Colors.white)),
          )
        ],
      ),
    );
  }

  Widget _buildStatsDashedBox(int permissionsCount, int usersCount, bool isActive, Color? activeColor) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300, style: BorderStyle.none),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Expanded(
            child: Column(
              children: [
                Text(
                  '$permissionsCount',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: isActive ? (activeColor ?? Colors.black87) : Colors.black87,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Permissions',
                  style: TextStyle(color: Colors.grey[500], fontSize: 12),
                ),
              ],
            ),
          ),
          Container(
            height: 30,
            width: 1,
            color: Colors.grey.shade300,
          ),
          Expanded(
            child: Column(
              children: [
                Text(
                  '$usersCount',
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.black87),
                ),
                const SizedBox(height: 2),
                Text(
                  'Users',
                  style: TextStyle(color: Colors.grey[500], fontSize: 12),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
