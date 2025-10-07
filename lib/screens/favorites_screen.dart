import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants/app_constants.dart';
import '../models/turf.dart';
import '../widgets/turf_card.dart';

class FavoritesScreen extends StatefulWidget {
  final List<Turf> favoriteTurfs;
  final Function(Turf turf) onRemoveFavorite;
  final Function(Turf turf) onTurfTap;

  const FavoritesScreen({
    super.key,
    required this.favoriteTurfs,
    required this.onRemoveFavorite,
    required this.onTurfTap,
  });

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  String _sortBy = 'name';
  String _filterBy = 'all';

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  List<Turf> get _filteredTurfs {
    List<Turf> turfs = List.from(widget.favoriteTurfs);

    // Apply sport filter
    if (_filterBy != 'all') {
      turfs = turfs.where((turf) => turf.sports.contains(_filterBy)).toList();
    }

    // Apply sorting
    switch (_sortBy) {
      case 'name':
        turfs.sort((a, b) => a.name.compareTo(b.name));
        break;
      case 'rating':
        turfs.sort((a, b) => b.rating.compareTo(a.rating));
        break;
      case 'price_low':
        turfs.sort((a, b) => a.pricePerHour.compareTo(b.pricePerHour));
        break;
      case 'price_high':
        turfs.sort((a, b) => b.pricePerHour.compareTo(a.pricePerHour));
        break;
    }

    return turfs;
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final isMobile = screenSize.width < AppConstants.mobileBreakpoint;

    return Scaffold(
      backgroundColor: AppConstants.backgroundColor,
      appBar: AppBar(
        title: Text(
          'My Favorites',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.white,
        foregroundColor: AppConstants.textPrimary,
        elevation: 0,
        actions: [
          if (widget.favoriteTurfs.isNotEmpty)
            PopupMenuButton<String>(
              onSelected: (value) {
                setState(() {
                  _sortBy = value;
                });
              },
              itemBuilder: (context) => [
                const PopupMenuItem(
                  value: 'name',
                  child: Text('Sort by Name'),
                ),
                const PopupMenuItem(
                  value: 'rating',
                  child: Text('Sort by Rating'),
                ),
                const PopupMenuItem(
                  value: 'price_low',
                  child: Text('Price: Low to High'),
                ),
                const PopupMenuItem(
                  value: 'price_high',
                  child: Text('Price: High to Low'),
                ),
              ],
              icon: const Icon(Icons.sort),
            ),
        ],
      ),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: Column(
          children: [
            // Filter Bar
            if (widget.favoriteTurfs.isNotEmpty)
              Container(
                padding: const EdgeInsets.all(AppConstants.mediumPadding),
                color: Colors.white,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _buildFilterChip('all', 'All Sports'),
                      const SizedBox(width: AppConstants.smallPadding),
                      ...AppConstants.sportsTypes.map((sport) {
                        return Padding(
                          padding: const EdgeInsets.only(right: AppConstants.smallPadding),
                          child: _buildFilterChip(sport, sport),
                        );
                      }).toList(),
                    ],
                  ),
                ),
              ),

            // Content
            Expanded(
              child: widget.favoriteTurfs.isEmpty
                  ? _buildEmptyState()
                  : ListView.builder(
                      padding: EdgeInsets.all(
                        isMobile ? AppConstants.mediumPadding : AppConstants.largePadding,
                      ),
                      itemCount: _filteredTurfs.length,
                      itemBuilder: (context, index) {
                        final turf = _filteredTurfs[index];
                        return Padding(
                          padding: const EdgeInsets.only(bottom: AppConstants.mediumPadding),
                          child: TurfCard(
                            turf: turf,
                            isHorizontal: true,
                            showFavoriteButton: true,
                            isFavorite: true,
                            onFavoriteToggle: () => widget.onRemoveFavorite(turf),
                            onTap: () => widget.onTurfTap(turf),
                            onShare: () => _shareTurf(turf),
                            onCall: () => _callTurf(turf),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterChip(String value, String label) {
    final isSelected = _filterBy == value;
    return GestureDetector(
      onTap: () {
        setState(() {
          _filterBy = value;
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
          label,
          style: GoogleFonts.poppins(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: isSelected ? Colors.white : AppConstants.textPrimary,
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.largePadding),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.favorite_border,
              size: 80,
              color: Colors.grey[400],
            ),
            
            const SizedBox(height: AppConstants.largePadding),
            
            Text(
              'No Favorites Yet',
              style: GoogleFonts.poppins(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppConstants.textSecondary,
              ),
            ),
            
            const SizedBox(height: AppConstants.mediumPadding),
            
            Text(
              'Start exploring turfs and add them to your favorites!',
              style: GoogleFonts.poppins(
                fontSize: 16,
                color: AppConstants.textHint,
              ),
              textAlign: TextAlign.center,
            ),
            
            const SizedBox(height: AppConstants.largePadding),
            
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppConstants.primaryColor,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: AppConstants.largePadding,
                  vertical: AppConstants.mediumPadding,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppConstants.mediumRadius),
                ),
              ),
              child: Text(
                'Explore Turfs',
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _shareTurf(Turf turf) {
    // Implement sharing functionality
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Sharing ${turf.name}...'),
        backgroundColor: AppConstants.primaryColor,
      ),
    );
  }

  void _callTurf(Turf turf) {
    // Implement calling functionality
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Contact ${turf.name}',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.phone, color: AppConstants.primaryColor),
              title: Text(
                'Call Owner',
                style: GoogleFonts.poppins(),
              ),
              subtitle: Text(
                '+91 9876543210', // This would come from turf data
                style: GoogleFonts.poppins(
                  color: AppConstants.textSecondary,
                ),
              ),
              onTap: () {
                Navigator.of(context).pop();
                // Implement actual calling
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Opening phone dialer...'),
                    backgroundColor: AppConstants.successColor,
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.email, color: AppConstants.primaryColor),
              title: Text(
                'Send Email',
                style: GoogleFonts.poppins(),
              ),
              subtitle: Text(
                'owner@${turf.name.toLowerCase().replaceAll(' ', '')}.com',
                style: GoogleFonts.poppins(
                  color: AppConstants.textSecondary,
                ),
              ),
              onTap: () {
                Navigator.of(context).pop();
                // Implement email sending
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Opening email client...'),
                    backgroundColor: AppConstants.successColor,
                  ),
                );
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              'Close',
              style: GoogleFonts.poppins(
                color: AppConstants.textSecondary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
