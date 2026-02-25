import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:trailmate/routes/app_routes.dart';

class AuthServices {
  //private constructor
  AuthServices._internal();
  // use singleton design pattern to ensure only one instance of AuthServices exists
  static final AuthServices _instance = AuthServices._internal();
  // factory constructor to return the same instance every time
  factory AuthServices() => _instance;
  //create Firebase Auth instance private to this class
  final FirebaseAuth _auth = FirebaseAuth.instance;
  // get current user from calling this
  User? get currentUser => _auth.currentUser;

  // Signin with email and password
  Future<User?> signinWithEmailAndPassword(
    String email,
    String password,
  ) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      throw _handleAuthError(e);
    }
  }

  //Singup with email and password
  Future<User?> signupWithEmailAndPassword(
    String email,
    String password,
  ) async {
    try {
      UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);
      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      throw _handleAuthError(e);
    }
  }

  // SignOut
  Future<void> signOut() async {
    await _auth.signOut();
    Get.offAllNamed(AppRoutes.login);
  }

  Future<UserCredential?> signInWithGoogle() async {
    try {
      final googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) return null;

      final googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      return await _auth.signInWithCredential(credential);
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'account-exists-with-different-credential':
          throw 'This email already exists. Please sign in with password and link Google.';
        case 'invalid-credential':
          throw 'Google credential is invalid. Check Firebase Google Sign-In setup and SHA keys.';
        case 'operation-not-allowed':
          throw 'Google Sign-In is not enabled in Firebase Authentication.';
        case 'network-request-failed':
          throw 'Network error during Google sign-in. Please check your connection.';
        case 'popup-closed-by-user':
          throw 'Google sign-in was cancelled.';
        default:
          throw 'Google sign-in failed: ${e.message ?? e.code}';
      }
    } catch (e) {
      final raw = e.toString();
      final cleaned = raw.startsWith('Exception: ')
          ? raw.replaceFirst('Exception: ', '')
          : raw;
      throw 'Google sign-in failed: $cleaned';
    }
  }

  //Handle Auth Errors
  String _handleAuthError(FirebaseAuthException e) {
    switch (e.code) {
      case 'invalid-email':
        return 'The email address is not valid.';
      case 'user-disabled':
        return 'This user has been disabled.';
      case 'user-not-found':
        return 'No user found with this email.';
      case 'wrong-password':
        return 'Incorrect password. Please try again.';
      default:
        return 'An unexpected error occurred. Please try again later.';
    }
  }
}
