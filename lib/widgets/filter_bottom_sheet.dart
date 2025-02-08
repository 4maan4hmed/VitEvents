import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_application_2/config/theme/app_colors.dart';
import 'package:intl/intl.dart';

class FilterBottomSheet extends StatefulWidget {
  final Map<String, dynamic> currentFilters;
  final Function(Map<String, dynamic>) onApplyFilters;

  const FilterBottomSheet({
    super.key,
    required this.currentFilters,
    required this.onApplyFilters,
  });

  @override
  State<FilterBottomSheet> createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends State<FilterBottomSheet> {
  late Map<String, dynamic> filters;
  final dateFormat = DateFormat('MMM dd, yyyy');

  // Colors
  static const primary = AppColors.primary;
  static const white = AppColors.white;
  static const gray = AppColors.gray;
  static const gray1 = AppColors.gray1;
  static const gray2 = AppColors.gray2;
  static const blueDark = AppColors.blueDark;

  // Typography
  static const TextStyle titleStyle = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.bold,
    color: white,
  );

  static const TextStyle subtitleStyle = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: white,
  );

  static const TextStyle bodyStyle = TextStyle(
    fontSize: 14,
    color: white,
  );

  @override
  void initState() {
    super.initState();
    filters = Map<String, dynamic>.from(widget.currentFilters);
    debugPrint('Initial Filters: $filters');
  }

  // Event categories with corresponding icons
  final Map<String, IconData> categories = {
    'Music': Icons.music_note,
    'Sports': Icons.sports_soccer,
    'Art': Icons.palette,
    'Technology': Icons.computer,
    'Food': Icons.fastfood,
    'Business': Icons.business,
    'Education': Icons.school,
    'Other': Icons.category,
  };

  Future<void> _selectDate(BuildContext context, String filterKey) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: primary,
              onPrimary: white,
              surface: blueDark,
              onSurface: white,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        filters[filterKey] = {
          'operator': filterKey == 'startDate' ? '>=' : '<=',
          'value': Timestamp.fromDate(picked),
        };
      });
      debugPrint('Filters after selecting $filterKey: $filters');
    }
  }

  Widget _buildDateFilter() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Row(
          children: [
            Icon(Icons.calendar_today, color: white, size: 20),
            SizedBox(width: 8),
            Text('Date Range', style: subtitleStyle),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: () => _selectDate(context, 'startDate'),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: white),
                  backgroundColor: primary.withOpacity(0.5), // Semi-transparent
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.date_range, color: white, size: 16),
                    const SizedBox(width: 8),
                    Text(
                      filters['startDate'] != null
                          ? dateFormat.format(
                              (filters['startDate']['value'] as Timestamp)
                                  .toDate())
                          : 'Start Date',
                      style: bodyStyle,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: OutlinedButton(
                onPressed: () => _selectDate(context, 'endDate'),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: white),
                  backgroundColor: primary.withOpacity(0.5), // Semi-transparent
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.date_range, color: white, size: 16),
                    const SizedBox(width: 8),
                    Text(
                      filters['endDate'] != null
                          ? dateFormat.format(
                              (filters['endDate']['value'] as Timestamp)
                                  .toDate())
                          : 'End Date',
                      style: bodyStyle,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildCategoryFilter() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Row(
          children: [
            Icon(Icons.category, color: white, size: 20),
            SizedBox(width: 8),
            Text('Categories', style: subtitleStyle),
          ],
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: categories.entries.map((entry) {
            final category = entry.key;
            final icon = entry.value;
            final isSelected = filters['category']?['value'] == category;
            return FilterChip(
              label: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(icon, size: 16, color: isSelected ? white : primary),
                  const SizedBox(width: 8),
                  Text(
                    category,
                    style: TextStyle(
                      color: isSelected ? white : primary,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
              selected: isSelected,
              onSelected: (selected) {
                setState(() {
                  if (selected) {
                    filters['category'] = {
                      'operator': '==',
                      'value': category,
                    };
                  } else {
                    filters.remove('category');
                  }
                });
                debugPrint('Filters after selecting category: $filters');
              },
              backgroundColor: gray1.withOpacity(0.1),
              selectedColor: blueDark.withOpacity(0.5), // Semi-transparent
              checkmarkColor: white,
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildPriceFilter() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Row(
          children: [
            Icon(Icons.attach_money, color: white, size: 20),
            SizedBox(width: 8),
            Text('Price', style: subtitleStyle),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            FilterChip(
              label: Text(
                'Free',
                style: TextStyle(
                  color: filters['isFree']?['value'] == true ? white : blueDark,
                ),
              ),
              selected: filters['isFree']?['value'] == true,
              onSelected: (selected) {
                setState(() {
                  if (selected) {
                    filters['isFree'] = {
                      'operator': '==',
                      'value': true,
                    };
                  } else {
                    filters.remove('isFree');
                  }
                });
                debugPrint('Filters after selecting price: $filters');
              },
              backgroundColor: gray1.withOpacity(0.1),
              selectedColor: blueDark.withOpacity(0.5), // Semi-transparent
              checkmarkColor: white,
            ),
            const SizedBox(width: 8),
            FilterChip(
              label: Text(
                'Paid',
                style: TextStyle(
                  color:
                      filters['isFree']?['value'] == false ? white : blueDark,
                ),
              ),
              selected: filters['isFree']?['value'] == false,
              onSelected: (selected) {
                setState(() {
                  if (selected) {
                    filters['isFree'] = {
                      'operator': '==',
                      'value': false,
                    };
                  } else {
                    filters.remove('isFree');
                  }
                });
                debugPrint('Filters after selecting price: $filters');
              },
              backgroundColor: gray1.withOpacity(0.1),
              selectedColor: blueDark.withOpacity(0.5), // Semi-transparent
              checkmarkColor: white,
            ),
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(24),
        topRight: Radius.circular(24),
      ),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10), // Blur effect
        child: Container(
          decoration: BoxDecoration(
            color: primary.withOpacity(0.4), // Semi-transparent background
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(24),
              topRight: Radius.circular(24),
            ),
          ),
          child: SafeArea(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(
                    color: white.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Filter Events', style: titleStyle),
                      if (filters.isNotEmpty)
                        TextButton(
                          onPressed: () {
                            setState(() {
                              filters.clear();
                            });
                            debugPrint('Filters after clearing all: $filters');
                          },
                          child: const Text(
                            'Clear All',
                            style: TextStyle(color: white),
                          ),
                        ),
                    ],
                  ),
                ),
                Flexible(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildDateFilter(),
                        const SizedBox(height: 24),
                        _buildCategoryFilter(),
                        const SizedBox(height: 24),
                        _buildPriceFilter(),
                        const SizedBox(height: 24),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: SizedBox(
                    width: double.infinity,
                    child: FilledButton(
                      style: FilledButton.styleFrom(
                        backgroundColor:
                            blueDark.withOpacity(0.7), // Semi-transparent
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      onPressed: () {
                        debugPrint('Final Filters before applying: $filters');
                        widget.onApplyFilters(filters);
                        Navigator.pop(context);
                      },
                      child: const Text('Apply Filters', style: bodyStyle),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
