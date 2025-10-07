import 'package:flutter/material.dart';

class AppConstants {
  // App Information
  static const String appName = 'PitchUp';
  static const String appVersion = '1.0.0';
  
  // Colors
  static const Color primaryColor = Color(0xFF2E7D32);
  static const Color secondaryColor = Color(0xFF4CAF50);
  static const Color accentColor = Color(0xFF81C784);
  static const Color backgroundColor = Color(0xFFF5F5F5);
  static const Color surfaceColor = Colors.white;
  static const Color errorColor = Color(0xFFE53935);
  static const Color warningColor = Color(0xFFFF9800);
  static const Color successColor = Color(0xFF4CAF50);
  
  // Text Colors
  static const Color textPrimary = Color(0xFF212121);
  static const Color textSecondary = Color(0xFF757575);
  static const Color textHint = Color(0xFFBDBDBD);
  
  // Sports Types
  static const List<String> sportsTypes = [
    'Football',
    'Cricket',
    'Tennis',
    'Badminton',
    'Basketball',
    'Volleyball',
    'Hockey',
    'Baseball',
    'Rugby',
    'Squash',
  ];
  
  // Booking Status
  static const String bookingPending = 'pending';
  static const String bookingConfirmed = 'confirmed';
  static const String bookingCancelled = 'cancelled';
  static const String bookingCompleted = 'completed';
  
  // Payment Status
  static const String paymentPending = 'pending';
  static const String paymentPaid = 'paid';
  static const String paymentRefunded = 'refunded';
  
  // User Roles
  static const String userRole = 'user';
  static const String ownerRole = 'owner';
  
  // Time Slots
  static const List<String> timeSlots = [
    '06:00 AM', '07:00 AM', '08:00 AM', '09:00 AM', '10:00 AM',
    '11:00 AM', '12:00 PM', '01:00 PM', '02:00 PM', '03:00 PM',
    '04:00 PM', '05:00 PM', '06:00 PM', '07:00 PM', '08:00 PM',
    '09:00 PM', '10:00 PM', '11:00 PM'
  ];
  
  // Amenities
  static const List<String> amenities = [
    'Parking',
    'Changing Room',
    'Shower',
    'Water Facility',
    'Lighting',
    'Seating Area',
    'First Aid',
    'Equipment Rental',
    'Refreshments',
    'WiFi',
  ];
  
  // Firebase Collections
  static const String usersCollection = 'users';
  static const String turfsCollection = 'turfs';
  static const String bookingsCollection = 'bookings';
  static const String reviewsCollection = 'reviews';
  
  // Image Placeholders
  static const String defaultTurfImage = 'https://via.placeholder.com/400x300/4CAF50/FFFFFF?text=Turf+Image';
  static const String defaultProfileImage = 'https://via.placeholder.com/150x150/757575/FFFFFF?text=User';
  
  // Responsive Breakpoints
  static const double mobileBreakpoint = 600;
  static const double tabletBreakpoint = 900;
  static const double desktopBreakpoint = 1200;
  
  // Animation Durations
  static const Duration shortAnimation = Duration(milliseconds: 200);
  static const Duration mediumAnimation = Duration(milliseconds: 300);
  static const Duration longAnimation = Duration(milliseconds: 500);
  
  // Padding and Margins
  static const double smallPadding = 8.0;
  static const double mediumPadding = 16.0;
  static const double largePadding = 24.0;
  static const double extraLargePadding = 32.0;
  
  // Border Radius
  static const double smallRadius = 8.0;
  static const double mediumRadius = 12.0;
  static const double largeRadius = 16.0;
  static const double extraLargeRadius = 24.0;
}
