import 'package:flutter/material.dart';

class ShiftWorkingHoursScreen extends StatefulWidget {
  const ShiftWorkingHoursScreen({super.key});

  @override
  State<ShiftWorkingHoursScreen> createState() => _ShiftWorkingHoursScreenState();
}

class _ShiftWorkingHoursScreenState extends State<ShiftWorkingHoursScreen> {
  String? _selectedBranch;
  bool _isActive = true;

  final Map<String, bool> _workingDays = {
    'Sunday': false,
    'Monday': true,
    'Tuesday': true,
    'Wednesday': true,
    'Thursday': true,
    'Friday': true,
    'Saturday': true,
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text('Shift & Working Hours Setup', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 1,
        shadowColor: Colors.black12,
        actions: [
          TextButton(
            onPressed: () {},
            child: Text('Cancel', style: TextStyle(color: Colors.grey.shade600, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildDetailsCard(),
                  const SizedBox(height: 16),
                  _buildWorkingDaysCard(),
                  const SizedBox(height: 16),
                  _buildStatusCard(),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
          _buildBottomBar(),
        ],
      ),
    );
  }

  Widget _buildDetailsCard() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Icon(Icons.info_outline, size: 20, color: Colors.indigo.shade400),
                const SizedBox(width: 8),
                const Text('Branch & Shift Details', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
              ],
            ),
          ),
          const Divider(height: 1),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                _buildComplexField(
                  'Select Branch',
                  'Select Branch',
                  Icons.business_outlined,
                  isDropdown: true,
                  value: _selectedBranch,
                  onDropdownChanged: (v) {
                    setState(() => _selectedBranch = v);
                  },
                ),
                const SizedBox(height: 16),
                _buildComplexField('Shift Name', 'Morning Shift', Icons.label_outline),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(child: _buildComplexField('Start Time', '--:--', Icons.access_time, suffixIcon: Icons.keyboard_arrow_down)),
                    const SizedBox(width: 16),
                    Expanded(child: _buildComplexField('End Time', '--:--', Icons.access_time, suffixIcon: Icons.keyboard_arrow_down)),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWorkingDaysCard() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Icon(Icons.calendar_month_outlined, size: 20, color: Colors.indigo.shade400),
                const SizedBox(width: 8),
                const Text('Working Days', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
              ],
            ),
          ),
          const Divider(height: 1),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: _workingDays.keys.map((day) {
                    bool isSelected = _workingDays[day]!;
                    String initial = day.substring(0, 3);
                    return InkWell(
                      onTap: () {
                        setState(() {
                          _workingDays[day] = !isSelected;
                        });
                      },
                      borderRadius: BorderRadius.circular(8),
                      child: Container(
                        width: 42,
                        height: 42,
                        decoration: BoxDecoration(
                          color: isSelected ? Colors.indigo : Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: isSelected ? Colors.indigo : Colors.grey.shade300),
                          boxShadow: isSelected
                              ? [BoxShadow(color: Colors.indigo.withOpacity(0.3), blurRadius: 6, offset: const Offset(0, 2))]
                              : null,
                        ),
                        child: Center(
                          child: Text(
                            initial,
                            style: TextStyle(
                              color: isSelected ? Colors.white : Colors.grey.shade600,
                              fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                              fontSize: 13,
                            ),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Icon(Icons.info_outline, size: 14, color: Colors.grey.shade500),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        'Select the days employees will work in this shift',
                        style: TextStyle(fontSize: 11, color: Colors.grey.shade500),
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

  Widget _buildStatusCard() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: SwitchListTile(
        value: _isActive,
        activeColor: Colors.indigo,
        onChanged: (val) {
          setState(() => _isActive = val);
        },
        title: const Text('Shift Status', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
        subtitle: Text(_isActive ? 'Active' : 'Inactive', style: TextStyle(color: Colors.grey.shade500, fontSize: 12)),
        secondary: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(color: Colors.indigo.shade50, shape: BoxShape.circle),
          child: Icon(Icons.toggle_on_outlined, color: Colors.indigo.shade400, size: 20),
        ),
      ),
    );
  }

  Widget _buildBottomBar() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Colors.grey.shade200)),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, -4)),
        ],
      ),
      child: SafeArea(
        child: ElevatedButton(
          onPressed: () {},
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.indigo,
            foregroundColor: Colors.white,
            minimumSize: const Size(double.infinity, 50),
            elevation: 0,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ),
          child: const Text('SAVE SHIFT SETUP', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, letterSpacing: 1)),
        ),
      ),
    );
  }

  Widget _buildComplexField(String label, String hint, IconData prefixIcon,
      {bool isDropdown = false, IconData? suffixIcon, String? value, Function(String?)? onDropdownChanged}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.grey[500], letterSpacing: 0.5),
        ),
        const SizedBox(height: 6),
        Container(
          height: 48,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(6),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: Row(
            children: [
              Container(
                width: 46,
                decoration: BoxDecoration(
                  color: Colors.grey.shade50,
                  borderRadius: const BorderRadius.horizontal(left: Radius.circular(5)),
                  border: Border(right: BorderSide(color: Colors.grey.shade200)),
                ),
                child: Center(
                  child: Icon(prefixIcon, size: 18, color: Colors.indigo.shade300),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  child: isDropdown
                      ? DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            isExpanded: true,
                            hint: Text(hint, style: TextStyle(color: Colors.grey.shade400)),
                            icon: Icon(Icons.keyboard_arrow_down, color: Colors.grey.shade400, size: 20),
                            value: value,
                            style: TextStyle(fontSize: 13, color: Colors.grey.shade800, fontWeight: FontWeight.w500),
                            items: ['Branch A', 'Branch B', 'HQ'].map((String val) {
                              return DropdownMenuItem<String>(
                                value: val,
                                child: Text(val),
                              );
                            }).toList(),
                            onChanged: onDropdownChanged,
                          ),
                        )
                      : TextField(
                          readOnly: true,
                          decoration: InputDecoration(
                            hintText: hint,
                            hintStyle: TextStyle(fontSize: 13, color: Colors.grey.shade800, fontWeight: FontWeight.w500),
                            border: InputBorder.none,
                            isDense: true,
                            contentPadding: EdgeInsets.zero,
                          ),
                        ),
                ),
              ),
              if (suffixIcon != null)
                Padding(
                  padding: const EdgeInsets.only(right: 12.0),
                  child: Icon(suffixIcon, size: 16, color: Colors.grey.shade400),
                ),
            ],
          ),
        ),
      ],
    );
  }
}

