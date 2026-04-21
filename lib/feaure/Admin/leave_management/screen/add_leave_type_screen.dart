import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/leave_type_bloc.dart';
import '../bloc/leave_type_event.dart';
import '../bloc/leave_type_state.dart';
import '../data/model/leave_type_model.dart';
import '../data/repository/leave_repository.dart';

class AddLeaveTypeScreen extends StatefulWidget {
  final LeaveTypeModel? leaveType;
  const AddLeaveTypeScreen({super.key, this.leaveType});

  @override
  State<AddLeaveTypeScreen> createState() => _AddLeaveTypeScreenState();
}

class _AddLeaveTypeScreenState extends State<AddLeaveTypeScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _codeController;
  late TextEditingController _daysController;
  late TextEditingController _descriptionController;
  bool _isPaid = true;
  bool _carryForward = false;
  bool _requiresDocument = false;
  bool _isActive = true;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.leaveType?.name ?? '');
    _codeController = TextEditingController(text: widget.leaveType?.code ?? '');
    _daysController = TextEditingController(text: widget.leaveType?.daysPerYear.toString() ?? '');
    _descriptionController = TextEditingController(text: widget.leaveType?.description ?? '');
    _isPaid = widget.leaveType?.isPaid ?? true;
    _carryForward = widget.leaveType?.carryForward ?? false;
    _requiresDocument = widget.leaveType?.requiresDocument ?? false;
    _isActive = widget.leaveType?.isActive ?? true;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _codeController.dispose();
    _daysController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print("AddLeaveTypeScreen -> widget.leaveType: ${widget.leaveType}");
    final isEditing = widget.leaveType != null;

    return BlocProvider(
      create: (context) => LeaveTypeBloc(leaveRepository: LeaveRepository()),
      child: Scaffold(
        appBar: AppBar(
          title: Text(isEditing ? 'Update Leave Type' : 'Add Leave Type'),
        ),
        body: BlocConsumer<LeaveTypeBloc, LeaveTypeState>(
          listener: (context, state) {
            if (state.status == LeaveTypeStatus.actionSuccess) {
              Navigator.pop(context, true);
            }
            if (state.status == LeaveTypeStatus.failure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.errorMessage ?? 'Failed to save leave type')),
              );
            }
          },
          builder: (context, state) {
            return Form(
              key: _formKey,
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    TextFormField(
                      controller: _nameController,
                      decoration: const InputDecoration(labelText: 'Name', border: OutlineInputBorder()),
                      validator: (value) => value == null || value.isEmpty ? 'Please enter name' : null,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _codeController,
                      decoration: const InputDecoration(labelText: 'Code', border: OutlineInputBorder()),
                      validator: (value) => value == null || value.isEmpty ? 'Please enter code' : null,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _daysController,
                      decoration: const InputDecoration(labelText: 'Days per Year', border: OutlineInputBorder()),
                      keyboardType: TextInputType.number,
                      validator: (value) => value == null || value.isEmpty ? 'Please enter days' : null,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _descriptionController,
                      decoration: const InputDecoration(labelText: 'Description', border: OutlineInputBorder()),
                      maxLines: 3,
                    ),
                    const SizedBox(height: 16),
                    SwitchListTile(
                      title: const Text('Is Paid'),
                      value: _isPaid,
                      onChanged: (value) => setState(() => _isPaid = value),
                    ),
                    SwitchListTile(
                      title: const Text('Carry Forward'),
                      value: _carryForward,
                      onChanged: (value) => setState(() => _carryForward = value),
                    ),
                    SwitchListTile(
                      title: const Text('Requires Document'),
                      value: _requiresDocument,
                      onChanged: (value) => setState(() => _requiresDocument = value),
                    ),
                    SwitchListTile(
                      title: const Text('Is Active'),
                      value: _isActive,
                      onChanged: (value) => setState(() => _isActive = value),
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: state.status == LeaveTypeStatus.loading
                            ? null
                            : () => _submit(context),
                        child: state.status == LeaveTypeStatus.loading
                            ? const CircularProgressIndicator(color: Colors.white)
                            : Text(isEditing ? 'Update' : 'Save'),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  void _submit(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      final leaveType = LeaveTypeModel(
        id: widget.leaveType?.id,
        name: _nameController.text,
        code: _codeController.text,
        daysPerYear: int.parse(_daysController.text),
        isPaid: _isPaid,
        carryForward: _carryForward,
        requiresDocument: _requiresDocument,
        description: _descriptionController.text,
        isActive: _isActive,
      );

      if (widget.leaveType != null) {
        context.read<LeaveTypeBloc>().add(UpdateLeaveType(widget.leaveType!.id!, leaveType.toJson()));
      } else {
        context.read<LeaveTypeBloc>().add(CreateLeaveType(leaveType));
      }
    }
  }
}
