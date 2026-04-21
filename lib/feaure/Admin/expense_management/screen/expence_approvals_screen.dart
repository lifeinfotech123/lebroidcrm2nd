import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../bloc/expense_bloc.dart';
import '../bloc/expense_event.dart';
import '../bloc/expense_state.dart';
import '../data/model/expense_model.dart';
import '../data/model/expense_category_model.dart';

class ExpenceApprovalsScreen extends StatefulWidget {
  const ExpenceApprovalsScreen({super.key});

  @override
  State<ExpenceApprovalsScreen> createState() => _ExpenceApprovalsScreenState();
}

class _ExpenceApprovalsScreenState extends State<ExpenceApprovalsScreen> {
  String _categoryId = 'All Categories';
  List<ExpenseCategoryModel> _categories = [];

  @override
  void initState() {
    super.initState();
    _fetchPending();
    context.read<ExpenseBloc>().add(FetchExpenseCategories());
  }

  void _fetchPending() {
    context.read<ExpenseBloc>().add(const FetchExpenses(status: 'pending', isRefresh: true));
  }

  void _showRejectDialog(int id) {
    final reasonController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Reject Expense'),
        content: TextField(
          controller: reasonController,
          decoration: const InputDecoration(
            labelText: 'Reason for rejection',
            hintText: 'e.g. Invalid bill, policy violation...',
          ),
          maxLines: 2,
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              if (reasonController.text.isNotEmpty) {
                context.read<ExpenseBloc>().add(RejectExpense(id, reasonController.text));
                Navigator.pop(context);
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Reject'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ExpenseBloc, ExpenseState>(
      listener: (context, state) {
        if (state is ExpenseActionSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.message)));
          _fetchPending();
        } else if (state is ExpenseError) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.message), backgroundColor: Colors.red));
        } else if (state is CategoriesLoaded) {
          setState(() => _categories = state.categories);
        }
      },
      child: Scaffold(
        backgroundColor: const Color(0xffF4F6F8),
        appBar: AppBar(
          title: const Text('Expense Approvals',
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 17)),
          backgroundColor: Colors.white,
          foregroundColor: Colors.black87,
          elevation: 0,
          surfaceTintColor: Colors.white,
        ),
        body: BlocBuilder<ExpenseBloc, ExpenseState>(
          builder: (context, state) {
            List<ExpenseModel> pending = [];
            bool isLoading = state is ExpenseLoading;

            if (state is ExpenseLoaded) {
              pending = state.expenses;
            }

            final filtered = pending.where((e) {
              return _categoryId == 'All Categories' || e.expenseCategoryId == _categoryId;
            }).toList();

            final totalPending = filtered.fold(0.0, (sum, e) => sum + double.parse(e.amount ?? '0'));

            return RefreshIndicator(
              onRefresh: () async => _fetchPending(),
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ── Pending Banner ───────────────────────────────
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Colors.orange.shade400, Colors.orange.shade600],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(14),
                        boxShadow: [
                          BoxShadow(
                              color: Colors.orange.withOpacity(0.3),
                              blurRadius: 12,
                              offset: const Offset(0, 4))
                        ],
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.pending_actions,
                                color: Colors.white, size: 28),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('₹${totalPending.toStringAsFixed(2)}',
                                    style: const TextStyle(
                                        fontSize: 22,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white)),
                                const SizedBox(height: 2),
                                Text('${filtered.length} request(s) awaiting review',
                                    style: const TextStyle(
                                        fontSize: 13,
                                        color: Colors.white70)),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 16),

                    // ── Filters ──────────────────────────────────────
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8)
                        ],
                      ),
                      child: DropdownButtonFormField<String>(
                        value: _categoryId,
                        decoration: InputDecoration(
                          labelText: 'Category',
                          prefixIcon: Icon(Icons.category_outlined,
                              size: 18, color: Colors.grey.shade400),
                          contentPadding:
                              const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(color: Colors.grey.shade300)),
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(color: Colors.grey.shade300)),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide:
                                  const BorderSide(color: Colors.indigo, width: 1.5)),
                          filled: true,
                          fillColor: Colors.grey.shade50,
                        ),
                        items: [
                          DropdownMenuItem(value: 'All Categories', child: const Text('All Categories')),
                          ..._categories.map((e) => DropdownMenuItem(
                              value: e.id.toString(),
                              child: Text(e.name, style: const TextStyle(fontSize: 14))))
                        ],
                        onChanged: (v) => setState(() => _categoryId = v!),
                        isExpanded: true,
                      ),
                    ),

                    const SizedBox(height: 16),

                    // ── List Header ──────────────────────────────────
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Pending Approvals',
                            style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 15,
                                color: Colors.black87)),
                        Text('${filtered.length} records',
                            style:
                                TextStyle(fontSize: 13, color: Colors.grey.shade500)),
                      ],
                    ),
                    const SizedBox(height: 12),

                    // ── Cards ────────────────────────────────────────
                    isLoading && pending.isEmpty
                    ? const Center(child: Padding(padding: EdgeInsets.all(64), child: CircularProgressIndicator()))
                    : filtered.isEmpty
                        ? _emptyState()
                        : ListView.separated(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: filtered.length,
                            separatorBuilder: (_, __) => const SizedBox(height: 12),
                            itemBuilder: (context, i) => _approvalCard(filtered[i]),
                          ),

                    const SizedBox(height: 24),
                    Center(
                      child: Text('Copyright © 2026 • Developed by: Life InfoTech',
                          style: TextStyle(color: Colors.grey.shade400, fontSize: 12)),
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _approvalCard(ExpenseModel e) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 8,
              offset: const Offset(0, 2))
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Row 1: Avatar + Name + Policy badge
          Row(
            children: [
              CircleAvatar(
                radius: 22,
                backgroundColor: Colors.indigo.shade50,
                child: Text(e.user?.initials ?? '?',
                    style: TextStyle(
                        color: Colors.indigo.shade600,
                        fontWeight: FontWeight.bold,
                        fontSize: 14)),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(e.user?.name ?? 'Unknown',
                        style: const TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 14,
                            color: Colors.black87)),
                    Text(e.user?.department?.name ?? '—',
                        style: TextStyle(
                            fontSize: 12, color: Colors.grey.shade500)),
                  ],
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: e.isPolicyViolated
                      ? Colors.red.shade50
                      : Colors.green.shade50,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      e.isPolicyViolated
                          ? Icons.warning_amber_outlined
                          : Icons.verified_outlined,
                      size: 13,
                      color:
                          e.isPolicyViolated ? Colors.red.shade700 : Colors.green.shade700,
                    ),
                    const SizedBox(width: 4),
                    Text(e.isPolicyViolated ? 'Violated' : 'Policy OK',
                        style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: e.isPolicyViolated
                                ? Colors.red.shade700
                                : Colors.green.shade700)),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),
          const Divider(height: 1),
          const SizedBox(height: 12),

          // Row 2: Amount + Category + Date
          Wrap(
            spacing: 16,
            runSpacing: 6,
            children: [
              _infoChip(Icons.attach_money, '₹${e.amount}', Colors.green),
              _infoChip(Icons.category_outlined, e.expenseCategory?.name ?? 'Unknown', Colors.indigo),
              _infoChip(Icons.calendar_today_outlined, DateFormat('dd MMM yyyy').format(DateTime.parse(e.expenseDate!)), Colors.grey),
            ],
          ),

          const SizedBox(height: 10),

          // Purpose
          Text(e.purpose ?? '',
              style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade600,
                  fontStyle: FontStyle.italic,
                  height: 1.4),
              maxLines: 2,
              overflow: TextOverflow.ellipsis),

          const SizedBox(height: 14),

          // Action buttons
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => _showRejectDialog(e.id),
                  icon: const Icon(Icons.cancel_outlined, size: 16),
                  label: const Text('Reject',
                      style: TextStyle(fontWeight: FontWeight.w600)),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.red.shade600,
                    side: BorderSide(color: Colors.red.shade200),
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () => context.read<ExpenseBloc>().add(ApproveExpense(e.id)),
                  icon: const Icon(Icons.check_circle_outline, size: 16),
                  label: const Text('Approve',
                      style: TextStyle(fontWeight: FontWeight.w600)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green.shade600,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _infoChip(IconData icon, String label, Color color) {
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

  Widget _emptyState() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 48, horizontal: 24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8)
        ],
      ),
      child: Column(
        children: [
          Icon(Icons.task_alt, size: 56, color: Colors.grey.shade300),
          const SizedBox(height: 16),
          Text('No pending approvals',
              style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey.shade500)),
          const SizedBox(height: 6),
          Text('All expenses have been reviewed.',
              style: TextStyle(fontSize: 13, color: Colors.grey.shade400)),
        ],
      ),
    );
  }
}

  Widget _infoChip(IconData icon, String label, Color color) {
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

  Widget _emptyState() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 48, horizontal: 24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8)
        ],
      ),
      child: Column(
        children: [
          Icon(Icons.task_alt, size: 56, color: Colors.grey.shade300),
          const SizedBox(height: 16),
          Text('No pending approvals',
              style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey.shade500)),
          const SizedBox(height: 6),
          Text('All expenses have been reviewed.',
              style: TextStyle(fontSize: 13, color: Colors.grey.shade400)),
        ],
      ),
    );
}
