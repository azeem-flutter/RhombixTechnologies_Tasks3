import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:trailmate/controllers/trip/trip_controller.dart';

class AddPhotoSection extends StatelessWidget {
  AddPhotoSection({super.key});

  final TripController controller = TripController.instance;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: controller.pickImage,
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
            child: Obx(() {
              final image = controller.selectedImage.value;
              if (image == null) {
                return Center(
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
                );
              }

              return Stack(
                fit: StackFit.expand,
                children: [Image.file(File(image.path), fit: BoxFit.cover)],
              );
            }),
          ),
        ),
      ),
    );
  }
}
