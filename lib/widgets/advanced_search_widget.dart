import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants/app_constants.dart';

class AdvancedSearchWidget extends StatefulWidget {
  final String? initialQuery;
  final String? initialSport;
  final double? initialMinPrice;
  final double? initialMaxPrice;
  final double? initialMinRating;
  final Function(String query, String sport, double minPrice, double maxPrice, double minRating)? onSearch;

  const AdvancedSearchWidget({
    super.key,
    this.initialQuery,
    this.initialSport,
    this.initialMinPrice,
    this.initialMaxPrice,
    this.initialMinRating,
    this.onSearch,
  });

  @override
  State<AdvancedSearchWidget> createState() => _AdvancedSearchWidgetState();
}

class _AdvancedSearchWidgetState extends State<AdvancedSearchWidget> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedSport = '';
  double _minPrice = 0;
  double _maxPrice = 5000;
  double _minRating = 0;
  bool _showAdvancedFilters = false;

  @override
  void initState() {
    super.initState();
    _searchController.text = widget.initialQuery ?? '';
    _selectedSport = widget.initialSport ?? '';
    _minPrice = widget.initialMinPrice ?? 0;
    _maxPrice = widget.initialMaxPrice ?? 5000;
    _minRating = widget.initialMinRating ?? 0;
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _performSearch() {
    widget.onSearch?.call(
      _searchController.text.trim(),
      _selectedSport,
      _minPrice,
      _maxPrice,
      _minRating,
    );
  }

  void _resetFilters() {
    setState(() {
      _searchController.clear();
      _selectedSport = '';
      _minPrice = 0;
      _maxPrice = 5000;
      _minRating = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final isMobile = screenSize.width < AppConstants.mobileBreakpoint;

    return Container(
      padding: const EdgeInsets.all(AppConstants.largePadding),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppConstants.largeRadius),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Find Your Perfect Turf',
                style: GoogleFonts.poppins(
                  fontSize: isMobile ? 18 : 22,
                  fontWeight: FontWeight.bold,
                  color: AppConstants.textPrimary,
                ),
              ),
              IconButton(
                onPressed: () {
                  setState(() {
                    _showAdvancedFilters = !_showAdvancedFilters;
                  });
                },
                icon: Icon(
                  _showAdvancedFilters ? Icons.keyboard_arrow_up : Icons.filter_list,
                  color: AppConstants.primaryColor,
                ),
              ),
            ],
          ),
          
          const SizedBox(height: AppConstants.mediumPadding),
          
          // Basic Search
          TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: 'Search by location...',
              hintStyle: GoogleFonts.poppins(
                color: AppConstants.textHint,
                fontSize: 16,
              ),
              prefixIcon: const Icon(
                Icons.search,
                color: AppConstants.textSecondary,
              ),
              suffixIcon: _searchController.text.isNotEmpty
                  ? IconButton(
                      onPressed: () {
                        _searchController.clear();
                        setState(() {});
                      },
                      icon: const Icon(
                        Icons.clear,
                        color: AppConstants.textSecondary,
                      ),
                    )
                  : null,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppConstants.mediumRadius),
                borderSide: BorderSide(color: Colors.grey[300]!),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppConstants.mediumRadius),
                borderSide: BorderSide(color: Colors.grey[300]!),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppConstants.mediumRadius),
                borderSide: const BorderSide(color: AppConstants.primaryColor, width: 2),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: AppConstants.mediumPadding,
                vertical: AppConstants.mediumPadding,
              ),
            ),
            style: GoogleFonts.poppins(
              fontSize: 16,
              color: AppConstants.textPrimary,
            ),
            onChanged: (value) {
              setState(() {});
            },
          ),
          
          const SizedBox(height: AppConstants.mediumPadding),
          
          // Sport Selection
          Text(
            'Select Sport',
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppConstants.textPrimary,
            ),
          ),
          const SizedBox(height: AppConstants.smallPadding),
          
          Wrap(
            spacing: AppConstants.smallPadding,
            runSpacing: AppConstants.smallPadding,
            children: AppConstants.sportsTypes.map((sport) {
              final isSelected = _selectedSport == sport;
              return GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedSport = isSelected ? '' : sport;
                  });
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppConstants.mediumPadding,
                    vertical: AppConstants.smallPadding,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected ? AppConstants.primaryColor : Colors.grey[100],
                    borderRadius: BorderRadius.circular(AppConstants.mediumRadius),
                    border: Border.all(
                      color: isSelected ? AppConstants.primaryColor : Colors.grey[300]!,
                    ),
                  ),
                  child: Text(
                    sport,
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: isSelected ? Colors.white : AppConstants.textPrimary,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
          
          // Advanced Filters
          if (_showAdvancedFilters) ...[
            const SizedBox(height: AppConstants.largePadding),
            
            Text(
              'Advanced Filters',
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppConstants.textPrimary,
              ),
            ),
            const SizedBox(height: AppConstants.mediumPadding),
            
            // Price Range
            Text(
              'Price Range: ₹${_minPrice.toInt()} - ₹${_maxPrice.toInt()}',
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: AppConstants.textSecondary,
              ),
            ),
            const SizedBox(height: AppConstants.smallPadding),
            
            RangeSlider(
              values: RangeValues(_minPrice, _maxPrice),
              min: 0,
              max: 5000,
              divisions: 50,
              labels: RangeLabels(
                '₹${_minPrice.toInt()}',
                '₹${_maxPrice.toInt()}',
              ),
              activeColor: AppConstants.primaryColor,
              onChanged: (values) {
                setState(() {
                  _minPrice = values.start;
                  _maxPrice = values.end;
                });
              },
            ),
            
            const SizedBox(height: AppConstants.mediumPadding),
            
            // Rating Filter
            Text(
              'Minimum Rating: ${_minRating.toStringAsFixed(1)} ⭐',
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: AppConstants.textSecondary,
              ),
            ),
            const SizedBox(height: AppConstants.smallPadding),
            
            Slider(
              value: _minRating,
              min: 0,
              max: 5,
              divisions: 10,
              label: '${_minRating.toStringAsFixed(1)} ⭐',
              activeColor: AppConstants.primaryColor,
              onChanged: (value) {
                setState(() {
                  _minRating = value;
                });
              },
            ),
          ],
          
          const SizedBox(height: AppConstants.largePadding),
          
          // Action Buttons
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: _performSearch,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppConstants.primaryColor,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      vertical: AppConstants.mediumPadding,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppConstants.mediumRadius),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.search, size: 20),
                      const SizedBox(width: AppConstants.smallPadding),
                      Text(
                        'Search Turfs',
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              
              const SizedBox(width: AppConstants.mediumPadding),
              
              OutlinedButton(
                onPressed: _resetFilters,
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppConstants.textSecondary,
                  side: BorderSide(color: Colors.grey[300]!),
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppConstants.largePadding,
                    vertical: AppConstants.mediumPadding,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppConstants.mediumRadius),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.refresh, size: 18),
                    const SizedBox(width: AppConstants.smallPadding),
                    Text(
                      'Reset',
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
