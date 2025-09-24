import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Login with Email and Password
  Future<User?> loginWithEmail(String email, String password) async {
    try {
      final UserCredential userCredential =
          await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user;
    } catch (e) {
      throw Exception('Login failed: $e');
    }
  }

  Future<String> getRole(String userId) async {
    try {
      DocumentSnapshot userDoc =
          await _db.collection('users').doc(userId).get();

      // Debug log to see user document data
      print('User Document: ${userDoc.data()}');

      if (userDoc.exists) {
        final data = userDoc.data() as Map<String, dynamic>;
        return data['role'] ?? 'unknown';
      } else {
        throw Exception('User document does not exist.');
      }
    } catch (e) {
      throw Exception('Failed to fetch role: $e');
    }
  }

  // Register with email
  Future<void> registerWithEmail(
      String email, String password, String name, String role) async {
    try {
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Save user to Firestore
      await _db.collection('users').doc(userCredential.user?.uid).set({
        'name': name,
        'email': email,
        'role': role,
      });
    } catch (e) {
      throw Exception('Signup failed: $e');
    }
  }

  // Reset password
  Future<void> resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } catch (e) {
      throw Exception('Failed to send password reset email: $e');
    }
  }

  // Logout
  Future<void> signOut() async {
    await _auth.signOut();
  }
}
