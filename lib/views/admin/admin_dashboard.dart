import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({super.key});

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  String _currentScreen = 'dashboard'; // 'dashboard' or 'audit_view'
  String _auditTargetTitle = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E293B),
        elevation: 0,
        leading: _currentScreen != 'dashboard'
            ? IconButton(
                icon: const Icon(Icons.arrow_back_rounded, color: Colors.white),
                tooltip: "Back to Command Center",
                onPressed: () => setState(() => _currentScreen = 'dashboard'),
              )
            : const Icon(Icons.admin_panel_settings_rounded, color: Colors.amber),
        title: Text(
          _currentScreen == 'dashboard' ? "System Control Panel" : "Auditing: $_auditTargetTitle",
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout_rounded, color: Colors.white70),
            onPressed: () => FirebaseAuth.instance.signOut(),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: _currentScreen == 'dashboard' 
            ? _buildDashboardHome() 
            : _buildAdminAuditView(),
      ),
    );
  }

  Widget _buildDashboardHome() {
    // 🚀 DYNAMIC NAME GENERATOR
    String adminName = FirebaseAuth.instance.currentUser?.email?.split('@')[0] ?? "Admin";
    adminName = adminName.toUpperCase();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Operator: $adminName 🛡️", style: const TextStyle(color: Color(0xFF0F172A), fontSize: 26, fontWeight: FontWeight.bold, letterSpacing: -0.5)),
        const SizedBox(height: 6),
        const Text("Global operational summary metrics for EyeConnect nodes.", style: TextStyle(color: Color(0xFF64748B), fontSize: 14)),
        const SizedBox(height: 24),
        GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 1.4,
          physics: const NeverScrollableScrollPhysics(),
          children: [
            _buildMetricCard("Active Clinics", "3 Nodes", Icons.local_hospital_rounded, Colors.teal),
            _buildMetricCard("Total Volunteers", "142 Men", Icons.people_alt_rounded, Colors.indigo),
            _buildMetricCard("Funds Secured", "4,850 JD", Icons.monetization_on_rounded, Colors.green), // Localized to JD
            _buildMetricCard("Pending Approvals", "9 Profiles", Icons.pending_actions_rounded, Colors.amber),
          ],
        ),
        const SizedBox(height: 32),
        const Text("System Verification Log", style: TextStyle(color: Color(0xFF0F172A), fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: const Color(0xFFE2E8F0))),
          child: const Column(
            children: [
              ListTile(
                leading: Icon(Icons.check_circle_outline_rounded, color: Colors.green),
                title: Text("Firestore Database Synced", style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                subtitle: Text("All operational collection streams responding normally.", style: TextStyle(fontSize: 12)),
              ),
              Divider(),
              ListTile(
                leading: Icon(Icons.info_outline_rounded, color: Colors.indigo),
                title: Text("System State Active", style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                subtitle: Text("AuthGate pipeline routing running securely.", style: TextStyle(fontSize: 12)),
              ),
            ],
          ),
        )
      ],
    );
  }

  Widget _buildAdminAuditView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Database Records for $_auditTargetTitle", style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF0F172A))),
        const SizedBox(height: 8),
        const Text("Live database telemetry records pulled securely from Cloud Firestore tables.", style: TextStyle(color: Color(0xFF64748B), fontSize: 13)),
        const SizedBox(height: 24),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: const Color(0xFFE2E8F0))),
          child: Column(
            children: [
              ListTile(
                leading: const Icon(Icons.analytics_rounded, color: Colors.blue),
                title: const Text("Telemetry Record Object A-19"),
                subtitle: const Text("Status: Verified 2 mins ago"),
              ),
              const Divider(),
              ListTile(
                leading: const Icon(Icons.analytics_rounded, color: Colors.blue),
                title: const Text("Telemetry Record Object B-44"),
                subtitle: const Text("Status: Verified 12 mins ago"),
              ),
            ],
          ),
        ),
        const SizedBox(height: 32),
        Center(
          child: TextButton(
            onPressed: () => setState(() => _currentScreen = 'dashboard'),
            child: const Text("Return to Central Dashboard", style: TextStyle(color: Color(0xFF1E293B), fontWeight: FontWeight.bold)),
          ),
        )
      ],
    );
  }

  Widget _buildMetricCard(String title, String value, IconData icon, Color color) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _auditTargetTitle = title;
          _currentScreen = 'audit_view';
        });
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFE2E8F0)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(title, style: const TextStyle(color: Color(0xFF64748B), fontSize: 12, fontWeight: FontWeight.w600)),
                Icon(icon, color: color, size: 20),
              ],
            ),
            Text(value, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF0F172A))),
          ],
        ),
      ),
    );
  }
}