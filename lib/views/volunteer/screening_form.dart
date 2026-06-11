import 'package:flutter/material.dart';

class PatientScreeningForm extends StatefulWidget {
  final VoidCallback onBack;

  const PatientScreeningForm({super.key, required this.onBack});

  @override
  State<PatientScreeningForm> createState() => _PatientScreeningFormState();
}

class _PatientScreeningFormState extends State<PatientScreeningForm> {
  final _nameController = TextEditingController();
  final _ageController = TextEditingController();
  final _leftEyeController = TextEditingController();
  final _rightEyeController = TextEditingController();
  final _notesController = TextEditingController();

  String? _selectedGender;
  String? _selectedSite;
  String? _selectedDiagnosis;
  bool _flaggedReferral = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            // 🚀 CLINICAL HEADER (Image 0)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 28),
              color: const Color(0xFF28256E),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: widget.onBack,
                    child: Row(
                      children: const [
                        Icon(Icons.arrow_back_rounded, color: Colors.white70, size: 16),
                        SizedBox(width: 6),
                        Text("Back to Dashboard", style: TextStyle(color: Colors.white70, fontSize: 13, fontWeight: FontWeight.w500)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text("New Patient Screening", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 24, letterSpacing: -0.5)),
                  const SizedBox(height: 4),
                  const Text("Complete the visual acuity assessment form", style: TextStyle(color: Colors.white60, fontSize: 13)),
                ],
              ),
            ),

            // FORM BODY FIELDS
            Padding(
              padding: const EdgeInsets.all(32.0),
              child: Container(
                constraints: const BoxConstraints(maxWidth: 600),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ROW 1: Name, Age, Gender Split Grid
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: 4,
                          child: _buildInputField(title: "Patient Full Name *", hint: "Enter patient name", controller: _nameController),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          flex: 2,
                          child: _buildInputField(title: "Age", hint: "Age", controller: _ageController, isNumber: true),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          flex: 3,
                          child: _buildDropdownField(title: "Gender", hint: "Select", items: ["Male", "Female"], value: _selectedGender, onChanged: (v) => setState(() => _selectedGender = v)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // ROW 2: Screening Site Dropdown
                    _buildDropdownField(
                      title: "Screening Site",
                      hint: "Select site",
                      items: ["Karak Rural Eye Camp", "Aqaba Coastal Screening", "Zaatari Mobile Unit"],
                      value: _selectedSite,
                      onChanged: (v) => setState(() => _selectedSite = v),
                    ),
                    const SizedBox(height: 20),

                    // ROW 3: Left Eye & Right Eye Visual Acuity
                    Row(
                      children: [
                        Expanded(child: _buildInputField(title: "Visual Acuity (Left Eye)", hint: "e.g. 20/20", controller: _leftEyeController)),
                        const SizedBox(width: 16),
                        Expanded(child: _buildInputField(title: "Visual Acuity (Right Eye)", hint: "e.g. 20/25", controller: _rightEyeController)),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // ROW 4: Diagnostic Outcome Dropdown
                    _buildDropdownField(
                      title: "Diagnostic Outcome *",
                      hint: "Select diagnosis",
                      items: ["Normal Vision", "Myopia", "Hyperopia", "Cataract Detected", "Refraction Error"],
                      value: _selectedDiagnosis,
                      onChanged: (v) => setState(() => _selectedDiagnosis = v),
                    ),
                    const SizedBox(height: 24),

                    // ROW 5: Switch Button Panel For Specialist Referral Flag
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      decoration: BoxDecoration(color: const Color(0xFFF8FAFC), borderRadius: BorderRadius.circular(10)),
                      child: Row(
                        children: [
                          Switch(
                            value: _flaggedReferral,
                            activeColor: const Color(0xFF28256E),
                            onChanged: (val) => setState(() => _flaggedReferral = val),
                          ),
                          const SizedBox(width: 12),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              Text("Flag for Specialist Referral", style: TextStyle(color: Color(0xFF0F172A), fontWeight: FontWeight.bold, fontSize: 13)),
                              SizedBox(height: 2),
                              Text("Patient requires ophthalmologist review", style: TextStyle(color: Color(0xFF64748B), fontSize: 11)),
                            ],
                          )
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),

                    // ROW 6: Clinical Notes Area Box
                    const Text("Clinical Notes", style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF1E293B))),
                    const SizedBox(height: 6),
                    TextFormField(
                      controller: _notesController,
                      maxLines: 4,
                      decoration: InputDecoration(
                        hintText: "Additional observations...",
                        hintStyle: const TextStyle(color: Color(0xFF94A3B8), fontSize: 13),
                        contentPadding: const EdgeInsets.all(12),
                        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: Color(0xFFE2E8F0))),
                        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: Color(0xFF28256E))),
                      ),
                    ),
                    const SizedBox(height: 32),

                    // ROW 7: Submit Execution Button Asset
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF8B8BAE), // Steel blue accent from your file image asset
                        minimumSize: const Size.fromHeight(48),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        elevation: 0,
                      ),
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Screening Log File Successfully Processed!"), backgroundColor: Colors.teal),
                        );
                        widget.onBack();
                      },
                      icon: const Icon(Icons.save_as_outlined, color: Colors.white, size: 18),
                      label: const Text("Record Screening", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildInputField({required String title, required String hint, required TextEditingController controller, bool isNumber = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF1E293B))),
        const SizedBox(height: 6),
        TextFormField(
          controller: controller,
          keyboardType: isNumber ? TextInputType.number : TextInputType.text,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(color: Color(0xFF94A3B8), fontSize: 13),
            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: Color(0xFFE2E8F0))),
            focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: Color(0xFF28256E))),
          ),
        ),
      ],
    );
  }

  Widget _buildDropdownField({required String title, required String hint, required List<String> items, required String? value, required ValueChanged<String?> onChanged}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF1E293B))),
        const SizedBox(height: 6),
        DropdownButtonFormField<String>(
          value: value,
          hint: Text(hint, style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 13)),
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: Color(0xFFE2E8F0))),
            focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: Color(0xFF28256E))),
          ),
          items: items.map((e) => DropdownMenuItem(value: e, child: Text(e, style: const TextStyle(fontSize: 13)))).toList(),
          onChanged: onChanged,
        ),
      ],
    );
  }
}