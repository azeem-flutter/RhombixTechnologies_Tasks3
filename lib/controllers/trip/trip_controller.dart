import 'dart:convert';
import 'dart:collection';

import 'package:crypto/crypto.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:trailmate/controllers/auth/auth_controller.dart';
import 'package:trailmate/core/utils/cloudinary_config.dart';
import 'package:trailmate/models/Trip/trip_models.dart';
import 'package:trailmate/services/trip_services.dart';

class TripController extends GetxController {
  static TripController get instance => Get.find();

  final TripServices _tripServices = TripServices();
  final AuthController _authController = AuthController.instance;
  final ImagePicker _picker = ImagePicker();

  final TextEditingController tripTitleController = TextEditingController();
  final TextEditingController locationController = TextEditingController();
  final TextEditingController startDateController = TextEditingController();
  final TextEditingController endDateController = TextEditingController();

  final Rxn<DateTime> startDate = Rxn<DateTime>();
  final Rxn<DateTime> endDate = Rxn<DateTime>();

  final RxInt totalMembers = 1.obs;
  final RxString selectedTripType = 'Camping'.obs;
  final RxString difficultyLevel = 'Easy'.obs;
  final RxBool aiPackingEnabled = true.obs;
  final RxBool isSaving = false.obs;
  final RxSet<String> deletingTripIds = <String>{}.obs;

  final Rxn<XFile> selectedImage = Rxn<XFile>();

  final List<String> tripTypes = const [
    'Hiking',
    'Camping',
    'Fishing',
    'Climbing',
    'Biking',
  ];

  Stream<List<TripModels>> get userTripsStream {
    final userId = _authController.currentUser.value?.uid;
    if (userId == null) {
      return const Stream<List<TripModels>>.empty();
    }
    return _tripServices.getTripsByOwner(userId);
  }

