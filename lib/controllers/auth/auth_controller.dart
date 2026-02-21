import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:trailmate/services/auth_services.dart';

class AuthController extends GetxController {
  static AuthController get instance => Get.find();

  final AuthServices _authServices = AuthServices();

  final Rxn<User> currentUser = Rxn<User>();
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;

  StreamSubscription<User?>? _authSub;

  @override
  void onInit() {
    super.onInit();
    currentUser.value = _authServices.currentUser;
    _authSub = FirebaseAuth.instance.authStateChanges().listen((user) {
      currentUser.value = user;
    });
  }

  @override
  void onClose() {
    _authSub?.cancel();
    super.onClose();
  }

  Future<User?> signIn(String email, String password) async {
    isLoading.value = true;
    errorMessage.value = '';
    try {
      final user = await _authServices.signinWithEmailAndPassword(
        email,
        password,
      );
      currentUser.value = user;
      return user;
    } catch (e) {
      errorMessage.value = _mapError(e);
      return null;
    } finally {
      isLoading.value = false;
    }
  }

  Future<User?> signUp(String email, String password) async {
    isLoading.value = true;
    errorMessage.value = '';
    try {
      final user = await _authServices.signupWithEmailAndPassword(
        email,
        password,
      );
      currentUser.value = user;
      return user;
    } catch (e) {
      errorMessage.value = _mapError(e);
      return null;
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> signOut() async {
    isLoading.value = true;
    errorMessage.value = '';
    try {
      await _authServices.signOut();
      currentUser.value = null;
    } catch (e) {
      errorMessage.value = _mapError(e);
    } finally {
      isLoading.value = false;
    }
  }

  Future<UserCredential?> signInWithGoogle() async {
    isLoading.value = true;
    errorMessage.value = '';
    try {
      final credential = await _authServices.signInWithGoogle();
      currentUser.value = credential?.user;
      return credential;
    } catch (e) {
      errorMessage.value = _mapError(e);
      return null;
    } finally {
      isLoading.value = false;
    }
  }

  void clearError() {
    errorMessage.value = '';
  }

  String _mapError(Object e) {
    if (e is String) return e;
    return 'An unexpected error occurred. Please try again later.';
  }
}
