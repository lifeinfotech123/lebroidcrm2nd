import 'package:flutter/material.dart';
import 'package:lebroid_crm/feaure/Employee/home/presentation/screens/project_detail_screen.dart';

import '../widget/home_widgets/attendance_card.dart';
import '../widget/home_widgets/home_screen_header.dart';
import '../widget/home_widgets/leave_card_widget.dart';
import '../widget/home_widgets/my_current_project_widget.dart';
import '../widget/home_widgets/my_punch_in_widget.dart';
import '../widget/home_widgets/stats_card_widget.dart';
import 'attendace_detail_screen.dart';


class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: const Color(0xFFF6F7FB),
        body: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) {
            return [
              SliverAppBar(
                pinned: true,
                backgroundColor: Colors.white,
                title: const Text(
                  'Dashboard',
                  style: TextStyle(color: Colors.black),
                ),

                centerTitle: true,
                elevation: innerBoxIsScrolled ? 4 : 0,
              ),

              /// HEADER CONTENT
              SliverToBoxAdapter(
                child: Column(
                  children: [
                    const HomeScreenHeader(
                      userName: 'John Doe',
                      designation: 'Flutter Developer',
                      profileImageUrl: 'https://i.pravatar.cc/150?img=12',
                    ),
                    const SizedBox(height: 10),
                    const StatCard(
                      totalProjects: '24',
                      projects: 'Total Task',
                      projectsIcons: Icons.folder_outlined,
                      totalCompletedProjects: '18',
                      completedProjects: 'Task Done',
                      completedProjectsIcons: Icons.check_circle_outline,
                      totalProgressProjects: '6',
                      progressProjects: 'In Progress',
                      totalprogressProjectsIcons: Icons.timelapse_outlined,
                    ),
                    const SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch, // 👈 full width
                        children: [
                          const MyPunchInWidget(),
                          const SizedBox(height: 16),
                          // Attendance Quick Access Button
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) =>
                                      const AttendanceDetailScreen(),
                                ),
                              );
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 14,
                              ),
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  colors: [
                                    Color(0xFF1565C0),
                                    Color(0xFF42A5F5),
                                  ],
                                  begin: Alignment.centerLeft,
                                  end: Alignment.centerRight,
                                ),
                                borderRadius: BorderRadius.circular(14),
                                boxShadow: [
                                  BoxShadow(
                                    color: Color(
                                      0xFF1565C0,
                                    ).withValues(alpha: 0.3),
                                    blurRadius: 12,
                                    offset: Offset(0, 6),
                                  ),
                                ],
                              ),
                              child: Row(
                                children: const [
                                  Icon(
                                    Icons.calendar_month_outlined,
                                    color: Colors.white,
                                    size: 26,
                                  ),
                                  SizedBox(width: 14),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,

                                      children: [
                                        Text(
                                          'Attendance',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        SizedBox(height: 2),
                                        Text(
                                          'View your attendance record',
                                          style: TextStyle(
                                            color: Colors.white70,
                                            fontSize: 12,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),

                                  Icon(
                                    Icons.arrow_forward_ios,
                                    color: Colors.white70,
                                    size: 16,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          MyCurrentProjectWidget(
                            onpress: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const ProjectDetailScreen(),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 16),
                  ],
                ),
              ),

              /// TAB BAR (STICKY)
              const SliverPersistentHeader(
                pinned: true,
                delegate: _TabBarDelegate(),
              ),
            ];
          },

          /// TAB CONTENT
          body: const TabBarView(
            children: [ProjectTabList(), ProjectTabList(), ProjectTabList()],
          ),
        ),
      ),
    );
  }
}

class ProjectTabList extends StatelessWidget {
  const ProjectTabList({super.key});

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.symmetric(vertical: 12),
      children: [
        ...List.generate(5, (index) {

          final startDate = DateTime(2024, 1, index + 1);
          final endDate = DateTime(2024, 3, index + 10);
          final progress = (index + 1) / 5; // 0.2 → 1.0

          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: const Icon(Icons.work),
                    title: Text(
                      'Task ${index + 1}',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      'Start: ${_formatDate(startDate)}\n'
                      'End: ${_formatDate(endDate)}',
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: LinearProgressIndicator(
                          value: progress,
                          minHeight: 8,
                          backgroundColor: Colors.grey.shade300,
                          color: Colors.green,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text('${(progress * 100).toInt()}%'),
                    ],
                  ),
                ],
              ),
            ),
          );
        }),

        const SizedBox(height: 16),
        const AttendanceCard(),
        const SizedBox(height: 10),
        const LeaveCardWidgetCard(),
        const SizedBox(height: 16),

        sectionTitle('Employees'),
        actionRow(
          const ActionPill(
            icon: Icons.receipt_long,
            title: 'Salary Slip',
            color: Color(0xFF4CAF50),
          ),
          const ActionPill(
            icon: Icons.account_balance_wallet,
            title: 'Payslip History',
            color: Color(0xFF2196F3),
          ),
        ),

        actionRow(
          const ActionPill(
            icon: Icons.work,
            title: 'My Task',
            color: Color(0xFF114798),
          ),
          const ActionPill(
            icon: Icons.settings,
            title: 'System Details',
            color: Color(0xFFF34870),
          ),
        ),

        const SizedBox(height: 24),
      ],
    );
  }

  Widget sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          title,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }

  Widget actionRow(Widget left, Widget right) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      child: Row(
        children: [
          Expanded(child: left),
          const SizedBox(width: 16),
          Expanded(child: right),
        ],
      ),
    );
  }
}

class _TabBarDelegate extends SliverPersistentHeaderDelegate {
  const _TabBarDelegate();

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return Container(
      color: Colors.white,
      child: const TabBar(
        labelColor: Colors.black,
        unselectedLabelColor: Colors.grey,
        indicatorColor: Colors.blue,
        tabs: [
          Tab(text: 'All Task'),
          Tab(text: 'Pending'),
          Tab(text: 'Completed'),
        ],
      ),
    );
  }

  @override
  double get maxExtent => 48;

  @override
  double get minExtent => 48;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return false;
  }
}

class ActionPill extends StatelessWidget {
  final IconData icon;
  final String title;
  final Color color;

  const ActionPill({
    super.key,
    required this.icon,
    required this.title,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(40),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          /// Icon Circle
          Container(
            height: 38,
            width: 38,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
            child: Icon(icon, color: Colors.white, size: 20),
          ),

          const SizedBox(width: 12),

          /// Title
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: color,
              ),
            ),
          ),

          /// Arrow
          Icon(Icons.arrow_forward_ios, size: 14, color: color),
        ],
      ),
    );
  }
}
