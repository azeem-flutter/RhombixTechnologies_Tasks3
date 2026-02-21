import 'package:flutter/material.dart';
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
      _authController.errorMessage.value = 'Please enter email and password.';
      return;
    }

    _authController.clearError();

    final user = await _authController.signIn(email, password);
    if (user != null) {
      Get.offAllNamed(AppRoutes.navigation);
    }
  }

  Future<void> signInWithGoogle() async {
    _authController.clearError();
    final credential = await _authController.signInWithGoogle();
    if (credential == null) return;

    final firebaseUser = credential.user;
    if (firebaseUser == null) return;

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
        _authController.errorMessage.value =
            'Failed to save user profile. Please try again.';
        return;
      }
    }

    Get.offAllNamed(AppRoutes.navigation);
  }

  void clearError() {
    _authController.clearError();
  }
}
