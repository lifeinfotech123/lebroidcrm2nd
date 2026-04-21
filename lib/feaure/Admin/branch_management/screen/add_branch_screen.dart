import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lebroid_crm/feaure/Admin/branch_management/bloc/branch_bloc.dart';
import 'package:lebroid_crm/feaure/Admin/branch_management/bloc/branch_event.dart';
import 'package:lebroid_crm/feaure/Admin/branch_management/data/model/branch_model.dart';

class AddBranchScreen extends StatefulWidget {
  final BranchModel? branch; // If provided, we are editing

  const AddBranchScreen({super.key, this.branch});

  @override
  State<AddBranchScreen> createState() => _AddBranchScreenState();
}

class _AddBranchScreenState extends State<AddBranchScreen> {
  final _nameController = TextEditingController();
  final _codeController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();
  final _cityController = TextEditingController();
  final _stateController = TextEditingController();
  final _latController = TextEditingController();
  final _lngController = TextEditingController();
  final _radiusController = TextEditingController();

  bool isActive = true;
  String selectedCountry = "India";
  String? selectedManager;

  final List<String> managers = [
    "— No manager assigned —",
    "System Administrator",
    "HR Manager",
  ];

  @override
  void initState() {
    super.initState();
    selectedManager = managers.first;
    
    if (widget.branch != null) {
      _nameController.text = widget.branch!.name ?? '';
      _codeController.text = widget.branch!.code ?? '';
      _emailController.text = widget.branch!.email ?? '';
      _phoneController.text = widget.branch!.phone ?? '';
      _addressController.text = widget.branch!.address ?? '';
      _cityController.text = widget.branch!.city ?? '';
      _stateController.text = widget.branch!.state ?? '';
      _latController.text = widget.branch!.geoLat ?? '';
      _lngController.text = widget.branch!.geoLng ?? '';
      _radiusController.text = widget.branch!.geoRadiusMeters ?? '';
      isActive = widget.branch!.isActive;
      selectedCountry = widget.branch!.country ?? "India";
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _codeController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _cityController.dispose();
    _stateController.dispose();
    _latController.dispose();
    _lngController.dispose();
    _radiusController.dispose();
    super.dispose();
  }

  void _saveBranch() {
    if (_nameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Branch Name is required')));
      return;
    }
    
    final branchData = {
      "name": _nameController.text.trim(),
      "code": _codeController.text.trim(),
      "email": _emailController.text.trim(),
      "phone": _phoneController.text.trim(),
      "address": _addressController.text.trim(),
      "city": _cityController.text.trim(),
      "state": _stateController.text.trim(),
      "country": selectedCountry,
      // Default to 1 for manager currently if assigned, just dummy for now as the dropdown does not have IDs.
      "manager_id": selectedManager != "— No manager assigned —" ? 1 : null, 
      "geo_lat": _latController.text.trim(),
      "geo_lng": _lngController.text.trim(),
      "geo_radius_meters": _radiusController.text.trim(),
      "is_active": isActive,
    };

    if (widget.branch != null) {
      context.read<BranchBloc>().add(UpdateBranchEvent(widget.branch!.id, branchData));
    } else {
      context.read<BranchBloc>().add(AddBranchEvent(branchData));
    }
    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff5f6fa),
      appBar: AppBar(
        title: Text(widget.branch != null ? 'Edit Branch' : 'Add Branch'),
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            /// ================= BASIC INFO =================
            _sectionTitle("Basic Information"),

            _buildTextField(label: "Branch Name *", hint: "e.g. Head Office", controller: _nameController),
            _buildTextField(label: "Code *", hint: "HO", controller: _codeController),
            _buildTextField(label: "Email", hint: "branch@email.com", controller: _emailController),
            _buildTextField(label: "Phone", hint: "+91 00000 00000", controller: _phoneController, keyboardType: TextInputType.phone),

            const SizedBox(height: 12),

            /// ACTIVE SWITCH
            Row(
              children: [
                const Text("Active", style: TextStyle(fontWeight: FontWeight.w600)),
                const Spacer(),
                Switch(
                  value: isActive,
                  onChanged: (val) {
                    setState(() => isActive = val);
                  },
                )
              ],
            ),

            const SizedBox(height: 16),

            _buildTextField(label: "Address", hint: "Street / building address", controller: _addressController),
            _buildTextField(label: "City", hint: "City", controller: _cityController),
            _buildTextField(label: "State / Province", hint: "State", controller: _stateController),

            /// COUNTRY DROPDOWN
            _buildDropdown(
              label: "Country *",
              value: selectedCountry,
              items: ["India", "USA", "UK"],
              onChanged: (val) => setState(() => selectedCountry = val!),
            ),

            /// MANAGER DROPDOWN
            _buildDropdown(
              label: "Branch Manager",
              value: selectedManager!,
              items: managers,
              onChanged: (val) => setState(() => selectedManager = val),
            ),

            const SizedBox(height: 25),

            /// ================= GEO FENCE =================
            _sectionTitle("Geo-fence Settings"),

            const SizedBox(height: 6),
            Text(
              "Used for location-based attendance verification. Employees must be within the geo-fence radius to clock in/out.",
              style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
            ),

            const SizedBox(height: 16),

            _buildTextField(label: "Latitude", hint: "e.g. 28.6139", controller: _latController, keyboardType: TextInputType.number),
            _buildTextField(label: "Longitude", hint: "e.g. 77.2090", controller: _lngController, keyboardType: TextInputType.number),
            _buildTextField(label: "Radius (meters) *", hint: "Enter radius", controller: _radiusController, keyboardType: TextInputType.number),

            const SizedBox(height: 30),

            /// SAVE BUTTON
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _saveBranch,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                child: Text(
                  widget.branch != null ? "Update Branch" : "Save Branch",
                  style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  /// ================= WIDGETS =================

  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Text(
        title,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required String hint,
    required TextEditingController controller,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
              style: const TextStyle(
                  fontWeight: FontWeight.w600, fontSize: 13)),
          const SizedBox(height: 6),
          TextField(
            controller: controller,
            keyboardType: keyboardType,
            decoration: InputDecoration(
              hintText: hint,
              filled: true,
              fillColor: Colors.white,
              contentPadding: const EdgeInsets.symmetric(
                  horizontal: 12, vertical: 14),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDropdown({
    required String label,
    required String value,
    required List<String> items,
    required Function(String?) onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
              style: const TextStyle(
                  fontWeight: FontWeight.w600, fontSize: 13)),
          const SizedBox(height: 6),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: DropdownButton<String>(
              value: items.contains(value) ? value : items.first,
              isExpanded: true,
              underline: const SizedBox(),
              items: items
                  .map((e) => DropdownMenuItem(
                value: e,
                child: Text(e),
              ))
                  .toList(),
              onChanged: onChanged,
            ),
          ),
        ],
      ),
    );
  }
}
