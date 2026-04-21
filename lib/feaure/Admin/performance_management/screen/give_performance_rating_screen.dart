import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import '../bloc/performance_bloc.dart';
import '../bloc/performance_event.dart';
import '../bloc/performance_state.dart';
import '../data/model/performance_model.dart';

class GivePerformanceRatingScreen extends StatefulWidget {
  final PerformanceModel? performance; // null = create, non-null = edit
  const GivePerformanceRatingScreen({super.key, this.performance});

  @override
  State<GivePerformanceRatingScreen> createState() => _GivePerformanceRatingScreenState();
}

class _GivePerformanceRatingScreenState extends State<GivePerformanceRatingScreen> {
  double attendance = 8;
  double taskQuality = 8;
  double punctuality = 8;
  double teamwork = 8;
  double communication = 8;
  double initiative = 8;

  bool notifyEmployee = true;
  bool get isEditing => widget.performance != null;

  final TextEditingController _remarksController = TextEditingController();
  final TextEditingController _improvementController = TextEditingController();
  final TextEditingController _userIdController = TextEditingController(text: '2');
  final TextEditingController _monthController = TextEditingController(text: '2026-04');

  String _selectedPeriod = 'monthly';

  @override
  void initState() {
    super.initState();
    if (isEditing) {
      final p = widget.performance!;
      attendance = p.ratingAttendance.toDouble();
      taskQuality = p.ratingTaskQuality.toDouble();
      punctuality = p.ratingPunctuality.toDouble();
      teamwork = p.ratingTeamwork.toDouble();
      communication = p.ratingCommunication.toDouble();
      initiative = p.ratingInitiative.toDouble();
      _remarksController.text = p.managerRemarks ?? '';
      _improvementController.text = p.improvementAreas ?? '';
      _userIdController.text = p.userId;
      _monthController.text = p.month;
      _selectedPeriod = p.period ?? 'monthly';
    }
  }

  @override
  void dispose() {
    _remarksController.dispose();
    _improvementController.dispose();
    _userIdController.dispose();
    _monthController.dispose();
    super.dispose();
  }

  int get overallScore {
    double total = attendance + taskQuality + punctuality + teamwork + communication + initiative;
    return ((total / 60) * 100).round();
  }

  String get grade {
    int score = overallScore;
    if (score >= 90) return 'A+';
    if (score >= 80) return 'A';
    if (score >= 70) return 'B';
    if (score >= 60) return 'C';
    return 'D';
  }

