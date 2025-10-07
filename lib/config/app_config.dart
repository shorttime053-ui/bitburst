class AppConfig {
  // App Information
  static const String appName = 'PitchUp';
  static const String appVersion = '1.0.0';
  static const String appDescription = 'A location-based turf booking platform for sports enthusiasts';
  
  // Environment Configuration
  static const bool isProduction = false;
  static const bool enableLogging = true;
  static const bool enableAnalytics = false;
  
  // API Configuration
  static const String baseUrl = 'https://api.pitchup.com';
  static const int timeoutDuration = 30; // seconds
  
  // Firebase Configuration
  static const bool useFirebase = false; // Set to true when Firebase is configured
  static const String firebaseProjectId = 'pitchup-app';
  
  // Feature Flags
  static const bool enableUserAuthentication = false;
  static const bool enablePushNotifications = false;
  static const bool enablePaymentProcessing = false;
  static const bool enableRealTimeBooking = false;
  
  // UI Configuration
  static const bool enableDarkMode = false;
  static const bool enableAnimations = true;
  static const double animationDuration = 300.0; // milliseconds
  
  // Sample Data Configuration
  static const bool useSampleData = true;
  static const int sampleDataDelay = 1000; // milliseconds
  
  // Development Configuration
  static const bool showDebugInfo = true;
  static const bool enableHotReload = true;
  
  // Production Configuration
  static const String supportEmail = 'support@pitchup.com';
  static const String privacyPolicyUrl = 'https://pitchup.com/privacy';
  static const String termsOfServiceUrl = 'https://pitchup.com/terms';
  
  // Social Media Links
  static const String facebookUrl = 'https://facebook.com/pitchup';
  static const String twitterUrl = 'https://twitter.com/pitchup';
  static const String instagramUrl = 'https://instagram.com/pitchup';
  
  // App Store Links
  static const String playStoreUrl = 'https://play.google.com/store/apps/details?id=com.pitchup.app';
  static const String appStoreUrl = 'https://apps.apple.com/app/pitchup/id123456789';
  
  // Contact Information
  static const String companyName = 'PitchUp Technologies';
  static const String companyAddress = '123 Sports Street, Bangalore, India';
  static const String companyPhone = '+91 9876543210';
  
  // Legal Information
  static const String copyrightYear = '2024';
  static const String licenseType = 'MIT';
  
  // Performance Configuration
  static const int maxImageCacheSize = 100; // MB
  static const int maxNetworkRetries = 3;
  static const int networkTimeout = 10; // seconds
  
  // Security Configuration
  static const bool enableSSL = true;
  static const bool enableDataEncryption = false;
  static const bool enableBiometricAuth = false;
  
  // Analytics Configuration
  static const String googleAnalyticsId = 'GA-XXXXXXXXX';
  static const String firebaseAnalyticsId = 'FA-XXXXXXXXX';
  
  // Error Reporting
  static const bool enableCrashReporting = false;
  static const String crashlyticsApiKey = 'CRASHLYTICS_API_KEY';
  
  // Payment Configuration
  static const String stripePublishableKey = 'pk_test_XXXXXXXXX';
  static const String razorpayKeyId = 'rzp_test_XXXXXXXXX';
  
  // Map Configuration
  static const String googleMapsApiKey = 'GOOGLE_MAPS_API_KEY';
  static const String mapboxApiKey = 'MAPBOX_API_KEY';
  
  // Notification Configuration
  static const String fcmServerKey = 'FCM_SERVER_KEY';
  static const String onesignalAppId = 'ONESIGNAL_APP_ID';
  
  // File Upload Configuration
  static const int maxFileSize = 10; // MB
  static const List<String> allowedImageTypes = ['jpg', 'jpeg', 'png', 'webp'];
  static const List<String> allowedDocumentTypes = ['pdf', 'doc', 'docx'];
  
  // Cache Configuration
  static const int cacheExpirationTime = 3600; // seconds (1 hour)
  static const int maxCacheSize = 50; // MB
  
  // Rate Limiting
  static const int maxRequestsPerMinute = 60;
  static const int maxBookingsPerUser = 10; // per day
  
  // Business Rules
  static const int minBookingAdvanceTime = 1; // hours
  static const int maxBookingAdvanceTime = 30; // days
  static const int bookingCancellationTime = 2; // hours before booking
  
  // Default Values
  static const double defaultLatitude = 12.9716; // Bangalore
  static const double defaultLongitude = 77.5946;
  static const String defaultCurrency = 'INR';
  static const String defaultLanguage = 'en';
  static const String defaultCountry = 'IN';
  
  // Validation Rules
  static const int minPasswordLength = 8;
  static const int maxPasswordLength = 50;
  static const int minPhoneNumberLength = 10;
  static const int maxPhoneNumberLength = 15;
  
  // UI Limits
  static const int maxSearchResults = 50;
  static const int maxFeaturedTurfs = 6;
  static const int maxNearbyTurfs = 4;
  static const int maxReviewsPerPage = 10;
  
  // Time Configuration
  static const int businessStartHour = 6; // 6 AM
  static const int businessEndHour = 22; // 10 PM
  static const int slotDurationMinutes = 60;
  
  // Rating Configuration
  static const double minRating = 1.0;
  static const double maxRating = 5.0;
  static const int minReviewLength = 10;
  static const int maxReviewLength = 500;
  
  // Price Configuration
  static const double minPricePerHour = 100.0;
  static const double maxPricePerHour = 5000.0;
  static const double defaultPricePerHour = 1000.0;
  
  // Distance Configuration
  static const double maxSearchRadius = 50.0; // kilometers
  static const double defaultSearchRadius = 10.0; // kilometers
  
  // Image Configuration
  static const int maxImagesPerTurf = 10;
  static const int thumbnailSize = 200; // pixels
  static const int fullImageSize = 800; // pixels
  
  // Notification Configuration
  static const int notificationRetentionDays = 30;
  static const bool enableEmailNotifications = false;
  static const bool enableSmsNotifications = false;
  
  // Backup Configuration
  static const bool enableAutoBackup = false;
  static const int backupFrequencyDays = 7;
  static const String backupStorageProvider = 'firebase'; // firebase, aws, gcp
  
  // Monitoring Configuration
  static const bool enablePerformanceMonitoring = false;
  static const bool enableErrorMonitoring = false;
  static const bool enableUserBehaviorTracking = false;
  
  // A/B Testing Configuration
  static const bool enableABTesting = false;
  static const String abTestGroup = 'control'; // control, variant_a, variant_b
  
  // Localization Configuration
  static const List<String> supportedLanguages = ['en', 'hi', 'ta', 'te'];
  static const String defaultLocale = 'en_US';
  
  // Accessibility Configuration
  static const bool enableAccessibilityFeatures = true;
  static const bool enableScreenReader = true;
  static const bool enableHighContrast = false;
  
  // Offline Configuration
  static const bool enableOfflineMode = false;
  static const int offlineDataRetentionDays = 7;
  
  // Integration Configuration
  static const bool enableGoogleSignIn = false;
  static const bool enableFacebookSignIn = false;
  static const bool enableAppleSignIn = false;
  
  // Web Configuration
  static const bool enablePWA = true;
  static const String pwaName = 'PitchUp';
  static const String pwaShortName = 'PitchUp';
  static const String pwaDescription = 'Book sports turfs easily';
  static const String pwaThemeColor = '#2E7D32';
  static const String pwaBackgroundColor = '#FFFFFF';
  
  // Mobile Configuration
  static const bool enableDeepLinking = false;
  static const String deepLinkScheme = 'pitchup';
  static const String universalLinkDomain = 'pitchup.com';
  
  // Security Headers
  static const Map<String, String> securityHeaders = {
    'X-Content-Type-Options': 'nosniff',
    'X-Frame-Options': 'DENY',
    'X-XSS-Protection': '1; mode=block',
    'Strict-Transport-Security': 'max-age=31536000; includeSubDomains',
  };
  
  // Environment Variables
  static const Map<String, String> environmentVariables = {
    'NODE_ENV': 'development',
    'FLUTTER_ENV': 'development',
    'DEBUG': 'true',
  };
}