  Future<void> pickImage() async {
    selectedImage.value = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 85,
      requestFullMetadata: false,
    );
  }

  Future<void> pickStartDate(BuildContext context) async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: startDate.value ?? now,
      firstDate: now,
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      startDate.value = picked;
      startDateController.text =
          '${picked.day}/${picked.month.toString().padLeft(2, '0')}/${picked.year}';
    }
  }

  Future<void> pickEndDate(BuildContext context) async {
    final now = DateTime.now();
    final minDate = startDate.value ?? now;
    final picked = await showDatePicker(
      context: context,
      initialDate: endDate.value ?? minDate,
      firstDate: minDate,
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      endDate.value = picked;
      endDateController.text =
          '${picked.day}/${picked.month.toString().padLeft(2, '0')}/${picked.year}';
    }
  }

  Future<void> createTrip() async {
    final userId = _authController.currentUser.value?.uid;
    if (userId == null) {
      Get.snackbar('Sign in required', 'Please sign in to create a trip.');
      return;
    }

    final title = tripTitleController.text.trim();
    final location = locationController.text.trim();

    if (title.isEmpty || location.isEmpty) {
      Get.snackbar('Missing info', 'Trip name and location are required.');
      return;
    }

    isSaving.value = true;
    try {
      final image = selectedImage.value;
      final uploadResult = image != null
          ? await _uploadImageToCloudinary(image)
          : null;
      final imageUrl = uploadResult?.imageUrl ?? _fallbackImageUrl;

      final tripId = FirebaseFirestore.instance.collection('trips').doc().id;

      final trip = TripModels(
        id: tripId,
        ownerId: userId,
        tripTitle: title,
        imageUrl: imageUrl,
        cloudinaryPublicId: uploadResult?.publicId,
        location: location,
        startDate: startDate.value ?? DateTime.now(),
        endDate: endDate.value ?? (startDate.value ?? DateTime.now()),
        members: totalMembers.value.toString(),
        isDraft: false,
        aiPackingEnabled: aiPackingEnabled.value,
        tripType: selectedTripType.value,
        difficultyLevel: difficultyLevel.value,
      );

      await _tripServices.creatTrip(trip);
      _resetForm();
      Get.snackbar('Trip created', 'Your trip is ready.');
    } catch (e) {
      Get.snackbar('Create failed', e.toString());
    } finally {
      isSaving.value = false;
    }
  }

  Future<void> deleteTrip(TripModels trip) async {
    final userId = _authController.currentUser.value?.uid;
    if (userId == null) {
      Get.snackbar('Sign in required', 'Please sign in to delete a trip.');
      return;
    }

    if (deletingTripIds.contains(trip.id)) {
      return;
    }

    deletingTripIds.add(trip.id);
    try {
      await _deleteImageFromCloudinaryIfNeeded(trip);
      await _tripServices.deleteTrip(userId, trip.id);
      Get.snackbar('Trip deleted', 'The trip was deleted successfully.');
    } catch (e) {
      Get.snackbar('Delete failed', e.toString());
    } finally {
      deletingTripIds.remove(trip.id);
    }
  }

  Future<_CloudinaryUploadResult> _uploadImageToCloudinary(XFile image) async {
    final uri = Uri.parse(
      'https://api.cloudinary.com/v1_1/${CloudinaryConfig.cloudName}/image/upload',
    );

    final request = http.MultipartRequest('POST', uri)
      ..fields['upload_preset'] = CloudinaryConfig.arthubartwork
      ..files.add(await http.MultipartFile.fromPath('file', image.path));

    final response = await request.send();
    final body = await response.stream.bytesToString();
    final data = jsonDecode(body) as Map<String, dynamic>;

    if (response.statusCode != 200) {
      throw Exception(data['error']?['message'] ?? 'Upload failed');
    }

    return _CloudinaryUploadResult(
      imageUrl: data['secure_url'] as String,
      publicId: data['public_id'] as String?,
    );
  }

  Future<void> _deleteImageFromCloudinaryIfNeeded(TripModels trip) async {
    final cloudinaryPublicId =
        trip.cloudinaryPublicId ?? _extractPublicIdFromUrl(trip.imageUrl);

    if (cloudinaryPublicId == null || cloudinaryPublicId.isEmpty) {
      return;
    }

    if (CloudinaryConfig.apiKey.isEmpty || CloudinaryConfig.apiSecret.isEmpty) {
      return;
    }

    final timestamp = (DateTime.now().millisecondsSinceEpoch ~/ 1000)
        .toString();

    final paramsToSign = SplayTreeMap<String, String>.from({
      'invalidate': 'true',
      'public_id': cloudinaryPublicId,
      'timestamp': timestamp,
    });
    final canonicalQuery = paramsToSign.entries
        .map((entry) => '${entry.key}=${entry.value}')
        .join('&');
    final signature = sha1
        .convert(utf8.encode('$canonicalQuery${CloudinaryConfig.apiSecret}'))
        .toString();

    final response = await http.post(
      Uri.parse(
        'https://api.cloudinary.com/v1_1/${CloudinaryConfig.cloudName}/image/destroy',
      ),
      body: {
        ...paramsToSign,
        'api_key': CloudinaryConfig.apiKey,
        'signature': signature,
      },
    );

    if (response.statusCode != 200) {
      var message = 'Failed to delete trip image from Cloudinary.';
      try {
        final payload = jsonDecode(response.body) as Map<String, dynamic>;
        message = payload['error']?['message'] as String? ?? message;
      } catch (_) {}
      throw Exception(message);
    }
  }

  String? _extractPublicIdFromUrl(String imageUrl) {
    if (!imageUrl.contains('res.cloudinary.com')) {
      return null;
    }

    final uploadIndex = imageUrl.indexOf('/upload/');
    if (uploadIndex == -1) {
      return null;
    }

    var pathAfterUpload = imageUrl.substring(uploadIndex + '/upload/'.length);
    final queryIndex = pathAfterUpload.indexOf('?');
    if (queryIndex != -1) {
      pathAfterUpload = pathAfterUpload.substring(0, queryIndex);
    }

    final parts = pathAfterUpload.split('/').where((part) => part.isNotEmpty);
    final filtered = parts
        .where((part) => !RegExp(r'^v\d+$').hasMatch(part))
        .toList();
    if (filtered.isEmpty) {
      return null;
    }

    final lastSegment = filtered.last;
    final dotIndex = lastSegment.lastIndexOf('.');
    if (dotIndex != -1) {
      filtered[filtered.length - 1] = lastSegment.substring(0, dotIndex);
    }

    return filtered.join('/');
  }

  bool isDeletingTrip(String tripId) => deletingTripIds.contains(tripId);

  void incrementMembers() => totalMembers.value++;

  void decrementMembers() {
    if (totalMembers.value > 1) {
      totalMembers.value--;
    }
  }

  void _resetForm() {
    tripTitleController.clear();
    locationController.clear();
    startDateController.clear();
    endDateController.clear();
    startDate.value = null;
    endDate.value = null;
    totalMembers.value = 1;
    selectedTripType.value = 'Camping';
    difficultyLevel.value = 'Easy';
    aiPackingEnabled.value = true;
    selectedImage.value = null;
  }

  @override
  void onClose() {
    tripTitleController.dispose();
    locationController.dispose();
    startDateController.dispose();
    endDateController.dispose();
    super.onClose();
  }
}

const String _fallbackImageUrl =
    'https://images.unsplash.com/photo-1500530855697-b586d89ba3ee?auto=format&fit=crop&w=1200&q=80';

class _CloudinaryUploadResult {
  final String imageUrl;
  final String? publicId;

  const _CloudinaryUploadResult({required this.imageUrl, this.publicId});
}
