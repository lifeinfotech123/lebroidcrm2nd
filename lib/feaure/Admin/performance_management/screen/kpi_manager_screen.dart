import 'package:flutter/material.dart';

class KPIItem {
  final String title;
  final String category;
  final bool active;
  final String weight;
  final String target;

  KPIItem({
    required this.title,
    required this.category,
    required this.active,
    required this.weight,
    required this.target,
  });
}

class KPIManagerScreen extends StatefulWidget {
  const KPIManagerScreen({super.key});

  @override
  State<KPIManagerScreen> createState() => _KPIManagerScreenState();
}

class _KPIManagerScreenState extends State<KPIManagerScreen> {
  final List<KPIItem> _kpis = [
    KPIItem(title: 'Attendance Rate', category: 'Attendance', active: true, weight: '40%', target: '≥ 95%'),
    KPIItem(title: 'Task Completion Rate', category: 'Task', active: true, weight: '40%', target: '≥ 90%'),
    KPIItem(title: 'Punctuality Score', category: 'Punctuality', active: true, weight: '20%', target: '≤ 2 late/month'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text('KPI Manager', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18)),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 1,
        shadowColor: Colors.black12,
        actions: [
          IconButton(icon: const Icon(Icons.add_circle_outline), onPressed: () {}),
        ],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _kpis.length,
        itemBuilder: (context, index) {
          return _buildKPICard(_kpis[index]);
        },
      ),
    );
  }

  Widget _buildKPICard(KPIItem kpi) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10, offset: const Offset(0, 4)),
        ],
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(kpi.title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.black87)),
                      const SizedBox(height: 6),
                      Text(kpi.category, style: TextStyle(color: Colors.grey.shade600, fontSize: 13, fontWeight: FontWeight.w500)),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(color: kpi.active ? Colors.green.shade50 : Colors.grey.shade100, borderRadius: BorderRadius.circular(6)),
                  child: Text(kpi.active ? 'Active' : 'Inactive', style: TextStyle(color: kpi.active ? Colors.green.shade700 : Colors.grey.shade600, fontSize: 11, fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(kpi.weight, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.indigo.shade700)),
                      const SizedBox(height: 2),
                      Text('Weight', style: TextStyle(color: Colors.grey.shade500, fontSize: 11, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
                Container(width: 1, height: 32, color: Colors.grey.shade200),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(kpi.target, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Colors.black87)),
                        const SizedBox(height: 4),
                        Text('Target', style: TextStyle(color: Colors.grey.shade500, fontSize: 11, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                ),
                Icon(Icons.more_vert, color: Colors.grey.shade400, size: 20),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

