import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

class AuthService extends GetxService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  

  // Reactive user state
  final Rxn<User> currentUser = Rxn<User>();

  // Authentication state
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    // Set up auth state listener
    _auth.authStateChanges().listen((User? user) {
      currentUser.value = user;
    });
  }

  // Get current user (non-reactive)
  User? get user => _auth.currentUser;

  // Check if user is logged in
  bool get isLoggedIn => user != null;

  // Check if email is verified
  bool get isEmailVerified => user?.emailVerified ?? false;

  Future<void> fetchUserData() async {
  if (user == null) return; // Ensure user is logged in

  try {
    DocumentSnapshot userDoc = await _firestore.collection('users').doc(user!.uid).get();
    
    if (userDoc.exists) {
      if (kDebugMode) {
        print('User Data: ${userDoc.data()}');
      } // Display user data in console
    } else {
      if (kDebugMode) {
        print('User data not found in Firestore.');
      }
    }
  } catch (e) {
    if (kDebugMode) {
      print('Error fetching user data: $e');
    }
  }
}

Future<String?> signInWithEmailAndPassword(String email, String password) async {
  try {
    isLoading(true);
    errorMessage('');

    final UserCredential userCredential = await _auth.signInWithEmailAndPassword(
      email: email.trim(),
      password: password.trim(),
    );

    await fetchUserData(); // Fetch user data after successful login

    return userCredential.user?.uid; // Return the UID
  } on FirebaseAuthException catch (e) {
    _handleAuthException(e);
    return null;
  } catch (e) {
    errorMessage('An unexpected error occurred');
    return null;
  } finally {
    isLoading(false);
  }
}


  // Sign Out
  Future<void> signOut() async {
    try {
      await _auth.signOut();
      currentUser.value = null;
    } catch (e) {
      errorMessage('Error signing out');
      rethrow;
    }
  }

  // Send Password Reset Email
  Future<void> sendPasswordResetEmail(String email) async {
    try {
      isLoading(true);
      errorMessage('');
      await _auth.sendPasswordResetEmail(email: email.trim());
    } on FirebaseAuthException catch (e) {
      _handleAuthException(e);
    } catch (e) {
      errorMessage('An unexpected error occurred');
    } finally {
      isLoading(false);
    }
  }

  // Reload user data (useful after email verification)
  Future<void> reloadUser() async {
    try {
      await user?.reload();
      currentUser.value = _auth.currentUser;
    } catch (e) {
      errorMessage('Error refreshing user data');
      rethrow;
    }
  }

  // Delete user account
  Future<void> deleteAccount() async {
    try {
      await user?.delete();
      currentUser.value = null;
    } catch (e) {
      errorMessage('Error deleting account');
      rethrow;
    }
  }

  // Handle Firebase Auth exceptions
  void _handleAuthException(FirebaseAuthException e) {
    switch (e.code) {
      case 'email-already-in-use':
        errorMessage('This email is already registered');
        break;
      case 'invalid-email':
        errorMessage('Please enter a valid email address');
        break;
      case 'weak-password':
        errorMessage('Password should be at least 6 characters');
        break;
      case 'user-not-found':
        errorMessage('No account found with this email');
        break;
      case 'wrong-password':
        errorMessage('Incorrect password, please try again');
        break;
      case 'user-disabled':
        errorMessage('This account has been disabled');
        break;
      case 'too-many-requests':
        errorMessage('Too many attempts. Try again later');
        break;
      case 'operation-not-allowed':
        errorMessage('Email/password accounts are not enabled');
        break;
      case 'network-request-failed':
        errorMessage('Network error. Check your connection');
        break;
      case 'missing-password':
        errorMessage('Password cannot be empty');
        break;
      default:
        errorMessage(e.message ?? 'Authentication failed');
    }
  }
}
