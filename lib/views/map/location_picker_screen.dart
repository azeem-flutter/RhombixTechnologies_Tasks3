import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:trailmate/models/location_data.dart';
import 'package:trailmate/services/location_service.dart';

/// Location picker screen with Google Maps integration
/// Allows user to select a location by tapping on the map
class LocationPickerScreen extends StatefulWidget {
  const LocationPickerScreen({super.key});

  @override
  State<LocationPickerScreen> createState() => _LocationPickerScreenState();
}

class _LocationPickerScreenState extends State<LocationPickerScreen> {
  final LocationService _locationService = LocationService();
  final Completer<GoogleMapController> _mapController = Completer();

  LatLng? _selectedLocation;
  String _selectedAddress = 'Tap on map to select location';
  bool _isLoading = false;
  bool _isFetchingAddress = false;
  Set<Marker> _markers = {};

  // Default camera position (will be updated to user's location)
  CameraPosition _initialPosition = const CameraPosition(
    target: LatLng(37.7749, -122.4194), // San Francisco
    zoom: 14.0,
  );

  @override
  void initState() {
    super.initState();
    _initializeLocation();
  }

  /// Initialize by getting user's current location
  Future<void> _initializeLocation() async {
    setState(() => _isLoading = true);

    try {
      // Request location permission
      final hasPermission = await _locationService.hasLocationPermission();

      if (!hasPermission) {
        final granted = await _locationService.requestLocationPermission();
        if (!granted) {
          if (mounted) {
            _showPermissionDialog();
          }
          // Set default location and continue (don't crash)
          setState(() => _isLoading = false);
          return;
        }
      }

      // Get current location
      try {
        final position = await _locationService.getCurrentPosition();
        final latLng = LatLng(position.latitude, position.longitude);

        // Update camera position
        _initialPosition = CameraPosition(target: latLng, zoom: 14.0);

        // Move camera to current location
        if (mounted) {
          final controller = await _mapController.future;
          await controller.animateCamera(
            CameraUpdate.newCameraPosition(_initialPosition),
          );

          // Set selected location to current location
          await _selectLocation(latLng);
        }
      } catch (e) {
        // If location fails, just show default map with fallback location
        debugPrint('Error getting position: $e');
        if (mounted) {
          _showErrorSnackBar(
            'Using default location. Tap to select a location.',
          );
        }
      }
    } catch (e) {
      if (mounted) {
        _showErrorSnackBar('Failed to initialize map');
      }
      debugPrint('Error initializing location: $e');
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  /// Handle map tap to select location
  Future<void> _onMapTapped(LatLng location) async {
    await _selectLocation(location);
  }

  /// Select a location and get its address
  Future<void> _selectLocation(LatLng location) async {
    setState(() {
      _selectedLocation = location;
      _isFetchingAddress = true;
      _markers = {
        Marker(
          markerId: const MarkerId('selected_location'),
          position: location,
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
        ),
      };
    });

    try {
      final address = await _locationService.getAddressFromCoordinates(
        latitude: location.latitude,
        longitude: location.longitude,
      );

      if (mounted) {
        setState(() {
          _selectedAddress = address ?? 'Unknown location';
          _isFetchingAddress = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _selectedAddress = 'Unable to fetch address';
          _isFetchingAddress = false;
        });
      }
      debugPrint('Error fetching address: $e');
    }
  }

  /// Confirm location selection and return to previous screen
  void _confirmLocation() {
    if (_selectedLocation == null) {
      _showErrorSnackBar('Please select a location on the map');
      return;
    }

    final locationData = LocationData(
      address: _selectedAddress,
      latitude: _selectedLocation!.latitude,
      longitude: _selectedLocation!.longitude,
    );

    Navigator.pop(context, locationData);
  }

  /// Show permission denied dialog
  void _showPermissionDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Location Permission Required'),
        content: const Text(
          'This app needs location permission to show your current location on the map. '
          'Please grant permission in app settings.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              await _locationService.openAppSettings();
            },
            child: const Text('Open Settings'),
          ),
        ],
      ),
    );
  }

  /// Show error snackbar
  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  /// Get current location button handler
  Future<void> _goToCurrentLocation() async {
    setState(() => _isLoading = true);

    try {
      final position = await _locationService.getCurrentPosition();
      final latLng = LatLng(position.latitude, position.longitude);

      final controller = await _mapController.future;
      await controller.animateCamera(CameraUpdate.newLatLngZoom(latLng, 14.0));

      await _selectLocation(latLng);
    } on LocationServiceException catch (e) {
      _showErrorSnackBar(e.message);
    } catch (e) {
      _showErrorSnackBar('Failed to get current location');
      debugPrint('Error getting current location: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Location'),
        elevation: 0,
        actions: [
          if (!_isLoading && _selectedLocation != null)
            TextButton.icon(
              onPressed: _confirmLocation,
              icon: const Icon(Icons.check, color: Colors.white),
              label: const Text(
                'Confirm',
                style: TextStyle(color: Colors.white),
              ),
            ),
        ],
      ),
      body: Stack(
        children: [
          // Google Map - Full screen background
          Container(
            color: Colors.grey[300],
            child: GoogleMap(
              initialCameraPosition: _initialPosition,
              liteModeEnabled: false,
              onMapCreated: (controller) {
                debugPrint('GoogleMap initialized');
                if (!_mapController.isCompleted) {
                  _mapController.complete(controller);
                }
              },
              onTap: _onMapTapped,
              markers: _markers,
              myLocationEnabled: true,
              myLocationButtonEnabled: false,
              zoomControlsEnabled: false,
              mapToolbarEnabled: false,
              compassEnabled: true,
            ),
          ),

          // Address display card
          Positioned(
            top: 16,
            left: 16,
            right: 16,
            child: Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.location_on,
                          color: Colors.red,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        const Text(
                          'Selected Location',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                        const Spacer(),
                        if (_isFetchingAddress)
                          const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _selectedAddress,
                      style: TextStyle(fontSize: 13, color: Colors.grey[700]),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Current location button
          Positioned(
            bottom: 100,
            right: 16,
            child: FloatingActionButton(
              heroTag: 'current_location',
              onPressed: _goToCurrentLocation,
              backgroundColor: Colors.white,
              child: const Icon(Icons.my_location, color: Colors.blue),
            ),
          ),

          // Confirm button at bottom
          if (!_isLoading && _selectedLocation != null)
            Positioned(
              bottom: 16,
              left: 16,
              right: 16,
              child: ElevatedButton(
                onPressed: _confirmLocation,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 4,
                ),
                child: const Text(
                  'Confirm Location',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),

          // Loading overlay
          if (_isLoading)
            Container(
              color: Colors.black26,
              child: const Center(
                child: Card(
                  child: Padding(
                    padding: EdgeInsets.all(24.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CircularProgressIndicator(),
                        SizedBox(height: 16),
                        Text(
                          'Getting your location...',
                          style: TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
