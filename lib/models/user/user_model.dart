import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String id;
  final String email;
  final String fullName;
  final String photoUrl;
  final DateTime createdAt;
  final DateTime updatedAt;

  UserModel({
    required this.id,
    required this.email,
    required this.fullName,
    required this.photoUrl,
    required this.createdAt,
    required this.updatedAt,
  });
  // Empty constructor for creating new user with default values
  static UserModel empty() {
    return UserModel(
      id: '',
      email: '',
      fullName: '',
      photoUrl: '',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
  }

  // convert model to map for firestore
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'fullName': fullName,
      'photoUrl': photoUrl,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
    };
  }

  UserModel copyWith({
    String? id,
    String? email,
    String? fullName,
    String? photoUrl,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return UserModel(
      id: id ?? this.id,
      email: email ?? this.email,
      fullName: fullName ?? this.fullName,
      photoUrl: photoUrl ?? this.photoUrl,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  // Conver map from firestore to model
  factory UserModel.fromSnapshot(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
  ) {
    if (snapshot.data() != null) {
      final data = snapshot.data()!;
      return UserModel(
        id: data['id'] as String,
        email: data['email'] as String,
        fullName: data['fullName'] ?? '',
        photoUrl: data['photoUrl'] ?? '',
        createdAt: (data['createdAt'] as Timestamp).toDate(),
        updatedAt: (data['updatedAt'] as Timestamp).toDate(),
      );
    }

    return UserModel.empty();
  }
}
