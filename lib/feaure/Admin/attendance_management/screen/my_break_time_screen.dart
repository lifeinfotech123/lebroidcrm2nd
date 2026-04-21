import 'package:flutter/material.dart';

class MyBreakTimeScreen extends StatefulWidget {
  const MyBreakTimeScreen({super.key});

  @override
  State<MyBreakTimeScreen> createState() => _MyBreakTimeScreenState();
}

class _MyBreakTimeScreenState extends State<MyBreakTimeScreen> {
  // Mock data states
  final bool _isCheckedIn = false;
  final int _breaksToday = 0;
  final String _totalTime = '0m';
  final int _overLimit = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text('My Break Time', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18)),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 1,
        shadowColor: Colors.black12,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildProfileHeader(),
            const SizedBox(height: 16),
            _buildStatsRow(),
            const SizedBox(height: 24),
            _buildBreakActionSection(),
            const SizedBox(height: 32),
            const Text(
              "Today's Break History",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            const SizedBox(height: 16),
            _buildEmptyHistory(),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10, offset: const Offset(0, 4)),
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 28,
            backgroundColor: Colors.indigo.shade50,
            foregroundColor: Colors.indigo.shade700,
            child: const Text('S', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22)),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'System Administrator',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.black87),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Text('LEB-001', style: TextStyle(color: Colors.grey.shade600, fontSize: 13, fontWeight: FontWeight.w600)),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Icon(Icons.circle, size: 4, color: Colors.grey.shade400),
                    ),
                    Text(
                      _isCheckedIn ? 'Checked In' : 'Not Checked In',
                      style: TextStyle(
                        color: _isCheckedIn ? Colors.green.shade600 : Colors.red.shade600,
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsRow() {
    return Row(
      children: [
        Expanded(child: _buildStatCard('Breaks Today', _breaksToday.toString(), Colors.blue, Icons.coffee_outlined)),
        const SizedBox(width: 12),
        Expanded(child: _buildStatCard('Total Time', _totalTime, Colors.indigo, Icons.timer_outlined)),
        const SizedBox(width: 12),
        Expanded(child: _buildStatCard('Over Limit', _overLimit.toString(), Colors.orange, Icons.warning_amber_rounded)),
      ],
    );
  }

  Widget _buildStatCard(String title, String value, Color color, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(color: color.withOpacity(0.04), blurRadius: 8, offset: const Offset(0, 2)),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(color: color.withOpacity(0.1), shape: BoxShape.circle),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(height: 12),
          Text(value, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          const SizedBox(height: 2),
          Text(title, textAlign: TextAlign.center, style: TextStyle(fontSize: 11, color: Colors.grey.shade600, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }

  Widget _buildBreakActionSection() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10, offset: const Offset(0, 4)),
        ],
      ),
      child: Column(
        children: [
          GestureDetector(
            onTap: _isCheckedIn ? () {} : null,
            child: Container(
              width: 160,
              height: 160,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _isCheckedIn ? Colors.indigo.shade50 : Colors.grey.shade100,
                border: Border.all(
                  color: _isCheckedIn ? Colors.indigo.shade200 : Colors.grey.shade300,
                  width: 4,
                ),
                boxShadow: _isCheckedIn
                    ? [BoxShadow(color: Colors.indigo.withOpacity(0.2), blurRadius: 20, spreadRadius: 5)]
                    : null,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.play_arrow_rounded,
                    size: 48,
                    color: _isCheckedIn ? Colors.indigo : Colors.grey.shade400,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Start a\nBreak',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: _isCheckedIn ? Colors.indigo.shade700 : Colors.grey.shade500,
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (!_isCheckedIn) ...[
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.red.shade50,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.red.shade100),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.error_outline, size: 16, color: Colors.red.shade500),
                  const SizedBox(width: 8),
                  Flexible(
                    child: Text(
                      'You must check in before taking a break.',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.red.shade700, fontSize: 13, fontWeight: FontWeight.w500),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildEmptyHistory() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200, width: 1, style: BorderStyle.solid),
      ),
      child: Column(
        children: [
          Icon(Icons.free_breakfast_outlined, size: 48, color: Colors.grey.shade300),
          const SizedBox(height: 16),
          Text(
            'No completed breaks yet today.',
            style: TextStyle(color: Colors.grey.shade500, fontSize: 14, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }
}
