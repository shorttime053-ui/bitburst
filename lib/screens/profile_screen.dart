import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants/app_constants.dart';
import '../models/user.dart';
import '../models/booking.dart';

class ProfileScreen extends StatefulWidget {
  final User user;
  final List<Booking> userBookings;
  final Function(User user) onUpdateProfile;
  final VoidCallback onLogout;

  const ProfileScreen({
    super.key,
    required this.user,
    required this.userBookings,
    required this.onUpdateProfile,
    required this.onLogout,
  });

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
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
    _tabController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final isMobile = screenSize.width < AppConstants.mobileBreakpoint;

    return Scaffold(
      backgroundColor: AppConstants.backgroundColor,
      appBar: AppBar(
        title: Text(
          'Profile',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.white,
        foregroundColor: AppConstants.textPrimary,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: _editProfile,
            icon: const Icon(Icons.edit),
          ),
          IconButton(
            onPressed: _showLogoutDialog,
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: Column(
          children: [
            // Profile Header
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(
                isMobile ? AppConstants.mediumPadding : AppConstants.largePadding,
              ),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(AppConstants.largeRadius),
                  bottomRight: Radius.circular(AppConstants.largeRadius),
                ),
              ),
              child: Column(
                children: [
                  // Profile Picture
                  CircleAvatar(
                    radius: isMobile ? 50 : 60,
                    backgroundColor: AppConstants.primaryColor.withOpacity(0.1),
                    child: widget.user.profileImageUrl != null
                        ? ClipOval(
                            child: Image.network(
                              widget.user.profileImageUrl!,
                              width: isMobile ? 100 : 120,
                              height: isMobile ? 100 : 120,
                              fit: BoxFit.cover,
                            ),
                          )
                        : Icon(
                            Icons.person,
                            size: isMobile ? 50 : 60,
                            color: AppConstants.primaryColor,
                          ),
                  ),
                  
                  const SizedBox(height: AppConstants.mediumPadding),
                  
                  // User Name
                  Text(
                    widget.user.name,
                    style: GoogleFonts.poppins(
                      fontSize: isMobile ? 24 : 28,
                      fontWeight: FontWeight.bold,
                      color: AppConstants.textPrimary,
                    ),
                  ),
                  
                  const SizedBox(height: AppConstants.smallPadding),
                  
                  // User Email
                  Text(
                    widget.user.email,
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      color: AppConstants.textSecondary,
                    ),
                  ),
                  
                  const SizedBox(height: AppConstants.smallPadding),
                  
                  // User Phone
                  if (widget.user.phoneNumber != null)
                    Text(
                      widget.user.phoneNumber!,
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        color: AppConstants.textSecondary,
                      ),
                    ),
                  
                  const SizedBox(height: AppConstants.largePadding),
                  
                  // Stats Row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildStatItem(
                        'Bookings',
                        widget.userBookings.length.toString(),
                        Icons.calendar_today,
                      ),
                      _buildStatItem(
                        'Favorites',
                        widget.user.favoriteTurfs.length.toString(),
                        Icons.favorite,
                      ),
                      _buildStatItem(
                        'Reviews',
                        '12', // This would come from user data
                        Icons.star,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            
            // Tab Bar
            Container(
              color: Colors.white,
              child: TabBar(
                controller: _tabController,
                labelColor: AppConstants.primaryColor,
                unselectedLabelColor: AppConstants.textSecondary,
                indicatorColor: AppConstants.primaryColor,
                labelStyle: GoogleFonts.poppins(
                  fontWeight: FontWeight.w600,
                ),
                tabs: const [
                  Tab(text: 'Bookings'),
                  Tab(text: 'Favorites'),
                  Tab(text: 'Settings'),
                ],
              ),
            ),
            
            // Tab Content
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildBookingsTab(),
                  _buildFavoritesTab(),
                  _buildSettingsTab(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(
          icon,
          color: AppConstants.primaryColor,
          size: 24,
        ),
        const SizedBox(height: AppConstants.smallPadding),
        Text(
          value,
          style: GoogleFonts.poppins(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppConstants.textPrimary,
          ),
        ),
        Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 12,
            color: AppConstants.textSecondary,
          ),
        ),
      ],
    );
  }

  Widget _buildBookingsTab() {
    if (widget.userBookings.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(AppConstants.largePadding),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.calendar_today,
                size: 80,
                color: Colors.grey[400],
              ),
              const SizedBox(height: AppConstants.largePadding),
              Text(
                'No Bookings Yet',
                style: GoogleFonts.poppins(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppConstants.textSecondary,
                ),
              ),
              const SizedBox(height: AppConstants.mediumPadding),
              Text(
                'Start booking turfs to see them here!',
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  color: AppConstants.textHint,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(AppConstants.mediumPadding),
      itemCount: widget.userBookings.length,
      itemBuilder: (context, index) {
        final booking = widget.userBookings[index];
        return Card(
          margin: const EdgeInsets.only(bottom: AppConstants.mediumPadding),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: AppConstants.primaryColor.withOpacity(0.1),
              child: Icon(
                Icons.sports_soccer,
                color: AppConstants.primaryColor,
              ),
            ),
            title: Text(
              booking.turfName,
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w600,
              ),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${booking.startTime.day}/${booking.startTime.month}/${booking.startTime.year}',
                  style: GoogleFonts.poppins(
                    color: AppConstants.textSecondary,
                  ),
                ),
                Text(
                  '${booking.startTime.hour}:${booking.startTime.minute.toString().padLeft(2, '0')} - ${booking.endTime.hour}:${booking.endTime.minute.toString().padLeft(2, '0')}',
                  style: GoogleFonts.poppins(
                    color: AppConstants.textSecondary,
                  ),
                ),
              ],
            ),
            trailing: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '₹${booking.totalPrice}',
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.bold,
                    color: AppConstants.primaryColor,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppConstants.smallPadding,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: _getStatusColor(booking.status).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(AppConstants.smallRadius),
                  ),
                  child: Text(
                    booking.status.toUpperCase(),
                    style: GoogleFonts.poppins(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color: _getStatusColor(booking.status),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildFavoritesTab() {
    if (widget.user.favoriteTurfs.isEmpty) {
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
                'Add turfs to your favorites to see them here!',
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  color: AppConstants.textHint,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(AppConstants.mediumPadding),
      itemCount: widget.user.favoriteTurfs.length,
      itemBuilder: (context, index) {
        final turfId = widget.user.favoriteTurfs[index];
        return Card(
          margin: const EdgeInsets.only(bottom: AppConstants.mediumPadding),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: AppConstants.primaryColor.withOpacity(0.1),
              child: Icon(
                Icons.sports_soccer,
                color: AppConstants.primaryColor,
              ),
            ),
            title: Text(
              'Turf $turfId', // This would be the actual turf name
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w600,
              ),
            ),
            subtitle: Text(
              'Tap to view details',
              style: GoogleFonts.poppins(
                color: AppConstants.textSecondary,
              ),
            ),
            trailing: IconButton(
              onPressed: () {
                // Remove from favorites
                setState(() {
                  widget.user.favoriteTurfs.remove(turfId);
                });
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Removed from favorites'),
                    backgroundColor: AppConstants.successColor,
                  ),
                );
              },
              icon: const Icon(
                Icons.favorite,
                color: Colors.red,
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildSettingsTab() {
    return ListView(
      padding: const EdgeInsets.all(AppConstants.mediumPadding),
      children: [
        _buildSettingsItem(
          'Edit Profile',
          'Update your personal information',
          Icons.person,
          _editProfile,
        ),
        _buildSettingsItem(
          'Notification Settings',
          'Manage your notification preferences',
          Icons.notifications,
          () {},
        ),
        _buildSettingsItem(
          'Privacy Settings',
          'Control your privacy and data',
          Icons.privacy_tip,
          () {},
        ),
        _buildSettingsItem(
          'Help & Support',
          'Get help and contact support',
          Icons.help,
          () {},
        ),
        _buildSettingsItem(
          'About',
          'App version and information',
          Icons.info,
          () {},
        ),
        const Divider(),
        _buildSettingsItem(
          'Logout',
          'Sign out of your account',
          Icons.logout,
          _showLogoutDialog,
          isDestructive: true,
        ),
      ],
    );
  }

  Widget _buildSettingsItem(
    String title,
    String subtitle,
    IconData icon,
    VoidCallback onTap, {
    bool isDestructive = false,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: AppConstants.smallPadding),
      child: ListTile(
        leading: Icon(
          icon,
          color: isDestructive ? Colors.red : AppConstants.primaryColor,
        ),
        title: Text(
          title,
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
            color: isDestructive ? Colors.red : AppConstants.textPrimary,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: GoogleFonts.poppins(
            color: AppConstants.textSecondary,
          ),
        ),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: onTap,
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'confirmed':
        return AppConstants.successColor;
      case 'pending':
        return Colors.orange;
      case 'cancelled':
        return Colors.red;
      default:
        return AppConstants.textSecondary;
    }
  }

  void _editProfile() {
    // Implement profile editing
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Profile editing coming soon!'),
        backgroundColor: AppConstants.primaryColor,
      ),
    );
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Logout',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Text(
          'Are you sure you want to logout?',
          style: GoogleFonts.poppins(),
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
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              widget.onLogout();
            },
            child: Text(
              'Logout',
              style: GoogleFonts.poppins(
                color: Colors.red,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
