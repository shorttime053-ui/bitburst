import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants/app_constants.dart';
import '../widgets/custom_button.dart';
import '../widgets/turf_card.dart';
import '../widgets/search_bar_widget.dart';
import '../models/turf.dart';
import '../services/firebase_service.dart';

class ResultsScreen extends StatefulWidget {
  final String searchQuery;
  final String selectedSport;

  const ResultsScreen({
    super.key,
    this.searchQuery = '',
    this.selectedSport = '',
  });

  @override
  State<ResultsScreen> createState() => _ResultsScreenState();
}

class _ResultsScreenState extends State<ResultsScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<Turf> _searchResults = [];
  bool _isLoading = true;
  String _selectedSport = '';
  String _sortBy = 'rating';

  @override
  void initState() {
    super.initState();
    _searchController.text = widget.searchQuery;
    _selectedSport = widget.selectedSport;
    _performSearch();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _performSearch() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final results = await FirebaseService.searchTurfs(
        location: _searchController.text.trim().isNotEmpty ? _searchController.text.trim() : null,
        sport: _selectedSport.isNotEmpty ? _selectedSport : null,
      );

      // Apply sorting
      _applySorting(results);

      setState(() {
        _searchResults = results;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error searching turfs: $e')),
        );
      }
    }
  }

  void _applySorting(List<Turf> turfs) {
    switch (_sortBy) {
      case 'rating':
        turfs.sort((a, b) => b.rating.compareTo(a.rating));
        break;
      case 'price_low':
        turfs.sort((a, b) => a.pricePerHour.compareTo(b.pricePerHour));
        break;
      case 'price_high':
        turfs.sort((a, b) => b.pricePerHour.compareTo(a.pricePerHour));
        break;
      case 'name':
        turfs.sort((a, b) => a.name.compareTo(b.name));
        break;
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: AppConstants.backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppConstants.textPrimary),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Search Results',
          style: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppConstants.textPrimary,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list, color: AppConstants.textPrimary),
            onPressed: _showFilterDialog,
          ),
        ],
      ),
      body: Column(
        children: [
          // Search Bar
          Container(
            padding: const EdgeInsets.all(AppConstants.mediumPadding),
            color: Colors.white,
            child: Column(
              children: [
                SearchBarWidget(
                  controller: _searchController,
                  hintText: 'Search by location...',
                  onChanged: (value) {},
                ),
                const SizedBox(height: AppConstants.smallPadding),
                
                // Sport Selection
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: AppConstants.sportsTypes.map((sport) {
                      final isSelected = _selectedSport == sport;
                      return Padding(
                        padding: const EdgeInsets.only(right: AppConstants.smallPadding),
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              _selectedSport = isSelected ? '' : sport;
                            });
                            _performSearch();
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
                        ),
                      );
                    }).toList(),
                  ),
                ),
                
                const SizedBox(height: AppConstants.smallPadding),
                
                // Search Button
                CustomButton(
                  text: 'Search',
                  onPressed: _performSearch,
                  width: double.infinity,
                  height: 48,
                  backgroundColor: AppConstants.primaryColor,
                  textColor: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  icon: const Icon(Icons.search, color: Colors.white),
                ),
              ],
            ),
          ),
          
          // Results Count and Sort
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppConstants.mediumPadding,
              vertical: AppConstants.smallPadding,
            ),
            color: Colors.white,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${_searchResults.length} turfs found',
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    color: AppConstants.textSecondary,
                  ),
                ),
                DropdownButton<String>(
                  value: _sortBy,
                  underline: const SizedBox(),
                  items: const [
                    DropdownMenuItem(value: 'rating', child: Text('Sort by Rating')),
                    DropdownMenuItem(value: 'price_low', child: Text('Price: Low to High')),
                    DropdownMenuItem(value: 'price_high', child: Text('Price: High to Low')),
                    DropdownMenuItem(value: 'name', child: Text('Sort by Name')),
                  ],
                  onChanged: (value) {
                    if (value != null) {
                      setState(() {
                        _sortBy = value;
                      });
                      _applySorting(_searchResults);
                    }
                  },
                ),
              ],
            ),
          ),
          
          // Results
          Expanded(
            child: _isLoading
                ? const Center(
                    child: CircularProgressIndicator(
                      color: AppConstants.primaryColor,
                    ),
                  )
                : _searchResults.isEmpty
                    ? _buildEmptyState()
                    : ListView.builder(
                        padding: const EdgeInsets.all(AppConstants.mediumPadding),
                        itemCount: _searchResults.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: AppConstants.mediumPadding),
                            child: TurfCard(
                              turf: _searchResults[index],
                              isHorizontal: true,
                            ),
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search_off,
            size: 80,
            color: Colors.grey[400],
          ),
          const SizedBox(height: AppConstants.mediumPadding),
          Text(
            'No turfs found',
            style: GoogleFonts.poppins(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppConstants.textSecondary,
            ),
          ),
          const SizedBox(height: AppConstants.smallPadding),
          Text(
            'Try adjusting your search criteria',
            style: GoogleFonts.poppins(
              fontSize: 16,
              color: AppConstants.textHint,
            ),
          ),
        ],
      ),
    );
  }

  void _showFilterDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Filter Results',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Price Range Filter
            Text(
              'Price Range',
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: AppConstants.smallPadding),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      labelText: 'Min Price',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(AppConstants.smallRadius),
                      ),
                    ),
                    keyboardType: TextInputType.number,
                  ),
                ),
                const SizedBox(width: AppConstants.smallPadding),
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      labelText: 'Max Price',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(AppConstants.smallRadius),
                      ),
                    ),
                    keyboardType: TextInputType.number,
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              'Cancel',
              style: GoogleFonts.poppins(
                color: AppConstants.textSecondary,
              ),
            ),
          ),
          CustomButton(
            text: 'Apply',
            onPressed: () {
              Navigator.of(context).pop();
              _performSearch();
            },
            backgroundColor: AppConstants.primaryColor,
            textColor: Colors.white,
          ),
        ],
      ),
    );
  }
}
