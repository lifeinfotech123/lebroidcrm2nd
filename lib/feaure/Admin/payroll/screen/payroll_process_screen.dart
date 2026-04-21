import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:lebroid_crm/feaure/Admin/payroll/bloc/salary_bloc.dart';
import 'package:lebroid_crm/feaure/Admin/payroll/bloc/salary_event.dart';
import 'package:lebroid_crm/feaure/Admin/payroll/bloc/salary_state.dart';
import 'package:lebroid_crm/feaure/Admin/payroll/data/model/salary_model.dart';

class PayrollProcessScreen extends StatefulWidget {
  const PayrollProcessScreen({super.key});

  @override
  State<PayrollProcessScreen> createState() => _PayrollProcessScreenState();
}

class _PayrollProcessScreenState extends State<PayrollProcessScreen> {
  // We need month strings formatted as 'yyyy-MM' for the API Request
  String _selectedMonth = DateFormat('yyyy-MM').format(DateTime.now());

  List<String> get _monthOptions {
    final now = DateTime.now();
    List<String> options = [];
    for (int i = -3; i <= 1; i++) {
      options.add(DateFormat('yyyy-MM').format(DateTime(now.year, now.month + i, 1)));
    }
    return options;
  }

  String _formatDisplayMonth(String yyyyMM) {
    try {
      final date = DateFormat('yyyy-MM').parse(yyyyMM);
      return DateFormat('MMMM, yyyy').format(date);
    } catch (_) {
      return yyyyMM;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF8FAFC),
      appBar: AppBar(
        title: const Text('Payroll Process', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18)),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 1,
        shadowColor: Colors.black12,
      ),
      body: BlocConsumer<SalaryBloc, SalaryState>(
        buildWhen: (previous, current) {
          return current is SalaryPayrollPreviewLoading ||
              current is SalaryPayrollPreviewLoaded ||
              current is SalaryPayrollPreviewError ||
              current is SalaryPayrollProcessLoading ||
              current is SalaryPayrollProcessSuccess ||
              current is SalaryPayrollProcessError;
        },
        listener: (context, state) {
          if (state is SalaryPayrollProcessSuccess) {
            Get.snackbar(
              'Success',
              state.response.message,
              snackPosition: SnackPosition.BOTTOM,
              backgroundColor: Colors.green,
              colorText: Colors.white,
            );
            // Re-fetch preview to verify or show empty state representing it's processed
            context.read<SalaryBloc>().add(SalaryRunPayrollEvent(month: _selectedMonth));
          } else if (state is SalaryPayrollProcessError) {
            Get.snackbar(
              'Process Error',
              state.message,
              snackPosition: SnackPosition.BOTTOM,
              backgroundColor: Colors.redAccent,
              colorText: Colors.white,
            );
          } else if (state is SalaryPayrollPreviewError) {
            Get.snackbar(
              'Preview Error',
              state.message,
              snackPosition: SnackPosition.BOTTOM,
              backgroundColor: Colors.orange,
              colorText: Colors.white,
            );
          }
        },
        builder: (context, state) {
          return CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildFiltersCard(),
                      if (state is SalaryPayrollPreviewLoading || state is SalaryPayrollProcessLoading)
                        const Padding(
                          padding: EdgeInsets.only(top: 40),
                          child: Center(child: CircularProgressIndicator(color: Colors.indigo)),
                        ),
                      if (state is SalaryPayrollPreviewLoaded)
                        _buildPreviewSection(state.response),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildFiltersCard() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10, offset: const Offset(0, 4)),
        ],
      ),
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: const BoxDecoration(color: Colors.indigo, shape: BoxShape.circle),
                child: const Text('1', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12)),
              ),
              const SizedBox(width: 12),
              const Text(
                'Select Month & Filters',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Wrap(
            spacing: 16,
            runSpacing: 16,
            crossAxisAlignment: WrapCrossAlignment.end,
            children: [
              SizedBox(
                width: 250,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('PAYROLL MONTH *', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.indigo)),
                    const SizedBox(height: 8),
                    DropdownButtonFormField<String>(
                      decoration: InputDecoration(
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: Colors.grey.shade300)),
                        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: Colors.grey.shade300)),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      ),
                      value: _monthOptions.contains(_selectedMonth) ? _selectedMonth : _monthOptions.first,
                      icon: const Icon(Icons.calendar_today, size: 18),
                      items: _monthOptions.map((e) {
                        return DropdownMenuItem(
                          value: e,
                          child: Text(_formatDisplayMonth(e), style: const TextStyle(fontSize: 14)),
                        );
                      }).toList(),
                      onChanged: (v) {
                        if (v != null) setState(() => _selectedMonth = v);
                      },
                    ),
                  ],
                ),
              ),
              ElevatedButton.icon(
                onPressed: () {
                  context.read<SalaryBloc>().add(SalaryRunPayrollEvent(
                    month: _selectedMonth,
                    previewOnly: true,
                  ));
                },
                icon: const Icon(Icons.remove_red_eye, size: 18),
                label: const Text('GENERATE PREVIEW', style: TextStyle(fontWeight: FontWeight.bold)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.indigo.shade600,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  elevation: 0,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          RichText(
            text: TextSpan(
              text: 'Processing: ',
              style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
              children: [
                TextSpan(text: _formatDisplayMonth(_selectedMonth), style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.indigo)),
              ]
            ),
          )
        ],
      ),
    );
  }

  Widget _buildPreviewSection(PayrollRunResponse response) {
    if (response.previews.isEmpty) {
      return Padding(
        padding: const EdgeInsets.only(top: 40),
        child: Center(
          child: Column(
            children: [
              Icon(Icons.inbox_rounded, size: 48, color: Colors.grey.shade300),
              const SizedBox(height: 12),
              const Text('No records found for processing.', style: TextStyle(color: Colors.grey, fontSize: 16)),
            ],
          ),
        ),
      );
    }

    final currencyFormat = NumberFormat.currency(locale: 'en_IN', symbol: '₹');
    double totalNetPay = response.previews.fold(0, (sum, item) => sum + item.netPay);

    return Padding(
      padding: const EdgeInsets.only(top: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: const BoxDecoration(color: Colors.indigo, shape: BoxShape.circle),
                child: const Text('2', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12)),
              ),
              const SizedBox(width: 12),
              const Text(
                'Review & Process',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const Spacer(),
              Text(
                'Total Payout: ${currencyFormat.format(totalNetPay)}',
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.indigo),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: response.previews.length,
            itemBuilder: (context, index) {
              final preview = response.previews[index];
              final initials = preview.employeeName.isNotEmpty
                  ? preview.employeeName.substring(0, preview.employeeName.length >= 2 ? 2 : 1).toUpperCase()
                  : '?';

              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade200),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 20,
                        backgroundColor: Colors.indigo.shade50,
                        child: Text(
                          initials,
                          style: TextStyle(color: Colors.indigo.shade700, fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(preview.employeeName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                            Text('ID: ${preview.employeeId}', style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
                          ],
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          const Text('Gross Pay', style: TextStyle(fontSize: 10, color: Colors.grey, fontWeight: FontWeight.w600)),
                          Text(currencyFormat.format(preview.grossPay), style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                          const SizedBox(height: 4),
                          const Text('Deductions', style: TextStyle(fontSize: 10, color: Colors.grey, fontWeight: FontWeight.w600)),
                          Text(currencyFormat.format(preview.totalDeductions), style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14, color: Colors.red)),
                        ],
                      ),
                      const SizedBox(width: 24),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          const Text('Net Pay', style: TextStyle(fontSize: 12, color: Colors.grey, fontWeight: FontWeight.w600)),
                          Text(currencyFormat.format(preview.netPay), style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 18, color: Colors.green)),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton.icon(
              onPressed: () {
                context.read<SalaryBloc>().add(SalaryProcessPayrollEvent(
                  month: _selectedMonth,
                  force: false,
                ));
              },
              icon: const Icon(Icons.check_circle_outline),
              label: const Text('FINAL PROCESS PAYROLL', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green.shade600,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
          )
        ],
      ),
    );
  }
}
