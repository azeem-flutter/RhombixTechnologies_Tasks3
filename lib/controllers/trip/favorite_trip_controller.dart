import 'package:get/get.dart';
import 'package:trailmate/models/Trip/trip_models.dart';

class FavoriteTripController extends GetxController {
  final RxList<TripModels> favoriteTrips = <TripModels>[].obs;

  bool isFavorite(String tripId) {
    return favoriteTrips.any((trip) => trip.id == tripId);
  }

  void toggleFavorite(TripModels trip) {
    final index = favoriteTrips.indexWhere((item) => item.id == trip.id);
    if (index >= 0) {
      favoriteTrips.removeAt(index);
      return;
    }
    favoriteTrips.add(trip);
  }
}
