import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '../models/turf.dart';
import '../models/user.dart' as app_user;
import '../models/booking.dart';
import '../models/review.dart';
import '../constants/app_constants.dart';
import '../utils/sample_data.dart';

class FirebaseService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static final FirebaseAuth _auth = FirebaseAuth.instance;
  static final FirebaseStorage _storage = FirebaseStorage.instance;

  // Auth Methods
  static Future<UserCredential?> signUpWithEmail(String email, String password, String name) async {
    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      
      // Update display name
      await credential.user?.updateDisplayName(name);
      
      // Create user document
      await createUserDocument(credential.user!.uid, email, name);
      
      return credential;
    } catch (e) {
      throw Exception('Sign up failed: $e');
    }
  }

  static Future<UserCredential?> signInWithEmail(String email, String password) async {
    try {
      return await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } catch (e) {
      throw Exception('Sign in failed: $e');
    }
  }

  static Future<void> signOut() async {
    await _auth.signOut();
  }

  static User? getCurrentUser() {
    return _auth.currentUser;
  }

  // User Methods
  static Future<void> createUserDocument(String uid, String email, String name) async {
    final user = app_user.User(
      id: uid,
      email: email,
      name: name,
      role: AppConstants.userRole,
      favoriteTurfs: [],
      preferences: {},
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      isActive: true,
    );

    await _firestore
        .collection(AppConstants.usersCollection)
        .doc(uid)
        .set(user.toMap());
  }

  static Future<app_user.User?> getUser(String uid) async {
    try {
      final doc = await _firestore
          .collection(AppConstants.usersCollection)
          .doc(uid)
          .get();
      
      if (doc.exists) {
        return app_user.User.fromMap(doc.data()!);
      }
      return null;
    } catch (e) {
      throw Exception('Failed to get user: $e');
    }
  }

  static Future<void> updateUser(app_user.User user) async {
    await _firestore
        .collection(AppConstants.usersCollection)
        .doc(user.id)
        .update(user.toMap());
  }

  // Turf Methods
  static Future<List<Turf>> getTurfs() async {
    try {
      // For demo purposes, return sample data
      // In production, this would fetch from Firestore
      await Future.delayed(const Duration(seconds: 1)); // Simulate network delay
      
      // Import sample data generator
      final sampleData = await _getSampleTurfs();
      return sampleData;
      
      // Uncomment below for actual Firebase integration
      /*
      final querySnapshot = await _firestore
          .collection(AppConstants.turfsCollection)
          .where('isActive', isEqualTo: true)
          .orderBy('rating', descending: true)
          .get();

      return querySnapshot.docs
          .map((doc) => Turf.fromMap({...doc.data(), 'id': doc.id}))
          .toList();
      */
    } catch (e) {
      throw Exception('Failed to get turfs: $e');
    }
  }

  static Future<List<Turf>> _getSampleTurfs() async {
    return SampleDataGenerator.generateSampleTurfs();
  }

  static Future<List<Turf>> searchTurfs({
    String? location,
    String? sport,
    double? minPrice,
    double? maxPrice,
  }) async {
    try {
      // For demo purposes, filter sample data
      await Future.delayed(const Duration(milliseconds: 500)); // Simulate network delay
      
      final allTurfs = await _getSampleTurfs();
      List<Turf> filteredTurfs = allTurfs;

      // Apply filters
      if (location != null && location.isNotEmpty) {
        filteredTurfs = filteredTurfs.where((turf) =>
            turf.location.toLowerCase().contains(location.toLowerCase())).toList();
      }

      if (sport != null && sport.isNotEmpty) {
        filteredTurfs = filteredTurfs.where((turf) =>
            turf.sports.contains(sport)).toList();
      }

      if (minPrice != null) {
        filteredTurfs = filteredTurfs.where((turf) =>
            turf.pricePerHour >= minPrice).toList();
      }

      if (maxPrice != null) {
        filteredTurfs = filteredTurfs.where((turf) =>
            turf.pricePerHour <= maxPrice).toList();
      }

      return filteredTurfs;
      
      // Uncomment below for actual Firebase integration
      /*
      Query query = _firestore
          .collection(AppConstants.turfsCollection)
          .where('isActive', isEqualTo: true);

      if (location != null && location.isNotEmpty) {
        query = query.where('location', isGreaterThanOrEqualTo: location)
                    .where('location', isLessThan: location + '\uf8ff');
      }

      if (sport != null && sport.isNotEmpty) {
        query = query.where('sports', arrayContains: sport);
      }

      if (minPrice != null) {
        query = query.where('pricePerHour', isGreaterThanOrEqualTo: minPrice);
      }

      if (maxPrice != null) {
        query = query.where('pricePerHour', isLessThanOrEqualTo: maxPrice);
      }

      final querySnapshot = await query.get();

      return querySnapshot.docs
          .map((doc) => Turf.fromMap({...doc.data(), 'id': doc.id}))
          .toList();
      */
    } catch (e) {
      throw Exception('Failed to search turfs: $e');
    }
  }

  static Future<Turf?> getTurf(String turfId) async {
    try {
      final doc = await _firestore
          .collection(AppConstants.turfsCollection)
          .doc(turfId)
          .get();
      
      if (doc.exists) {
        return Turf.fromMap({...doc.data()!, 'id': doc.id});
      }
      return null;
    } catch (e) {
      throw Exception('Failed to get turf: $e');
    }
  }

  // Booking Methods
  static Future<String> createBooking(Booking booking) async {
    try {
      final docRef = await _firestore
          .collection(AppConstants.bookingsCollection)
          .add(booking.toMap());
      
      return docRef.id;
    } catch (e) {
      throw Exception('Failed to create booking: $e');
    }
  }

  static Future<List<Booking>> getUserBookings(String userId) async {
    try {
      final querySnapshot = await _firestore
          .collection(AppConstants.bookingsCollection)
          .where('userId', isEqualTo: userId)
          .orderBy('createdAt', descending: true)
          .get();

      return querySnapshot.docs
          .map((doc) => Booking.fromMap({...doc.data(), 'id': doc.id}))
          .toList();
    } catch (e) {
      throw Exception('Failed to get user bookings: $e');
    }
  }

  static Future<void> updateBookingStatus(String bookingId, String status) async {
    await _firestore
        .collection(AppConstants.bookingsCollection)
        .doc(bookingId)
        .update({
      'status': status,
      'updatedAt': DateTime.now().millisecondsSinceEpoch,
    });
  }

  // Review Methods
  static Future<String> createReview(Review review) async {
    try {
      final docRef = await _firestore
          .collection(AppConstants.reviewsCollection)
          .add(review.toMap());
      
      // Update turf rating
      await _updateTurfRating(review.turfId);
      
      return docRef.id;
    } catch (e) {
      throw Exception('Failed to create review: $e');
    }
  }

  static Future<List<Review>> getTurfReviews(String turfId) async {
    try {
      final querySnapshot = await _firestore
          .collection(AppConstants.reviewsCollection)
          .where('turfId', isEqualTo: turfId)
          .orderBy('createdAt', descending: true)
          .get();

      return querySnapshot.docs
          .map((doc) => Review.fromMap({...doc.data(), 'id': doc.id}))
          .toList();
    } catch (e) {
      throw Exception('Failed to get turf reviews: $e');
    }
  }

  static Future<void> _updateTurfRating(String turfId) async {
    try {
      final reviewsSnapshot = await _firestore
          .collection(AppConstants.reviewsCollection)
          .where('turfId', isEqualTo: turfId)
          .get();

      if (reviewsSnapshot.docs.isNotEmpty) {
        double totalRating = 0;
        for (var doc in reviewsSnapshot.docs) {
          totalRating += doc.data()['rating'];
        }
        double averageRating = totalRating / reviewsSnapshot.docs.length;

        await _firestore
            .collection(AppConstants.turfsCollection)
            .doc(turfId)
            .update({
          'rating': averageRating,
          'reviewCount': reviewsSnapshot.docs.length,
          'updatedAt': DateTime.now().millisecondsSinceEpoch,
        });
      }
    } catch (e) {
      throw Exception('Failed to update turf rating: $e');
    }
  }

  // Storage Methods
  static Future<String> uploadImage(String path, Uint8List imageBytes) async {
    try {
      final ref = _storage.ref().child(path);
      final uploadTask = ref.putData(imageBytes);
      final snapshot = await uploadTask;
      return await snapshot.ref.getDownloadURL();
    } catch (e) {
      throw Exception('Failed to upload image: $e');
    }
  }

  static Future<void> deleteImage(String url) async {
    try {
      final ref = _storage.refFromURL(url);
      await ref.delete();
    } catch (e) {
      throw Exception('Failed to delete image: $e');
    }
  }
}
