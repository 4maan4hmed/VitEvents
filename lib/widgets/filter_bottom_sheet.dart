import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
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
  static const primary = Color(0xFF2196F3);
  static const white = Colors.white;
  static const blueDark = Color(0xFF1565C0);
  static const gray1 = Colors.grey;

  // Typography
  static const TextStyle titleStyle = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.bold,
    color: blueDark,
  );

  static const TextStyle subtitleStyle = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: blueDark,
  );

  static const TextStyle bodyStyle = TextStyle(
    fontSize: 14,
    color: blueDark,
  );

  @override
  void initState() {
    super.initState();
    filters = Map<String, dynamic>.from(widget.currentFilters);
  }

  // Event categories
  final List<String> categories = [
    'Music',
    'Sports',
    'Art',
    'Technology',
    'Food',
    'Business',
    'Education',
    'Other',
  ];

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
              surface: white,
              onSurface: blueDark,
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
    }
  }

  Widget _buildDateFilter() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Date Range', style: subtitleStyle),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: () => _selectDate(context, 'startDate'),
                child: Text(
                  filters['startDate'] != null
                      ? dateFormat.format(
                          (filters['startDate']['value'] as Timestamp).toDate())
                      : 'Start Date',
                  style: bodyStyle,
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: OutlinedButton(
                onPressed: () => _selectDate(context, 'endDate'),
                child: Text(
                  filters['endDate'] != null
                      ? dateFormat.format(
                          (filters['endDate']['value'] as Timestamp).toDate())
                      : 'End Date',
                  style: bodyStyle,
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
        const Text('Categories', style: subtitleStyle),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: categories.map((category) {
            final isSelected = filters['category']?['value'] == category;
            return FilterChip(
              label: Text(
                category,
                style: TextStyle(
                  color: isSelected ? gray1 : blueDark,
                  fontSize: 14,
                ),
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
              },
              backgroundColor: gray1.withOpacity(0.1),
              selectedColor: primary.withOpacity(0.2),
              checkmarkColor: primary,
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
        const Text('Price', style: subtitleStyle),
        const SizedBox(height: 8),
        Row(
          children: [
            FilterChip(
              label: const Text('Free', style: bodyStyle),
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
              },
              backgroundColor: gray1.withOpacity(0.1),
              selectedColor: primary.withOpacity(0.2),
              checkmarkColor: primary,
            ),
            const SizedBox(width: 8),
            FilterChip(
              label: const Text('Paid', style: bodyStyle),
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
              },
              backgroundColor: gray1.withOpacity(0.1),
              selectedColor: primary.withOpacity(0.2),
              checkmarkColor: primary,
            ),
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: white,
        borderRadius: BorderRadius.only(
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
                color: gray1.withOpacity(0.3),
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
                      },
                      child: const Text('Clear All'),
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
                  onPressed: () {
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
    );
  }
}
