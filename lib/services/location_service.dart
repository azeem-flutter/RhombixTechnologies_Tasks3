import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:trailmate/models/location_data.dart';

/// Service class for handling location-related operations
/// including permissions, current location, and reverse geocoding
class LocationService {
  /// Checks if location permissions are granted
  Future<bool> hasLocationPermission() async {
    try {
      final status = await Permission.location.status;
      return status.isGranted;
    } catch (e) {
      debugPrint('Error checking location permission: $e');
      return false;
    }
  }

  /// Requests location permission from user
  /// Returns true if granted, false otherwise
  Future<bool> requestLocationPermission() async {
    try {
      final status = await Permission.location.request();
      return status.isGranted;
    } catch (e) {
      debugPrint('Error requesting location permission: $e');
      return false;
    }
  }

  /// Gets the current position of the user
  /// Throws exception if location services are disabled or permission denied
  Future<Position> getCurrentPosition() async {
    try {
      // Check if location services are enabled
      final serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        throw LocationServiceException('Location services are disabled');
      }

      // Check permissions
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          throw LocationServiceException('Location permissions are denied');
        }
      }

      if (permission == LocationPermission.deniedForever) {
        throw LocationServiceException(
          'Location permissions are permanently denied',
        );
      }

      // Get current position with timeout
      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
        timeLimit: const Duration(seconds: 10),
      );

      return position;
    } on LocationServiceException {
      rethrow;
    } catch (e) {
      debugPrint('Error getting current position: $e');
      throw LocationServiceException('Failed to get current location: $e');
    }
  }

  /// Converts latitude and longitude to a human-readable address
  /// Returns address string or null if geocoding fails
  Future<String?> getAddressFromCoordinates({
    required double latitude,
    required double longitude,
  }) async {
    try {
      final placemarks = await placemarkFromCoordinates(
        latitude,
        longitude,
        localeIdentifier: 'en',
      );

      if (placemarks.isEmpty) {
        return null;
      }

      final placemark = placemarks.first;
      
      // Build comprehensive address string
      final addressComponents = <String>[];

      if (placemark.street != null && placemark.street!.isNotEmpty) {
        addressComponents.add(placemark.street!);
      }
      if (placemark.subLocality != null && placemark.subLocality!.isNotEmpty) {
        addressComponents.add(placemark.subLocality!);
      }
      if (placemark.locality != null && placemark.locality!.isNotEmpty) {
        addressComponents.add(placemark.locality!);
      }
      if (placemark.administrativeArea != null && 
          placemark.administrativeArea!.isNotEmpty) {
        addressComponents.add(placemark.administrativeArea!);
      }
      if (placemark.country != null && placemark.country!.isNotEmpty) {
        addressComponents.add(placemark.country!);
      }

      return addressComponents.isNotEmpty
          ? addressComponents.join(', ')
          : 'Unknown location';
    } catch (e) {
      debugPrint('Error in reverse geocoding: $e');
      return null;
    }
  }

  /// Gets LocationData object from coordinates
  /// Includes address, latitude, and longitude
  Future<LocationData> getLocationData({
    required double latitude,
    required double longitude,
  }) async {
    final address = await getAddressFromCoordinates(
      latitude: latitude,
      longitude: longitude,
    );

    return LocationData(
      address: address ?? 'Unknown location',
      latitude: latitude,
      longitude: longitude,
    );
  }

  /// Gets current location as LocationData
  Future<LocationData> getCurrentLocationData() async {
    final position = await getCurrentPosition();
    return getLocationData(
      latitude: position.latitude,
      longitude: position.longitude,
    );
  }

  /// Opens app settings page for user to manually enable permissions
  Future<bool> openAppSettings() async {
    try {
      return await Geolocator.openAppSettings();
    } catch (e) {
      debugPrint('Error opening app settings: $e');
      return false;
    }
  }

  /// Checks if location service is enabled
  Future<bool> isLocationServiceEnabled() async {
    try {
      return await Geolocator.isLocationServiceEnabled();
    } catch (e) {
      debugPrint('Error checking location service: $e');
      return false;
    }
  }
}

/// Custom exception for location service errors
class LocationServiceException implements Exception {
  final String message;
  
  LocationServiceException(this.message);

  @override
  String toString() => message;
}
