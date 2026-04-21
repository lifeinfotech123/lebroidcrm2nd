import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/expense_bloc.dart';
import '../bloc/expense_event.dart';
import '../bloc/expense_state.dart';
import '../data/model/expense_category_model.dart';

class ExpenceCategoryScreen extends StatefulWidget {
  const ExpenceCategoryScreen({super.key});

  @override
  State<ExpenceCategoryScreen> createState() => _ExpenceCategoryScreenState();
}

class _ExpenceCategoryScreenState extends State<ExpenceCategoryScreen> {
  @override
  void initState() {
    super.initState();
    context.read<ExpenseBloc>().add(FetchExpenseCategories());
  }

  void _showCategoryDialog({ExpenseCategoryModel? category}) {
    final isEditing = category != null;
    final nameController = TextEditingController(text: category?.name);
    final limitController = TextEditingController(text: category?.monthlyLimit);
    bool isActive = category?.isActive ?? true;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: Text(isEditing ? 'Edit Category' : 'Add Category'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(labelText: 'Category Name'),
                ),
                TextField(
                  controller: limitController,
                  decoration: const InputDecoration(labelText: 'Monthly Limit'),
                  keyboardType: TextInputType.number,
                ),
                SwitchListTile(
                  title: const Text('Active'),
                  value: isActive,
                  onChanged: (val) => setDialogState(() => isActive = val),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
            ElevatedButton(
              onPressed: () {
                final data = {
                  'name': nameController.text,
                  'monthly_limit': limitController.text,
                  'is_active': isActive,
                };
                if (isEditing) {
                  context.read<ExpenseBloc>().add(UpdateCategory(category.id, data));
                } else {
                  context.read<ExpenseBloc>().add(CreateCategory(data));
                }
                Navigator.pop(context);
              },
              child: Text(isEditing ? 'Update' : 'Create'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ExpenseBloc, ExpenseState>(
      listener: (context, state) {
        if (state is ExpenseActionSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.message)));
          context.read<ExpenseBloc>().add(FetchExpenseCategories());
        } else if (state is ExpenseError) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.message), backgroundColor: Colors.red));
        }
      },
      child: Scaffold(
        backgroundColor: Colors.grey[50],
        appBar: AppBar(
          title: const Text('Expense Categories', style: TextStyle(fontWeight: FontWeight.w600)),
          backgroundColor: Colors.white,
          elevation: 1,
          foregroundColor: Colors.black,
          actions: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: ElevatedButton.icon(
                onPressed: () => _showCategoryDialog(),
                icon: const Icon(Icons.add, size: 18),
                label: const Text('Add Category'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).primaryColor,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
              ),
            ),
          ],
        ),
        body: BlocBuilder<ExpenseBloc, ExpenseState>(
          builder: (context, state) {
            if (state is ExpenseLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            List<ExpenseCategoryModel> categories = [];
            if (state is CategoriesLoaded) {
              categories = state.categories;
            }

            return SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Filters and Search (UI only for now)
                  Card(
                    color: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: BorderSide(color: Colors.grey[200]!),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        children: [
                          Expanded(
                            flex: 2,
                            child: TextField(
                              decoration: InputDecoration(
                                hintText: 'Search categories...',
                                prefixIcon: const Icon(Icons.search),
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: Colors.grey[300]!)),
                                enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: Colors.grey[300]!)),
                                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: DropdownButtonFormField<String>(
                              value: 'All Status',
                              items: ['All Status', 'Active', 'Inactive'].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
                              onChanged: (val) {},
                              decoration: InputDecoration(
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: Colors.grey[300]!)),
                                enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: Colors.grey[300]!)),
                                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Data Table
                  Card(
                    color: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: BorderSide(color: Colors.grey[200]!),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: DataTable(
                              headingRowColor: WidgetStateProperty.resolveWith((states) => Colors.grey[50]),
                              columns: const [
                                DataColumn(label: Text('Category Name', style: TextStyle(fontWeight: FontWeight.bold))),
                                DataColumn(label: Text('Monthly Limit', style: TextStyle(fontWeight: FontWeight.bold))),
                                DataColumn(label: Text('Status', style: TextStyle(fontWeight: FontWeight.bold))),
                                DataColumn(label: Text('Actions', style: TextStyle(fontWeight: FontWeight.bold))),
                              ],
                              rows: categories.map((cat) => _buildDataRow(cat)).toList(),
                            ),
                          ),
                          if (categories.isEmpty)
                            const Padding(
                              padding: EdgeInsets.all(32.0),
                              child: Center(child: Text('No categories found')),
                            ),
                        ],
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 32),
                  const Center(
                    child: Text('Copyright © 2026 • Developed by: Life InfoTech', style: TextStyle(color: Colors.grey)),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  DataRow _buildDataRow(ExpenseCategoryModel cat) {
    return DataRow(
      cells: [
        DataCell(Text(cat.name, style: const TextStyle(fontWeight: FontWeight.w600))),
        DataCell(Text('₹${cat.monthlyLimit ?? '0.00'}', style: const TextStyle(fontWeight: FontWeight.w500))),
        DataCell(
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: (cat.isActive ? Colors.green : Colors.grey).withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(cat.isActive ? 'Active' : 'Inactive', style: TextStyle(color: cat.isActive ? Colors.green : Colors.grey, fontSize: 12, fontWeight: FontWeight.bold)),
          ),
        ),
        DataCell(
          Row(
            children: [
              IconButton(icon: const Icon(Icons.edit, color: Colors.blue, size: 20), onPressed: () => _showCategoryDialog(category: cat), tooltip: 'Edit'),
              IconButton(
                icon: const Icon(Icons.delete, color: Colors.red, size: 20), 
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('Delete Category'),
                      content: Text('Are you sure you want to delete ${cat.name}?'),
                      actions: [
                        TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
                        TextButton(
                          onPressed: () {
                            context.read<ExpenseBloc>().add(DeleteCategory(cat.id));
                            Navigator.pop(context);
                          }, 
                          child: const Text('Delete', style: TextStyle(color: Colors.red)),
                        ),
                      ],
                    ),
                  );
                }, 
                tooltip: 'Delete',
              ),
            ],
          ),
        ),
      ],
    );
  }
}
