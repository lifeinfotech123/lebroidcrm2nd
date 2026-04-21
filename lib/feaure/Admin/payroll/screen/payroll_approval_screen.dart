import 'package:flutter/material.dart';

class PayrollApprovalScreen extends StatelessWidget {
  const PayrollApprovalScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF4F6F8),
      appBar: AppBar(
        title: const Text('Payroll Approval'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                  )
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'February 2026 Payroll Summary: Gross: ₹0.00 · Net: ₹0.00 · 0 employee(s)',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        ElevatedButton(
                          onPressed: () {},
                          child: const Text('Approve All'),
                        )
                      ],
                    ),
                  ),
                  const Divider(height: 1),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: DataTable(
                      headingRowColor: MaterialStateProperty.all(Colors.grey.shade50),
                      columns: const [
                        DataColumn(label: Text('Employee', style: TextStyle(fontWeight: FontWeight.bold))),
                        DataColumn(label: Text('Days', style: TextStyle(fontWeight: FontWeight.bold))),
                        DataColumn(label: Text('Absent', style: TextStyle(fontWeight: FontWeight.bold))),
                        DataColumn(label: Text('Basic', style: TextStyle(fontWeight: FontWeight.bold))),
                        DataColumn(label: Text('Allowances', style: TextStyle(fontWeight: FontWeight.bold))),
                        DataColumn(label: Text('OT', style: TextStyle(fontWeight: FontWeight.bold))),
                        DataColumn(label: Text('Deductions', style: TextStyle(fontWeight: FontWeight.bold))),
                        DataColumn(label: Text('Net Pay', style: TextStyle(fontWeight: FontWeight.bold))),
                        DataColumn(label: Text('Status', style: TextStyle(fontWeight: FontWeight.bold))),
                        DataColumn(label: Text('Actions', style: TextStyle(fontWeight: FontWeight.bold))),
                      ],
                      rows: const [],
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.all(32.0),
                    child: Center(
                      child: Text(
                        'No payrolls pending approval for February 2026.',
                        style: TextStyle(color: Colors.grey, fontSize: 16),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
