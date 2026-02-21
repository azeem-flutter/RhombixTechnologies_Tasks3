import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:trailmate/models/user/user_model.dart';

class UserServices {
  UserServices._internal();

  static final UserServices _instance = UserServices._internal();
  factory UserServices() => _instance;

  final FirebaseFirestore _db = FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> get _users =>
      _db.collection('users');

  // ================= CREATE =================

  Future<void> createUser(UserModel user) async {
    try {
      await _users.doc(user.id).set(user.toJson());
    } catch (e) {
      throw Exception("Failed to create user: $e");
    }
  }

  // ================= READ (single) =================

  Future<UserModel> getUser(String id) async {
    try {
      final snapshot = await _users.doc(id).get();

      if (!snapshot.exists) {
        return UserModel.empty();
      }

      return UserModel.fromSnapshot(snapshot);
    } catch (e) {
      throw Exception("Failed to fetch user: $e");
    }
  }

  // ================= STREAM (Realtime User) =================

  Stream<UserModel> streamUser(String id) {
    return _users.doc(id).snapshots().map((snapshot) {
      if (!snapshot.exists) return UserModel.empty();
      return UserModel.fromSnapshot(snapshot);
    });
  }

  // ================= UPDATE =================

  Future<void> updateUser(UserModel user) async {
    try {
      await _users
          .doc(user.id)
          .update(user.copyWith(updatedAt: DateTime.now()).toJson());
    } catch (e) {
      throw Exception("Failed to update user: $e");
    }
  }

  // ================= DELETE =================

  Future<void> deleteUser(String id) async {
    try {
      await _users.doc(id).delete();
    } catch (e) {
      throw Exception("Failed to delete user: $e");
    }
  }

  // ================= CHECK EXIST =================

  Future<bool> userExists(String id) async {
    final doc = await _users.doc(id).get();
    return doc.exists;
  }
}
