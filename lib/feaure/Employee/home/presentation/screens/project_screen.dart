import 'package:flutter/material.dart';

import '../widget/project_screen_widget/project_screen_widget.dart';
// import 'package:lebroid_crm/feaure/home/presentation/widget/project_screen_widget/project_screen_widget.dart';

class ProjectScreen extends StatelessWidget {
  const ProjectScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Projects")),
      body: Column(
        children: [
          // 🔹 Horizontal Summary Cards
          SizedBox(
            height: 140,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: [
                TotalProjectWidget(
                  icon: Icons.folder,
                  projectStatus: "Total Projects",
                  projectCount: "24",
                  color: Colors.blue,
                ),
                TotalProjectWidget(
                  icon: Icons.timelapse,
                  projectStatus: "In Progress",
                  projectCount: "10",
                  color: Colors.orange,
                ),
                TotalProjectWidget(
                  icon: Icons.check_circle,
                  projectStatus: "Completed",
                  projectCount: "14",
                  color: Colors.green,
                ),
              ],
            ),
          ),

          const SizedBox(height: 12),

          // 🔹 Search + Filters
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                // Search
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: "Search projects...",
                      prefixIcon: const Icon(Icons.search),
                      filled: true,
                      fillColor: Colors.grey.shade100,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),

                // Dropdown 1
                _dropdown(
                  value: "All",
                  items: const ["All", "In Progress", "Completed"],
                ),

                const SizedBox(width: 8),

                // Dropdown 2
                _dropdown(
                  value: "High",
                  items: const ["High", "Medium", "Low"],
                ),
              ],
            ),
          ),

          const SizedBox(height: 12),

          // 🔹 Project List
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: 6,
              itemBuilder: (context, index) {
                return _projectItem(
                  title: "CRM Mobile App",
                  status: "In Progress",
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // ===================== UI HELPERS (same class) =====================
  Widget _dropdown({required String value, required List<String> items}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          items: items
              .map((e) => DropdownMenuItem(value: e, child: Text(e)))
              .toList(),
          onChanged: (_) {},
        ),
      ),
    );
  }

  Widget _projectItem({required String title, required String status}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, 3)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 6),
          Text(status, style: TextStyle(color: Colors.grey.shade600)),
        ],
      ),
    );
  }
}
