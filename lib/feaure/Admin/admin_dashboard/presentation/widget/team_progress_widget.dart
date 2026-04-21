import 'package:flutter/material.dart';
import 'package:flutter/material.dart';

class TeamProgressWidget extends StatelessWidget {
  const TeamProgressWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Column(
        children: [

          /// HEADER
          Row(
            children: [
              const Text(
                "Team Progress",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const Spacer(),
              const Icon(Icons.more_vert),
            ],
          ),

          const SizedBox(height: 16),
          Divider(color: Colors.grey.shade300),
          const SizedBox(height: 10),

          _teamItem(
            name: "Alexandra Della",
            role: "Frontend Developer",
            progress: 0.40,
            image:
            "https://randomuser.me/api/portraits/women/44.jpg",
            color: Colors.blue,
          ),

          _teamItem(
            name: "Archie Cantones",
            role: "UI/UX Designer",
            progress: 0.65,
            image:
            "https://randomuser.me/api/portraits/men/32.jpg",
            color: Colors.green,
          ),

          _teamItem(
            name: "Malanie Hanvey",
            role: "Backend Developer",
            progress: 0.50,
            image:
            "https://randomuser.me/api/portraits/women/68.jpg",
            color: Colors.orange,
          ),

          _teamItem(
            name: "Kenneth Hune",
            role: "Digital Marketer",
            progress: 0.30,
            image:
            "https://randomuser.me/api/portraits/men/75.jpg",
            color: Colors.red,
          ),
        ],
      ),
    );
  }

  Widget _teamItem({
    required String name,
    required String role,
    required double progress,
    required String image,
    required Color color,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [

          /// PROFILE IMAGE
          CircleAvatar(
            radius: 22,
            backgroundImage: NetworkImage(image),
          ),

          const SizedBox(width: 12),

          /// NAME + ROLE
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 4),
                Text(
                  role,
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),

          /// CIRCULAR PROGRESS
          Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                height: 50,
                width: 50,
                child: CircularProgressIndicator(
                  value: progress,
                  strokeWidth: 5,
                  backgroundColor: Colors.grey.shade200,
                  valueColor: AlwaysStoppedAnimation(color),
                ),
              ),
              Text(
                "${(progress * 100).toInt()}%",
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}