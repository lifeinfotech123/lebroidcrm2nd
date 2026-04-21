import 'package:flutter/material.dart';
import 'package:lebroid_crm/widgets/custom_text_field.dart';

class AddNewLeadsScreen extends StatefulWidget {
  const AddNewLeadsScreen({super.key});

  @override
  State<AddNewLeadsScreen> createState() => _AddNewLeadsScreenState();
}

class _AddNewLeadsScreenState extends State<AddNewLeadsScreen> {
  final _formKey = GlobalKey<FormState>();

  // Controllers
  final TextEditingController nameController = TextEditingController();
  final TextEditingController companyController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController websiteController = TextEditingController();
  final TextEditingController leadValueController = TextEditingController(
    text: '0.00',
  );
  final TextEditingController dateController = TextEditingController();
  final TextEditingController timeController = TextEditingController();
  final TextEditingController messageController = TextEditingController();

  // Dropdown values
  String? selectedCategory;
  String? selectedType;
  String? selectedStatus;
  String? selectedSource;
  String? selectedAssignUser;

  final List<String> categories = ['New', 'Source', 'Final'];
  final List<String> leadTypes = ['Cold', 'Warm', 'Hot'];
  final List<String> statuses = ['New', 'In Progress', 'Closed'];
  final List<String> sources = ['Just dial', 'Website', 'Referral'];
  final List<String> users = ['User A', 'User B', 'User C'];

  @override
  void dispose() {
    nameController.dispose();
    companyController.dispose();
    emailController.dispose();
    phoneController.dispose();
    websiteController.dispose();
    leadValueController.dispose();
    dateController.dispose();
    timeController.dispose();
    messageController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final date = await showDatePicker(
      context: context,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      initialDate: DateTime.now(),
    );
    if (date != null) {
      dateController.text =
          '${date.day.toString().padLeft(2, '0')}-${date.month.toString().padLeft(2, '0')}-${date.year}';
    }
  }

  Future<void> _pickTime() async {
    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (time != null) {
      timeController.text = time.format(context);
    }
  }

  Widget _dropdown({
    required String label,
    required String? value,
    required List<String> items,
    required void Function(String?) onChanged,
  }) {
    return DropdownButtonFormField<String>(
      value: value,
      decoration: InputDecoration(labelText: label),
      items: items
          .map((e) => DropdownMenuItem(value: e, child: Text(e)))
          .toList(),
      onChanged: onChanged,
      validator: (v) => v == null ? 'Required' : null,
    );
  }

  Widget _textField({
    required String label,
    required TextEditingController controller,
    TextInputType keyboardType = TextInputType.text,
    bool requiredField = false,
    VoidCallback? onTap,
    bool readOnly = false,
    String? prefixText,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      readOnly: readOnly,
      onTap: onTap,
      validator: requiredField
          ? (v) => v == null || v.isEmpty ? 'Required' : null
          : null,
      decoration: InputDecoration(labelText: label, prefixText: prefixText),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add New Lead')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _dropdown(
              label: 'Leads Categories',
              value: selectedCategory,
              items: categories,
              onChanged: (v) => setState(() => selectedCategory = v),
            ),
            const SizedBox(height: 12),
            _dropdown(
              label: 'Leads Types',
              value: selectedType,
              items: leadTypes,
              onChanged: (v) => setState(() => selectedType = v),
            ),
            const SizedBox(height: 12),
            _dropdown(
              label: 'Status',
              value: selectedStatus,
              items: statuses,
              onChanged: (v) => setState(() => selectedStatus = v),
            ),
            const SizedBox(height: 12),
            _dropdown(
              label: 'Source',
              value: selectedSource,
              items: sources,
              onChanged: (v) => setState(() => selectedSource = v),
            ),
            const SizedBox(height: 12),
            CustomTextField(label: 'Name *', controller: nameController),
            const SizedBox(height: 12),
            CustomTextField(label: 'Company', controller: companyController),
            const SizedBox(height: 12),
            CustomTextField(
              label: 'Email',
              controller: emailController,
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 12),
            CustomTextField(
              label: 'Phone',
              controller: phoneController,
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 12),
            CustomTextField(
              label: 'Website',
              controller: websiteController,
              keyboardType: TextInputType.url,
            ),
            const SizedBox(height: 12),
            CustomTextField(
              label: 'Lead Value',
              controller: leadValueController,
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 12),
            CustomTextField(label: 'Latest Date *', controller: dateController),
            const SizedBox(height: 12),
            CustomTextField(label: 'Latest Time *', controller: timeController),
            const SizedBox(height: 12),
            _dropdown(
              label: 'Assign to',
              value: selectedAssignUser,
              items: users,
              onChanged: (v) => setState(() => selectedAssignUser = v),
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: messageController,
              maxLines: 4,
              decoration: const InputDecoration(labelText: 'Message'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Lead Saved Successfully')),
                  );
                }
              },
              child: const Text('Save Lead'),
            ),
          ],
        ),
      ),
    );
  }
}
