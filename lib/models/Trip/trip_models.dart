import 'package:cloud_firestore/cloud_firestore.dart';

class TripModels {
  final String id;
  final String ownerId;
  String tripTitle;
  String imageUrl;
  String? cloudinaryPublicId;
  String location;
  DateTime startDate;
  DateTime endDate;
  String members;
  bool isDraft;
  bool aiPackingEnabled;
  String tripType;
  String difficultyLevel;
  List<String> activities;

  // Constructor
  TripModels({
    required this.id,
    required this.ownerId,
    required this.tripTitle,
    required this.imageUrl,
    this.cloudinaryPublicId,
    required this.location,
    required this.startDate,
    required this.endDate,
    required this.members,
    this.isDraft = false,
    this.aiPackingEnabled = false,
    required this.tripType,
    this.difficultyLevel = 'Easy',
    this.activities = const [],
  });
  // Copy with method for creating a new instance with updated fields
  TripModels copyWith({
    String? id,
    String? ownerId,
    String? tripTitle,
    String? imageUrl,
    String? cloudinaryPublicId,
    String? location,
    DateTime? startDate,
    DateTime? endDate,
    String? members,
    bool? isDraft,
    bool? aiPackingEnabled,
    String? tripType,
    String? difficultyLevel,
    List<String>? activities,
  }) {
    return TripModels(
      id: id ?? this.id,
      ownerId: ownerId ?? this.ownerId,
      tripTitle: tripTitle ?? this.tripTitle,
      imageUrl: imageUrl ?? this.imageUrl,
      cloudinaryPublicId: cloudinaryPublicId ?? this.cloudinaryPublicId,
      location: location ?? this.location,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      members: members ?? this.members,
      isDraft: isDraft ?? this.isDraft,
      aiPackingEnabled: aiPackingEnabled ?? this.aiPackingEnabled,
      tripType: tripType ?? this.tripType,
      difficultyLevel: difficultyLevel ?? this.difficultyLevel,
      activities: activities ?? this.activities,
    );
  }

  // Empty constructor for creating new trip with default values
  static TripModels empty() {
    return TripModels(
      id: '',
      ownerId: '',
      tripTitle: '',
      imageUrl: '',
      cloudinaryPublicId: null,
      location: '',
      startDate: DateTime.now(),
      endDate: DateTime.now(),
      members: '',
      isDraft: false,
      aiPackingEnabled: false,
      tripType: '',
      difficultyLevel: 'Easy',
      activities: const [],
    );
  }

  // Convert model to map for Firestore
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'ownerId': ownerId,
      'tripTitle': tripTitle,
      'imageUrl': imageUrl,
      'cloudinaryPublicId': cloudinaryPublicId,
      'location': location,
      'startDate': Timestamp.fromDate(startDate),
      'endDate': Timestamp.fromDate(endDate),
      'members': members,
      'isDraft': isDraft,
      'aiPackingEnabled': aiPackingEnabled,
      'tripType': tripType,
      'difficultyLevel': difficultyLevel,
      'activities': activities,
    };
  }

  // Create a TripModels instance from Firestore document
  factory TripModels.fromSnapshot(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
  ) {
    final data = snapshot.data()!;
    if (data.isNotEmpty) {
      return TripModels(
        id: data['id'],
        ownerId: data['ownerId'],
        tripTitle: data['tripTitle'],
        imageUrl: data['imageUrl'],
        cloudinaryPublicId: data['cloudinaryPublicId'],
        location: data['location'],
        startDate: (data['startDate'] as Timestamp).toDate(),
        endDate: (data['endDate'] as Timestamp).toDate(),
        members: data['members'],
        isDraft: data['isDraft'],
        aiPackingEnabled: data['aiPackingEnabled'],
        tripType: data['tripType'],
        difficultyLevel: data['difficultyLevel'],
        activities: List<String>.from(data['activities'] ?? const []),
      );
    }
    return TripModels.empty();
  }
}
