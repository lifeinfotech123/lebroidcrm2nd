import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import '../bloc/performance_bloc.dart';
import '../bloc/performance_event.dart';
import '../bloc/performance_state.dart';
import '../data/model/performance_model.dart';
import 'give_performance_rating_screen.dart';

class PerformanceRatingsScreen extends StatefulWidget {
  const PerformanceRatingsScreen({super.key});

  @override
  State<PerformanceRatingsScreen> createState() => _PerformanceRatingsScreenState();
}

class _PerformanceRatingsScreenState extends State<PerformanceRatingsScreen> {
  @override
  void initState() {
    super.initState();
    context.read<PerformanceBloc>().add(FetchPerformances());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text('Performance Ratings', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18)),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 1,
        shadowColor: Colors.black12,
        actions: [
          IconButton(
            icon: const Icon(Icons.add_circle_outline),
            onPressed: () {
              Get.to(() => const GivePerformanceRatingScreen());
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

          if (state is PerformancesLoaded) {
            final ratings = state.performances;
            return CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildFilters(),
                        const SizedBox(height: 16),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(color: Colors.indigo.shade50, borderRadius: BorderRadius.circular(12)),
                          child: Row(
                            children: [
                              Icon(Icons.calendar_month, size: 18, color: Colors.indigo.shade700),
                              const SizedBox(width: 8),
                              Text('Total ratings: ${ratings.length}', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.indigo.shade800)),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),
                      ],
                    ),
                  ),
                ),
                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 16).copyWith(bottom: 24),
                  sliver: ratings.isEmpty
                      ? const SliverFillRemaining(child: Center(child: Text("No performance ratings found")))
                      : SliverList(
                          delegate: SliverChildBuilderDelegate(
                            (context, index) {
                              return _buildRatingCard(ratings[index]);
                            },
                            childCount: ratings.length,
                          ),
                        ),
                ),
              ],
            );
          }

          return const Center(child: Text("Initializing..."));
        },
      ),
    );
  }

  Widget _buildFilters() {
    return Column(
      children: [
        TextField(
          decoration: InputDecoration(
            hintText: 'Search employee...',
            hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 13),
            prefixIcon: Icon(Icons.search, color: Colors.grey.shade400, size: 20),
            filled: true,
            fillColor: Colors.white,
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
              child: Container(
                height: 36,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.grey.shade300)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('March, 2026', style: TextStyle(color: Colors.grey.shade700, fontSize: 13)),
                    const Icon(Icons.keyboard_arrow_down, size: 16, color: Colors.grey),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Container(
                height: 36,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.grey.shade300)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('All Departments', style: TextStyle(color: Colors.grey.shade700, fontSize: 13)),
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

  Widget _buildRatingCard(PerformanceModel item) {
    Color gradeColor = Colors.grey;
    if (item.grade == 'A+' || item.grade == 'A') gradeColor = Colors.green;
    else if (item.grade == 'B') gradeColor = Colors.blue;
    else if (item.grade == 'C') gradeColor = Colors.orange;
    else if (item.grade == 'D') gradeColor = Colors.red;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 6, offset: const Offset(0, 2)),
        ],
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 18,
                  backgroundColor: Colors.indigo.shade50,
                  child: Text(item.initials, style: TextStyle(color: Colors.indigo.shade700, fontWeight: FontWeight.bold, fontSize: 13)),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(child: Text(item.userName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14))),
                          const SizedBox(width: 6),
                          Text('ID: ${item.userId}', style: TextStyle(color: Colors.grey.shade500, fontSize: 11)),
                        ],
                      ),
                      const SizedBox(height: 2),
                      Text('Month: ${item.month} • ${item.period ?? "monthly"}', style: TextStyle(color: Colors.grey.shade600, fontSize: 12)),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(color: gradeColor.withOpacity(0.1), borderRadius: BorderRadius.circular(6)),
                  child: Text('Grade ${item.grade}', style: TextStyle(color: gradeColor, fontSize: 10, fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Score', style: TextStyle(fontSize: 10, color: Colors.grey.shade500, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 4),
                      Text('${item.totalScore}/100', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.black87)),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Grade', style: TextStyle(fontSize: 10, color: Colors.grey.shade500, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 4),
                      Text(item.grade, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: gradeColor)),
                    ],
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Remarks', style: TextStyle(fontSize: 10, color: Colors.grey.shade500, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 4),
                      Text(
                        (item.managerRemarks != null && item.managerRemarks!.isNotEmpty) ? item.managerRemarks! : '—',
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.black87),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                // Edit and Delete buttons
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    InkWell(
                      onTap: () {
                        Get.to(() => GivePerformanceRatingScreen(performance: item));
                      },
                      child: Icon(Icons.edit_outlined, size: 18, color: Colors.indigo.shade400),
                    ),
                    const SizedBox(width: 12),
                    InkWell(
                      onTap: () => _showDeleteDialog(item.id),
                      child: const Icon(Icons.delete_outline, size: 18, color: Colors.redAccent),
                    ),
                    const SizedBox(width: 8),
                    Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey.shade500),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showDeleteDialog(int id) {
    Get.defaultDialog(
      title: "Delete Rating",
      middleText: "Are you sure you want to delete this performance rating?",
      textConfirm: "Delete",
      textCancel: "Cancel",
      confirmTextColor: Colors.white,
      buttonColor: Colors.red,
      onConfirm: () {
        context.read<PerformanceBloc>().add(DeletePerformance(id));
        Get.back();
      },
    );
  }
}
