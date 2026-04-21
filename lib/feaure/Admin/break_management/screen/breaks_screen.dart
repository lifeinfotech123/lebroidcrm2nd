import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/break_bloc.dart';
import '../bloc/break_event.dart';
import '../bloc/break_state.dart';
import '../data/repository/break_repository.dart';
import '../data/model/break_model.dart';
import 'package:intl/intl.dart';

class BreaksScreen extends StatefulWidget {
  const BreaksScreen({super.key});

  @override
  State<BreaksScreen> createState() => _BreaksScreenState();
}

class _BreaksScreenState extends State<BreaksScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => BreakBloc(breakRepository: BreakRepository())..add(FetchBreaks()),
      child: Scaffold(
        backgroundColor: Colors.grey[50],
        appBar: AppBar(
          title: const Text('Break Management', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18)),
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          elevation: 1,
          shadowColor: Colors.black12,
        ),
        body: BlocConsumer<BreakBloc, BreakState>(
          listener: (context, state) {
            if (state is BreakError) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.message)));
            } else if (state is BreakActionSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.message), backgroundColor: Colors.green));
            }
          },
          builder: (context, state) {
            List<BreakRecord> logs = [];
            List<BreakType> types = [];
            bool isLoading = state is BreakLoading;

            if (state is BreaksLoaded) {
              logs = state.breaks;
              types = state.breakTypes;
            }

            return CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        _buildBreadcrumbs(),
                        const SizedBox(height: 16),
                        _buildStatsGrid(logs),
                        const SizedBox(height: 16),
                        _buildSearchAndFilters(),
                        const SizedBox(height: 24),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Recent Break Logs', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(color: Colors.indigo.shade50, borderRadius: BorderRadius.circular(12)),
                              child: Text('${logs.length} break(s)', style: TextStyle(color: Colors.indigo.shade700, fontSize: 11, fontWeight: FontWeight.bold)),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        if (isLoading && logs.isEmpty)
                          const Center(child: Padding(padding: EdgeInsets.all(32.0), child: CircularProgressIndicator()))
                        else if (logs.isEmpty)
                          _buildEmptyState()
                      ],
                    ),
                  ),
                ),
                if (logs.isNotEmpty)
                  SliverPadding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) => _buildBreakLogCard(context, logs[index]),
                        childCount: logs.length,
                      ),
                    ),
                  ),
                const SliverToBoxAdapter(child: SizedBox(height: 32)),
                const SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.0),
                    child: Text('Break Categories Summary', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  ),
                ),
                const SliverToBoxAdapter(child: SizedBox(height: 12)),
                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0).copyWith(bottom: 24.0),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        return _buildCategorySummaryCard(types[index], logs);
                      },
                      childCount: types.length,
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildBreadcrumbs() {
    return Row(
      children: [
        Icon(Icons.home_outlined, size: 14, color: Colors.indigo.shade400),
        const SizedBox(width: 4),
        Text('Home', style: TextStyle(fontSize: 12, color: Colors.indigo.shade600, fontWeight: FontWeight.w600)),
        const SizedBox(width: 4),
        Icon(Icons.chevron_right, size: 14, color: Colors.grey.shade400),
        const SizedBox(width: 4),
        Text('Breaks', style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
      ],
    );
  }

  Widget _buildStatsGrid(List<BreakRecord> logs) {
    final active = logs.where((l) => l.endedAt == null).length;
    final overLimit = logs.where((l) => l.isOverLimit).length;
    final today = logs.where((l) => l.startedAt != null && DateFormat('yyyy-MM-dd').format(l.startedAt!) == DateFormat('yyyy-MM-dd').format(DateTime.now())).length;

    return Row(
      children: [
        Expanded(child: _buildSmallStatCard('Total Breaks', '${logs.length}', Colors.blue, Icons.list_alt_outlined)),
        const SizedBox(width: 8),
        Expanded(child: _buildSmallStatCard('Active', '$active', Colors.orange, Icons.play_circle_outline)),
        const SizedBox(width: 8),
        Expanded(child: _buildSmallStatCard('Over Limit', '$overLimit', Colors.red, Icons.warning_amber_rounded)),
        const SizedBox(width: 8),
        Expanded(child: _buildSmallStatCard('Today', '$today', Colors.green, Icons.today_outlined)),
      ],
    );
  }

  Widget _buildSmallStatCard(String title, String value, Color color, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(color: color.withOpacity(0.1), shape: BoxShape.circle),
            child: Icon(icon, color: color, size: 16),
          ),
          const SizedBox(height: 8),
          Text(value, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 2),
          Text(title, textAlign: TextAlign.center, style: TextStyle(fontSize: 10, color: Colors.grey.shade600, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }

  Widget _buildSearchAndFilters() {
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
      ],
    );
  }

  Widget _buildBreakLogCard(BuildContext context, BreakRecord log) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(12),
        leading: CircleAvatar(
          backgroundColor: Colors.indigo.shade50,
          child: Text(log.user?.name?[0] ?? '?', style: TextStyle(color: Colors.indigo.shade700)),
        ),
        title: Text(log.user?.name ?? 'Unknown', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(log.breakType?.name ?? 'General Break', style: TextStyle(fontSize: 12, color: Colors.indigo.shade400)),
            const SizedBox(height: 4),
            Row(
              children: [
                Icon(Icons.access_time, size: 12, color: Colors.grey.shade400),
                const SizedBox(width: 4),
                Text(
                  '${DateFormat('HH:mm').format(log.startedAt!)} - ${log.endedAt != null ? DateFormat('HH:mm').format(log.endedAt!) : 'Active'}',
                  style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
                ),
              ],
            ),
          ],
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text('${log.durationMinutes}m', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
            if (log.isOverLimit)
              const Text('Over Limit', style: TextStyle(color: Colors.red, fontSize: 9, fontWeight: FontWeight.bold)),
            IconButton(
              icon: const Icon(Icons.delete_outline, size: 18, color: Colors.red),
              onPressed: () => _confirmDelete(context, log.id!),
            ),
          ],
        ),
      ),
    );
  }

  void _confirmDelete(BuildContext context, int id) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Delete Break Log'),
        content: const Text('Are you sure you want to delete this break record?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(dialogContext), child: const Text('Cancel')),
          TextButton(
            onPressed: () {
              context.read<BreakBloc>().add(DeleteBreak(id));
              Navigator.pop(dialogContext);
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        children: [
          Icon(Icons.free_breakfast_outlined, size: 48, color: Colors.grey.shade300),
          const SizedBox(height: 16),
          const Text('No Break Logs', style: TextStyle(color: Colors.black87, fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Text('No break records have been logged yet.', style: TextStyle(color: Colors.grey.shade500, fontSize: 13)),
        ],
      ),
    );
  }

  Widget _buildCategorySummaryCard(BreakType type, List<BreakRecord> logs) {
    final typeLogs = logs.where((l) => l.breakTypeId == type.id);
    final totalUses = typeLogs.length;
    bool isPaid = type.type == 'paid';
    Color color = Colors.blue; 

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(color: color.withOpacity(0.1), shape: BoxShape.circle),
                      child: Icon(Icons.coffee_outlined, color: color, size: 16),
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(type.name ?? 'Unknown', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                        const SizedBox(height: 2),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(color: isPaid ? Colors.green.shade50 : Colors.grey.shade100, borderRadius: BorderRadius.circular(4)),
                          child: Text(
                            isPaid ? 'Paid' : 'Unpaid',
                            style: TextStyle(color: isPaid ? Colors.green.shade700 : Colors.grey.shade700, fontSize: 9, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                  decoration: BoxDecoration(color: Colors.indigo.shade50, borderRadius: BorderRadius.circular(8)),
                  child: Column(
                    children: [
                      Text('${type.maxMinutes ?? 0}m', style: TextStyle(color: Colors.indigo.shade700, fontWeight: FontWeight.bold, fontSize: 16)),
                      Text('Max Limit', style: TextStyle(color: Colors.indigo.shade400, fontSize: 9, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Divider(height: 1),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(child: _buildMiniStat('$totalUses', 'Total Uses', Icons.bar_chart)),
                Container(width: 1, height: 24, color: Colors.grey.shade200, margin: const EdgeInsets.symmetric(horizontal: 16)),
                Expanded(child: _buildMiniStat('-', 'Today', Icons.today)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMiniStat(String value, String label, IconData icon) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, size: 14, color: Colors.grey.shade400),
        const SizedBox(width: 6),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
            Text(label, style: TextStyle(fontSize: 10, color: Colors.grey.shade500, fontWeight: FontWeight.w600)),
          ],
        ),
      ],
    );
  }
}

