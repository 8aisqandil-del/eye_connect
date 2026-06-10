import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../auth_gate.dart';
import '../auth/auth_screen.dart';
import '../volunteer/screening_form.dart';
import '../donor/pledge_form.dart';

class GuestHome extends StatelessWidget {
  const GuestHome({super.key});

  // 🔒 THE SECURITY GATE: Intercepts unauthenticated guests cleanly
  void _protectedActionGateway(BuildContext context, Widget targetScreen) {
    final user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      Navigator.push(context, MaterialPageRoute(builder: (context) => targetScreen));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('🔒 Authentication Required. Please sign in to access this portal.'),
          backgroundColor: Color(0xFF0F172A),
          duration: Duration(seconds: 3),
        ),
      );
      Navigator.push(context, MaterialPageRoute(builder: (context) => const AuthScreen()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        title: const Text(
          "EyeConnect Hub",
          style: TextStyle(color: Color(0xFF10172A), fontWeight: FontWeight.bold, fontSize: 18),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.teal),
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const AuthScreen()));
              },
              child: Text(
                FirebaseAuth.instance.currentUser == null ? "Sign In" : "My Workspace",
                style: const TextStyle(color: Colors.white, fontSize: 13),
              ),
            ),
          ),
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth > 950) {
            return _buildLaptopLayout(context);
          } else {
            return _buildMobileLayout(context);
          }
        },
      ),
    );
  }

  // 💻 LAPTOP VIEW: Dual Column Panel Setup
  Widget _buildLaptopLayout(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          _buildHeroSection(),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Left Panel: Active Campaigns Feed (60% Width)
              Expanded(
                flex: 3,
                child: Padding(
                  padding: const EdgeInsets.all(40.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Active Vision Campaigns",
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF10172A)),
                      ),
                      const SizedBox(height: 4),
                      const Text("Live field deployments and tracking parameters across Jordan.", style: TextStyle(fontSize: 13, color: Color(0xFF64748B))),
                      const SizedBox(height: 24),
                      _buildCampaignCardHorizontal("Amman Central Campaign", "Downtown Amman Clinic", "In Progress", Colors.teal, "14 Active Volunteers"),
                      const SizedBox(height: 16),
                      _buildCampaignCardHorizontal("Zarqa Pediatric Screening", "Zarqa Community Hub", "Deploying June 5", Colors.indigo, "8 Assigned Field Workers"),
                      const SizedBox(height: 16),
                      _buildCampaignCardHorizontal("Irbid Mobile Vision Truck", "Northern Villages Route", "Completed", Colors.grey, "22 Logged Case Files"),
                    ],
                  ),
                ),
              ),

              // Right Panel: Operational Toolkit Gateways (40% Width)
              Expanded(
                flex: 2,
                child: Container(
                  margin: const EdgeInsets.only(top: 40, right: 40, bottom: 40),
                  padding: const EdgeInsets.all(32),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: const Color(0xFFE2E8F0)),
                    boxShadow: [
                      BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 15, offset: const Offset(0, 8))
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text("Workspace Portals", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF10172A))),
                      const SizedBox(height: 4),
                      const Text("Select an operational dynamic below to begin.", style: TextStyle(fontSize: 12, color: Color(0xFF64748B))),
                      const SizedBox(height: 24),
                      _buildServiceTileLaptop(
                        icon: Icons.add_moderator_rounded,
                        title: "Log Patient Screening",
                        subtitle: "Access the offline-ready medical field toolkit for vision tests.",
                        color: Colors.teal,
                        onTap: () => _protectedActionGateway(context, const ScreeningForm()),
                      ),
                      const SizedBox(height: 16),
                      _buildServiceTileLaptop(
                        icon: Icons.volunteer_activism_rounded,
                        title: "Pledge Support",
                        subtitle: "Open the donor pipeline to submit sponsorships or organ pledges.",
                        color: Colors.indigo,
                        onTap: () => _protectedActionGateway(context, const PledgeForm()),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // 📱 SMARTPHONE VIEW: Vertical Stacking Layout
  Widget _buildMobileLayout(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text("Active Vision Campaigns", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF10172A))),
          const SizedBox(height: 12),
          SizedBox(
            height: 140,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                _buildMobileCampaignCard("Amman Central", "Downtown Clinic", "In Progress", Colors.teal),
                const SizedBox(width: 12),
                _buildMobileCampaignCard("Zarqa Pediatric", "Community Hub", "June 5", Colors.indigo),
                const SizedBox(width: 12),
                _buildMobileCampaignCard("Irbid Mobile Truck", "Northern Route", "Completed", Colors.grey),
              ],
            ),
          ),
          const SizedBox(height: 28),
          const Text("Quick Access Services", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF10172A))),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildServiceTileMobile(
                  icon: Icons.add_moderator_rounded,
                  title: "Log Patient Screening",
                  color: Colors.teal,
                  onTap: () => _protectedActionGateway(context, const ScreeningForm()),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: _buildServiceTileMobile(
                  icon: Icons.volunteer_activism_rounded,
                  title: "Pledge Support",
                  color: Colors.indigo,
                  onTap: () => _protectedActionGateway(context, const PledgeForm()),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // --- SUB-WIDGET COMPONENTS ---

  Widget _buildHeroSection() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 70, horizontal: 40),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF0F172A), Color(0xFF1E293B)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(color: Colors.teal, borderRadius: BorderRadius.circular(20)),
            child: const Text("JORDAN NATIONAL VISION PIPELINE", style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
          ),
          const SizedBox(height: 20),
          const Text(
            "Connecting Hearts,\nRestoring Sight.",
            style: TextStyle(color: Colors.white, fontSize: 44, fontWeight: FontWeight.bold, height: 1.1),
          ),
          const SizedBox(height: 16),
          // 🚀 FIXED: Wrapped in a clean BoxConstraint interface instead of standard invalid sized bounds
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 650),
            child: const Text(
              "EyeConnect provides a serverless communication layer bridging localized medical field automation with macro-level donor campaign resources across Jordan.",
              style: TextStyle(color: Colors.white70, fontSize: 14, height: 1.5),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCampaignCardHorizontal(String title, String clinic, String status, Color statusColor, String stats) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Color(0xFF10172A))),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(color: statusColor.withOpacity(0.1), borderRadius: BorderRadius.circular(6)),
                child: Text(status, style: TextStyle(color: statusColor, fontSize: 11, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(clinic, style: const TextStyle(fontSize: 13, color: Color(0xFF64748B))),
          const Divider(height: 24, color: Color(0xFFF1F5F9)),
          Row(
            children: [
              const Icon(Icons.bolt, size: 14, color: Colors.teal),
              const SizedBox(width: 4),
              Text(stats, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: Colors.teal)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildServiceTileLaptop({required IconData icon, required String title, required String subtitle, required Color color, required VoidCallback onTap}) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        leading: CircleAvatar(backgroundColor: color.withOpacity(0.1), child: Icon(icon, color: color)),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 4.0),
          child: Text(subtitle, style: const TextStyle(fontSize: 12, height: 1.3, color: Color(0xFF64748B))),
        ),
        trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 14, color: Color(0xFF94A3B8)),
        onTap: onTap,
      ),
    );
  }

  Widget _buildMobileCampaignCard(String title, String clinic, String status, Color statusColor) {
    return Container(
      width: 200,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white, 
        borderRadius: BorderRadius.circular(12), 
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Color(0xFF10172A))),
          const SizedBox(height: 4),
          Text(clinic, style: const TextStyle(fontSize: 12, color: Color(0xFF64748B))),
          const Spacer(),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(color: statusColor.withOpacity(0.1), borderRadius: BorderRadius.circular(6)),
            child: Text(status, style: TextStyle(color: statusColor, fontSize: 10, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  Widget _buildServiceTileMobile({required IconData icon, required String title, required Color color, required VoidCallback onTap}) {
    return Container(
      height: 120,
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
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, size: 28, color: color),
                const SizedBox(height: 12),
                Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF10172A))),
              ],
            ),
          ),
        ),
      ),
    );
  }
}