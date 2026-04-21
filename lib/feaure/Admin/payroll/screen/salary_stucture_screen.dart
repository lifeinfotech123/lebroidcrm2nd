import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:lebroid_crm/feaure/Admin/payroll/bloc/salary_bloc.dart';
import 'package:lebroid_crm/feaure/Admin/payroll/bloc/salary_event.dart';
import 'package:lebroid_crm/feaure/Admin/payroll/bloc/salary_state.dart';
import 'package:lebroid_crm/feaure/Admin/payroll/data/model/salary_model.dart';

class SalaryStuctureScreen extends StatefulWidget {
  final int employeeId;
  final String employeeName;
  final String? empCode;
  final String? department;
  final String? branch;
  final double basicSalary;
  final double grossSalary;
  final double netSalary;
  final String salaryType;

  const SalaryStuctureScreen({
    super.key,
    required this.employeeId,
    required this.employeeName,
    this.empCode,
    this.department,
    this.branch,
    required this.basicSalary,
    required this.grossSalary,
    required this.netSalary,
    required this.salaryType,
  });

  @override
  State<SalaryStuctureScreen> createState() => _SalaryStuctureScreenState();
}

class _SalaryStuctureScreenState extends State<SalaryStuctureScreen> {
  // Earnings Controllers
  late final TextEditingController _basicController;
  late final TextEditingController _hraController;
  late final TextEditingController _transportController;
  late final TextEditingController _medicalController;
  late final TextEditingController _otherAllowanceController;

  // Deductions Controllers
  late final TextEditingController _pfController;
  late final TextEditingController _tdsController;
  late final TextEditingController _otherDeductionController;

  // Settings
  String _salaryType = 'monthly';
  late final TextEditingController _effectiveFromController;
  late final TextEditingController _effectiveToController;

  bool _autoHra = false;
  bool _autoPf = false;
  bool _isSaving = false;

  // History data
  SalaryHistoryModel? _historyData;
  bool _historyLoading = true;
  String? _historyError;

  double _grossSalary = 0;
  double _totalDeductions = 0;
  double _netSalary = 0;
  double _perDay = 0;
  double _perHour = 0;

  final currencyFormat = NumberFormat.currency(locale: 'en_IN', symbol: '₹');

  @override
  void initState() {
    super.initState();

    _basicController = TextEditingController();
    _hraController = TextEditingController();
    _transportController = TextEditingController();
    _medicalController = TextEditingController();
    _otherAllowanceController = TextEditingController();
    _pfController = TextEditingController();
    _tdsController = TextEditingController();
    _otherDeductionController = TextEditingController();
    _effectiveFromController = TextEditingController(text: DateFormat('yyyy-MM-dd').format(DateTime.now()));
    _effectiveToController = TextEditingController();

    _salaryType = widget.salaryType;

    // Add listeners for live calculation
    for (var c in [
      _basicController, _hraController, _transportController,
      _medicalController, _otherAllowanceController,
      _pfController, _tdsController, _otherDeductionController
    ]) {
      c.addListener(_calculateSalary);
    }

    // Fetch salary history to populate fields
    _fetchHistory();
  }

  void _fetchHistory() {
    context.read<SalaryBloc>().add(FetchSalaryHistory(userId: widget.employeeId));
  }

  void _populateFromStructure(SalaryStructureModel s) {
    _basicController.text = s.basicSalary.toStringAsFixed(2);
    _hraController.text = s.allowances.hra.toStringAsFixed(2);
    _transportController.text = s.allowances.transportAllowance.toStringAsFixed(2);
    _medicalController.text = s.allowances.medicalAllowance.toStringAsFixed(2);
    _otherAllowanceController.text = s.allowances.otherAllowances.toStringAsFixed(2);
    _pfController.text = s.deductions.pfDeduction.toStringAsFixed(2);
    _tdsController.text = s.deductions.taxDeduction.toStringAsFixed(2);
    _otherDeductionController.text = s.deductions.otherDeductions.toStringAsFixed(2);
    _salaryType = s.salaryType;
    if (s.effectiveFrom != null) {
      _effectiveFromController.text = s.effectiveFrom!;
    }
    if (s.effectiveTo != null) {
      _effectiveToController.text = s.effectiveTo!;
    }
    _calculateSalary();
  }

