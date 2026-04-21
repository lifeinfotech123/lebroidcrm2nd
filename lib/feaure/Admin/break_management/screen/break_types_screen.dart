import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/break_bloc.dart';
import '../bloc/break_event.dart';
import '../bloc/break_state.dart';
import '../data/repository/break_repository.dart';
import '../data/model/break_model.dart';
import 'package:intl/intl.dart';

class BreakTypesScreen extends StatefulWidget {
  const BreakTypesScreen({super.key});

  @override
  State<BreakTypesScreen> createState() => _BreakTypesScreenState();
}

class _BreakTypesScreenState extends State<BreakTypesScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => BreakBloc(breakRepository: BreakRepository())..add(FetchBreakTypes()),
      child: Scaffold(
        backgroundColor: Colors.grey[50],
        appBar: AppBar(
          title: const Text('Break Categories', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18)),
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          elevation: 1,
          shadowColor: Colors.black12,
        ),
        body: BlocBuilder<BreakBloc, BreakState>(
          builder: (context, state) {
            List<BreakType> types = [];
            bool isLoading = state is BreakLoading;

            if (state is BreaksLoaded) {
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
                        _buildStatsGrid(types),
                        const SizedBox(height: 16),
                        _buildSearchAndFilters(),
                        const SizedBox(height: 24),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('${types.length} category(s)', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                          ],
                        ),
                        const SizedBox(height: 12),
                        if (isLoading && types.isEmpty)
                          const Center(child: Padding(padding: EdgeInsets.all(32.0), child: CircularProgressIndicator()))
                        else if (types.isEmpty)
                          const Center(child: Text('No break categories found')),
                      ],
                    ),
                  ),
                ),
                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0).copyWith(bottom: 24.0),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        return _buildCategoryCard(types[index]);
                      },
                      childCount: types.length,
                    ),
                  ),
                ),
              ],
            );
          },
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {},
          backgroundColor: Colors.indigo,
          child: const Icon(Icons.add, color: Colors.white),
        ),
      ),
    );
  }

  Widget _buildStatsGrid(List<BreakType> types) {
    final paidCount = types.where((t) => t.type == 'paid').length;
    final unpaidCount = types.where((t) => t.type == 'unpaid').length;

    return Row(
      children: [
        Expanded(child: _buildSmallStatCard('Total', '${types.length}', Colors.blue, Icons.list_alt_outlined)),
        const SizedBox(width: 8),
        Expanded(child: _buildSmallStatCard('Paid', '$paidCount', Colors.green, Icons.monetization_on_outlined)),
        const SizedBox(width: 8),
        Expanded(child: _buildSmallStatCard('Unpaid', '$unpaidCount', Colors.grey, Icons.money_off_outlined)),
        const SizedBox(width: 8),
        Expanded(child: _buildSmallStatCard('Active', '${types.length}', Colors.orange, Icons.check_circle_outline)),
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
            hintText: 'Search categories...',
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

  Widget _buildCategoryCard(BreakType type) {
    bool isPaid = type.type == 'paid';
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(type.name ?? 'Unknown', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                          const SizedBox(width: 8),
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
                      const SizedBox(height: 4),
                      Text('Duration Limit: ${type.maxMinutes ?? 0}m', style: TextStyle(color: Colors.grey.shade500, fontSize: 11)),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () {},
                  icon: Icon(Icons.edit_outlined, color: Colors.grey.shade400, size: 18),
                  constraints: const BoxConstraints(),
                  padding: EdgeInsets.zero,
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('${type.maxMinutes ?? 0}m', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.indigo.shade700)),
                      const SizedBox(height: 2),
                      Text('Max Duration', style: TextStyle(fontSize: 10, color: Colors.grey.shade600, fontWeight: FontWeight.w600)),
                    ],
                  ),
                ),
                Container(width: 1, height: 32, color: Colors.grey.shade200, margin: const EdgeInsets.symmetric(horizontal: 16)),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('?', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.black87)),
                      const SizedBox(height: 2),
                      Text('Stats', style: TextStyle(fontSize: 10, color: Colors.grey.shade600, fontWeight: FontWeight.w600)),
                    ],
                  ),
                ),
                Switch(
                  value: true,
                  onChanged: (v) {},
                  activeColor: Colors.indigo,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

