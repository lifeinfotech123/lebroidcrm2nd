import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:lebroid_crm/feaure/Admin/performance_management/screen/performance_detail_screen.dart';
import '../bloc/performance_bloc.dart';
import '../bloc/performance_event.dart';
import '../bloc/performance_state.dart';
import '../data/model/performance_model.dart';

class PerformanceMonitoringScreen extends StatefulWidget {
  const PerformanceMonitoringScreen({super.key});

  @override
  State<PerformanceMonitoringScreen> createState() => _PerformanceMonitoringScreenState();
}

class _PerformanceMonitoringScreenState extends State<PerformanceMonitoringScreen> {
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
        title: const Text('Performance Monitoring', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18)),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 1,
        shadowColor: Colors.black12,
      ),
      body: BlocBuilder<PerformanceBloc, PerformanceState>(
        builder: (context, state) {
          if (state is PerformanceLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is PerformancesLoaded) {
            final performances = List<PerformanceModel>.from(state.performances);
            // Sort by total_score descending
            performances.sort((a, b) => b.totalScore.compareTo(a.totalScore));

            return CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        _buildFilters(),
                        const SizedBox(height: 16),
                        if (performances.isNotEmpty) _buildHighlightCards(performances),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('${performances.length} employees', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Colors.grey.shade800)),
                            Text('Score: High to Low', style: TextStyle(color: Colors.indigo.shade600, fontSize: 13, fontWeight: FontWeight.bold)),
                          ],
                        ),
                        const SizedBox(height: 12),
                      ],
                    ),
                  ),
                ),
                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 16).copyWith(bottom: 24),
                  sliver: performances.isEmpty
                      ? const SliverFillRemaining(child: Center(child: Text("No performance data found")))
                      : SliverList(
                          delegate: SliverChildBuilderDelegate(
                            (context, index) {
                              return _buildEmployeeCard(performances[index], index + 1);
                            },
                            childCount: performances.length,
                          ),
                        ),
                ),
              ],
            );
          }

          if (state is PerformanceError) {
            return Center(child: Text("Error: ${state.message}"));
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

  Widget _buildHighlightCards(List<PerformanceModel> performances) {
    final topPerformer = performances.first;
    final needsImprovement = performances.last;

    return Row(
      children: [
        Expanded(
          child: _buildBadgeCard(
            performanceId: topPerformer.id,
            title: 'Top Performer',
            subtitle: topPerformer.month,
            name: topPerformer.userName,
            score: '${topPerformer.totalScore}/100',
            grade: topPerformer.grade,
            emoji: '🏆',
            color: Colors.amber,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildBadgeCard(
            performanceId: needsImprovement.id,
            title: 'Needs Improvement',
            subtitle: needsImprovement.month,
            name: needsImprovement.userName,
            score: '${needsImprovement.totalScore}/100',
            grade: needsImprovement.grade,
            emoji: '📈',
            color: Colors.red,
          ),
        ),
      ],
    );
  }

  Widget _buildBadgeCard({required int performanceId, required String title, required String subtitle, required String name, required String score, required String grade, required String emoji, required MaterialColor color}) {
    return InkWell(
      onTap: () {
        Get.to(() => PerformanceDetailScreen(performanceId: performanceId));
      },
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.shade200),
          boxShadow: [
            BoxShadow(color: color.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4)),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(emoji, style: const TextStyle(fontSize: 18)),
                const SizedBox(width: 6),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(title, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11, color: color.shade800)),
                      Text(subtitle, style: TextStyle(fontSize: 9, color: Colors.grey.shade600)),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
            const SizedBox(height: 4),
            Text('Score: $score · Grade: $grade', style: TextStyle(fontSize: 10, color: Colors.grey.shade600, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }

  Widget _buildEmployeeCard(PerformanceModel perf, int rank) {
    Color gradeColor = Colors.grey;
    if (perf.grade == 'A+' || perf.grade == 'A') gradeColor = Colors.green;
    else if (perf.grade == 'B') gradeColor = Colors.blue;
    else if (perf.grade == 'C') gradeColor = Colors.orange;
    else if (perf.grade == 'D') gradeColor = Colors.red;

    return GestureDetector(
      onTap: () {
        Get.to(() => PerformanceDetailScreen(performanceId: perf.id));
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  Container(
                    width: 28, height: 28,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(color: Colors.grey.shade100, shape: BoxShape.circle),
                    child: Text('#$rank', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey.shade700, fontSize: 12)),
                  ),
                const SizedBox(width: 12),
                CircleAvatar(
                  radius: 16,
                  backgroundColor: Colors.indigo.shade50,
                  child: Text(perf.initials, style: TextStyle(color: Colors.indigo.shade700, fontWeight: FontWeight.bold, fontSize: 12)),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Flexible(child: Text(perf.userName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14))),
                          const SizedBox(width: 6),
                          Text('ID:${perf.userId}', style: TextStyle(color: Colors.grey.shade500, fontSize: 11)),
                        ],
                      ),
                      Text('Month: ${perf.month}', style: TextStyle(color: Colors.grey.shade600, fontSize: 11)),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(perf.totalScore.toString(), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.indigo)),
                    Text('Grade: ${perf.grade}', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11, color: gradeColor)),
                  ],
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(16), bottomRight: Radius.circular(16)),
              border: Border(top: BorderSide(color: Colors.grey.shade200)),
            ),
            child: Row(
              children: [
                Expanded(child: _buildMetricCol('Attendance', '${perf.ratingAttendance}/10', '${perf.ratingAttendance * 10}%')),
                Container(width: 1, height: 24, color: Colors.grey.shade300),
                Expanded(child: _buildMetricCol('Tasks', '${perf.ratingTaskQuality}/10', '${perf.ratingTaskQuality * 10}%')),
                Container(width: 1, height: 24, color: Colors.grey.shade300),
                Expanded(child: _buildMetricCol('Punctuality', '${perf.ratingPunctuality}/10', '${perf.ratingPunctuality * 10}%')),
              ],
            ),
          ),
        ],
      ),
      ),
    );
  }

  Widget _buildMetricCol(String label, String score, String detail) {
    return Column(
      children: [
        Text(label, style: TextStyle(fontSize: 9, color: Colors.grey.shade500, fontWeight: FontWeight.bold)),
        const SizedBox(height: 2),
        Text(score, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
        Text(detail, style: TextStyle(fontSize: 9, color: Colors.grey.shade600)),
      ],
    );
  }
}
