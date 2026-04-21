import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../bloc/expense_bloc.dart';
import '../bloc/expense_event.dart';
import '../bloc/expense_state.dart';
import '../data/model/expense_model.dart';
import 'add_expense_screen.dart';

class ExpenceListScreen extends StatefulWidget {
  const ExpenceListScreen({super.key});

  @override
  State<ExpenceListScreen> createState() => _ExpenceListScreenState();
}

class _ExpenceListScreenState extends State<ExpenceListScreen> {
  final ScrollController _scrollController = ScrollController();
  String _status = 'All Status';
  String _category = 'All Categories';
  DateTime _selectedDate = DateTime.now();
  final TextEditingController _searchCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchExpenses(isRefresh: true);
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent * 0.9) {
      final state = context.read<ExpenseBloc>().state;
      if (state is ExpenseLoaded && state.hasMore) {
        _fetchExpenses();
      }
    }
  }

  void _fetchExpenses({bool isRefresh = false}) {
    context.read<ExpenseBloc>().add(FetchExpenses(
      status: _status,
      month: DateFormat('yyyy-MM').format(_selectedDate),
      page: isRefresh ? 1 : 1, // BLoC handles page increment if not refresh
      isRefresh: isRefresh,
    ));
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF4F6F8),
      appBar: AppBar(
        title: const Text(
          'Expense Management',
          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 17),
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 0,
        surfaceTintColor: Colors.white,
        actions: [
          IconButton(
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const AddExpenseScreen())).then((_) => _fetchExpenses(isRefresh: true)),
            icon: const Icon(Icons.add_circle_outline),
            tooltip: 'Add Expense',
          ),
        ],
      ),
      body: BlocBuilder<ExpenseBloc, ExpenseState>(
        builder: (context, state) {
          List<ExpenseModel> expenses = [];
          bool isLoading = state is ExpenseLoading;

          if (state is ExpenseLoaded) {
            expenses = state.expenses;
          }

          final totalSubmitted = expenses.fold(0.0, (sum, e) => sum + double.parse(e.amount ?? '0'));
          final pendingAmount = expenses.where((e) => e.status?.toLowerCase() == 'pending').fold(0.0, (sum, e) => sum + double.parse(e.amount ?? '0'));
          final approvedAmount = expenses.where((e) => e.status?.toLowerCase() == 'approved').fold(0.0, (sum, e) => sum + double.parse(e.amount ?? '0'));
          final reimbursedAmount = expenses.where((e) => e.status?.toLowerCase() == 'reimbursed').fold(0.0, (sum, e) => sum + double.parse(e.amount ?? '0'));

          return RefreshIndicator(
            onRefresh: () async => _fetchExpenses(isRefresh: true),
            child: SingleChildScrollView(
              controller: _scrollController,
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── Breadcrumb ───────────────────────────────────
                  Row(
                    children: [
                      Text('Home',
                          style: TextStyle(
                              color: Colors.indigo.shade400,
                              fontWeight: FontWeight.w500,
                              fontSize: 13)),
                      const Icon(Icons.chevron_right, size: 16, color: Colors.grey),
                      Text('Expenses',
                          style: TextStyle(color: Colors.grey.shade500, fontSize: 13)),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // ── Summary Cards ────────────────────────────────
                  GridView.count(
                    shrinkWrap: true,
                    crossAxisCount: 2,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 1.8,
                    physics: const NeverScrollableScrollPhysics(),
                    children: [
                      _summaryCard('Total Submitted', '₹${totalSubmitted.toStringAsFixed(2)}', Icons.receipt_long_outlined, Colors.blue),
                      _summaryCard('Pending', '₹${pendingAmount.toStringAsFixed(2)}', Icons.pending_actions_outlined, Colors.orange),
                      _summaryCard('Approved', '₹${approvedAmount.toStringAsFixed(2)}', Icons.check_circle_outline, Colors.green),
                      _summaryCard('Reimbursed', '₹${reimbursedAmount.toStringAsFixed(2)}', Icons.payments_outlined, Colors.purple),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // ── Filters ──────────────────────────────────────
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8)],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Search
                        TextField(
                          controller: _searchCtrl,
                          decoration: InputDecoration(
                            hintText: 'Search expense / employee...',
                            hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 14),
                            prefixIcon: Icon(Icons.search, size: 18, color: Colors.grey.shade400),
                            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide(color: Colors.grey.shade300)),
                            enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide(color: Colors.grey.shade300)),
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: const BorderSide(color: Colors.indigo, width: 1.5)),
                            filled: true,
                            fillColor: Colors.grey.shade50,
                          ),
                          onSubmitted: (v) => _fetchExpenses(isRefresh: true),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            Expanded(
                              child: _dropdown(
                                _status,
                                ['All Status', 'Pending', 'Approved', 'Rejected', 'Reimbursed'],
                                Icons.tune_outlined,
                                (v) {
                                  setState(() => _status = v!);
                                  _fetchExpenses(isRefresh: true);
                                },
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: InkWell(
                                onTap: () async {
                                  final picked = await showDatePicker(
                                    context: context,
                                    initialDate: _selectedDate,
                                    firstDate: DateTime(2020),
                                    lastDate: DateTime(2030),
                                  );
                                  if (picked != null) {
                                    setState(() => _selectedDate = picked);
                                    _fetchExpenses(isRefresh: true);
                                  }
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                                  decoration: BoxDecoration(
                                    color: Colors.grey.shade50,
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(color: Colors.grey.shade300),
                                  ),
                                  child: Row(
                                    children: [
                                      Icon(Icons.calendar_month_outlined, size: 16, color: Colors.grey.shade400),
                                      const SizedBox(width: 8),
                                      Text(DateFormat('MMM, yyyy').format(_selectedDate), style: const TextStyle(fontSize: 13)),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  // ── List Header ──────────────────────────────────
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Expense Records',
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 15,
                              color: Colors.black87)),
                      Text('${expenses.length} records',
                          style: TextStyle(fontSize: 13, color: Colors.grey.shade500)),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // ── Expense Cards ────────────────────────────────
                  isLoading && expenses.isEmpty
                  ? const Center(child: Padding(padding: EdgeInsets.all(32), child: CircularProgressIndicator()))
                  : ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: expenses.length + (isLoading ? 1 : 0),
                      separatorBuilder: (_, __) => const SizedBox(height: 10),
                      itemBuilder: (context, i) {
                        if (i == expenses.length) {
                          return const Center(child: Padding(padding: EdgeInsets.all(8), child: CircularProgressIndicator()));
                        }
                        return _expenseCard(expenses[i]);
                      },
                    ),

                  const SizedBox(height: 24),
                  Center(
                    child: Text(
                      'Copyright © 2026 • Developed by: Life InfoTech',
                      style: TextStyle(color: Colors.grey.shade400, fontSize: 12),
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  // ── Summary Card ──────────────────────────────────────────
  Widget _summaryCard(String title, String amount, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8, offset: const Offset(0, 2))
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
                color: color.withOpacity(0.12), shape: BoxShape.circle),
            child: Icon(icon, color: color, size: 18),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(amount,
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: color)),
                const SizedBox(height: 2),
                Text(title,
                    style: TextStyle(
                        fontSize: 10,
                        color: Colors.grey.shade500,
                        height: 1.3),
                    overflow: TextOverflow.ellipsis),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── Expense Card ──────────────────────────────────────────
  Widget _expenseCard(ExpenseModel e) {
    final status = e.status ?? 'Pending';
    Color statusColor;
    Color statusBg;
    IconData statusIcon;

    switch (status.toLowerCase()) {
      case 'approved':
        statusColor = Colors.green.shade700;
        statusBg = Colors.green.shade50;
        statusIcon = Icons.check_circle_outline;
        break;
      case 'reimbursed':
        statusColor = Colors.purple.shade700;
        statusBg = Colors.purple.shade50;
        statusIcon = Icons.payments_outlined;
        break;
      case 'rejected':
        statusColor = Colors.red.shade700;
        statusBg = Colors.red.shade50;
        statusIcon = Icons.cancel_outlined;
        break;
      default:
        statusColor = Colors.orange.shade700;
        statusBg = Colors.orange.shade50;
        statusIcon = Icons.hourglass_top_outlined;
    }

    return BlocListener<ExpenseBloc, ExpenseState>(
      listener: (context, state) {
        if (state is ExpenseActionSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.message)));
          _fetchExpenses(isRefresh: true);
        } else if (state is ExpenseError) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.message), backgroundColor: Colors.red));
        }
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8, offset: const Offset(0, 2))
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Row 1: Avatar + Name + Status badge + Menu
            Row(
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundColor: Colors.indigo.shade50,
                  child: Text(
                    e.user?.initials ?? '?',
                    style: TextStyle(
                        color: Colors.indigo.shade600,
                        fontWeight: FontWeight.bold,
                        fontSize: 15),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment:CrossAxisAlignment.start,
                    children: [
                      Text(e.user?.name ?? 'Unknown',
                          style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                              color: Colors.black87)),
                      Text(e.user?.employeeId ?? '—',
                          style: TextStyle(
                              fontSize: 12, color: Colors.grey.shade500)),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                      color: statusBg,
                      borderRadius: BorderRadius.circular(20)),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(statusIcon, size: 13, color: statusColor),
                      const SizedBox(width: 4),
                      Text(status.toUpperCase(),
                          style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: statusColor)),
                    ],
                  ),
                ),
                PopupMenuButton<String>(
                  icon: const Icon(Icons.more_vert, size: 20, color: Colors.grey),
                  padding: EdgeInsets.zero,
                  onSelected: (val) {
                    if (val == 'edit') {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => AddExpenseScreen(expense: e)),
                      ).then((_) => _fetchExpenses(isRefresh: true));
                    } else if (val == 'delete') {
                      _showDeleteDialog(e.id);
                    } else if (val == 'reimburse') {
                      context.read<ExpenseBloc>().add(ReimburseExpense(e.id));
                    }
                  },
                  itemBuilder: (context) => [
                    const PopupMenuItem(
                      value: 'edit',
                      child: Row(
                        children: [
                          Icon(Icons.edit_outlined, size: 18, color: Colors.indigo),
                          SizedBox(width: 8),
                          Text('Edit', style: TextStyle(fontSize: 14)),
                        ],
                      ),
                    ),
                    if (e.status?.toLowerCase() == 'approved')
                      const PopupMenuItem(
                        value: 'reimburse',
                        child: Row(
                          children: [
                            Icon(Icons.payments_outlined, size: 18, color: Colors.green),
                            SizedBox(width: 8),
                            Text('Reimburse', style: TextStyle(fontSize: 14)),
                          ],
                        ),
                      ),
                    const PopupMenuItem(
                      value: 'delete',
                      child: Row(
                        children: [
                          Icon(Icons.delete_outline, size: 18, color: Colors.red),
                          SizedBox(width: 8),
                          Text('Delete', style: TextStyle(fontSize: 14)),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 12),
            const Divider(height: 1),
            const SizedBox(height: 12),

            // Row 2: Amount + Category + Date
            Wrap(
              spacing: 12,
              runSpacing: 8,
              children: [
                _chip(Icons.attach_money, '₹${e.amount}', Colors.green),
                _chip(Icons.category_outlined, e.expenseCategory?.name ?? 'Unknown', Colors.indigo),
                _chip(Icons.calendar_today_outlined, DateFormat('dd MMM yyyy').format(DateTime.parse(e.expenseDate!)), Colors.grey),
              ],
            ),

            const SizedBox(height: 10),

            // Purpose
            Text(
              e.purpose ?? '',
              style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade600,
                  fontStyle: FontStyle.italic,
                  height: 1.4),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),

            if (e.approvedBy != null) ...[
              const SizedBox(height: 8),
              Row(
                children: [
                  Icon(Icons.person_outline, size: 13, color: Colors.grey.shade400),
                  const SizedBox(width: 4),
                  Text('Approved by ${e.approvedBy?.name}',
                      style: TextStyle(fontSize: 11, color: Colors.grey.shade500)),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  void _showDeleteDialog(int id) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Expense'),
        content: const Text('Are you sure you want to delete this expense record? This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              context.read<ExpenseBloc>().add(DeleteExpense(id));
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  Widget _chip(IconData icon, String label, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 13, color: color.withOpacity(0.8)),
        const SizedBox(width: 4),
        Text(label,
            style: TextStyle(
                fontSize: 12,
                color: Colors.grey.shade700,
                fontWeight: FontWeight.w500)),
      ],
    );
  }

  Widget _dropdown(
      String value, List<String> items, IconData icon, ValueChanged<String?> onChanged) {
    return DropdownButtonFormField<String>(
      value: value,
      decoration: InputDecoration(
        prefixIcon: Icon(icon, size: 16, color: Colors.grey.shade400),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: Colors.grey.shade300)),
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: Colors.grey.shade300)),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: Colors.indigo, width: 1.5)),
        filled: true,
        fillColor: Colors.grey.shade50,
      ),
      items: items
          .map((e) =>
              DropdownMenuItem(value: e, child: Text(e, style: const TextStyle(fontSize: 13))))
          .toList(),
      onChanged: onChanged,
      isExpanded: true,
    );
  }
}
