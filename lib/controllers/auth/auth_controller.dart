import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:trailmate/services/auth_services.dart';

class AuthController extends GetxController {
  static AuthController get instance => Get.find();

  final AuthServices _authServices = AuthServices();

  final Rxn<User> currentUser = Rxn<User>();
  final RxBool isLoading = false.obs;

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
    try {
      final user = await _authServices.signinWithEmailAndPassword(
        email,
        password,
      );
      currentUser.value = user;
      return user;
    } catch (e) {
      throw _mapError(e);
    } finally {
      isLoading.value = false;
    }
  }

  Future<User?> signUp(String email, String password) async {
    isLoading.value = true;
    try {
      final user = await _authServices.signupWithEmailAndPassword(
        email,
        password,
      );
      currentUser.value = user;
      return user;
    } catch (e) {
      throw _mapError(e);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> signOut() async {
    isLoading.value = true;
    try {
      await _authServices.signOut();
      currentUser.value = null;
    } catch (e) {
      throw _mapError(e);
    } finally {
      isLoading.value = false;
    }
  }

  Future<UserCredential?> signInWithGoogle() async {
    isLoading.value = true;
    try {
      final credential = await _authServices.signInWithGoogle();
      currentUser.value = credential?.user;
      return credential;
    } catch (e) {
      throw _mapError(e);
    } finally {
      isLoading.value = false;
    }
  }

  String _mapError(Object e) {
    if (e is String) return e;
    if (e is FirebaseAuthException) {
      if (e.message != null && e.message!.trim().isNotEmpty) {
        return e.message!;
      }
      return e.code;
    }

    final raw = e.toString();
    return raw.startsWith('Exception: ')
        ? raw.replaceFirst('Exception: ', '')
        : raw;
  }
}
