import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants/app_constants.dart';

class NotificationItem {
  final String id;
  final String title;
  final String message;
  final DateTime timestamp;
  final bool isRead;
  final String type; // 'booking', 'promotion', 'system'
  final Map<String, dynamic>? data;

  NotificationItem({
    required this.id,
    required this.title,
    required this.message,
    required this.timestamp,
    this.isRead = false,
    required this.type,
    this.data,
  });
}

class NotificationScreen extends StatefulWidget {
  final List<NotificationItem> notifications;
  final Function(NotificationItem notification) onMarkAsRead;
  final Function(NotificationItem notification) onNotificationTap;

  const NotificationScreen({
    super.key,
    required this.notifications,
    required this.onMarkAsRead,
    required this.onNotificationTap,
  });

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  String _filterType = 'all';

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

  List<NotificationItem> get _filteredNotifications {
    if (_filterType == 'all') {
      return widget.notifications;
    }
    return widget.notifications.where((n) => n.type == _filterType).toList();
  }

  int get _unreadCount {
    return widget.notifications.where((n) => !n.isRead).length;
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final isMobile = screenSize.width < AppConstants.mobileBreakpoint;

    return Scaffold(
      backgroundColor: AppConstants.backgroundColor,
      appBar: AppBar(
        title: Text(
          'Notifications',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.white,
        foregroundColor: AppConstants.textPrimary,
        elevation: 0,
        actions: [
          if (_unreadCount > 0)
            Container(
              margin: const EdgeInsets.only(right: AppConstants.mediumPadding),
              padding: const EdgeInsets.symmetric(
                horizontal: AppConstants.smallPadding,
                vertical: 4,
              ),
              decoration: BoxDecoration(
                color: AppConstants.primaryColor,
                borderRadius: BorderRadius.circular(AppConstants.smallRadius),
              ),
              child: Text(
                '$_unreadCount',
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          PopupMenuButton<String>(
            onSelected: (value) {
              setState(() {
                _filterType = value;
              });
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'all',
                child: Text('All Notifications'),
              ),
              const PopupMenuItem(
                value: 'booking',
                child: Text('Booking Updates'),
              ),
              const PopupMenuItem(
                value: 'promotion',
                child: Text('Promotions'),
              ),
              const PopupMenuItem(
                value: 'system',
                child: Text('System Notifications'),
              ),
            ],
            icon: const Icon(Icons.filter_list),
          ),
        ],
      ),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: Column(
          children: [
            // Filter Bar
            if (widget.notifications.isNotEmpty)
              Container(
                padding: const EdgeInsets.all(AppConstants.mediumPadding),
                color: Colors.white,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _buildFilterChip('all', 'All'),
                      const SizedBox(width: AppConstants.smallPadding),
                      _buildFilterChip('booking', 'Bookings'),
                      const SizedBox(width: AppConstants.smallPadding),
                      _buildFilterChip('promotion', 'Promotions'),
                      const SizedBox(width: AppConstants.smallPadding),
                      _buildFilterChip('system', 'System'),
                    ],
                  ),
                ),
              ),

            // Notifications List
            Expanded(
              child: widget.notifications.isEmpty
                  ? _buildEmptyState()
                  : ListView.builder(
                      padding: EdgeInsets.all(
                        isMobile ? AppConstants.mediumPadding : AppConstants.largePadding,
                      ),
                      itemCount: _filteredNotifications.length,
                      itemBuilder: (context, index) {
                        final notification = _filteredNotifications[index];
                        return _buildNotificationItem(notification);
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterChip(String value, String label) {
    final isSelected = _filterType == value;
    return GestureDetector(
      onTap: () {
        setState(() {
          _filterType = value;
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

  Widget _buildNotificationItem(NotificationItem notification) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppConstants.mediumPadding),
      decoration: BoxDecoration(
        color: notification.isRead ? Colors.white : AppConstants.primaryColor.withOpacity(0.05),
        borderRadius: BorderRadius.circular(AppConstants.mediumRadius),
        border: notification.isRead 
            ? Border.all(color: Colors.grey[200]!)
            : Border.all(color: AppConstants.primaryColor.withOpacity(0.3)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(AppConstants.mediumPadding),
        leading: CircleAvatar(
          backgroundColor: _getNotificationColor(notification.type).withOpacity(0.1),
          child: Icon(
            _getNotificationIcon(notification.type),
            color: _getNotificationColor(notification.type),
          ),
        ),
        title: Text(
          notification.title,
          style: GoogleFonts.poppins(
            fontWeight: notification.isRead ? FontWeight.w500 : FontWeight.bold,
            color: AppConstants.textPrimary,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: AppConstants.smallPadding),
            Text(
              notification.message,
              style: GoogleFonts.poppins(
                color: AppConstants.textSecondary,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: AppConstants.smallPadding),
            Text(
              _formatTimestamp(notification.timestamp),
              style: GoogleFonts.poppins(
                color: AppConstants.textHint,
                fontSize: 12,
              ),
            ),
          ],
        ),
        trailing: notification.isRead
            ? null
            : Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                  color: AppConstants.primaryColor,
                  shape: BoxShape.circle,
                ),
              ),
        onTap: () {
          if (!notification.isRead) {
            widget.onMarkAsRead(notification);
          }
          widget.onNotificationTap(notification);
        },
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
              Icons.notifications_none,
              size: 80,
              color: Colors.grey[400],
            ),
            
            const SizedBox(height: AppConstants.largePadding),
            
            Text(
              'No Notifications',
              style: GoogleFonts.poppins(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppConstants.textSecondary,
              ),
            ),
            
            const SizedBox(height: AppConstants.mediumPadding),
            
            Text(
              'You\'re all caught up! New notifications will appear here.',
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

  IconData _getNotificationIcon(String type) {
    switch (type) {
      case 'booking':
        return Icons.calendar_today;
      case 'promotion':
        return Icons.local_offer;
      case 'system':
        return Icons.info;
      default:
        return Icons.notifications;
    }
  }

  Color _getNotificationColor(String type) {
    switch (type) {
      case 'booking':
        return AppConstants.primaryColor;
      case 'promotion':
        return Colors.orange;
      case 'system':
        return Colors.blue;
      default:
        return AppConstants.textSecondary;
    }
  }

  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inDays > 0) {
      return '${difference.inDays} day${difference.inDays > 1 ? 's' : ''} ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} hour${difference.inHours > 1 ? 's' : ''} ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} minute${difference.inMinutes > 1 ? 's' : ''} ago';
    } else {
      return 'Just now';
    }
  }
}