  void _calculateSalary() {
    double basic = double.tryParse(_basicController.text) ?? 0;
    double hra = double.tryParse(_hraController.text) ?? 0;
    double transport = double.tryParse(_transportController.text) ?? 0;
    double medical = double.tryParse(_medicalController.text) ?? 0;
    double otherAllowance = double.tryParse(_otherAllowanceController.text) ?? 0;
    double pf = double.tryParse(_pfController.text) ?? 0;
    double tds = double.tryParse(_tdsController.text) ?? 0;
    double otherDeduction = double.tryParse(_otherDeductionController.text) ?? 0;

    setState(() {
      _grossSalary = basic + hra + transport + medical + otherAllowance;
      _totalDeductions = pf + tds + otherDeduction;
      _netSalary = _grossSalary - _totalDeductions;
      _perDay = _netSalary / 26; // 26 working days approx
      _perHour = _perDay / 8;
    });
  }

  Map<String, dynamic> _buildSalaryBody() {
    return {
      'basic_salary': double.tryParse(_basicController.text) ?? 0,
      'hra': double.tryParse(_hraController.text) ?? 0,
      'transport_allowance': double.tryParse(_transportController.text) ?? 0,
      'medical_allowance': double.tryParse(_medicalController.text) ?? 0,
      'other_allowances': double.tryParse(_otherAllowanceController.text) ?? 0,
      'pf_deduction': double.tryParse(_pfController.text) ?? 0,
      'tax_deduction': double.tryParse(_tdsController.text) ?? 0,
      'other_deductions': double.tryParse(_otherDeductionController.text) ?? 0,
      'ot_multiplier': 1.5,
      'calculation_type': _salaryType,
      'salary_type': _salaryType,
      'effective_from': _effectiveFromController.text,
      if (_effectiveToController.text.isNotEmpty)
        'effective_to': _effectiveToController.text,
    };
  }

  void _saveSalary() {
    final body = _buildSalaryBody();
    final hasCurrent = _historyData != null &&
        _historyData!.history.any((h) => h.isCurrent);

    if (hasCurrent) {
      // Update existing salary
      context.read<SalaryBloc>().add(
            UpdateSalaryEvent(userId: widget.employeeId, body: body),
          );
    } else {
      // Set new salary
      context.read<SalaryBloc>().add(
            SetSalaryEvent(userId: widget.employeeId, body: body),
          );
    }
  }

  String get _initials {
    final parts = widget.employeeName.split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return widget.employeeName.isNotEmpty
        ? widget.employeeName.substring(0, widget.employeeName.length >= 2 ? 2 : 1).toUpperCase()
        : '??';
  }

