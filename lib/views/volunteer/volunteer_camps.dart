import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class VolunteerCamps extends StatelessWidget {
  const VolunteerCamps({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        title: const Text(
          "Assigned Camp Locations",
          style: TextStyle(color: Color(0xFF10172A), fontWeight: FontWeight.bold, fontSize: 16),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Color(0xFF10172A), size: 18),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        // 🚀 Pulling active camps directly from the cloud database
        stream: FirebaseFirestore.instance.collection('screening_sites').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator(color: Colors.indigo));
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.fmd_bad_rounded, size: 48, color: Colors.grey[400]),
                  const SizedBox(height: 12),
                  Text(
                    "No camp locations assigned to you yet.",
                    style: TextStyle(color: Colors.grey[600], fontSize: 14),
                  ),
                ],
              ),
            );
          }

          final campDocs = snapshot.data!.docs;

          return ListView.builder(
            padding: const EdgeInsets.all(24.0),
            itemCount: campDocs.length,
            itemBuilder: (context, index) {
              final data = campDocs[index].data() as Map<String, dynamic>;

              String siteName = data['siteName'] ?? 'Unnamed Medical Site';
              String locationName = data['locationName'] ?? 'Location TBD';
              String status = data['status'] ?? 'Deploying';
              int volunteers = data['volunteerCount'] ?? 1;

              // Color coordinate the status tags dynamically
              Color statusColor = status == 'Active' ? Colors.teal : Colors.indigo;

              return Container(
                margin: const EdgeInsets.only(bottom: 16),
                padding: const EdgeInsets.all(18),
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
                        Expanded(
                          child: Text(
                            siteName,
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Color(0xFF10172A)),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: statusColor.withOpacity(0.08),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            status,
                            style: TextStyle(color: statusColor, fontSize: 11, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(Icons.location_on_rounded, size: 14, color: Color(0xFF64748B)),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            locationName,
                            style: const TextStyle(fontSize: 13, color: Color(0xFF64748B)),
                          ),
                        ),
                      ],
                    ),
                    const Divider(height: 24, color: Color(0xFFF1F5F9)),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "👥 Staffing: $volunteers Assigned",
                          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: Color(0xFF10172A)),
                        ),
                        TextButton.icon(
                          onPressed: () {
                            // Quick anchor for future navigation integration mapping
                          },
                          icon: const Icon(Icons.navigation_rounded, size: 14, color: Colors.indigo),
                          label: const Text("Route", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.indigo)),
                        )
                      ],
                    )
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}