import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:trailmate/controllers/trip/trip_controller.dart';
import 'package:trailmate/views/trip/widgets/add_photo_section.dart';

class TripCreateForm extends StatelessWidget {
  TripCreateForm({super.key});

  final TripController controller = Get.isRegistered<TripController>()
      ? Get.find<TripController>()
      : Get.put(TripController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.arrow_back_ios_new_outlined),
                    ),
                    Text(
                      'Plan new Trip',
                      style: Theme.of(
                        context,
                      ).textTheme.headlineMedium?.copyWith(color: Colors.black),
                    ),
                  ],
                ),
              ),

              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Add Photo Section
                    AddPhotoSection(),

                    // Trip Name Field
                    const SizedBox(height: 20),
                    Text(
                      'Trip Name',
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        color: const Color.fromARGB(255, 107, 107, 107),
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                    ),
                    const SizedBox(height: 7),
                    TextFormField(
                      controller: controller.tripTitleController,
                      decoration: const InputDecoration(
                        hintText: 'e.g. Summer Camp 2026',
                        prefixIcon: Icon(Icons.edit_outlined),
                      ),
                    ),

                    // Location Field
                    const SizedBox(height: 20),
                    Text(
                      'Location',
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        color: const Color.fromARGB(255, 107, 107, 107),
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                    ),
                    const SizedBox(height: 7),
                    TextFormField(
                      controller: controller.locationController,
                      decoration: const InputDecoration(
                        hintText: 'Enter destination...',
                        prefixIcon: Icon(Icons.location_on_outlined),
                      ),
                    ),

                    // Date Range Pickers
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        // Start Date
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Start Date',
                                style: Theme.of(context).textTheme.labelLarge
                                    ?.copyWith(
                                      color: const Color.fromARGB(
                                        255,
                                        107,
                                        107,
                                        107,
                                      ),
                                      fontWeight: FontWeight.bold,
                                      fontSize: 13,
                                    ),
                              ),
                              const SizedBox(height: 7),
                              TextFormField(
                                controller: controller.startDateController,
                                readOnly: true,
                                onTap: () => controller.pickStartDate(context),
                                decoration: const InputDecoration(
                                  hintText: 'dd/mm/yyyy',
                                  suffixIcon: Icon(
                                    Icons.calendar_today_outlined,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 16),
                        // End Date
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'End Date',
                                style: Theme.of(context).textTheme.labelLarge
                                    ?.copyWith(
                                      color: const Color.fromARGB(
                                        255,
                                        107,
                                        107,
                                        107,
                                      ),
                                      fontWeight: FontWeight.bold,
                                      fontSize: 13,
                                    ),
                              ),
                              const SizedBox(height: 7),
                              TextFormField(
                                controller: controller.endDateController,
                                readOnly: true,
                                onTap: () => controller.pickEndDate(context),
                                decoration: const InputDecoration(
                                  hintText: 'dd/mm/yyyy',
                                  suffixIcon: Icon(
                                    Icons.calendar_today_outlined,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    // Total Members Field (for group trips)
                    const SizedBox(height: 20),
                    Text(
                      'Total Members',
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        color: const Color.fromARGB(255, 107, 107, 107),
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                    ),
                    const SizedBox(height: 7),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton.filled(
                          onPressed: controller.decrementMembers,
                          style: IconButton.styleFrom(
                            backgroundColor: const Color(0xFF1F5A2E),
                            foregroundColor: Colors.white,
                          ),
                          icon: const Icon(Icons.remove),
                        ),
                        Obx(
                          () => Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 24),
                            child: Text(
                              '${controller.totalMembers.value} Members',
                              style: Theme.of(context).textTheme.headlineSmall
                                  ?.copyWith(fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                        IconButton.filled(
                          onPressed: controller.incrementMembers,
                          style: IconButton.styleFrom(
                            backgroundColor: const Color(0xFF1F5A2E),
                            foregroundColor: Colors.white,
                          ),
                          icon: const Icon(Icons.add),
                        ),
                      ],
                    ),

                    // Trip Type Selection
                    const SizedBox(height: 20),
                    Text(
                      'Trip Type',
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        color: const Color.fromARGB(255, 107, 107, 107),
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                    ),
                    const SizedBox(height: 7),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: controller.tripTypes.map((type) {
                        return Obx(() {
                          final isSelected =
                              controller.selectedTripType.value == type;
                          return FilterChip(
                            label: Text(
                              type,
                              style: Theme.of(context).textTheme.bodyMedium
                                  ?.copyWith(
                                    color: isSelected
                                        ? Colors.white
                                        : Colors.black87,
                                  ),
                            ),
                            selected: isSelected,
                            onSelected: (selected) {
                              controller.selectedTripType.value = type;
                            },
                            backgroundColor: Colors.white,
                            selectedColor: const Color(0xFF1F5A2E),
                            labelStyle: TextStyle(
                              color: isSelected ? Colors.white : Colors.black87,
                              fontWeight: isSelected
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                            ),
                            side: BorderSide(
                              color: isSelected
                                  ? const Color(0xFF1F5A2E)
                                  : Colors.grey[300]!,
                            ),
                            showCheckmark: false,
                          );
                        });
                      }).toList(),
                    ),

                    // Generate AI Packing List Toggle
                    const SizedBox(height: 20),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey[300]!),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Generate AI Packing List',
                                  style: Theme.of(context).textTheme.bodyLarge
                                      ?.copyWith(fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Automatically based on destination weather.',
                                  style: Theme.of(context).textTheme.bodySmall
                                      ?.copyWith(color: Colors.grey[600]),
                                ),
                              ],
                            ),
                          ),
                          Obx(
                            () => Switch(
                              value: controller.aiPackingEnabled.value,
                              onChanged: (value) {
                                controller.aiPackingEnabled.value = value;
                              },
                              activeThumbColor: const Color(0xFF1F5A2E),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 30),

                    SizedBox(
                      width: double.infinity,
                      child: Obx(
                        () => ElevatedButton(
                          onPressed: controller.isSaving.value
                              ? null
                              : controller.createTrip,
                          child: controller.isSaving.value
                              ? const SizedBox(
                                  width: 22,
                                  height: 22,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
                                  ),
                                )
                              : const Text('Create Trip'),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
