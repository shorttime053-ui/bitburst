import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants/app_constants.dart';
import '../widgets/custom_button.dart';
import '../widgets/turf_card.dart';
import '../widgets/search_bar_widget.dart';
import '../widgets/error_widgets.dart' as custom_error;
import '../models/turf.dart';
import '../services/firebase_service.dart';
import 'results_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedSport = '';
  List<Turf> _featuredTurfs = [];
  List<Turf> _nearbyTurfs = [];
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadTurfs();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadTurfs() async {
    try {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });
      
      final turfs = await FirebaseService.getTurfs();
      setState(() {
        _featuredTurfs = turfs.take(6).toList();
        _nearbyTurfs = turfs.skip(6).take(4).toList();
        _isLoading = false;
        _errorMessage = null;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = e.toString();
      });
    }
  }

  void _performSearch() {
    if (_searchController.text.trim().isEmpty && _selectedSport.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a location or select a sport')),
      );
      return;
    }

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ResultsScreen(
          searchQuery: _searchController.text.trim(),
          selectedSport: _selectedSport,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final isMobile = screenSize.width < AppConstants.mobileBreakpoint;

    return Scaffold(
      backgroundColor: AppConstants.backgroundColor,
      body: SafeArea(
        child: _isLoading
            ? const custom_error.LoadingWidget(message: 'Loading turfs...')
            : _errorMessage != null
                ? custom_error.ErrorWidget(
                    message: _errorMessage!,
                    onRetry: _loadTurfs,
                  )
                : SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.all(
                    isMobile ? AppConstants.mediumPadding : AppConstants.largePadding,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header
                      _buildHeader(isMobile),
                      
                      const SizedBox(height: AppConstants.largePadding),
                      
                      // Search Section
                      _buildSearchSection(isMobile),
                      
                      const SizedBox(height: AppConstants.largePadding),
                      
                      // Featured Turfs
                      _buildFeaturedSection(isMobile),
                      
                      const SizedBox(height: AppConstants.largePadding),
                      
                      // Nearby Turfs
                      _buildNearbySection(isMobile),
                    ],
                  ),
                ),
              ),
      ),
    );
  }

  Widget _buildHeader(bool isMobile) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Welcome to',
              style: GoogleFonts.poppins(
                fontSize: isMobile ? 16 : 20,
                color: AppConstants.textSecondary,
                fontWeight: FontWeight.w400,
              ),
            ),
            Text(
              AppConstants.appName,
              style: GoogleFonts.poppins(
                fontSize: isMobile ? 28 : 36,
                fontWeight: FontWeight.bold,
                color: AppConstants.primaryColor,
              ),
            ),
          ],
        ),
        Container(
          padding: const EdgeInsets.all(AppConstants.smallPadding),
          decoration: BoxDecoration(
            color: AppConstants.primaryColor,
            borderRadius: BorderRadius.circular(AppConstants.mediumRadius),
          ),
          child: const Icon(
            Icons.notifications_outlined,
            color: Colors.white,
            size: 24,
          ),
        ),
      ],
    );
  }

  Widget _buildSearchSection(bool isMobile) {
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
          Text(
            'Find Your Perfect Turf',
            style: GoogleFonts.poppins(
              fontSize: isMobile ? 18 : 22,
              fontWeight: FontWeight.bold,
              color: AppConstants.textPrimary,
            ),
          ),
          const SizedBox(height: AppConstants.mediumPadding),
          
          // Search Bar
          SearchBarWidget(
            controller: _searchController,
            hintText: 'Search by location...',
            onChanged: (value) {},
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
          
          const SizedBox(height: AppConstants.largePadding),
          
          // Search Button
          CustomButton(
            text: 'Search Turfs',
            onPressed: _performSearch,
            width: double.infinity,
            height: 56,
            backgroundColor: AppConstants.primaryColor,
            textColor: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
            icon: const Icon(Icons.search, color: Colors.white),
          ),
        ],
      ),
    );
  }

  Widget _buildFeaturedSection(bool isMobile) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Featured Turfs',
              style: GoogleFonts.poppins(
                fontSize: isMobile ? 20 : 24,
                fontWeight: FontWeight.bold,
                color: AppConstants.textPrimary,
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const ResultsScreen(),
                  ),
                );
              },
              child: Text(
                'View All',
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppConstants.primaryColor,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: AppConstants.mediumPadding),
        SizedBox(
          height: isMobile ? 280 : 320,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: _featuredTurfs.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: EdgeInsets.only(
                  right: index < _featuredTurfs.length - 1 ? AppConstants.mediumPadding : 0,
                ),
                child: TurfCard(
                  turf: _featuredTurfs[index],
                  width: isMobile ? 280 : 320,
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildNearbySection(bool isMobile) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Nearby Turfs',
          style: GoogleFonts.poppins(
            fontSize: isMobile ? 20 : 24,
            fontWeight: FontWeight.bold,
            color: AppConstants.textPrimary,
          ),
        ),
        const SizedBox(height: AppConstants.mediumPadding),
        ...(_nearbyTurfs.map((turf) => Padding(
          padding: const EdgeInsets.only(bottom: AppConstants.mediumPadding),
          child: TurfCard(
            turf: turf,
            isHorizontal: true,
          ),
        )).toList()),
      ],
    );
  }
}
