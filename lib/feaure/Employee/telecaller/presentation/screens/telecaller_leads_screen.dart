import 'package:flutter/material.dart';


class TelecallerLeadsScreen extends StatelessWidget {
  const TelecallerLeadsScreen({super.key});

  final List<Map<String, dynamic>> dummyLeads = const [
    {
      'latestDate': '12-09-2025',
      'source': 'Just Dial',
      'name': 'Rahul Sharma',
      'phone': '9876543210',
      'tags': 'Hot',
      'assigned': 'John',
      'status': 'New',
      'value': '₹25,000',
      'createdDate': '10-09-2025',
    },
    {
      'latestDate': '13-09-2025',
      'source': 'Website',
      'name': 'Amit Verma',
      'phone': '9123456789',
      'tags': 'Warm',
      'assigned': 'Alex',
      'status': 'In Progress',
      'value': '₹40,000',
      'createdDate': '11-09-2025',
    },
  ];

  Color _statusColor(String status) {
    switch (status) {
      case 'New':
        return Colors.blue;
      case 'In Progress':
        return Colors.orange;
      case 'Closed':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  Widget _infoRow(String label, String value, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 18, color: Colors.grey.shade600),
          const SizedBox(width: 10),
          SizedBox(
            width: 90,
            child: Text(
              label,
              style: TextStyle(
                fontSize: 13,
                color: Colors.grey.shade700,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _statusChip(String status) {
    final color = _statusColor(status);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Text(
        status,
        style: TextStyle(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F7FB),
      appBar: AppBar(
        title: const Text('Telecaller Leads'),
        centerTitle: true,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(14),
        itemCount: dummyLeads.length,
        itemBuilder: (context, index) {
          final lead = dummyLeads[index];

          return Card(
            elevation: 3,
            shadowColor: Colors.black12,
            margin: const EdgeInsets.only(bottom: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// Header (Name + Status)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          lead['name'],
                          style: const TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      _statusChip(lead['status']),
                    ],
                  ),

                  const SizedBox(height: 14),

                  /// Primary Info
                  _infoRow('Phone', lead['phone'], Icons.phone),
                  _infoRow('Source', lead['source'], Icons.public),
                  _infoRow('Tags', lead['tags'], Icons.local_offer),
                  _infoRow('Assigned', lead['assigned'], Icons.person_outline),
                  _infoRow('Value', lead['value'], Icons.currency_rupee),

                  const SizedBox(height: 12),

                  /// Divider
                  Container(
                    height: 1,
                    color: Colors.grey.shade300,
                  ),

                  const SizedBox(height: 12),

                  /// Dates
                  Row(
                    children: [
                      Expanded(
                        child: _infoRow(
                          'Latest',
                          lead['latestDate'],
                          Icons.update,
                        ),
                      ),
                      Expanded(
                        child: _infoRow(
                          'Created',
                          lead['createdDate'],
                          Icons.calendar_today,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}


