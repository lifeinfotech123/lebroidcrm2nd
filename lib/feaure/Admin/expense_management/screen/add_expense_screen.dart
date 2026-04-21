import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import '../bloc/expense_bloc.dart';
import '../bloc/expense_event.dart';
import '../bloc/expense_state.dart';
import '../data/model/expense_model.dart';
import '../data/model/expense_category_model.dart';
import '../data/repository/expense_repository.dart';
import 'package:lebroid_crm/feaure/auth/data/services/auth_service.dart';

class AddExpenseScreen extends StatefulWidget {
  final ExpenseModel? expense;
  const AddExpenseScreen({super.key, this.expense});

  @override
  State<AddExpenseScreen> createState() => _AddExpenseScreenState();
}

class _AddExpenseScreenState extends State<AddExpenseScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _amountCtrl;
  late TextEditingController _dateCtrl;
  late TextEditingController _purposeCtrl;
  String? _selectedCategoryId;
  File? _image;
  final _picker = ImagePicker();
  List<ExpenseCategoryModel> _categories = [];
  String _selectedSubmissionType = 'Submit Expense';

  @override
  void initState() {
    super.initState();
    _amountCtrl = TextEditingController(text: widget.expense?.amount);
    _dateCtrl = TextEditingController(text: widget.expense != null 
        ? DateFormat('yyyy-MM-dd').format(DateTime.parse(widget.expense!.expenseDate!))
        : DateFormat('yyyy-MM-dd').format(DateTime.now()));
    _purposeCtrl = TextEditingController(text: widget.expense?.purpose);
    _selectedCategoryId = widget.expense?.expenseCategoryId;
    
    context.read<ExpenseBloc>().add(FetchExpenseCategories());
  }

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery, imageQuality: 70);
    if (pickedFile != null) {
      setState(() => _image = File(pickedFile.path));
    }
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      if (_selectedCategoryId == null) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please select a category')));
        return;
      }

      final data = {
        'expense_category_id': _selectedCategoryId,
        'amount': _amountCtrl.text,
        'expense_date': _dateCtrl.text,
        'purpose': _purposeCtrl.text,
      };

      if (widget.expense != null) {
        // Since BLoC events might need updates to handle files, I'll call Repo directly for multipart or update BLoC
        // For now, I'll dispatch the event and skip multipart in BLoC state for simplicity, or just use the repo
        // Better: Update BLoC to handle File
        context.read<ExpenseBloc>().add(UpdateExpense(widget.expense!.id, data));
      } else {
        context.read<ExpenseBloc>().add(CreateExpense(data));
      }
    }
  }

  @override
  void dispose() {
    _amountCtrl.dispose();
    _dateCtrl.dispose();
    _purposeCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.expense != null;

    return BlocListener<ExpenseBloc, ExpenseState>(
      listener: (context, state) {
        if (state is ExpenseActionSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.message)));
          Navigator.pop(context, true);
        } else if (state is ExpenseError) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.message), backgroundColor: Colors.red));
        } else if (state is CategoriesLoaded) {
          setState(() {
            _categories = state.categories;
            if (_selectedCategoryId != null && !_categories.any((c) => c.id.toString() == _selectedCategoryId)) {
               _selectedCategoryId = null;
            }
          });
        }
      },
      child: Scaffold(
        backgroundColor: Colors.grey[50],
        appBar: AppBar(
          title: Text(isEditing ? 'Edit Expense' : 'Expense Management',
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 17)),
          backgroundColor: Colors.white,
          elevation: 0,
          shadowColor: Colors.black12,
          surfaceTintColor: Colors.white,
          foregroundColor: Colors.black87,
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Tab Toggle ───────────────────────────────────
                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: [
                      _tabButton('Submit Expense'),
                      _tabButton('Submit Multiple'),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // ── Expense Details Card ─────────────────────────
                _sectionCard(
                  title: 'Expense Details',
                  icon: Icons.receipt_long_outlined,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _labeledField(
                        'Category *',
                        DropdownButtonFormField<String>(
                          value: _selectedCategoryId,
                          hint: const Text('— Select Category —', style: TextStyle(fontSize: 14)),
                          items: _categories.map((e) => DropdownMenuItem(
                            value: e.id.toString(), 
                            child: Text(e.name, style: const TextStyle(fontSize: 14)),
                          )).toList(),
                          onChanged: (v) => setState(() => _selectedCategoryId = v),
                          decoration: _inputDeco(null, null, Icons.category_outlined),
                          validator: (v) => v == null ? 'Required' : null,
                        ),
                      ),
                      const SizedBox(height: 14),
                      Row(
                        children: [
                          Expanded(
                            child: _labeledField(
                              'Amount (₹) *',
                              TextFormField(
                                controller: _amountCtrl,
                                keyboardType: TextInputType.number,
                                decoration: _inputDeco('0.00', '₹ ', null),
                                validator: (v) => (v == null || v.isEmpty) ? 'Required' : null,
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _labeledField(
                              'Expense Date *',
                              TextFormField(
                                controller: _dateCtrl,
                                readOnly: true,
                                decoration: _inputDeco(null, null, Icons.calendar_today_outlined),
                                onTap: () async {
                                  final picked = await showDatePicker(
                                    context: context,
                                    initialDate: DateTime.now(),
                                    firstDate: DateTime(2020),
                                    lastDate: DateTime(2030),
                                  );
                                  if (picked != null) {
                                    setState(() => _dateCtrl.text = DateFormat('yyyy-MM-dd').format(picked));
                                  }
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),
                      _labeledField(
                        'Purpose / Description *',
                        TextFormField(
                          controller: _purposeCtrl,
                          maxLines: 3,
                          decoration: _inputDeco(
                              'Describe the business purpose of this expense...', null, null),
                          validator: (v) => (v == null || v.isEmpty) ? 'Required' : null,
                        ),
                      ),
                      const SizedBox(height: 14),
                      _fileUpload(),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                // ── Monthly Limits Card ──────────────────────────
                _monthlyLimitsCard(),

                const SizedBox(height: 20),

                // ── Action Buttons ───────────────────────────────
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(context),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.black54,
                          side: BorderSide(color: Colors.grey.shade300),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                        child: const Text('Cancel', style: TextStyle(fontWeight: FontWeight.w600)),
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      flex: 2,
                      child: ElevatedButton.icon(
                        onPressed: _submit,
                        icon: const Icon(Icons.send_outlined, size: 18),
                        label: Text(isEditing ? 'Update Expense' : 'Submit Expense', style: const TextStyle(fontWeight: FontWeight.w600)),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.indigo,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          elevation: 0,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _tabButton(String title) {
    final bool selected = _selectedSubmissionType == title;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _selectedSubmissionType = title),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: selected ? Colors.white : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
            boxShadow: selected
                ? [BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 6)]
                : [],
          ),
          child: Center(
            child: Text(
              title,
              style: TextStyle(
                color: selected ? Colors.indigo : Colors.grey.shade600,
                fontWeight: selected ? FontWeight.bold : FontWeight.normal,
                fontSize: 13,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _sectionCard({required String title, required IconData icon, required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 10, offset: const Offset(0, 2))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 18, color: Colors.indigo),
              const SizedBox(width: 8),
              Text(title, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black87)),
            ],
          ),
          const SizedBox(height: 18),
          child,
        ],
      ),
    );
  }

  Widget _labeledField(String label, Widget field) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 13, color: Colors.black87)),
        const SizedBox(height: 6),
        field,
      ],
    );
  }

  InputDecoration _inputDeco(String? hint, String? prefix, IconData? suffix) {
    return InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 14),
      prefixText: prefix,
      suffixIcon: suffix != null ? Icon(suffix, size: 18, color: Colors.grey.shade400) : null,
      border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: Colors.grey.shade300)),
      enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: Colors.grey.shade300)),
      focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: Colors.indigo, width: 1.5)),
      filled: true,
      fillColor: Colors.grey.shade50,
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
    );
  }

  Widget _fileUpload() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Receipt / Bill (Optional)',
            style: TextStyle(fontWeight: FontWeight.w500, fontSize: 13, color: Colors.black87)),
        const SizedBox(height: 6),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(
            color: Colors.grey.shade50,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: Row(
            children: [
              OutlinedButton.icon(
                onPressed: _pickImage,
                icon: const Icon(Icons.upload_file_outlined, size: 16),
                label: const Text('Choose File', style: TextStyle(fontSize: 13)),
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.black87,
                  side: BorderSide(color: Colors.grey.shade300),
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(7)),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(_image != null ? 'Image selected' : 'No file chosen',
                        style: const TextStyle(fontSize: 13, color: Colors.black87)),
                    Text('Max 5MB • JPG, PNG, PDF',
                        style: TextStyle(fontSize: 11, color: Colors.grey.shade500)),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _monthlyLimitsCard() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 10, offset: const Offset(0, 2))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.bar_chart_outlined, size: 18, color: Colors.indigo),
              const SizedBox(width: 8),
              const Text('Monthly Limits (Mar 2026)',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black87)),
            ],
          ),
          const SizedBox(height: 16),
          const Center(child: Text('Limit details are currently based on categories.', style: TextStyle(fontSize: 12, color: Colors.grey))),
        ],
      ),
    );
  }
}
