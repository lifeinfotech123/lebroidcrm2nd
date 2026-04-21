import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:lebroid_crm/feaure/Admin/payroll/bloc/salary_bloc.dart';
import 'package:lebroid_crm/feaure/Admin/payroll/bloc/salary_event.dart';
import 'package:lebroid_crm/feaure/Admin/payroll/bloc/salary_state.dart';
import 'package:lebroid_crm/feaure/Admin/payroll/data/model/salary_model.dart';

class SalaryPayslipScreen extends StatefulWidget {
  final int employeeId;

  const SalaryPayslipScreen({super.key, required this.employeeId});

  @override
  State<SalaryPayslipScreen> createState() => _SalaryPayslipScreenState();
}

class _SalaryPayslipScreenState extends State<SalaryPayslipScreen> {
  final currencyFormat = NumberFormat.currency(locale: 'en_IN', symbol: '₹');

  @override
  void initState() {
    super.initState();
    context.read<SalaryBloc>().add(FetchPayslipEvent(employeeId: widget.employeeId));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: const Text('Payslip'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: BlocBuilder<SalaryBloc, SalaryState>(
        builder: (context, state) {
          if (state is PayslipLoading) {
            return const Center(child: CircularProgressIndicator(color: Colors.indigo));
          }
          if (state is PayslipError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, size: 48, color: Colors.red.shade300),
                  const SizedBox(height: 12),
                  Text('Failed to load payslip', style: TextStyle(color: Colors.grey.shade700, fontSize: 16)),
                  const SizedBox(height: 4),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32),
                    child: Text(state.message, style: TextStyle(fontSize: 12, color: Colors.grey.shade500), textAlign: TextAlign.center),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: () => context.read<SalaryBloc>().add(FetchPayslipEvent(employeeId: widget.employeeId)),
                    icon: const Icon(Icons.refresh),
                    label: const Text('Retry'),
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.indigo, foregroundColor: Colors.white),
                  ),
                ],
              ),
            );
          }
          if (state is PayslipLoaded) {
            return _buildPayslipView(state.payslip);
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildPayslipView(PayslipModel data) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Payslip Header ─────────────────────
          _buildPayslipHeader(data),
          const SizedBox(height: 20),

          // ── Employee Info ──────────────────────
          _buildEmployeeInfo(data.employee),
          const SizedBox(height: 20),

          // ── Attendance Summary ─────────────────
          _buildSectionHeader('Attendance Summary'),
          const SizedBox(height: 12),
          _buildAttendanceSummary(data.attendanceSummary),
          const SizedBox(height: 24),

          // ── Earnings ───────────────────────────
          _buildSectionHeader('Earnings'),
          const SizedBox(height: 12),
          _buildEarningsCard(data.earnings),
          const SizedBox(height: 24),

          // ── Deductions ─────────────────────────
          _buildSectionHeader('Deductions'),
          const SizedBox(height: 12),
          _buildDeductionsCard(data.deductions),
          const SizedBox(height: 24),

          // ── Adjustments ────────────────────────
          if (data.adjustments.isNotEmpty) ...[
            _buildSectionHeader('Adjustments'),
            const SizedBox(height: 12),
            _buildAdjustmentsCard(data.adjustments),
            const SizedBox(height: 24),
          ],

          // ── Net Pay ────────────────────────────
          _buildNetPayCard(data.netPay),
          const SizedBox(height: 24),

          // ── Salary Structure ───────────────────
          _buildSectionHeader('Salary Structure'),
          const SizedBox(height: 12),
          _buildSalaryStructureCard(data.salaryStructure),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildPayslipHeader(PayslipModel data) {
    Color statusColor;
    switch (data.payslip.status) {
      case 'approved':
        statusColor = Colors.green;
        break;
      case 'processed':
        statusColor = Colors.blue;
        break;
      case 'paid':
        statusColor = Colors.teal;
        break;
      default:
        statusColor = Colors.orange;
    }

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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Payslip - ${data.payslip.monthLabel}',
                style: TextStyle(color: Colors.white.withOpacity(0.9), fontSize: 16, fontWeight: FontWeight.w600),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: statusColor.withOpacity(0.5)),
                ),
                child: Text(
                  data.payslip.status.toUpperCase(),
                  style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            currencyFormat.format(data.netPay),
            style: const TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Text('Net Pay', style: TextStyle(color: Colors.white.withOpacity(0.7), fontSize: 13)),
          const SizedBox(height: 12),
          if (data.payslip.processedAt != null)
            Row(
              children: [
                Icon(Icons.access_time_rounded, size: 14, color: Colors.white.withOpacity(0.6)),
                const SizedBox(width: 4),
                Text(
                  'Processed: ${data.payslip.processedAt}',
                  style: TextStyle(color: Colors.white.withOpacity(0.6), fontSize: 11),
                ),
              ],
            ),
        ],
      ),
    );
  }

  Widget _buildEmployeeInfo(PayslipEmployee emp) {
    final parts = emp.name.split(' ');
    final initials = parts.length >= 2
        ? '${parts[0][0]}${parts[1][0]}'.toUpperCase()
        : emp.name.substring(0, emp.name.length >= 2 ? 2 : 1).toUpperCase();

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10, offset: const Offset(0, 2)),
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 24,
            backgroundColor: Colors.indigo.shade50,
            child: Text(initials, style: TextStyle(color: Colors.indigo.shade700, fontWeight: FontWeight.bold)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(emp.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                Text(
                  '${emp.employeeId ?? 'N/A'} • ${emp.designation ?? emp.department ?? 'N/A'}',
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                ),
                if (emp.branch != null)
                  Text(emp.branch!, style: TextStyle(fontSize: 12, color: Colors.grey.shade500)),
              ],
            ),
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

  Widget _buildAttendanceSummary(PayslipAttendanceSummary att) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        children: [
          Row(
            children: [
              _buildAttStat('Working Days', '${att.totalWorkingDays}', Colors.indigo),
              _buildAttStat('Present', '${att.presentDays}', Colors.green),
              _buildAttStat('Absent', '${att.absentDays}', Colors.red),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              _buildAttStat('Leave', '${att.leaveDays}', Colors.orange),
              _buildAttStat('Late', att.lateCount, Colors.amber.shade700),
              _buildAttStat('OT Hrs', att.overtimeHours.toStringAsFixed(1), Colors.purple),
            ],
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 8),
            child: Divider(),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Total Worked Hours', style: TextStyle(fontSize: 13, color: Colors.grey.shade700)),
              Text('${att.workedHours.toStringAsFixed(2)} hrs', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAttStat(String label, String value, Color color) {
    return Expanded(
      child: Column(
        children: [
          Text(value, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: color)),
          Text(label, style: TextStyle(fontSize: 11, color: Colors.grey.shade600)),
        ],
      ),
    );
  }

  Widget _buildEarningsCard(PayslipEarnings e) {
    return _buildBreakdownCard(
      items: [
        _row('Basic Salary', e.basic),
        if (e.hra > 0) _row('HRA', e.hra),
        if (e.overtimePay > 0) _row('Overtime Pay', e.overtimePay),
        if (e.bonus > 0) _row('Bonus', e.bonus),
        _row('Total Allowances', e.totalAllowances),
      ],
      total: e.grossPay,
      totalLabel: 'Gross Pay',
      totalColor: Colors.green.shade700,
    );
  }

  Widget _buildDeductionsCard(PayslipDeductions d) {
    return _buildBreakdownCard(
      items: [
        if (d.lateDeduction > 0) _rowDeduction('Late Deduction', d.lateDeduction),
        if (d.lopDeduction > 0) _rowDeduction('LOP Deduction', d.lopDeduction),
      ],
      total: d.totalDeductions,
      totalLabel: 'Total Deductions',
      totalColor: Colors.red.shade700,
      isDeduction: true,
    );
  }

  Widget _buildAdjustmentsCard(List<PayslipAdjustment> adjustments) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        children: adjustments.map((adj) {
          final isCredit = adj.mode == 'credit';
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${adj.type[0].toUpperCase()}${adj.type.substring(1)}',
                        style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
                      ),
                      if (adj.description != null)
                        Text(adj.description!, style: TextStyle(fontSize: 11, color: Colors.grey.shade500)),
                    ],
                  ),
                ),
                Text(
                  '${isCredit ? '+ ' : '- '}${currencyFormat.format(adj.amount)}',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                    color: isCredit ? Colors.green.shade700 : Colors.red.shade700,
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildBreakdownCard({
    required List<Widget> items,
    required double total,
    required String totalLabel,
    required Color totalColor,
    bool isDeduction = false,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        children: [
          ...items,
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 8),
            child: Divider(),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(totalLabel, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
              Text(
                '${isDeduction ? '- ' : ''}${currencyFormat.format(total)}',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: totalColor),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _row(String label, double val) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(fontSize: 13, color: Colors.grey.shade700)),
          Text(currencyFormat.format(val), style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }

  Widget _rowDeduction(String label, double val) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(fontSize: 13, color: Colors.grey.shade700)),
          Text('- ${currencyFormat.format(val)}', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: Colors.red.shade700)),
        ],
      ),
    );
  }

  Widget _buildNetPayCard(double netPay) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.indigo.shade50,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.indigo.shade100),
      ),
      child: Column(
        children: [
          const Text('Net Pay', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.grey)),
          const SizedBox(height: 4),
          Text(
            currencyFormat.format(netPay),
            style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.indigo),
          ),
        ],
      ),
    );
  }

  Widget _buildSalaryStructureCard(SalaryStructureModel s) {
    return Container(
      padding: const EdgeInsets.all(16),
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
              Text('Type: ${s.salaryType}', style: TextStyle(fontSize: 13, color: Colors.grey.shade700)),
              Text('OT Multiplier: ${s.otMultiplier}x', style: TextStyle(fontSize: 13, color: Colors.grey.shade700)),
            ],
          ),
          const Padding(padding: EdgeInsets.symmetric(vertical: 8), child: Divider()),
          _row('Basic', s.basicSalary),
          _row('HRA', s.allowances.hra),
          _row('Transport', s.allowances.transportAllowance),
          _row('Medical', s.allowances.medicalAllowance),
          _row('Other Allowances', s.allowances.otherAllowances),
          const Padding(padding: EdgeInsets.symmetric(vertical: 8), child: Divider()),
          _rowDeduction('PF', s.deductions.pfDeduction),
          _rowDeduction('Tax', s.deductions.taxDeduction),
          _rowDeduction('Other', s.deductions.otherDeductions),
          const Padding(padding: EdgeInsets.symmetric(vertical: 8), child: Divider()),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Net Salary', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
              Text(currencyFormat.format(s.netSalary), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.indigo)),
            ],
          ),
        ],
      ),
    );
  }
}
