import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AddPhotoSection extends StatefulWidget {
  const AddPhotoSection({super.key});

  @override
  State<AddPhotoSection> createState() => _AddPhotoSectionState();
}

class _AddPhotoSectionState extends State<AddPhotoSection> {
  File? _selectedImage;
  final ImagePicker _imagePicker = ImagePicker();

  /// Picks an image from the device gallery with error handling
  Future<void> _pickImage() async {
    try {
      // Request gallery access before picking
      final XFile? pickedFile = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 85, // Compress to 85% quality
        requestFullMetadata: false, // Performance optimization
      );

      if (pickedFile == null) {
        // User cancelled - handle gracefully
        debugPrint('Image selection cancelled by user');
        return;
      }

      // Validate file exists before processing
      final file = File(pickedFile.path);
      if (!await file.exists()) {
        if (mounted) {
          _showError('Selected file no longer exists');
        }
        return;
      }

      // Update state with image
      if (mounted) {
        setState(() {
          _selectedImage = file;
        });
        debugPrint('Image selected: ${file.path}');
      }
    } on FileSystemException catch (e) {
      // Handle file system errors
      if (mounted) {
        _showError('File error: ${e.message}');
      }
      debugPrint('File system error: $e');
    } catch (e) {
      // Handle unexpected errors
      if (mounted) {
        _showError('Failed to pick image');
      }
      debugPrint('Unexpected error: $e');
    }
  }

  /// Shows error message to user
  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _pickImage,
      child: DottedBorder(
        borderType: BorderType.RRect,
        radius: const Radius.circular(12),
        color: Colors.grey[400]!,
        strokeWidth: 2,
        dashPattern: const [5, 3],
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Container(
            height: 200,
            width: double.infinity,
            color: Colors.grey[100],
            child: _selectedImage == null
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.photo_camera_outlined,
                          size: 48,
                          color: Colors.grey[600],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Add Cover Photo',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  )
                : Stack(
                    fit: StackFit.expand,
                    children: [Image.file(_selectedImage!, fit: BoxFit.cover)],
                  ),
          ),
        ),
      ),
    );
  }
}
