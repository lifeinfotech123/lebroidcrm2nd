import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../bloc/leave_management_bloc.dart';
import '../bloc/leave_management_event.dart';
import '../bloc/leave_management_state.dart';
import '../bloc/leave_type_bloc.dart';
import '../bloc/leave_type_event.dart';
import '../bloc/leave_type_state.dart';
import '../data/model/leave_model.dart';
import '../data/repository/leave_repository.dart';

class ApplyForLeaveScreen extends StatefulWidget {
  const ApplyForLeaveScreen({super.key});

  @override
  State<ApplyForLeaveScreen> createState() => _ApplyForLeaveScreenState();
}

class _ApplyForLeaveScreenState extends State<ApplyForLeaveScreen> {
  final _formKey = GlobalKey<FormState>();
  int? _selectedLeaveTypeId;
  String _dayType = 'full';
  DateTime _fromDate = DateTime.now();
  DateTime _toDate = DateTime.now();
  final _reasonController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => LeaveTypeBloc(
            leaveRepository: LeaveRepository(),
          )..add(FetchLeaveTypes()),
        ),
        BlocProvider(
          create: (context) => LeaveManagementBloc(
            leaveRepository: LeaveRepository(),
          )..add(FetchLeaveBalance()),
        ),
      ],
      child: Scaffold(
        backgroundColor: Colors.grey[50],
        appBar: AppBar(
          title: const Text('Leave Request', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18)),
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          elevation: 1,
          shadowColor: Colors.black12,
        ),
        body: BlocConsumer<LeaveManagementBloc, LeaveManagementState>(
          listener: (context, state) {
            if (state.status == LeaveManagementStatus.actionSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Leave applied successfully')),
              );
              Navigator.pop(context, true);
            }
            if (state.status == LeaveManagementStatus.failure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.errorMessage ?? 'Failed to apply leave')),
              );
            }
          },
          builder: (context, state) {
            return Form(
              key: _formKey,
              child: Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          _buildFormCard(context),
                          const SizedBox(height: 24),
                          _buildLeaveBalanceCard(state),
                          const SizedBox(height: 24),
                        ],
                      ),
                    ),
                  ),
                  _buildBottomBar(context, state),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildFormCard(BuildContext context) {
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
                Icon(Icons.edit_document, size: 20, color: Colors.indigo.shade400),
                const SizedBox(width: 8),
                const Text('Leave Details', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
              ],
            ),
          ),
          const Divider(height: 1),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildFieldLabel('Leave Type', isRequired: true),
                BlocBuilder<LeaveTypeBloc, LeaveTypeState>(
                  builder: (context, state) {
                    return _buildDropdownInput(
                      '— Select Leave Type —',
                      Icons.beach_access,
                      value: _selectedLeaveTypeId,
                      items: state.leaveTypes,
                      onChanged: (id) => setState(() => _selectedLeaveTypeId = id),
                    );
                  },
                ),
                const SizedBox(height: 16),
                _buildFieldLabel('Day Type'),
                Row(
                  children: [
                    Expanded(
                      child: _buildSegmentButton('Full Day', _dayType == 'full', () => setState(() => _dayType = 'full')),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildSegmentButton('Half Day', _dayType == 'half', () => setState(() => _dayType = 'half')),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildFieldLabel('From Date', isRequired: true),
                          _buildDatePickerInput(
                            context,
                            _fromDate,
                            (date) => setState(() => _fromDate = date),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildFieldLabel('To Date', isRequired: true),
                          _buildDatePickerInput(
                            context,
                            _toDate,
                            (date) => setState(() => _toDate = date),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                _buildFieldLabel('Reason', isRequired: true),
                TextFormField(
                  controller: _reasonController,
                  maxLines: 3,
                  style: const TextStyle(fontSize: 13),
                  decoration: InputDecoration(
                    hintText: 'Please describe the reason for your leave...',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  validator: (value) => value == null || value.isEmpty ? 'Please enter reason' : null,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFieldLabel(String text, {bool isRequired = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6.0),
      child: RichText(
        text: TextSpan(
          text: text,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.grey.shade700),
          children: isRequired
              ? [TextSpan(text: ' *', style: TextStyle(color: Colors.red.shade600, fontWeight: FontWeight.bold))]
              : [],
        ),
      ),
    );
  }

  Widget _buildDatePickerInput(BuildContext context, DateTime selectedDate, Function(DateTime) onPicked) {
    return InkWell(
      onTap: () async {
        final picked = await showDatePicker(
          context: context,
          initialDate: selectedDate,
          firstDate: DateTime(2020),
          lastDate: DateTime(2030),
        );
        if (picked != null) onPicked(picked);
      },
      child: Container(
        height: 48,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(6),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Row(
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 12),
              child: Icon(Icons.calendar_today, size: 18, color: Colors.indigo),
            ),
            Text(DateFormat('dd-MM-yyyy').format(selectedDate), style: const TextStyle(fontSize: 13)),
          ],
        ),
      ),
    );
  }

  Widget _buildDropdownInput(
    String hint,
    IconData icon, {
    int? value,
    required List<dynamic> items,
    required Function(int?) onChanged,
  }) {
    return Container(
      height: 48,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              border: Border(right: BorderSide(color: Colors.grey.shade200)),
            ),
            child: Icon(icon, size: 18, color: Colors.indigo.shade300),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<int>(
                  isExpanded: true,
                  hint: Text(hint, style: TextStyle(color: Colors.grey.shade500, fontSize: 13)),
                  value: value,
                  items: items.map((val) {
                    return DropdownMenuItem<int>(
                      value: val.id,
                      child: Text(val.name, style: const TextStyle(fontSize: 13)),
                    );
                  }).toList(),
                  onChanged: onChanged,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSegmentButton(String text, bool isSelected, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? Colors.indigo.shade50 : Colors.white,
          borderRadius: BorderRadius.circular(6),
          border: Border.all(color: isSelected ? Colors.indigo.shade300 : Colors.grey.shade300),
        ),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 13,
              color: isSelected ? Colors.indigo.shade700 : Colors.grey.shade600,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLeaveBalanceCard(LeaveManagementState state) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Icon(Icons.account_balance_wallet_outlined, size: 20, color: Colors.indigo),
                const SizedBox(width: 8),
                const Text('Leave Balance', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
              ],
            ),
          ),
          const Divider(height: 1),
          if (state.status == LeaveManagementStatus.loading && state.balances.isEmpty)
            const Padding(padding: EdgeInsets.all(20), child: Center(child: CircularProgressIndicator()))
          else if (state.balances.isEmpty)
            const Padding(padding: EdgeInsets.all(20), child: Text('No balance data available'))
          else
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Wrap(
                spacing: 12,
                runSpacing: 12,
                children: state.balances.map((b) => _buildBalanceItem(b.name, '${b.used}/${b.allocated}', b.remaining > 0 ? Colors.green : Colors.grey)).toList(),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildBalanceItem(String title, String ratio, Color color) {
    return Container(
      width: 150,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.05),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: TextStyle(color: Colors.grey.shade700, fontSize: 11, fontWeight: FontWeight.w600), overflow: TextOverflow.ellipsis),
          const SizedBox(height: 6),
          Text(ratio, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: color)),
        ],
      ),
    );
  }

  Widget _buildBottomBar(BuildContext context, LeaveManagementState state) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Colors.grey.shade200)),
      ),
      child: SafeArea(
        child: ElevatedButton(
          onPressed: state.status == LeaveManagementStatus.loading
              ? null
              : () => _submitLeave(context),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.indigo,
            foregroundColor: Colors.white,
            minimumSize: const Size(double.infinity, 50),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ),
          child: state.status == LeaveManagementStatus.loading
              ? const CircularProgressIndicator(color: Colors.white)
              : const Text('SUBMIT LEAVE REQUEST', style: TextStyle(fontWeight: FontWeight.bold)),
        ),
      ),
    );
  }

  void _submitLeave(BuildContext context) {
    if (_formKey.currentState!.validate() && _selectedLeaveTypeId != null) {
      final leave = LeaveModel(
        leaveTypeId: _selectedLeaveTypeId!,
        fromDate: _fromDate,
        toDate: _toDate,
        dayType: _dayType,
        reason: _reasonController.text,
      );
      context.read<LeaveManagementBloc>().add(ApplyLeaveRequest(leave));
    } else if (_selectedLeaveTypeId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select leaf type')),
      );
    }
  }
}

