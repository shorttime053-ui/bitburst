import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'constants/app_constants.dart';
import 'constants/app_theme.dart';
import 'screens/splash_screen.dart';
import 'screens/main_navigation_screen.dart';
import 'models/user.dart';
import 'models/turf.dart';
import 'models/booking.dart';
import 'screens/notifications_screen.dart';
import 'utils/sample_data.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Firebase
  // Note: You need to add your Firebase configuration here
  // await Firebase.initializeApp(
  //   options: DefaultFirebaseOptions.currentPlatform,
  // );
  
  runApp(const PitchUpApp());
}

class PitchUpApp extends StatelessWidget {
  const PitchUpApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AppState()),
      ],
      child: MaterialApp(
        title: AppConstants.appName,
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        home: const SplashScreen(),
        routes: {
          '/main': (context) => MainNavigationScreen(
            currentUser: User(
              id: 'user1',
              email: 'user@example.com',
              name: 'John Doe',
              phoneNumber: '+1234567890',
              role: 'user',
              createdAt: DateTime.now(),
              updatedAt: DateTime.now(),
              favoriteTurfs: [],
              isActive: true,
              preferences: {},
            ),
            favoriteTurfs: [],
            userBookings: [],
            notifications: [],
          ),
        },
      ),
    );
  }
}

class AppState extends ChangeNotifier {
  
  User? _currentUser;
  List<Turf> _favoriteTurfs = [];
  List<Booking> _userBookings = [];
  List<NotificationItem> _notifications = [];
  bool _isLoading = false;

  User? get currentUser => _currentUser;
  List<Turf> get favoriteTurfs => _favoriteTurfs;
  List<Booking> get userBookings => _userBookings;
  List<NotificationItem> get notifications => _notifications;
  bool get isLoading => _isLoading;

  Future<void> initializeApp() async {
    _setLoading(true);
    
    try {
      // Initialize sample data
      await _loadSampleData();
      
      // Set default user
      _currentUser = User(
        id: 'user1',
        email: 'user@example.com',
        name: 'John Doe',
        phoneNumber: '+1234567890',
        role: 'user',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        favoriteTurfs: [],
        isActive: true,
        preferences: {},
      );
      
      // Load notifications
      await _loadNotifications();
      
    } catch (e) {
      print('Error initializing app: $e');
    } finally {
      _setLoading(false);
    }
  }

  Future<void> _loadSampleData() async {
    try {
      final turfs = SampleDataGenerator.generateSampleTurfs();
      // Set some turfs as favorites for demo
      _favoriteTurfs = turfs.take(3).toList();
      
      // Generate sample bookings
      _userBookings = [
        Booking(
          id: 'booking1',
          userId: 'user1',
          turfId: turfs[0].id,
          turfName: turfs[0].name,
          startTime: DateTime.now().add(const Duration(days: 1)),
          endTime: DateTime.now().add(const Duration(days: 1, hours: 2)),
          totalPrice: turfs[0].pricePerHour * 2,
          status: 'confirmed',
          paymentStatus: 'paid',
          bookingDetails: {
            'duration': 2,
            'rate': turfs[0].pricePerHour,
          },
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        ),
        Booking(
          id: 'booking2',
          userId: 'user1',
          turfId: turfs[1].id,
          turfName: turfs[1].name,
          startTime: DateTime.now().add(const Duration(days: 3)),
          endTime: DateTime.now().add(const Duration(days: 3, hours: 1)),
          totalPrice: turfs[1].pricePerHour,
          status: 'pending',
          paymentStatus: 'pending',
          bookingDetails: {
            'duration': 1,
            'rate': turfs[1].pricePerHour,
          },
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        ),
      ];
    } catch (e) {
      print('Error loading sample data: $e');
    }
  }

  Future<void> _loadNotifications() async {
    _notifications = [
      NotificationItem(
        id: 'notif1',
        title: 'Booking Confirmed',
        message: 'Your booking at Green Valley Sports Complex has been confirmed.',
        timestamp: DateTime.now().subtract(const Duration(hours: 2)),
        type: 'booking',
        data: {'bookingId': 'booking1'},
      ),
      NotificationItem(
        id: 'notif2',
        title: 'Special Offer',
        message: 'Get 20% off on your next booking! Use code SAVE20',
        timestamp: DateTime.now().subtract(const Duration(days: 1)),
        type: 'promotion',
        data: {'promoCode': 'SAVE20'},
      ),
      NotificationItem(
        id: 'notif3',
        title: 'App Update',
        message: 'New features added! Check out the improved search functionality.',
        timestamp: DateTime.now().subtract(const Duration(days: 2)),
        type: 'system',
        isRead: true,
      ),
    ];
  }

  void addToFavorites(Turf turf) {
    if (!_favoriteTurfs.any((t) => t.id == turf.id)) {
      _favoriteTurfs.add(turf);
      _currentUser?.favoriteTurfs.add(turf.id);
      notifyListeners();
    }
  }

  void removeFromFavorites(Turf turf) {
    _favoriteTurfs.removeWhere((t) => t.id == turf.id);
    _currentUser?.favoriteTurfs.remove(turf.id);
    notifyListeners();
  }

  void addBooking(Booking booking) {
    _userBookings.add(booking);
    notifyListeners();
  }

  void updateBookingStatus(String bookingId, String status) {
    final bookingIndex = _userBookings.indexWhere((b) => b.id == bookingId);
    if (bookingIndex != -1) {
      _userBookings[bookingIndex] = Booking(
        id: _userBookings[bookingIndex].id,
        userId: _userBookings[bookingIndex].userId,
        turfId: _userBookings[bookingIndex].turfId,
        turfName: _userBookings[bookingIndex].turfName,
        startTime: _userBookings[bookingIndex].startTime,
        endTime: _userBookings[bookingIndex].endTime,
        totalPrice: _userBookings[bookingIndex].totalPrice,
        status: status,
        paymentStatus: _userBookings[bookingIndex].paymentStatus,
        bookingDetails: _userBookings[bookingIndex].bookingDetails,
        notes: _userBookings[bookingIndex].notes,
        createdAt: _userBookings[bookingIndex].createdAt,
        updatedAt: DateTime.now(),
      );
      notifyListeners();
    }
  }

  void markNotificationAsRead(NotificationItem notification) {
    final index = _notifications.indexWhere((n) => n.id == notification.id);
    if (index != -1) {
      _notifications[index] = NotificationItem(
        id: notification.id,
        title: notification.title,
        message: notification.message,
        timestamp: notification.timestamp,
        isRead: true,
        type: notification.type,
        data: notification.data,
      );
      notifyListeners();
    }
  }

  void addNotification(NotificationItem notification) {
    _notifications.insert(0, notification);
    notifyListeners();
  }

  void updateUserProfile(User user) {
    _currentUser = user;
    notifyListeners();
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }
}
