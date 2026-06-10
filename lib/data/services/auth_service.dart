import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Stream to monitor if a user logs in or out in real-time
  Stream<User?> get user => _auth.authStateChanges();

  // SIGN UP ENGINE
  Future<UserCredential?> signUp(String email, String password, String name, String role) async {
    try {
      // 1. Create secure login details in Firebase Authentication
      UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email, 
        password: password,
      );
      User? user = result.user;

      // 2. Inject extra user details into a Firestore Document labeled by User UID
      if (user != null) {
        await _db.collection('users').doc(user.uid).set({
          'uid': user.uid,
          'name': name,
          'email': email,
          'role': role.toLowerCase(), // 'donor', 'volunteer', or 'admin'
          'createdAt': FieldValue.serverTimestamp(),
        });
      }
      return result;
    } catch (e) {
      rethrow; // Pass any database errors up to the state machine layer
    }
  }
  // SIGN IN ENGINE
  Future<UserCredential?> signIn(String email, String password) async {
    try {
      // Authenticates credentials against Firebase Auth tables
      UserCredential result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return result;
    } catch (e) {
      rethrow; // Pass any password/email mismatches up the architectural ladder
    }
  }

  // LOGOUT PIPELINE
  Future<void> signOut() async {
    await _auth.signOut();
  }
}