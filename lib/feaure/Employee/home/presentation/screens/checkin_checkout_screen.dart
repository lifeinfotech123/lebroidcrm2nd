import 'package:flutter/material.dart';

class CheckinCheckoutScreen extends StatelessWidget {
  const CheckinCheckoutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 24),

              /// Welcome Text
              RichText(
                text: const TextSpan(
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  children: [
                    TextSpan(
                      text: 'Welcome, ',
                      style: TextStyle(color: Colors.orange),
                    ),
                    TextSpan(
                      text: 'Jack',
                      style: TextStyle(color: Colors.black),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 6),

              /// Designation
              const Text(
                'UI/UX Intern',
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),

              const SizedBox(height: 30),

              /// Time
              const Text(
                '09:30',
                style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 4),

              /// Date
              const Text(
                'Monday | July 03',
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),

              const SizedBox(height: 40),

              /// Clock In Button
              GestureDetector(
                onTap: () {},
                child: Container(
                  height: 150,
                  width: 150,
                  decoration: const BoxDecoration(
                    color: Color(0xFFFFC107),
                    shape: BoxShape.circle,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(Icons.touch_app, size: 48, color: Colors.white),
                      SizedBox(height: 8),
                      Text(
                        'Clock in',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),

              /// Location Info
              const Text(
                'You are 1 meter away from office',
                style: TextStyle(fontSize: 13, color: Colors.grey),
              ),
              const SizedBox(height: 4),
              const Text(
                'Vashi · Navi Mumbai',
                style: TextStyle(fontSize: 13, color: Colors.grey),
              ),

              const Spacer(),

              /// Bottom Stats Card
              Container(
                padding: const EdgeInsets.symmetric(vertical: 16),
                margin: const EdgeInsets.only(bottom: 24),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.orange.shade200),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: const [
                    _BottomStat(
                      icon: Icons.login,
                      value: '00:00',
                      label: 'Clock in',
                    ),
                    _BottomStat(
                      icon: Icons.logout,
                      value: '00:00',
                      label: 'Check out',
                    ),
                    _BottomStat(
                      icon: Icons.timer,
                      value: '00:00',
                      label: 'Total hours',
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _BottomStat extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;

  const _BottomStat({
    required this.icon,
    required this.value,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: Colors.orange),
        const SizedBox(height: 6),
        Text(
          value,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
        ),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
      ],
    );
  }
}
