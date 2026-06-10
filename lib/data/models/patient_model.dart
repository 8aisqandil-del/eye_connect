import 'package:cloud_firestore/cloud_firestore.dart';

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

  // Map data to save securely into Cloud Firestore collections
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