  @override
  void dispose() {
    for (var c in [
      _basicController, _hraController, _transportController,
      _medicalController, _otherAllowanceController,
      _pfController, _tdsController, _otherDeductionController,
      _effectiveFromController, _effectiveToController
    ]) {
      c.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<SalaryBloc, SalaryState>(
      listener: (context, state) {
        if (state is SalaryHistoryLoaded) {
          setState(() {
            _historyData = state.history;
            _historyLoading = false;
            _historyError = null;
          });
          // Populate fields from the current salary
          final current = state.history.history.where((h) => h.isCurrent).toList();
          if (current.isNotEmpty) {
            _populateFromStructure(current.first);
          } else if (state.history.history.isNotEmpty) {
            _populateFromStructure(state.history.history.first);
          }
        }
        if (state is SalaryHistoryError) {
          setState(() {
            _historyLoading = false;
            _historyError = state.message;
          });
          // Still set basic data from passed params
          if (_basicController.text.isEmpty) {
            _basicController.text = widget.basicSalary.toStringAsFixed(2);
          }
        }
        if (state is SalarySaving) {
          setState(() => _isSaving = true);
        }
        if (state is SalarySaved) {
          setState(() => _isSaving = false);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.green,
              behavior: SnackBarBehavior.floating,
            ),
          );
          // Refresh history after save
          _fetchHistory();
        }
        if (state is SalarySaveError) {
          setState(() => _isSaving = false);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.red,
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      },
      child: Scaffold(
        backgroundColor: const Color(0xFFF8FAFC),
        appBar: AppBar(
          title: const Text('Salary Structure'),
          backgroundColor: Colors.white,
          foregroundColor: Colors.black87,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildEmployeeHeader(),
              const SizedBox(height: 20),
              _buildCurrentSalaryCard(),
              const SizedBox(height: 24),
              _buildSectionHeader('Salary Components'),
              const SizedBox(height: 12),
              _buildSalaryComponentsSection(),
              const SizedBox(height: 24),
              _buildSectionHeader('Settings'),
              const SizedBox(height: 12),
              _buildSettingsSection(),
              const SizedBox(height: 24),
              _buildSectionHeader('Salary Breakdown'),
              const SizedBox(height: 12),
              _buildBreakdownSection(),
              const SizedBox(height: 24),
              _buildSectionHeader('Salary History'),
              const SizedBox(height: 12),
              _buildHistorySection(),
              const SizedBox(height: 40),
            ],
          ),
        ),
        bottomNavigationBar: _buildBottomAction(),
      ),
    );
  }

  Widget _buildEmployeeHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 2),
          )
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 28,
            backgroundColor: Colors.indigo.shade50,
            child: Text(
              _initials,
              style: TextStyle(color: Colors.indigo.shade700, fontWeight: FontWeight.bold, fontSize: 18),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.employeeName,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.black87),
                ),
                Text(
                  '${widget.department ?? 'N/A'}',
                  style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    if (widget.empCode != null)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.indigo.shade50,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(widget.empCode!, style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.indigo.shade700)),
                      ),
                    if (widget.branch != null) ...[
                      const SizedBox(width: 8),
                      Icon(Icons.location_on_rounded, size: 12, color: Colors.grey.shade500),
                      const SizedBox(width: 2),
                      Flexible(
                        child: Text(
                          widget.branch!,
                          style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCurrentSalaryCard() {
    final currentEffective = _historyData?.history
        .where((h) => h.isCurrent)
        .map((h) => h.effectiveFrom)
        .firstOrNull;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.indigo.shade600, Colors.indigo.shade800],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.indigo.withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 8),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Current Net Salary',
            style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 14),
          ),
          const SizedBox(height: 8),
          Text(
            currencyFormat.format(_netSalary),
            style: const TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Icon(Icons.calendar_today_rounded, size: 14, color: Colors.white.withOpacity(0.7)),
              const SizedBox(width: 6),
              Text(
                currentEffective != null ? 'Since $currentEffective' : 'Not set',
                style: TextStyle(color: Colors.white.withOpacity(0.7), fontSize: 12),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87),
    );
  }

  Widget _buildSalaryComponentsSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Auto HRA (40% of basic)', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500)),
              Switch.adaptive(
                value: _autoHra,
                activeColor: Colors.indigo,
                onChanged: (val) {
                  setState(() {
                    _autoHra = val;
                    if (val) {
                      double basic = double.tryParse(_basicController.text) ?? 0;
                      _hraController.text = (basic * 0.40).toStringAsFixed(2);
                    }
                  });
                },
              ),
            ],
          ),
          const Divider(),
          const SizedBox(height: 8),
          const Text('Earnings', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.indigo, fontSize: 14)),
          const SizedBox(height: 16),
          _buildInputField('Basic Salary *', _basicController),
          _buildInputField('HRA', _hraController, enabled: !_autoHra),
          _buildInputField('Transport Allowance', _transportController),
          _buildInputField('Medical Allowance', _medicalController),
          _buildInputField('Other Allowances', _otherAllowanceController),

          const SizedBox(height: 16),
          const Text('Deductions', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.redAccent, fontSize: 14)),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('PF Deduction (12% of basic)', style: TextStyle(fontSize: 12, color: Colors.grey)),
              Switch.adaptive(
                value: _autoPf,
                activeColor: Colors.redAccent,
                onChanged: (val) {
                  setState(() {
                    _autoPf = val;
                    if (val) {
                      double basic = double.tryParse(_basicController.text) ?? 0;
                      _pfController.text = (basic * 0.12).toStringAsFixed(2);
                    }
                  });
                },
              ),
            ],
          ),
          _buildInputField('PF Deduction', _pfController, enabled: !_autoPf),
          _buildInputField('TDS / Income Tax', _tdsController),
          _buildInputField('Other Deductions', _otherDeductionController),
        ],
      ),
    );
  }

  Widget _buildInputField(String label, TextEditingController controller, {bool enabled = true}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
          const SizedBox(height: 6),
          TextField(
            controller: controller,
            enabled: enabled,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: InputDecoration(
              prefixText: '₹ ',
              prefixStyle: const TextStyle(color: Colors.black87, fontWeight: FontWeight.bold),
              filled: !enabled,
              fillColor: Colors.grey.shade50,
              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: Colors.grey.shade300)),
              enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: Colors.grey.shade300)),
              focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: Colors.indigo)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        children: [
          _buildDropdownField('Salary Type', ['monthly', 'daily', 'hourly'], _salaryType, (val) {
            setState(() => _salaryType = val!);
          }),
          const SizedBox(height: 16),
          _buildDateField('Effective From *', _effectiveFromController),
          const SizedBox(height: 16),
          _buildDateField('Effective To (optional)', _effectiveToController),
        ],
      ),
    );
  }

  Widget _buildDateField(String label, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          readOnly: true,
          onTap: () async {
            final picked = await showDatePicker(
              context: context,
              initialDate: DateTime.now(),
              firstDate: DateTime(2020),
              lastDate: DateTime(2030),
            );
            if (picked != null) {
              controller.text = DateFormat('yyyy-MM-dd').format(picked);
            }
          },
          decoration: InputDecoration(
            suffixIcon: const Icon(Icons.calendar_today_rounded, size: 18),
            hintText: 'yyyy-mm-dd',
            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: Colors.grey.shade300)),
            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: Colors.grey.shade300)),
            focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: Colors.indigo)),
          ),
        ),
      ],
    );
  }

  Widget _buildDropdownField(String label, List<String> items, String currentVal, void Function(String?) onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
        const SizedBox(height: 6),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: items.contains(currentVal) ? currentVal : items.first,
              isExpanded: true,
              items: items.map((e) => DropdownMenuItem(
                value: e,
                child: Text(e[0].toUpperCase() + e.substring(1)),
              )).toList(),
              onChanged: onChanged,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBreakdownSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFF1F5F9),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.indigo.withOpacity(0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Earnings', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.black87)),
          const SizedBox(height: 8),
          _buildValueRow('Basic Salary', double.tryParse(_basicController.text) ?? 0),
          _buildValueRow('HRA', double.tryParse(_hraController.text) ?? 0),
          _buildValueRow('Transport', double.tryParse(_transportController.text) ?? 0),
          _buildValueRow('Medical', double.tryParse(_medicalController.text) ?? 0),
          _buildValueRow('Other Allowances', double.tryParse(_otherAllowanceController.text) ?? 0),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 8.0),
            child: Divider(),
          ),
          _buildTotalRow('Gross Salary', _grossSalary, Colors.black87),
          const SizedBox(height: 20),
          const Text('Deductions', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.black87)),
          const SizedBox(height: 8),
          _buildValueRow('PF Deduction', double.tryParse(_pfController.text) ?? 0, isDeduction: true),
          _buildValueRow('TDS / Tax', double.tryParse(_tdsController.text) ?? 0, isDeduction: true),
          _buildValueRow('Other', double.tryParse(_otherDeductionController.text) ?? 0, isDeduction: true),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 8.0),
            child: Divider(),
          ),
          _buildTotalRow('Total Deductions', _totalDeductions, Colors.redAccent, isDeduction: true),
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(color: Colors.indigo.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4)),
              ],
            ),
            child: Column(
              children: [
                const Text('Net Take-Home Salary', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.grey)),
                const SizedBox(height: 4),
                Text(
                  currencyFormat.format(_netSalary),
                  style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.indigo),
                ),
                Text('per month', style: TextStyle(fontSize: 12, color: Colors.grey.shade500)),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildSubStat(currencyFormat.format(_perDay), 'Per Day'),
                    _buildSubStat(currencyFormat.format(_perHour), 'Per Hour (OT rate)'),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildValueRow(String label, double val, {bool isDeduction = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(fontSize: 13, color: Colors.grey.shade700)),
          Text(
            "${isDeduction ? '- ' : ''}${currencyFormat.format(val)}",
            style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: isDeduction ? Colors.red.shade700 : Colors.black87),
          ),
        ],
      ),
    );
  }

  Widget _buildTotalRow(String label, double val, Color color, {bool isDeduction = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black87)),
        Text(
          "${isDeduction ? '- ' : ''}${currencyFormat.format(val)}",
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: color),
        ),
      ],
    );
  }

  Widget _buildSubStat(String value, String label) {
    return Column(
      children: [
        Text(value, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black87)),
        Text(label, style: TextStyle(fontSize: 11, color: Colors.grey.shade500)),
      ],
    );
  }

  Widget _buildHistorySection() {
    if (_historyLoading) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(24.0),
          child: CircularProgressIndicator(color: Colors.indigo),
        ),
      );
    }

    if (_historyError != null) {
      return Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.red.shade100),
        ),
        child: Column(
          children: [
            Icon(Icons.error_outline, color: Colors.red.shade300, size: 32),
            const SizedBox(height: 8),
            Text('Could not load history', style: TextStyle(color: Colors.grey.shade700)),
            const SizedBox(height: 4),
            Text(
              _historyError!,
              style: TextStyle(fontSize: 11, color: Colors.grey.shade500),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            TextButton.icon(
              onPressed: () {
                setState(() {
                  _historyLoading = true;
                  _historyError = null;
                });
                _fetchHistory();
              },
              icon: const Icon(Icons.refresh, size: 16),
              label: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    if (_historyData == null || _historyData!.history.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Column(
          children: [
            Icon(Icons.history_rounded, size: 40, color: Colors.grey.shade300),
            const SizedBox(height: 8),
            Text('No salary history found', style: TextStyle(color: Colors.grey.shade600)),
            Text('Set a salary to create the first record.', style: TextStyle(fontSize: 12, color: Colors.grey.shade400)),
          ],
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '${_historyData!.totalRevisions} revision(s)',
          style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
        ),
        const SizedBox(height: 8),
        ..._historyData!.history.map((h) => _buildHistoryItem(h)),
      ],
    );
  }

  Widget _buildHistoryItem(SalaryStructureModel h) {
    final fromDate = h.effectiveFrom ?? 'N/A';
    final toDate = h.effectiveTo;
    final dateRange = toDate != null
        ? '$fromDate to $toDate'
        : 'From $fromDate';

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: h.isCurrent ? Colors.indigo.shade50.withOpacity(0.3) : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: h.isCurrent ? Colors.indigo.shade100 : Colors.grey.shade200),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: h.isCurrent ? Colors.indigo.shade100 : Colors.grey.shade100,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              h.isCurrent ? Icons.check_circle_rounded : Icons.history_rounded,
              color: h.isCurrent ? Colors.indigo : Colors.grey.shade600,
              size: 20,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      '${currencyFormat.format(h.grossSalary)} Gross',
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.black87),
                    ),
                    if (h.isCurrent) ...[
                      const SizedBox(width: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                        decoration: BoxDecoration(
                          color: Colors.green.shade100,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text('Current', style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: Colors.green.shade800)),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 2),
                Text(dateRange, style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
                if (h.revisionNote != null && h.revisionNote!.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 2),
                    child: Text(h.revisionNote!, style: TextStyle(fontSize: 11, color: Colors.grey.shade400, fontStyle: FontStyle.italic)),
                  ),
              ],
            ),
          ),
          Text(
            '${currencyFormat.format(h.netSalary)}\nnet',
            textAlign: TextAlign.right,
            style: TextStyle(fontWeight: FontWeight.w600, color: h.isCurrent ? Colors.indigo : Colors.black87, fontSize: 13),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomAction() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, -4)),
        ],
      ),
      child: SafeArea(
        child: ElevatedButton(
          onPressed: _isSaving ? null : _saveSalary,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.indigo,
            foregroundColor: Colors.white,
            disabledBackgroundColor: Colors.indigo.shade200,
            minimumSize: const Size(double.infinity, 54),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            elevation: 0,
          ),
          child: _isSaving
              ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5))
              : const Text('Save Salary Structure', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        ),
      ),
    );
  }
}
