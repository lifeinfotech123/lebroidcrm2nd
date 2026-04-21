import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import '../bloc/performance_bloc.dart';
import '../bloc/performance_event.dart';
import '../bloc/performance_state.dart';
import '../data/model/performance_model.dart';
import 'create_goal_tracking_screen.dart';

class GoalTrackingDetailScreen extends StatefulWidget {
  final GoalModel goal;
  const GoalTrackingDetailScreen({super.key, required this.goal});

  @override
  State<GoalTrackingDetailScreen> createState() => _GoalTrackingDetailScreenState();
}

class _GoalTrackingDetailScreenState extends State<GoalTrackingDetailScreen> {
  late GoalModel _currentGoal;

  @override
  void initState() {
    super.initState();
    _currentGoal = widget.goal;
  }

  @override
  Widget build(BuildContext context) {
    Color statusColor;
    if (_currentGoal.status == 'active') {
      statusColor = Colors.blue;
    } else if (_currentGoal.status == 'achieved') {
      statusColor = Colors.green;
    } else if (_currentGoal.status == 'missed') {
      statusColor = Colors.red;
    } else {
      statusColor = Colors.grey;
    }

    return BlocListener<PerformanceBloc, PerformanceState>(
      listener: (context, state) {
        if (state is PerformanceOperationSuccess) {
          Get.snackbar("Success", state.message, backgroundColor: Colors.green, colorText: Colors.white);
        } else if (state is PerformanceError) {
          Get.snackbar("Error", state.message, backgroundColor: Colors.red, colorText: Colors.white);
        }
      },
      child: Scaffold(
        backgroundColor: Colors.grey[50],
        appBar: AppBar(
          title: const Text('Goal Details', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18)),
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          elevation: 1,
          shadowColor: Colors.black12,
          actions: [
            IconButton(
              icon: Icon(Icons.edit_outlined, color: Colors.indigo.shade400),
              onPressed: () async {
                await Get.to(() => CreateGoalTrackingScreen(goal: _currentGoal));
              },
            ),
            IconButton(
              icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
              onPressed: () => _showDeleteDialog(),
            ),
          ],
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title & Status
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.grey.shade200),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(_currentGoal.title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Color(0xFF1E293B))),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                          decoration: BoxDecoration(color: statusColor.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
                          child: Text(_currentGoal.status.capitalizeFirst!, style: TextStyle(color: statusColor, fontSize: 12, fontWeight: FontWeight.bold)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(_currentGoal.description, style: TextStyle(color: Colors.grey.shade600, fontSize: 14, height: 1.5)),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Progress Card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.grey.shade200),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Progress', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Color(0xFF1E293B))),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('${_currentGoal.current} / ${_currentGoal.target} ${_currentGoal.unit}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.indigo)),
                        Text('${(_currentGoal.progressPercent * 100).toStringAsFixed(0)}%', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.indigo)),
                      ],
                    ),
                    const SizedBox(height: 12),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(6),
                      child: LinearProgressIndicator(
                        value: _currentGoal.progressPercent,
                        backgroundColor: Colors.grey.shade200,
                        valueColor: AlwaysStoppedAnimation<Color>(_currentGoal.progressPercent >= 1.0 ? Colors.green : Colors.indigo),
                        minHeight: 10,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Info Card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.grey.shade200),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Goal Information', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Color(0xFF1E293B))),
                    const SizedBox(height: 16),
                    _buildInfoRow(Icons.person_outline, 'Set By', _currentGoal.setByName),
                    _buildInfoRow(Icons.person_add_alt, 'Assigned To', 'User #${_currentGoal.userId}'),
                    _buildInfoRow(Icons.category_outlined, 'Category', _currentGoal.category.capitalizeFirst!),
                    _buildInfoRow(Icons.calendar_today_outlined, 'Deadline', _currentGoal.deadline.split('T')[0]),
                    _buildInfoRow(Icons.access_time, 'Created', _currentGoal.createdAt?.split('T')[0] ?? 'N/A'),
                    _buildInfoRow(Icons.update, 'Updated', _currentGoal.updatedAt?.split('T')[0] ?? 'N/A'),
                    if (_currentGoal.notes != null && _currentGoal.notes!.isNotEmpty)
                      _buildInfoRow(Icons.notes, 'Notes', _currentGoal.notes!),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Quick Update Progress
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.grey.shade200),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        Icon(Icons.sync, size: 18, color: Colors.blue),
                        SizedBox(width: 8),
                        Text('Quick Update', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                      ],
                    ),
                    const SizedBox(height: 16),
                    _buildQuickUpdateSection(),
                  ],
                ),
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value, {Color? valueColor}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Icon(icon, size: 18, color: Colors.grey.shade500),
          const SizedBox(width: 12),
          SizedBox(
            width: 100,
            child: Text(label, style: TextStyle(color: Colors.grey.shade600, fontSize: 13)),
          ),
          Expanded(
            child: Text(value, style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13, color: valueColor ?? const Color(0xFF334155))),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickUpdateSection() {
    final currentController = TextEditingController(text: _currentGoal.current.toString());
    String quickStatus = _currentGoal.status;

    return StatefulBuilder(
      builder: (context, setLocalState) {
        return Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Current Progress', style: TextStyle(color: Colors.grey.shade600, fontSize: 11, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 6),
                      TextField(
                        controller: currentController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: Colors.grey.shade200)),
                          enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: Colors.grey.shade200)),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Status', style: TextStyle(color: Colors.grey.shade600, fontSize: 11, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey.shade200),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            isExpanded: true,
                            value: quickStatus,
                            items: ['active', 'achieved', 'missed', 'paused'].map((e) => DropdownMenuItem(value: e, child: Text(e.capitalizeFirst!, style: const TextStyle(fontSize: 14)))).toList(),
                            onChanged: (val) {
                              if (val != null) setLocalState(() => quickStatus = val);
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  final data = {
                    "current": int.tryParse(currentController.text) ?? _currentGoal.current,
                    "status": quickStatus,
                  };
                  context.read<PerformanceBloc>().add(UpdateGoal(_currentGoal.id, data));
                },
                icon: const Icon(Icons.save, size: 16),
                label: const Text('UPDATE PROGRESS'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.indigo,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showDeleteDialog() {
    Get.defaultDialog(
      title: "Delete Goal",
      middleText: "Are you sure you want to delete this goal?",
      textConfirm: "Delete",
      textCancel: "Cancel",
      confirmTextColor: Colors.white,
      buttonColor: Colors.red,
      onConfirm: () {
        context.read<PerformanceBloc>().add(DeleteGoal(_currentGoal.id));
        Get.back(); // close dialog
        Get.back(); // go back to list
      },
    );
  }
}
