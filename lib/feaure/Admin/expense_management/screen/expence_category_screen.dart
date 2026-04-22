import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/expense_bloc.dart';
import '../bloc/expense_event.dart';
import '../bloc/expense_state.dart';
import '../data/model/expense_category_model.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ExpenceCategoryScreen extends StatefulWidget {
  const ExpenceCategoryScreen({super.key});

  @override
  State<ExpenceCategoryScreen> createState() => _ExpenceCategoryScreenState();
}

class _ExpenceCategoryScreenState extends State<ExpenceCategoryScreen> {

  final TextEditingController _searchController = TextEditingController();
  String selectedStatus = "All";

  @override
  void initState() {
    super.initState();
    context.read<ExpenseBloc>().add(FetchExpenseCategories());
  }

  void _showCategoryDialog({ExpenseCategoryModel? category}) {
    final isEditing = category != null;
    final nameController = TextEditingController(text: category?.name);
    final limitController =
    TextEditingController(text: category?.monthlyLimit);
    bool isActive = category?.isActive ?? true;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      builder: (context) => StatefulBuilder(
        builder: (context, setStateDialog) => Padding(
          padding: EdgeInsets.only(
            left: 16,
            right: 16,
            top: 20,
            bottom: MediaQuery.of(context).viewInsets.bottom + 20,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                isEditing ? "Edit Category" : "Add Category",
                style:
                const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),

              TextField(
                controller: nameController,
                decoration: InputDecoration(
                  labelText: "Category Name",
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
              ),

              const SizedBox(height: 12),

              TextField(
                controller: limitController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: "Monthly Limit",
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
              ),

              SwitchListTile(
                value: isActive,
                title: const Text("Active"),
                onChanged: (val) =>
                    setStateDialog(() => isActive = val),
              ),

              const SizedBox(height: 10),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    final data = {
                      'name': nameController.text,
                      'monthly_limit': limitController.text,
                      'is_active': isActive,
                    };

                    if (isEditing) {
                      context
                          .read<ExpenseBloc>()
                          .add(UpdateCategory(category.id, data));
                    } else {
                      context.read<ExpenseBloc>().add(CreateCategory(data));
                    }

                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                  child: Text(isEditing ? "Update" : "Create"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ExpenseBloc, ExpenseState>(
      listener: (context, state) {
        if (state is ExpenseActionSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
          context.read<ExpenseBloc>().add(FetchExpenseCategories());
        } else if (state is ExpenseError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message), backgroundColor: Colors.red),
          );
        }
      },
      child: Scaffold(
        backgroundColor: Colors.grey.shade100,

        /// APP BAR
        appBar: AppBar(
          title: const Text("Expense Categories"),
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          elevation: 0,
        ),

        /// FLOATING BUTTON
        floatingActionButton: FloatingActionButton(
          onPressed: () => _showCategoryDialog(),
          child: const Icon(Icons.add),
        ),

        /// BODY
        body: Column(
          children: [

            /// SEARCH + FILTER
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        hintText: "Search...",
                        prefixIcon: const Icon(Icons.search),
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding: const EdgeInsets.symmetric(vertical: 0),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      onChanged: (_) => setState(() {}),
                    ),
                  ),
                  const SizedBox(width: 10),
                  DropdownButton<String>(
                    value: selectedStatus,
                    items: ["All", "Active", "Inactive"]
                        .map((e) => DropdownMenuItem(
                      value: e,
                      child: Text(e),
                    ))
                        .toList(),
                    onChanged: (val) {
                      setState(() => selectedStatus = val!);
                    },
                  ),
                ],
              ),
            ),

            /// LIST
            Expanded(
              child: BlocBuilder<ExpenseBloc, ExpenseState>(
                builder: (context, state) {
                  if (state is ExpenseLoading) {
                    return const Center(
                        child: CircularProgressIndicator());
                  }

                  List<ExpenseCategoryModel> categories = [];
                  if (state is CategoriesLoaded) {
                    categories = state.categories;
                  }

                  /// FILTER LOGIC
                  categories = categories.where((cat) {
                    final matchesSearch = cat.name
                        .toLowerCase()
                        .contains(_searchController.text.toLowerCase());

                    final matchesStatus = selectedStatus == "All" ||
                        (selectedStatus == "Active" && cat.isActive) ||
                        (selectedStatus == "Inactive" && !cat.isActive);

                    return matchesSearch && matchesStatus;
                  }).toList();

                  if (categories.isEmpty) {
                    return const Center(child: Text("No categories found"));
                  }

                  return ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: categories.length,
                    itemBuilder: (context, index) {
                      final cat = categories[index];
                      return _categoryCard(cat);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _categoryCard(ExpenseCategoryModel cat) {
    final isActive = cat.isActive;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            blurRadius: 6,
            color: Colors.black.withOpacity(0.05),
            offset: const Offset(0, 3),
          )
        ],
      ),
      child: Row(
        children: [

          /// ICON
          CircleAvatar(
            radius: 22,
            backgroundColor:
            (isActive ? Colors.green : Colors.grey).withOpacity(0.1),
            child: Icon(
              Icons.category,
              color: isActive ? Colors.green : Colors.grey,
            ),
          ),

          const SizedBox(width: 12),

          /// INFO
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  cat.name,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const SizedBox(height: 4),
                Text(
                  "₹${cat.monthlyLimit ?? '0'} / month",
                  style: TextStyle(color: Colors.grey.shade600),
                ),
              ],
            ),
          ),

          /// STATUS
          Container(
            padding:
            const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: (isActive ? Colors.green : Colors.grey)
                  .withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              isActive ? "Active" : "Inactive",
              style: TextStyle(
                color: isActive ? Colors.green : Colors.grey,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          const SizedBox(width: 8),

          /// ACTION MENU
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == "edit") {
                _showCategoryDialog(category: cat);
              } else if (value == "delete") {
                context.read<ExpenseBloc>().add(DeleteCategory(cat.id));
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(value: "edit", child: Text("Edit")),
              const PopupMenuItem(value: "delete", child: Text("Delete")),
            ],
          )
        ],
      ),
    );
  }
}