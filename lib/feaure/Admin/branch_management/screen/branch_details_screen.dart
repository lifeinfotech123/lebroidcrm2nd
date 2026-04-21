import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lebroid_crm/feaure/Admin/branch_management/bloc/branch_bloc.dart';
import 'package:lebroid_crm/feaure/Admin/branch_management/bloc/branch_event.dart';
import 'package:lebroid_crm/feaure/Admin/branch_management/bloc/branch_state.dart';

class BranchDetailsScreen extends StatefulWidget {
  final int branchId;

  const BranchDetailsScreen({super.key, required this.branchId});

  @override
  State<BranchDetailsScreen> createState() => _BranchDetailsScreenState();
}

class _BranchDetailsScreenState extends State<BranchDetailsScreen> {
  @override
  void initState() {
    super.initState();
    context.read<BranchBloc>().add(FetchSingleBranchEvent(widget.branchId));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: const Text('Branch Details'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 1,
      ),
      body: BlocBuilder<BranchBloc, BranchState>(
        builder: (context, state) {
          if (state is BranchLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is SingleBranchLoaded) {
            final branch = state.branch;
            return SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildDetailCard(
                    title: branch.name ?? "N/A",
                    subtitle: "Code: ${branch.code ?? 'N/A'}",
                    icon: Icons.business,
                    isActive: branch.isActive,
                  ),
                  const SizedBox(height: 24),
                  const Text("Location Details", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  const SizedBox(height: 12),
                  _buildInfoRow(Icons.map, "City", branch.city ?? "-"),
                  _buildInfoRow(Icons.location_city, "State", branch.state ?? "-"),
                  _buildInfoRow(Icons.public, "Country", branch.country ?? "-"),
                  _buildInfoRow(Icons.my_location, "Address", branch.address ?? "-"),
                  const SizedBox(height: 24),
                  const Text("Contact Info", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  const SizedBox(height: 12),
                  _buildInfoRow(Icons.phone, "Phone", branch.phone ?? "-"),
                  _buildInfoRow(Icons.email, "Email", branch.email ?? "-"),
                  const SizedBox(height: 24),
                  const Text("Management", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  const SizedBox(height: 12),
                  _buildInfoRow(Icons.person, "Manager ID", branch.managerId?.toString() ?? "-"),
                  _buildInfoRow(Icons.person_pin, "Manager Name", branch.manager?['name'] ?? "-"),
                ],
              ),
            );
          } else if (state is BranchError) {
            return Center(child: Text(state.message, style: const TextStyle(color: Colors.red)));
          }
          return const Center(child: Text("Loading..."));
        },
      ),
    );
  }

  Widget _buildDetailCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required bool isActive,
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
            backgroundColor: Colors.blue.shade50,
            child: Icon(icon, size: 30, color: Colors.blue),
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
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: isActive ? Colors.green.shade50 : Colors.red.shade50,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              isActive ? "Active" : "Inactive",
              style: TextStyle(
                color: isActive ? Colors.green : Colors.red,
                fontWeight: FontWeight.bold,
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 20, color: Colors.indigo),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: TextStyle(color: Colors.grey.shade500, fontSize: 13, fontWeight: FontWeight.w500)),
                const SizedBox(height: 4),
                Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Colors.black87)),
              ],
            ),
          )
        ],
      ),
    );
  }
}
