import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// 🚀 EMBEDDED ARCHITECTURE MODEL: Placed right here to completely eliminate the path error!
class PatientRecord {
  final String? id;
  final String fullName;
  final int age;
  final String gender;
  final String screeningSite;
  final String visualAcuityLeft;
  final String visualAcuityRight;
  final String diagnosticOutcome;
  final bool isReferralFlaged;
  final DateTime timestamp;

  PatientRecord({
    this.id,
    required this.fullName,
    required this.age,
    required this.gender,
    required this.screeningSite,
    required this.visualAcuityLeft,
    required this.visualAcuityRight,
    required this.diagnosticOutcome,
    required this.isReferralFlaged,
    required this.timestamp,
  });

  Map<String, dynamic> toMap() {
    return {
      'fullName': fullName,
      'age': age,
      'gender': gender,
      'screeningSite': screeningSite,
      'visualAcuityLeft': visualAcuityLeft,
      'visualAcuityRight': visualAcuityRight,
      'diagnosticOutcome': diagnosticOutcome,
      'isReferralFlaged': isReferralFlaged,
      'timestamp': Timestamp.fromDate(timestamp),
    };
  }
}

class ScreeningForm extends StatefulWidget {
  const ScreeningForm({super.key});

  @override
  State<ScreeningForm> createState() => _ScreeningFormState();
}

class _ScreeningFormState extends State<ScreeningForm> {
  final _formKey = GlobalKey<FormState>();
  
  final _nameController = TextEditingController();
  final _ageController = TextEditingController();
  final _vaLeftController = TextEditingController();
  final _vaRightController = TextEditingController();

  String _selectedGender = 'Select';
  String _selectedSite = 'Select site';
  String _selectedDiagnosis = 'Select diagnosis';
  bool _flagForReferral = false;
  bool _isSubmitting = false;

  final List<String> _genders = ['Select', 'Male', 'Female'];
  final List<String> _sites = ['Select site', 'Amman Central Camp', 'Zarqa Refugee Clinic', 'Irbid Community Center'];
  final List<String> _diagnoses = ['Select diagnosis', 'Normal Vision', 'Refractive Error', 'Cataract Diagnosed', 'Glaucoma Suspect', 'Other'];

  void _submitForm() async {
    if (!_formKey.currentState!.validate() || _selectedGender == 'Select' || _selectedSite == 'Select site' || _selectedDiagnosis == 'Select diagnosis') {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please verify all required operational selections.'), backgroundColor: Colors.orangeAccent),
      );
      return;
    }

    setState(() => _isSubmitting = true);

    try {
      final record = PatientRecord(
        fullName: _nameController.text.trim(),
        age: int.parse(_ageController.text.trim()),
        gender: _selectedGender,
        screeningSite: _selectedSite,
        visualAcuityLeft: _vaLeftController.text.trim(),
        visualAcuityRight: _vaRightController.text.trim(),
        diagnosticOutcome: _selectedDiagnosis,
        isReferralFlaged: _flagForReferral,
        timestamp: DateTime.now(),
      );

      await FirebaseFirestore.instance.collection('patients').add(record.toMap());

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Patient Screening Logged Successfully!'), backgroundColor: Colors.teal),
        );
        Navigator.pop(context); 
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Submission Failure: $e'), backgroundColor: Colors.redAccent),
      );
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _ageController.dispose();
    _vaLeftController.dispose();
    _vaRightController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: TextButton.icon(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_ios_rounded, size: 14, color: Colors.blue),
          label: const Text("Back to Station", style: TextStyle(color: Colors.blue, fontSize: 13, fontWeight: FontWeight.w500)),
        ),
        leadingWidth: 150,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color(0xFF312E81),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("New Patient Screening", style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                    SizedBox(height: 4),
                    Text("Complete the visual acuity assessment form", style: TextStyle(color: Colors.white70, fontSize: 12)),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 3,
                    child: _buildFormFieldLabel("Patient Full Name *", _buildTextField(_nameController, "Enter patient name", (val) => val!.isEmpty ? 'Required' : null)),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    flex: 1,
                    child: _buildFormFieldLabel("Age", _buildTextField(_ageController, "Age", (val) => val!.isEmpty ? 'Required' : null, isNum: true)),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    flex: 2,
                    child: _buildFormFieldLabel("Gender", _buildDropdownButton(_selectedGender, _genders, (val) => setState(() => _selectedGender = val!))),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              _buildFormFieldLabel("Screening Site", _buildDropdownButton(_selectedSite, _sites, (val) => setState(() => _selectedSite = val!))),
              const SizedBox(height: 20),

              Row(
                children: [
                  Expanded(child: _buildFormFieldLabel("Visual Acuity (Left Eye)", _buildTextField(_vaLeftController, "e.g. 20/20", (val) => val!.isEmpty ? 'Required' : null))),
                  const SizedBox(width: 16),
                  Expanded(child: _buildFormFieldLabel("Visual Acuity (Right Eye)", _buildTextField(_vaRightController, "e.g. 20/25", (val) => val!.isEmpty ? 'Required' : null))),
                ],
              ),
              const SizedBox(height: 20),

              _buildFormFieldLabel("Diagnostic Outcome *", _buildDropdownButton(_selectedDiagnosis, _diagnoses, (val) => setState(() => _selectedDiagnosis = val!))),
              const SizedBox(height: 24),

              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(color: const Color(0xFFF8FAFC), borderRadius: BorderRadius.circular(10), border: Border.all(color: const Color(0xFFE2E8F0))),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Row(
                      children: [
                        Icon(Icons.assignment_turned_in_outlined, color: Color(0xFF475569)),
                        SizedBox(width: 12),
                        Text("Flag for Specialist Referral", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF0F172A))),
                      ],
                    ),
                    Switch(
                      value: _flagForReferral,
                      activeColor: Colors.teal,
                      onChanged: (val) => setState(() => _flagForReferral = val),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),

              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1E1B4B),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  elevation: 0,
                ),
                onPressed: _isSubmitting ? null : _submitForm,
                child: _isSubmitting
                    ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                    : const Text("Submit Screening Record", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFormFieldLabel(String label, Widget child) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF0F172A))),
        const SizedBox(height: 8),
        child,
      ],
    );
  }

  Widget _buildTextField(TextEditingController controller, String hint, String? Function(String?)? validator, {bool isNum = false}) {
    return TextFormField(
      controller: controller,
      validator: validator,
      keyboardType: isNum ? TextInputType.number : TextInputType.text,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: Color(0xFF94A3B8), fontSize: 13),
        contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 14),
        filled: true,
        fillColor: Colors.white,
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: Color(0xFFE2E8F0))),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: Color(0xFF1E1B4B), width: 1.5)),
        errorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: Colors.redAccent)),
        focusedErrorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: Colors.redAccent, width: 1.5)),
      ),
    );
  }

  Widget _buildDropdownButton(String value, List<String> items, ValueChanged<String?> onChanged) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8), border: Border.all(color: const Color(0xFFE2E8F0))),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          isExpanded: true,
          icon: const Icon(Icons.keyboard_arrow_down_rounded, color: Color(0xFF94A3B8)),
          style: const TextStyle(color: Color(0xFF0F172A), fontSize: 13),
          items: items.map((String item) => DropdownMenuItem<String>(value: item, child: Text(item))).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }
}