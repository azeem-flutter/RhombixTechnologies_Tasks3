import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:trailmate/controllers/auth/auth_controller.dart';
import 'package:trailmate/models/user/user_model.dart';
import 'package:trailmate/routes/app_routes.dart';
import 'package:trailmate/services/user_services.dart';

class LoginController extends GetxController {
  static LoginController get instance => Get.find();

  final AuthController _authController = AuthController.instance;
  final UserServices _userServices = UserServices();

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final RxString errorMessage = ''.obs;

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }

  Future<void> signIn() async {
    final email = emailController.text.trim();
    final password = passwordController.text;

    if (email.isEmpty || password.isEmpty) {
      _showError('Please enter email and password.');
      return;
    }

    clearError();

    try {
      final user = await _authController.signIn(email, password);
      if (user != null) {
        Get.offAllNamed(AppRoutes.navigation);
      }
    } catch (e) {
      _showError(_normalizeError(e));
    }
  }

  Future<void> signInWithGoogle() async {
    clearError();

    UserCredential? credential;
    try {
      credential = await _authController.signInWithGoogle();
    } catch (e) {
      _showError(_normalizeError(e));
      return;
    }

    if (credential == null) {
      _showError('Google sign-in was cancelled.');
      return;
    }

    final firebaseUser = credential.user;
    if (firebaseUser == null) {
      _showError('Unable to complete Google sign-in. Please try again.');
      return;
    }

    if (credential.additionalUserInfo?.isNewUser ?? false) {
      final now = DateTime.now();
      final profile = UserModel(
        id: firebaseUser.uid,
        email: firebaseUser.email ?? '',
        fullName: firebaseUser.displayName ?? 'TrailMate Explorer',
        photoUrl: firebaseUser.photoURL ?? '',
        createdAt: now,
        updatedAt: now,
      );
      try {
        await _userServices.createUser(profile);
      } catch (_) {
        _showError('Failed to save user profile. Please try again.');
        return;
      }
    }

    Get.offAllNamed(AppRoutes.navigation);
  }

  void clearError() {
    errorMessage.value = '';
  }

  void _showError(String message) {
    errorMessage.value = message;
    Get.snackbar(
      'Login Error',
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.red.shade700,
      colorText: Colors.white,
      margin: const EdgeInsets.all(12),
      duration: const Duration(seconds: 3),
    );
  }

  String _normalizeError(Object error) {
    final raw = error.toString();
    return raw.startsWith('Exception: ')
        ? raw.replaceFirst('Exception: ', '')
        : raw;
  }
}
