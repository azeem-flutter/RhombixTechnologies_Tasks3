import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:trailmate/models/Trip/trip_models.dart';

class TripServices {
  TripServices._internal();
  static final TripServices _instance = TripServices._internal();
  factory TripServices() => _instance;

  CollectionReference<Map<String, dynamic>> get _tripCollection =>
      FirebaseFirestore.instance.collection('trips');

  // Create a new trip in Firestore
  Future<void> creatTrip(TripModels trip) async {
    try {
      await _tripCollection.doc(trip.id).set(trip.toJson());
    } catch (e) {
      throw Exception('Failed to create trip');
    }
  }

  // Get Grouped Trips by ownerId
  Stream<List<TripModels>> getTripsByOwner(String ownerId) {
    try {
      return _tripCollection
          .where('ownerId', isEqualTo: ownerId)
          .snapshots()
          .map(
            (snapshot) => snapshot.docs
                .map((doc) => TripModels.fromSnapshot(doc))
                .toList(),
          );
    } catch (e) {
      throw Exception('Failed to get trips by owner');
    }
  }

  // Get a single trip by its Id
  Future<TripModels> getTripById(String tripId) async {
    try {
      final snapshot = await _tripCollection.doc(tripId).get();
      if (!snapshot.exists) {
        throw Exception('Trip not found');
      }
      return TripModels.fromSnapshot(snapshot);
    } catch (e) {
      throw Exception('Failed to get trip by ID: $e');
    }
  }

  // update trip details (owner only)
  Future<void> updateTrip(String userId, TripModels trip) async {
    try {
      final snapshot = await _tripCollection.doc(trip.id).get();
      if (!snapshot.exists) {
        throw Exception('Trip not found');
      }

      final data = snapshot.data();
      if (data == null || data['ownerId'] != userId) {
        throw Exception('Unauthorized to update this trip');
      }

      await _tripCollection.doc(trip.id).update(trip.toJson());
    } catch (e) {
      throw Exception('Failed to update trip: $e');
    }
  }

  // Delete a trip by its Id (owner only)
  Future<void> deleteTrip(String userId, String tripId) async {
    try {
      final snapshot = await _tripCollection.doc(tripId).get();
      if (!snapshot.exists) {
        throw Exception('Trip not found');
      }

      final data = snapshot.data();
      if (data == null || data['ownerId'] != userId) {
        throw Exception('Unauthorized to delete this trip');
      }

      await _tripCollection.doc(tripId).delete();
    } catch (e) {
      throw Exception('Failed to delete trip: $e');
    }
  }
}
