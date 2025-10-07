import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants/app_constants.dart';
import '../screens/main_screen.dart';
import '../screens/favorites_screen.dart';
import '../screens/notifications_screen.dart';
import '../screens/profile_screen.dart';
import '../screens/booking_screen.dart';
import '../models/user.dart';
import '../models/turf.dart';
import '../models/booking.dart';
// import '../models/notification_item.dart'; // ensure this file exists in your project

class MainNavigationScreen extends StatefulWidget {
  final User currentUser;
  final List<Turf> favoriteTurfs;
  final List<Booking> userBookings;
  final List<NotificationItem> notifications;

  const MainNavigationScreen({
    super.key,
    required this.currentUser,
    required this.favoriteTurfs,
    required this.userBookings,
    required this.notifications,
  });

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen>
    with TickerProviderStateMixin {
  int _currentIndex = 0;
  late PageController _pageController;
  late AnimationController _fabAnimationController;
  late Animation<double> _fabAnimation;

  // A getter for pages ensures the list stays in-sync with widget data
  List<Widget> get _pages => [
        MainScreen(),
        FavoritesScreen(
          favoriteTurfs: widget.favoriteTurfs,
          onRemoveFavorite: _onRemoveFavorite,
          onTurfTap: _onTurfTap,
        ),
        // NotificationsScreen(
        //   notifications: widget.notifications,
        //   onMarkAsRead: _onMarkAsRead,
        //   onNotificationTap: _onNotificationTap,
        // ),
        ProfileScreen(
          user: widget.currentUser,
          userBookings: widget.userBookings,
          onUpdateProfile: _onUpdateProfile,
          onLogout: _onLogout,
        ),
      ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _currentIndex);
    _fabAnimationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _fabAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fabAnimationController,
      curve: Curves.easeInOut,
    ));
    _fabAnimationController.forward();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _fabAnimationController.dispose();
    super.dispose();
  }

  void _onTabTapped(int index) {
    // Guard: ensure index is valid for the current pages list
    if (index < 0 || index >= _pages.length) return;

    setState(() {
      _currentIndex = index;
    });

    // Animate only when pageController has attached positions
    if (_pageController.hasClients) {
      _pageController.animateToPage(
        index,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      _pageController.jumpToPage(index);
    }
  }

  void _onPageChanged(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final isMobile = screenSize.width < AppConstants.mobileBreakpoint;

    // compute unread notifications count for badge
    final unreadCount = widget.notifications.where((n) => !n.isRead).length;
    final favoritesCount = widget.favoriteTurfs.length;

    return Scaffold(
      // PageView with 4 pages (Home, Favorites, Notifications, Profile)
      body: PageView(
        controller: _pageController,
        onPageChanged: _onPageChanged,
        physics: const BouncingScrollPhysics(),
        children: _pages,
      ),

      // Custom bottom navigation bar container
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: isMobile ? AppConstants.mediumPadding : AppConstants.largePadding,
              vertical: AppConstants.smallPadding,
            ),
            child: Row(
              children: [
                // Make each nav item take equal space to avoid overflow
                Expanded(
                  child: _buildNavItem(
                    index: 0,
                    icon: Icons.home,
                    label: 'Home',
                    isSelected: _currentIndex == 0,
                  ),
                ),
                Expanded(
                  child: _buildNavItem(
                    index: 1,
                    icon: Icons.favorite,
                    label: 'Favorites',
                    isSelected: _currentIndex == 1,
                    badge: favoritesCount > 0 ? favoritesCount.toString() : null,
                  ),
                ),
                Expanded(
                  child: _buildNavItem(
                    index: 2,
                    icon: Icons.notifications,
                    label: 'Notifications',
                    isSelected: _currentIndex == 2,
                    badge: unreadCount > 0 ? (unreadCount > 99 ? '99+' : unreadCount.toString()) : null,
                  ),
                ),
                Expanded(
                  child: _buildNavItem(
                    index: 3,
                    icon: Icons.person,
                    label: 'Profile',
                    isSelected: _currentIndex == 3,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),

      // Floating button for quick booking (animated)
      floatingActionButton: ScaleTransition(
        scale: _fabAnimation,
        child: FloatingActionButton(
          onPressed: _onQuickBook,
          backgroundColor: AppConstants.primaryColor,
          child: const Icon(
            Icons.add,
            color: Colors.white,
          ),
        ),
      ),
      // put FAB in default location (floating), adjust if you want centerDocked with notch
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Widget _buildNavItem({
    required int index,
    required IconData icon,
    required String label,
    required bool isSelected,
    String? badge,
  }) {
    final iconColor = isSelected ? AppConstants.primaryColor : AppConstants.textSecondary;
    final textColor = isSelected ? AppConstants.primaryColor : AppConstants.textSecondary;

    return GestureDetector(
      onTap: () => _onTabTapped(index),
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppConstants.smallPadding,
          vertical: AppConstants.smallPadding,
        ),
        decoration: BoxDecoration(
          color: isSelected ? AppConstants.primaryColor.withOpacity(0.06) : Colors.transparent,
          borderRadius: BorderRadius.circular(AppConstants.mediumRadius),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // use a fixed-size box for the icon + badge so layout is predictable
            SizedBox(
              height: 28,
              width: 28,
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Center(
                    child: Icon(
                      icon,
                      color: iconColor,
                      size: 24,
                    ),
                  ),
                  if (badge != null)
                    // place badge at top-right without negative offsets
                    Positioned(
                      top: -6,
                      right: -6,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.12),
                              blurRadius: 3,
                            ),
                          ],
                        ),
                        constraints: const BoxConstraints(
                          minWidth: 16,
                          minHeight: 16,
                        ),
                        child: Text(
                          badge,
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: GoogleFonts.poppins(
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                color: textColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _onTurfTap(Turf turf) {
    // Navigate to turf details or booking screen
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => BookingScreen(turf: turf),
      ),
    );
  }


  void _onRemoveFavorite(Turf turf) {
    setState(() {
      widget.favoriteTurfs.remove(turf);
      widget.currentUser.favoriteTurfs.remove(turf.id);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Removed from favorites'),
        backgroundColor: AppConstants.successColor,
      ),
    );
  }



  void _onUpdateProfile(User user) {
    // In a real app, an external state manager would persist this change.
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Profile updated successfully'),
        backgroundColor: AppConstants.successColor,
      ),
    );
  }

  void _onLogout() {
    // show snackbar before navigating away (otherwise context may change)
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Logged out successfully'),
        backgroundColor: AppConstants.successColor,
      ),
    );

    // Handle logout navigation
    Navigator.of(context).pushReplacementNamed('/welcome');
  }

  void _onQuickBook() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Quick booking feature coming soon!'),
        backgroundColor: AppConstants.primaryColor,
      ),
    );
  }
}
