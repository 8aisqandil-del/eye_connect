import 'package:flutter/material.dart';
import '../auth/auth_screen.dart'; // Handles the routing to your sign-in options

class HomeDashboard extends StatefulWidget {
  const HomeDashboard({super.key});

  @override
  State<HomeDashboard> createState() => _HomeDashboardState();
}

class _HomeDashboardState extends State<HomeDashboard> {
  final List<Map<String, dynamic>> _clinics = [
    {
      "name": "Spring Eye Camp 2025", 
      "status": "Active",
      "location": "Amman & Irbid", 
      "patients": "2.4k target",
      "color": Colors.teal
    },
    {
      "name": "Refugee Camp Initiative", 
      "status": "Deploying",
      "location": "Zaatari, Mafraq", 
      "patients": "800 target",
      "color": Colors.orange
    },
    {
      "name": "Rural Outreach Program", 
      "status": "Upcoming",
      "location": "Karak & Tafilah", 
      "patients": "600 target",
      "color": Colors.indigo
    },
  ];

  void _restrictAction() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text("Authentication required! Sign in to access system portals."),
        backgroundColor: Colors.amber[800],
        duration: const Duration(seconds: 3),
        action: SnackBarAction(
          label: 'SIGN IN',
          textColor: Colors.white,
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => const AuthScreen()));
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A), 
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: const Icon(Icons.blur_circular_rounded, color: Colors.tealAccent),
        title: const Text("EYECONNECT", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16, letterSpacing: 1)),
        actions: [
          IconButton(
            icon: const Icon(Icons.login_rounded, color: Colors.white70),
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const AuthScreen())),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(color: Colors.teal.withOpacity(0.15), borderRadius: BorderRadius.circular(20)),
                    child: const Text("• LIVE CAMPAIGNS ACROSS JORDAN", style: TextStyle(color: Colors.tealAccent, fontSize: 10, fontWeight: FontWeight.bold)),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    "Restoring Vision,\nTransforming Lives",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 32, height: 1.1, letterSpacing: -0.5),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    "EyeConnect coordinates charitable eye screening campaigns across Jordan.",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white60, fontSize: 13, height: 1.4),
                  ),
                  const SizedBox(height: 16),
                  
                  // 🚀 FIXED ROWS BUTTON TREE:
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF00F2FE), 
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                        ),
                        // 🚀 FIXED: Takes you straight to sign in screen now
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const AuthScreen()),
                          );
                        },
                        icon: const Text("Access Portal", style: TextStyle(color: Color(0xFF0F172A), fontWeight: FontWeight.bold, fontSize: 11)),
                        label: const Icon(Icons.arrow_forward_rounded, color: Color(0xFF0F172A), size: 12),
                      ),
                      const SizedBox(width: 10),
                      OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.white,
                          side: const BorderSide(color: Colors.white24),
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                        ),
                        onPressed: _restrictAction,
                        child: const Text("Join as Volunteer", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  GridView.count(
                    crossAxisCount: 4, 
                    shrinkWrap: true,
                    crossAxisSpacing: 6,
                    mainAxisSpacing: 6,
                    childAspectRatio: 1.25, 
                    physics: const NeverScrollableScrollPhysics(),
                    children: [
                      _buildTopMiniStatCard("12.8k", "Screened"),
                      _buildTopMiniStatCard("4", "Camps"),
                      _buildTopMiniStatCard("128", "Volunteers"),
                      _buildTopMiniStatCard("8", "Govs"),
                    ],
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              decoration: const BoxDecoration(
                color: Color(0xFFF8FAFC),
                borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Active Charity Campaigns", style: TextStyle(color: Color(0xFF0F172A), fontWeight: FontWeight.bold, fontSize: 14)),
                  const SizedBox(height: 12),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: _clinics.length,
                    itemBuilder: (context, index) {
                      final clinic = _clinics[index];
                      return Container(
                        margin: const EdgeInsets.only(bottom: 8),
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8), 
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: const Color(0xFFE2E8F0)),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Text(clinic['name'], style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF0F172A), fontSize: 13)),
                                      const SizedBox(width: 6),
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                                        decoration: BoxDecoration(color: clinic['color'].withOpacity(0.1), borderRadius: BorderRadius.circular(4)),
                                        child: Text(clinic['status'], style: TextStyle(color: clinic['color'], fontSize: 9, fontWeight: FontWeight.bold)),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 2),
                                  Row(
                                    children: [
                                      Text(clinic['location'], style: const TextStyle(color: Color(0xFF64748B), fontSize: 11)),
                                      const SizedBox(width: 8),
                                      Text("•  ${clinic['patients']}", style: const TextStyle(color: Color(0xFF0F172A), fontSize: 11, fontWeight: FontWeight.w600)),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            const Icon(Icons.chevron_right_rounded, size: 18, color: Colors.blueAccent)
                          ],
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 20),
                  const Text("Medical Utility Portals", style: TextStyle(color: Color(0xFF0F172A), fontWeight: FontWeight.bold, fontSize: 14)),
                  const SizedBox(height: 10),
                  _buildUtilityCard("Volunteer Field Station", Icons.analytics_outlined),
                  _buildUtilityCard("Donor Impact Portal", Icons.volunteer_activism_rounded),
                  _buildUtilityCard("Admin Control Panel", Icons.admin_panel_settings_outlined),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildTopMiniStatCard(String value, String label) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(color: Colors.white.withOpacity(0.04), borderRadius: BorderRadius.circular(6), border: Border.all(color: Colors.white.withOpacity(0.05))),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(value, style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w900)),
          Text(label, textAlign: TextAlign.center, style: const TextStyle(color: Colors.white38, fontSize: 8, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }

  Widget _buildUtilityCard(String title, IconData icon) {
    return GestureDetector(
      onTap: _restrictAction, 
      child: Container(
        margin: const EdgeInsets.only(bottom: 6),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8), 
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8), border: Border.all(color: const Color(0xFFE2E8F0))),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(icon, color: const Color(0xFF94A3B8), size: 18),
                const SizedBox(width: 10),
                Text(title, style: const TextStyle(color: Color(0xFF94A3B8), fontWeight: FontWeight.bold, fontSize: 12)),
              ],
            ),
            const Icon(Icons.lock_outline_rounded, color: Color(0xFFCBD5E1), size: 14),
          ],
        ),
      ),
    );
  }
}