import 'package:flutter/material.dart';
import 'package:trailmate/models/location_data.dart';
import 'package:trailmate/views/map/location_picker_screen.dart';
import 'package:trailmate/views/trip/widgets/add_photo_section.dart';

class TripCreateForm extends StatefulWidget {
  const TripCreateForm({super.key});

  @override
  State<TripCreateForm> createState() => _TripCreateFormState();
}

class _TripCreateFormState extends State<TripCreateForm> {
  final TextEditingController _tripNameController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _startDateController = TextEditingController();
  final TextEditingController _endDateController = TextEditingController();
  LocationData? _selectedLocation;
  DateTime? _startDate;
  DateTime? _endDate;

  // Trip type selection
  String _selectedTripType = 'Camping';
  final List<String> _tripTypes = [
    'Hiking',
    'Camping',
    'Fishing',
    'Climbing',
    'Biking',
  ];

  // Generate AI packing list toggle
  bool _generatePackingList = true;

  // for group trips - total members
  int _totalMembers = 1;

  @override
  void initState() {
    super.initState();
    // Initialize default text for date fields
    _startDateController.text = '';
    _endDateController.text = '';
    _totalMembers = 1; // Default to 1 member for solo trips
  }

  @override
  void dispose() {
    _tripNameController.dispose();
    _locationController.dispose();
    _startDateController.dispose();
    _endDateController.dispose();
    super.dispose();
  }

  /// Opens location picker screen and handles result
  Future<void> _openLocationPicker() async {
    final result = await Navigator.push<LocationData>(
      context,
      MaterialPageRoute(builder: (context) => const LocationPickerScreen()),
    );

    if (result != null && mounted) {
      setState(() {
        _selectedLocation = result;
        _locationController.text = result.address;
      });
    }
  }

  // Start Date Picker
  void _pickStartDate() {
    final now = DateTime.now();
    showDatePicker(
      context: context,
      initialDate: _startDate ?? now,
      firstDate: now,
      lastDate: DateTime(2100),
    ).then((pickerDate) {
      if (pickerDate != null && mounted) {
        setState(() {
          _startDate = pickerDate;
          _startDateController.text =
              '${pickerDate.day.toString()}/${pickerDate.month.toString().padLeft(2, '0')}/${pickerDate.year}';
        });
      }
    });
  }

  // End Date Picker
  void _pickEndDate() {
    final now = DateTime.now();
    final startDate = _startDate ?? now;
    showDatePicker(
      context: context,
      initialDate: _endDate ?? startDate,
      firstDate: startDate,
      lastDate: DateTime(2100),
    ).then((pickerDate) {
      if (pickerDate != null && mounted) {
        setState(() {
          _endDate = pickerDate;
          _endDateController.text =
              '${pickerDate.day.toString()}/${pickerDate.month.toString().padLeft(2, '0')}/${pickerDate.year}';
        });
      }
    });
  }

  // Total Members Increment
  void _incrementMembers() {
    setState(() {
      _totalMembers++;
    });
  }

  // Total Members Decrement
  void _decrementMembers() {
    if (_totalMembers > 1) {
      setState(() {
        _totalMembers--;
      });
    }
  }

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
                    const AddPhotoSection(),

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
                      controller: _tripNameController,
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
                      controller: _locationController,
                      readOnly: true,
                      onTap: _openLocationPicker,
                      decoration: const InputDecoration(
                        hintText: 'Search destination...',
                        prefixIcon: Icon(Icons.search),
                        suffixIcon: Icon(Icons.arrow_forward_ios, size: 16),
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
                                controller: _startDateController,
                                readOnly: true,
                                onTap: _pickStartDate,
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
                                controller: _endDateController,
                                readOnly: true,
                                onTap: _pickEndDate,
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
                          onPressed: _decrementMembers,
                          style: IconButton.styleFrom(
                            backgroundColor: const Color(0xFF1F5A2E),
                            foregroundColor: Colors.white,
                          ),
                          icon: const Icon(Icons.remove),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 24),
                          child: Text(
                            '$_totalMembers Members',
                            style: Theme.of(context).textTheme.headlineSmall
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ),
                        ),
                        IconButton.filled(
                          onPressed: _incrementMembers,
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
                      children: _tripTypes.map((type) {
                        final isSelected = _selectedTripType == type;
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
                            setState(() {
                              _selectedTripType = type;
                            });
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
                          Switch(
                            value: _generatePackingList,
                            onChanged: (value) {
                              setState(() {
                                _generatePackingList = value;
                              });
                            },
                            activeThumbColor: const Color(0xFF1F5A2E),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 30),

                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          // Handle trip creation logic here
                        },
                        child: const Text('Create Trip'),
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
