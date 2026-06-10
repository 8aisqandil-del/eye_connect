import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'pledge_form.dart';

class DonorDashboard extends StatelessWidget {
  const DonorDashboard({super.key});

  void _handleSignOut(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        title: const Text(
          "Donor Workspace",
          style: TextStyle(color: Color(0xFF10172A), fontWeight: FontWeight.bold, fontSize: 18),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout_rounded, color: Colors.redAccent),
            onPressed: () => _handleSignOut(context),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Welcome Header Card
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.teal,
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Welcome Back, Donor!",
                    style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 6),
                  Text(
                    "Your contributions directly power global mobile vision screening clinics.",
                    style: TextStyle(color: Colors.white70, fontSize: 13),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            const Text(
              "Quick Actions",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF10172A)),
            ),
            const SizedBox(height: 12),

            // Action Panel Grid Rows
            Row(
              children: [
                Expanded(
                  child: _buildActionButton(
                    icon: Icons.volunteer_activism_rounded,
                    title: "Pledge Donation",
                    color: Colors.teal,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const PledgeForm()),
                      );
                    },
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildActionButton(
                    icon: Icons.history_rounded,
                    title: "History Logs",
                    color: const Color(0xFF64748B),
                    onTap: () {
                      // Placeholder for history module
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Impact Metrics Section
            const Text(
              "Your Contribution Impact Tracker",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF10172A)),
            ),
            const SizedBox(height: 12),

            // 🚀 DEVELOPER FIX: Live StreamBuilder calculating metrics straight from Firestore
            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('pledges')
                  .where('donorEmail', isEqualTo: user?.email)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: CircularProgressIndicator(color: Colors.teal),
                  ));
                }

                int totalPledgesCount = 0;
                double totalFinancialContribution = 0.0;

                if (snapshot.hasData) {
                  final docs = snapshot.data!.docs;
                  totalPledgesCount = docs.length;

                  for (var doc in docs) {
                    final data = doc.data() as Map<String, dynamic>;
                    // Accumulate all financial amounts logged under this donor
                    totalFinancialContribution += (data['supportAmountJD'] ?? 0.0);
                  }
                }

                return Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0xFFE2E8F0)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildMetricItem("$totalPledgesCount", "Active Pledges"),
                      Container(height: 40, width: 1, color: const Color(0xFFE2E8F0)),
                      _buildMetricItem("JD ${totalFinancialContribution.toStringAsFixed(0)}", "Total Contributed"),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon, 
    required String title, 
    required Color color,
    required VoidCallback onTap,
  }) {
    return Container(
      height: 110,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: onTap,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 32, color: color),
              const SizedBox(height: 10),
              Text(title, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13, color: Color(0xFF10172A))),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMetricItem(String value, String subtitle) {
    return Column(
      children: [
        Text(value, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.teal)),
        const SizedBox(height: 4),
        Text(subtitle, style: const TextStyle(fontSize: 12, color: Color(0xFF64748B))),
      ],
    );
  }
}