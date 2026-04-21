import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import '../bloc/performance_bloc.dart';
import '../bloc/performance_event.dart';
import '../bloc/performance_state.dart';
import '../data/model/performance_model.dart';
import 'create_goal_tracking_screen.dart';
import 'goal_tracking_detail_Screen.dart';

class GoalTrackingScreen extends StatefulWidget {
  const GoalTrackingScreen({super.key});

  @override
  State<GoalTrackingScreen> createState() => _GoalTrackingScreenState();
}

class _GoalTrackingScreenState extends State<GoalTrackingScreen> {
  @override
  void initState() {
    super.initState();
    context.read<PerformanceBloc>().add(FetchGoals());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text('Goal Tracking', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18)),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 1,
        shadowColor: Colors.black12,
        actions: [
          IconButton(
            icon: const Icon(Icons.add_circle_outline),
            onPressed: () async {
              await Get.to(() => const CreateGoalTrackingScreen());
              if (mounted) context.read<PerformanceBloc>().add(FetchGoals());
            },
          ),
        ],
      ),
      body: BlocConsumer<PerformanceBloc, PerformanceState>(
        listener: (context, state) {
          if (state is PerformanceOperationSuccess) {
            Get.snackbar("Success", state.message, backgroundColor: Colors.green, colorText: Colors.white);
          } else if (state is PerformanceError) {
            Get.snackbar("Error", state.message, backgroundColor: Colors.red, colorText: Colors.white);
          }
        },
        builder: (context, state) {
          if (state is PerformanceLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is GoalsLoaded) {
            final goals = state.goals;
            int total = goals.length;
            int active = goals.where((g) => g.status == 'active').length;
            int achieved = goals.where((g) => g.status == 'achieved').length;
            int missed = goals.where((g) => g.status == 'missed').length;

            return Column(
              children: [
                Container(
                  color: Colors.white,
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      _buildStatsGrid(total, active, achieved, missed),
                      const SizedBox(height: 16),
                      _buildFilters(),
                    ],
                  ),
                ),
                Expanded(
                  child: goals.isEmpty
                      ? _buildEmptyState()
                      : ListView.builder(
                          padding: const EdgeInsets.all(16),
                          itemCount: goals.length,
                          itemBuilder: (context, index) => _buildGoalCard(goals[index]),
                        ),
                ),
                _buildFooter(),
              ],
            );
          }

          return const Center(child: Text("Initializing..."));
        },
      ),
    );
  }

  Widget _buildStatsGrid(int total, int active, int achieved, int missed) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          _buildStatCard('Total Goals', '$total', Colors.blue, Icons.flag_circle),
          const SizedBox(width: 8),
          _buildStatCard('Active', '$active', Colors.orange, Icons.trending_up),
          const SizedBox(width: 8),
          _buildStatCard('Achieved', '$achieved', Colors.green, Icons.track_changes),
          const SizedBox(width: 8),
          _buildStatCard('Missed', '$missed', Colors.red, Icons.cancel_outlined),
        ],
      ),
    );
  }

  Widget _buildStatCard(String title, String value, MaterialColor color, IconData icon) {
    return Container(
      width: 110,
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
      decoration: BoxDecoration(
        color: color.shade50,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.shade100),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color.shade600, size: 24),
          const SizedBox(height: 12),
          Text(value, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24, color: color.shade800)),
          const SizedBox(height: 4),
          Text(title, style: TextStyle(fontWeight: FontWeight.w600, fontSize: 11, color: color.shade700)),
        ],
      ),
    );
  }

  Widget _buildFilters() {
    return Column(
      children: [
        TextField(
          decoration: InputDecoration(
            hintText: 'Search goal or employee...',
            hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 13),
            prefixIcon: Icon(Icons.search, color: Colors.grey.shade400, size: 20),
            filled: true,
            fillColor: Colors.grey.shade50,
            contentPadding: const EdgeInsets.symmetric(vertical: 0),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey.shade200)),
            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey.shade200)),
            focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Colors.indigo)),
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              flex: 2,
              child: Container(
                height: 36,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), border: Border.all(color: Colors.grey.shade300)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('All Status', style: TextStyle(color: Colors.grey.shade700, fontSize: 13)),
                    const Icon(Icons.keyboard_arrow_down, size: 16, color: Colors.grey),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              flex: 1,
              child: Container(
                height: 36,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), border: Border.all(color: Colors.grey.shade300)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('2026', style: TextStyle(color: Colors.grey.shade700, fontSize: 13)),
                    const Icon(Icons.keyboard_arrow_down, size: 16, color: Colors.grey),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildGoalCard(GoalModel goal) {
    Color statusColor;
    if (goal.status == 'active') {
      statusColor = Colors.blue;
    } else if (goal.status == 'achieved') {
      statusColor = Colors.green;
    } else if (goal.status == 'missed') {
      statusColor = Colors.red;
    } else {
      statusColor = Colors.grey;
    }

    return InkWell(
      onTap: () async {
        await Get.to(() => GoalTrackingDetailScreen(goal: goal));
        if (mounted) context.read<PerformanceBloc>().add(FetchGoals());
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey.shade200),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 6, offset: const Offset(0, 2)),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(goal.title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(color: statusColor.withOpacity(0.1), borderRadius: BorderRadius.circular(6)),
                  child: Text(goal.status.capitalizeFirst!, style: TextStyle(color: statusColor, fontSize: 10, fontWeight: FontWeight.bold)),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(goal.description, style: TextStyle(color: Colors.grey.shade600, fontSize: 13), maxLines: 2, overflow: TextOverflow.ellipsis),
            const SizedBox(height: 12),
            Row(
              children: [
                Icon(Icons.category_outlined, size: 14, color: Colors.grey.shade500),
                const SizedBox(width: 4),
                Text(goal.category.capitalizeFirst!, style: TextStyle(color: Colors.grey.shade600, fontSize: 12)),
                const SizedBox(width: 16),
                Icon(Icons.calendar_today_outlined, size: 14, color: Colors.grey.shade500),
                const SizedBox(width: 4),
                Text(goal.deadline.split('T')[0], style: TextStyle(color: Colors.grey.shade600, fontSize: 12)),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: goal.progressPercent,
                      backgroundColor: Colors.grey.shade200,
                      valueColor: AlwaysStoppedAnimation<Color>(goal.progressPercent >= 1.0 ? Colors.green : Colors.indigo),
                      minHeight: 6,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Text('${goal.current}/${goal.target} ${goal.unit}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 11)),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Set by: ${goal.setByName}', style: TextStyle(color: Colors.grey.shade500, fontSize: 11)),
                Row(
                  children: [
                    InkWell(
                      onTap: () async {
                        await Get.to(() => CreateGoalTrackingScreen(goal: goal));
                        if (mounted) context.read<PerformanceBloc>().add(FetchGoals());
                      },
                      child: Icon(Icons.edit_outlined, size: 18, color: Colors.indigo.shade400),
                    ),
                    const SizedBox(width: 12),
                    InkWell(
                      onTap: () => _showDeleteDialog(goal.id),
                      child: const Icon(Icons.delete_outline, size: 18, color: Colors.redAccent),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showDeleteDialog(int id) {
    Get.defaultDialog(
      title: "Delete Goal",
      middleText: "Are you sure you want to delete this goal?",
      textConfirm: "Delete",
      textCancel: "Cancel",
      confirmTextColor: Colors.white,
      buttonColor: Colors.red,
      onConfirm: () {
        context.read<PerformanceBloc>().add(DeleteGoal(id));
        Get.back();
      },
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(color: Colors.grey.shade100, shape: BoxShape.circle),
            child: Icon(Icons.sports_score, size: 64, color: Colors.grey.shade300),
          ),
          const SizedBox(height: 24),
          const Text('No goals found.', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.black87)),
          const SizedBox(height: 8),
          Text('Goals assigned to employees will appear here.', style: TextStyle(color: Colors.grey.shade500, fontSize: 13)),
        ],
      ),
    );
  }

  Widget _buildFooter() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 16),
      color: Colors.white,
      child: Column(
        children: [
          Text('Copyright © 2026', style: TextStyle(color: Colors.grey.shade500, fontSize: 11)),
          const SizedBox(height: 4),
          Text('• Developed by: Life InfoTech', style: TextStyle(color: Colors.grey.shade400, fontSize: 11)),
        ],
      ),
    );
  }
}