  void _saveRating() {
    final data = {
      "user_id": int.tryParse(_userIdController.text) ?? 2,
      "month": _monthController.text,
      "period": _selectedPeriod,
      "rating_attendance": attendance.toInt(),
      "rating_task_quality": taskQuality.toInt(),
      "rating_punctuality": punctuality.toInt(),
      "rating_teamwork": teamwork.toInt(),
      "rating_communication": communication.toInt(),
      "rating_initiative": initiative.toInt(),
      "manager_remarks": _remarksController.text,
      "improvement_areas": _improvementController.text,
    };

    if (isEditing) {
      context.read<PerformanceBloc>().add(UpdatePerformance(widget.performance!.id, data));
    } else {
      context.read<PerformanceBloc>().add(CreatePerformance(data));
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<PerformanceBloc, PerformanceState>(
      listener: (context, state) {
        if (state is PerformanceOperationSuccess) {
          Get.back();
          Get.snackbar("Success", state.message, backgroundColor: Colors.green, colorText: Colors.white);
        } else if (state is PerformanceError) {
          Get.snackbar("Error", state.message, backgroundColor: Colors.red, colorText: Colors.white);
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          automaticallyImplyLeading: false,
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                isEditing ? 'Edit Performance Rating' : 'Performance Rating',
                style: const TextStyle(color: Color(0xFF1E293B), fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              Text(
                isEditing ? 'Editing User #${widget.performance!.userId}' : 'New Rating',
                style: TextStyle(color: Colors.grey.shade500, fontSize: 12),
              ),
            ],
          ),
          actions: [
            IconButton(
              icon: Icon(Icons.close, color: Colors.grey.shade500),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(1.0),
            child: Container(color: Colors.grey.shade200, height: 1.0),
          ),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildScoreBanner(),
              const SizedBox(height: 24),
              Column(
                children: [
                  _buildTextInputField('USER ID *', _userIdController),
                  const SizedBox(height: 16),
                  _buildTextInputField('MONTH *', _monthController, hint: 'YYYY-MM'),
                  const SizedBox(height: 16),
                  _buildPeriodDropdown(),
                ],
              ),
              const SizedBox(height: 24),
              Column(
                children: [
                  _buildRatingCard('Attendance & Presence', Icons.event_available, Colors.green, attendance, (val) => setState(() => attendance = val)),
                  const SizedBox(height: 16),
                  _buildRatingCard('Task Quality & Completion', Icons.check_circle_outline, Colors.blue, taskQuality, (val) => setState(() => taskQuality = val)),
                  const SizedBox(height: 16),
                  _buildRatingCard('Punctuality & Time Mgmt', Icons.access_time, Colors.teal, punctuality, (val) => setState(() => punctuality = val)),
                  const SizedBox(height: 16),
                  _buildRatingCard('Teamwork & Collaboration', Icons.people_outline, Colors.orange, teamwork, (val) => setState(() => teamwork = val)),
                  const SizedBox(height: 16),
                  _buildRatingCard('Communication Skills', Icons.chat_bubble_outline, Colors.grey.shade600, communication, (val) => setState(() => communication = val)),
                  const SizedBox(height: 16),
                  _buildRatingCard('Initiative & Proactiveness', Icons.bolt, Colors.red, initiative, (val) => setState(() => initiative = val)),
                ],
              ),
              const SizedBox(height: 24),
              _buildSectionTitle('MANAGER REMARKS'),
              const SizedBox(height: 8),
              _buildTextArea('Overall feedback and observations...', _remarksController),
              const SizedBox(height: 24),
              _buildSectionTitle('AREAS FOR IMPROVEMENT'),
              const SizedBox(height: 8),
              _buildTextArea('Specific areas the employee should work on...', _improvementController),
              const SizedBox(height: 24),
              Row(
                children: [
                  SizedBox(
                    height: 24, width: 24,
                    child: Checkbox(
                      value: notifyEmployee,
                      onChanged: (val) => setState(() => notifyEmployee = val ?? true),
                      activeColor: const Color(0xFF3B82F6),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text('Notify employee about this rating', style: TextStyle(color: Colors.grey.shade600, fontSize: 13)),
                ],
              ),
              const SizedBox(height: 32),
              BlocBuilder<PerformanceBloc, PerformanceState>(
                builder: (context, state) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      OutlinedButton(
                        onPressed: () => Navigator.of(context).pop(),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.grey.shade700,
                          side: BorderSide(color: Colors.grey.shade300),
                          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                          textStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                        ),
                        child: const Text('CANCEL'),
                      ),
                      const SizedBox(width: 12),
                      ElevatedButton.icon(
                        onPressed: state is PerformanceLoading ? null : _saveRating,
                        icon: state is PerformanceLoading
                            ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                            : const Icon(Icons.save, size: 16),
                        label: Text(isEditing ? 'UPDATE RATING' : 'SAVE RATING'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF3B82F6),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                          textStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                          elevation: 0,
                        ),
                      ),
                    ],
                  );
                },
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildScoreBanner() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFFE2E8F0),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '$overallScore',
                style: const TextStyle(color: Color(0xFF2563EB), fontSize: 40, fontWeight: FontWeight.bold, height: 1.0),
              ),
              const SizedBox(height: 4),
              Text('/ 100', style: TextStyle(color: Colors.grey.shade600, fontSize: 12)),
            ],
          ),
          const SizedBox(width: 32),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: overallScore / 100,
                    backgroundColor: Colors.white,
                    valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF2563EB)),
                    minHeight: 8,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('0', style: TextStyle(color: Colors.grey.shade500, fontSize: 11)),
                    Text('Grade: $grade', style: const TextStyle(color: Color(0xFF2563EB), fontSize: 11, fontWeight: FontWeight.bold)),
                    Text('100', style: TextStyle(color: Colors.grey.shade500, fontSize: 11)),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextInputField(String label, TextEditingController controller, {String? hint}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle(label),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 14),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(4), borderSide: BorderSide(color: Colors.grey.shade300)),
            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(4), borderSide: BorderSide(color: Colors.grey.shade200)),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          ),
        ),
      ],
    );
  }

  Widget _buildPeriodDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('PERIOD TYPE'),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade200),
            borderRadius: BorderRadius.circular(4),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              isExpanded: true,
              value: _selectedPeriod,
              items: ['monthly', 'quarterly', 'yearly'].map((e) => DropdownMenuItem(value: e, child: Text(e.capitalizeFirst!))).toList(),
              onChanged: (val) {
                if (val != null) setState(() => _selectedPeriod = val);
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: TextStyle(color: Colors.grey.shade600, fontSize: 11, fontWeight: FontWeight.bold, letterSpacing: 0.5),
    );
  }

  Widget _buildRatingCard(String title, IconData icon, Color color, double value, ValueChanged<double> onChanged) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey.shade200),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(
                  children: [
                    Icon(icon, color: color, size: 20),
                    const SizedBox(width: 8),
                    Flexible(child: Text(title, style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF475569), fontSize: 13))),
                  ],
                ),
              ),
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(text: '${value.toInt()}', style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 18)),
                    TextSpan(text: ' /10', style: TextStyle(color: Colors.grey.shade500, fontSize: 12)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          SliderTheme(
            data: SliderThemeData(
              activeTrackColor: Colors.blue.shade100,
              inactiveTrackColor: Colors.grey.shade200,
              thumbColor: const Color(0xFF2563EB),
              overlayColor: const Color(0xFF2563EB).withOpacity(0.2),
              trackHeight: 6.0,
              thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 8.0),
              overlayShape: const RoundSliderOverlayShape(overlayRadius: 16.0),
            ),
            child: Slider(
              value: value,
              min: 1,
              max: 10,
              divisions: 9,
              onChanged: onChanged,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Poor (1)', style: TextStyle(color: Colors.grey.shade500, fontSize: 10)),
              Text('Average (5)', style: TextStyle(color: Colors.grey.shade500, fontSize: 10)),
              Text('Excellent (10)', style: TextStyle(color: Colors.grey.shade500, fontSize: 10)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTextArea(String hint, TextEditingController controller) {
    return TextField(
      controller: controller,
      maxLines: 4,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 14),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(4), borderSide: BorderSide(color: Colors.grey.shade300)),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(4), borderSide: BorderSide(color: Colors.grey.shade200)),
        contentPadding: const EdgeInsets.all(16),
      ),
    );
  }
}
