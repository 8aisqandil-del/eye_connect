import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class PledgeForm extends StatefulWidget {
  const PledgeForm({super.key});

  @override
  State<PledgeForm> createState() => _PledgeFormState();
}

class _PledgeFormState extends State<PledgeForm> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  String _pledgeType = 'Eye Donation Pledge';
  bool _isSaving = false;

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  void _submitPledge() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isSaving = true);
      final user = FirebaseAuth.instance.currentUser;

      try {
        // Log the pledge straight to a new cloud collection linked to this user's ID
        await FirebaseFirestore.instance.collection('pledges').add({
          'donorId': user?.uid,
          'donorEmail': user?.email,
          'pledgeType': _pledgeType,
          'supportAmountJD': _pledgeType == 'Financial Sponsorship' 
              ? double.tryParse(_amountController.text.trim()) ?? 0.0 
              : 0.0,
          'timestamp': FieldValue.serverTimestamp(),
        });

        if (!mounted) return;

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Thank you! Your pledge has been registered.'), backgroundColor: Colors.teal),
        );
        Navigator.pop(context); // Return to Donor Dashboard
      } catch (e) {
        setState(() => _isSaving = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e'), backgroundColor: Colors.redAccent),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        title: const Text("Register Support Pledge", style: TextStyle(color: Color(0xFF10172A), fontWeight: FontWeight.bold, fontSize: 16)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Color(0xFF10172A), size: 18),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: _isSaving
          ? const Center(child: CircularProgressIndicator(color: Colors.teal))
          : Padding(
              padding: const EdgeInsets.all(24.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Text(
                      "Select Pledge Type",
                      style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF10172A), fontSize: 14),
                    ),
                    const SizedBox(height: 12),
                    
                    // Dropdown for type of support
                    DropdownButtonFormField<String>(
                      value: _pledgeType,
                      decoration: const InputDecoration(
                        prefixIcon: Icon(Icons.volunteer_activism_rounded),
                      ),
                      items: const [
                        DropdownMenuItem(value: 'Eye Donation Pledge', child: Text('Post-Mortem Eye Donation Pledge')),
                        DropdownMenuItem(value: 'Financial Sponsorship', child: Text('Mobile Camp Financial Sponsorship')),
                      ],
                      onChanged: (val) => setState(() => _pledgeType = val!),
                    ),
                    const SizedBox(height: 20),

                    // Conditionally show amount field if it's a financial sponsorship
                    if (_pledgeType == 'Financial Sponsorship') ...[
                      TextFormField(
                        controller: _amountController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: 'Sponsorship Amount (JD)',
                          prefixIcon: Icon(Icons.monetization_on_outlined),
                        ),
                        validator: (val) => val!.isEmpty ? 'Please enter an amount' : null,
                      ),
                      const SizedBox(height: 24),
                    ],

                    const Spacer(),
                    ElevatedButton(
                      onPressed: _submitPledge,
                      child: const Text("Confirm & Log Pledge"),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}