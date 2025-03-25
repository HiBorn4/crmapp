// File: services/auth_service.dart
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class AuthService extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  
  // Observable user state
  Rx<User?> currentUser = Rx<User?>(null);
  
  // Authentication state
  RxBool isLoading = false.obs;
  RxString errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    // Set up auth state listener
    currentUser.value = _auth.currentUser;
    _auth.authStateChanges().listen((User? user) {
      currentUser.value = user;
    });
  }

  // Sign up with email and password
  Future<User?> signUp(String email, String password) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password
      );
      
      // Send email verification
      await userCredential.user?.sendEmailVerification();
      
      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      _handleAuthException(e);
      return null;
    } catch (e) {
      errorMessage.value = 'An unexpected error occurred';
      return null;
    } finally {
      isLoading.value = false;
    }
  }

  // Sign in with email and password
  Future<User?> signIn(String email, String password) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password
      );
      
      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      _handleAuthException(e);
      return null;
    } catch (e) {
      errorMessage.value = 'An unexpected error occurred';
      return null;
    } finally {
      isLoading.value = false;
    }
  }

  // Sign out
  Future<void> signOut() async {
    try {
      await _auth.signOut();
    } catch (e) {
      errorMessage.value = 'Error signing out';
    }
  }

  // Check if email is verified
  bool isEmailVerified() {
    return _auth.currentUser?.emailVerified ?? false;
  }

  // Reload user to check for email verification
  Future<void> reloadUser() async {
    try {
      await _auth.currentUser?.reload();
      currentUser.value = _auth.currentUser;
    } catch (e) {
      errorMessage.value = 'Error refreshing user state';
    }
  }

  // Send OTP (verification email)
  Future<bool> sendOTP() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      
      await _auth.currentUser?.sendEmailVerification();
      return true;
    } catch (e) {
      errorMessage.value = 'Error sending verification email';
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  // Get current user's email
  String? getCurrentUserEmail() {
    return _auth.currentUser?.email;
  }

  // Handle Firebase Auth exceptions
  void _handleAuthException(FirebaseAuthException e) {
    switch (e.code) {
      case 'email-already-in-use':
        errorMessage.value = 'Email is already in use. Please login instead.';
        break;
      case 'invalid-email':
        errorMessage.value = 'Invalid email address.';
        break;
      case 'weak-password':
        errorMessage.value = 'Password is too weak. Please use a stronger password.';
        break;
      case 'user-not-found':
        errorMessage.value = 'No user found with this email. Please sign up.';
        break;
      case 'wrong-password':
        errorMessage.value = 'Incorrect password. Please try again.';
        break;
      case 'user-disabled':
        errorMessage.value = 'This account has been disabled.';
        break;
      case 'too-many-requests':
        errorMessage.value = 'Too many requests. Please try again later.';
        break;
      case 'operation-not-allowed':
        errorMessage.value = 'This operation is not allowed.';
        break;
      case 'network-request-failed':
        errorMessage.value = 'Network error. Please check your connection.';
        break;
      default:
        errorMessage.value = 'An error occurred: ${e.message}';
    }
  }
}