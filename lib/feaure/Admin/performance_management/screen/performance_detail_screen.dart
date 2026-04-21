import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import '../bloc/performance_bloc.dart';
import '../bloc/performance_event.dart';
import '../bloc/performance_state.dart';
import '../data/model/performance_model.dart';
import 'give_performance_rating_screen.dart';

class PerformanceDetailScreen extends StatefulWidget {
  final int performanceId;
  
  const PerformanceDetailScreen({super.key, required this.performanceId});

  @override
  State<PerformanceDetailScreen> createState() => _PerformanceDetailScreenState();
}

class _PerformanceDetailScreenState extends State<PerformanceDetailScreen> {
  @override
  void initState() {
    super.initState();
    context.read<PerformanceBloc>().add(FetchPerformanceById(widget.performanceId));
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PerformanceBloc, PerformanceState>(
      listener: (context, state) {
        if (state is PerformanceOperationSuccess) {
           Get.snackbar("Success", state.message, backgroundColor: Colors.green, colorText: Colors.white);
           // Refresh data if updated
           context.read<PerformanceBloc>().add(FetchPerformanceById(widget.performanceId));
        } else if (state is PerformanceError) {
           Get.snackbar("Error", state.message, backgroundColor: Colors.red, colorText: Colors.white);
        }
      },
      builder: (context, state) {
        if (state is PerformanceLoading) {
          return Scaffold(
            appBar: _buildAppBar(context, isLoading: true),
            body: const Center(child: CircularProgressIndicator()),
          );
        }
        
        if (state is PerformanceDetailLoaded) {
          final perf = state.performance;
          return _buildDetailContent(context, perf);
        }

        return Scaffold(
            appBar: _buildAppBar(context, isLoading: true),
            body: const Center(child: Text("Performance details not found.")),
        );
      },
    );
  }

  AppBar _buildAppBar(BuildContext context, {bool isLoading = false, PerformanceModel? perf}) {
    return AppBar(
      title: const Text('Performance Details', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18)),
      backgroundColor: Colors.white,
      foregroundColor: Colors.black,
      elevation: 1,
      shadowColor: Colors.black12,
      actions: (!isLoading && perf != null) ? [
        IconButton(
          icon: Icon(Icons.edit_outlined, color: Colors.indigo.shade400),
          onPressed: () {
            Get.to(() => GivePerformanceRatingScreen(performance: perf));
          },
        ),
        IconButton(
          icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
          onPressed: () => _showDeleteDialog(perf.id),
        ),
      ] : null,
    );
  }

  Widget _buildDetailContent(BuildContext context, PerformanceModel perf) {
    Color gradeColor = Colors.grey;
    if (perf.grade == 'A+' || perf.grade == 'A') gradeColor = Colors.green;
    else if (perf.grade == 'B') gradeColor = Colors.blue;
    else if (perf.grade == 'C') gradeColor = Colors.orange;
    else if (perf.grade == 'D') gradeColor = Colors.red;

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: _buildAppBar(context, perf: perf),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // User Header Profile
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.grey.shade200),
                boxShadow: [
                  BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 6, offset: const Offset(0, 2)),
                ],
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.indigo.shade50,
                    child: Text(perf.initials, style: TextStyle(color: Colors.indigo.shade700, fontWeight: FontWeight.bold, fontSize: 22)),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(perf.userName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                        const SizedBox(height: 4),
                        Text('Employee ID: ${perf.userId}', style: TextStyle(color: Colors.grey.shade600, fontSize: 13)),
                        const SizedBox(height: 4),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(color: Colors.indigo.shade50, borderRadius: BorderRadius.circular(6)),
                          child: Text('Period: ${perf.month} (${perf.period ?? "monthly"})', style: TextStyle(color: Colors.indigo.shade700, fontSize: 11, fontWeight: FontWeight.bold)),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Overall Score
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: gradeColor.withOpacity(0.05),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: gradeColor.withOpacity(0.2)),
              ),
              child: Column(
                children: [
                  Text('Overall Score', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: gradeColor)),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text('${perf.totalScore}', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 48, color: gradeColor, height: 1)),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 6.0, left: 2.0),
                        child: Text('/100', style: TextStyle(fontSize: 18, color: gradeColor.withOpacity(0.7))),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                    decoration: BoxDecoration(color: gradeColor, borderRadius: BorderRadius.circular(20)),
                    child: Text('Grade ${perf.grade}', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Detailed Scores Grid
            const Text('Metrics Breakdown', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Color(0xFF1E293B))),
            const SizedBox(height: 12),
            GridView.count(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              childAspectRatio: 2.2,
              children: [
                _buildMetricScoreCard('Attendance', perf.ratingAttendance, Colors.green),
                _buildMetricScoreCard('Task Quality', perf.ratingTaskQuality, Colors.blue),
                _buildMetricScoreCard('Punctuality', perf.ratingPunctuality, Colors.teal),
                _buildMetricScoreCard('Teamwork', perf.ratingTeamwork, Colors.orange),
                _buildMetricScoreCard('Communication', perf.ratingCommunication, Colors.purple),
                _buildMetricScoreCard('Initiative', perf.ratingInitiative, Colors.red),
              ],
            ),
            const SizedBox(height: 24),

            // Remarks
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
                      Icon(Icons.format_quote, color: Colors.indigo, size: 20),
                      SizedBox(width: 8),
                      Text('Manager Remarks', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Color(0xFF1E293B))),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text((perf.managerRemarks != null && perf.managerRemarks!.isNotEmpty) ? perf.managerRemarks! : "No remarks provided.", style: TextStyle(color: Colors.grey.shade700, fontSize: 14, height: 1.5)),
                  
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 16.0),
                    child: Divider(height: 1),
                  ),
                  
                  const Row(
                    children: [
                      Icon(Icons.trending_up, color: Colors.orange, size: 20),
                      SizedBox(width: 8),
                      Text('Improvement Areas', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Color(0xFF1E293B))),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text((perf.improvementAreas != null && perf.improvementAreas!.isNotEmpty) ? perf.improvementAreas! : "No improvement areas specified.", style: TextStyle(color: Colors.grey.shade700, fontSize: 14, height: 1.5)),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Meta Info
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
                  const Text('Rating Information', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Color(0xFF1E293B))),
                  const SizedBox(height: 16),
                  _buildInfoRow(Icons.person, 'Rated By', perf.ratedByName),
                  _buildInfoRow(Icons.access_time, 'Created At', perf.createdAt?.split('T')[0] ?? 'N/A'),
                  _buildInfoRow(Icons.update, 'Updated At', perf.updatedAt?.split('T')[0] ?? 'N/A'),
                ],
              ),
             ),
             const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildMetricScoreCard(String title, int score, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(title, style: TextStyle(color: Colors.grey.shade600, fontSize: 11, fontWeight: FontWeight.bold), maxLines: 1, overflow: TextOverflow.ellipsis),
          const SizedBox(height: 4),
          Row(
            children: [
              Text('$score', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: color)),
              Text('/10', style: TextStyle(color: Colors.grey.shade400, fontSize: 12, fontWeight: FontWeight.w600)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Icon(icon, size: 18, color: Colors.grey.shade400),
          const SizedBox(width: 12),
          SizedBox(
            width: 100,
            child: Text(label, style: TextStyle(color: Colors.grey.shade600, fontSize: 13)),
          ),
          Expanded(
            child: Text(value, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13, color: Color(0xFF334155))),
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
        Get.back(); // close dialog
        Get.back(); // go back to previous screen
      },
    );
  }
}
