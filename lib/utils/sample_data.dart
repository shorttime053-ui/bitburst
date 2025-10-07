import '../models/turf.dart';

class SampleDataGenerator {
  static List<Turf> generateSampleTurfs() {
    final now = DateTime.now();
    
    return [
      Turf(
        id: '1',
        name: 'Green Valley Sports Complex',
        description: 'Premium football turf with professional-grade grass and modern facilities.',
        location: 'Koramangala, Bangalore',
        latitude: 12.9352,
        longitude: 77.6245,
        pricePerHour: 1200.0,
        images: [
          'https://images.unsplash.com/photo-1574629810360-7efbbe195018?w=400',
          'https://images.unsplash.com/photo-1571019613454-1cb2f99b2d8b?w=400',
        ],
        sports: ['Football', 'Cricket'],
        availableSlots: _generateTimeSlots(now),
        rating: 4.8,
        reviewCount: 127,
        ownerId: 'owner1',
        amenities: {
          'Parking': true,
          'Changing Room': true,
          'Shower': true,
          'Water Facility': true,
          'Lighting': true,
          'Seating Area': true,
        },
        isActive: true,
        createdAt: now.subtract(const Duration(days: 30)),
        updatedAt: now,
      ),
      
      Turf(
        id: '2',
        name: 'Royal Cricket Ground',
        description: 'Professional cricket ground with excellent pitch conditions.',
        location: 'Indiranagar, Bangalore',
        latitude: 12.9716,
        longitude: 77.6412,
        pricePerHour: 1500.0,
        images: [
          'https://images.unsplash.com/photo-1540747913346-19e32dc3e97e?w=400',
          'https://images.unsplash.com/photo-1574629810360-7efbbe195018?w=400',
        ],
        sports: ['Cricket', 'Football'],
        availableSlots: _generateTimeSlots(now),
        rating: 4.6,
        reviewCount: 89,
        ownerId: 'owner2',
        amenities: {
          'Parking': true,
          'Changing Room': true,
          'Shower': true,
          'Water Facility': true,
          'Lighting': true,
          'Seating Area': true,
          'First Aid': true,
        },
        isActive: true,
        createdAt: now.subtract(const Duration(days: 45)),
        updatedAt: now,
      ),
      
      Turf(
        id: '3',
        name: 'Sports Hub Arena',
        description: 'Multi-sport facility with tennis, badminton, and basketball courts.',
        location: 'Whitefield, Bangalore',
        latitude: 12.9698,
        longitude: 77.7500,
        pricePerHour: 800.0,
        images: [
          'https://images.unsplash.com/photo-1551698618-1dfe5d97d256?w=400',
          'https://images.unsplash.com/photo-1571019613454-1cb2f99b2d8b?w=400',
        ],
        sports: ['Tennis', 'Badminton', 'Basketball'],
        availableSlots: _generateTimeSlots(now),
        rating: 4.4,
        reviewCount: 156,
        ownerId: 'owner3',
        amenities: {
          'Parking': true,
          'Changing Room': true,
          'Water Facility': true,
          'Lighting': true,
          'Equipment Rental': true,
        },
        isActive: true,
        createdAt: now.subtract(const Duration(days: 20)),
        updatedAt: now,
      ),
      
      Turf(
        id: '4',
        name: 'Elite Football Center',
        description: 'Modern football training facility with synthetic turf.',
        location: 'JP Nagar, Bangalore',
        latitude: 12.9063,
        longitude: 77.5857,
        pricePerHour: 1000.0,
        images: [
          'https://images.unsplash.com/photo-1574629810360-7efbbe195018?w=400',
          'https://images.unsplash.com/photo-1551698618-1dfe5d97d256?w=400',
        ],
        sports: ['Football'],
        availableSlots: _generateTimeSlots(now),
        rating: 4.7,
        reviewCount: 203,
        ownerId: 'owner4',
        amenities: {
          'Parking': true,
          'Changing Room': true,
          'Shower': true,
          'Water Facility': true,
          'Lighting': true,
          'Seating Area': true,
          'Refreshments': true,
        },
        isActive: true,
        createdAt: now.subtract(const Duration(days: 60)),
        updatedAt: now,
      ),
      
      Turf(
        id: '5',
        name: 'City Sports Complex',
        description: 'Comprehensive sports facility with multiple courts and grounds.',
        location: 'Marathahalli, Bangalore',
        latitude: 12.9584,
        longitude: 77.6996,
        pricePerHour: 900.0,
        images: [
          'https://images.unsplash.com/photo-1540747913346-19e32dc3e97e?w=400',
          'https://images.unsplash.com/photo-1551698618-1dfe5d97d256?w=400',
        ],
        sports: ['Volleyball', 'Basketball', 'Badminton'],
        availableSlots: _generateTimeSlots(now),
        rating: 4.3,
        reviewCount: 78,
        ownerId: 'owner5',
        amenities: {
          'Parking': true,
          'Changing Room': true,
          'Water Facility': true,
          'Lighting': true,
          'Seating Area': true,
          'WiFi': true,
        },
        isActive: true,
        createdAt: now.subtract(const Duration(days: 15)),
        updatedAt: now,
      ),
      
      Turf(
        id: '6',
        name: 'Premier Cricket Academy',
        description: 'Professional cricket training ground with coaching facilities.',
        location: 'Electronic City, Bangalore',
        latitude: 12.8456,
        longitude: 77.6603,
        pricePerHour: 1300.0,
        images: [
          'https://images.unsplash.com/photo-1540747913346-19e32dc3e97e?w=400',
          'https://images.unsplash.com/photo-1574629810360-7efbbe195018?w=400',
        ],
        sports: ['Cricket'],
        availableSlots: _generateTimeSlots(now),
        rating: 4.9,
        reviewCount: 145,
        ownerId: 'owner6',
        amenities: {
          'Parking': true,
          'Changing Room': true,
          'Shower': true,
          'Water Facility': true,
          'Lighting': true,
          'Seating Area': true,
          'First Aid': true,
          'Equipment Rental': true,
        },
        isActive: true,
        createdAt: now.subtract(const Duration(days: 90)),
        updatedAt: now,
      ),
      
      Turf(
        id: '7',
        name: 'Urban Sports Hub',
        description: 'Modern multi-sport facility in the heart of the city.',
        location: 'MG Road, Bangalore',
        latitude: 12.9716,
        longitude: 77.5946,
        pricePerHour: 1100.0,
        images: [
          'https://images.unsplash.com/photo-1551698618-1dfe5d97d256?w=400',
          'https://images.unsplash.com/photo-1540747913346-19e32dc3e97e?w=400',
        ],
        sports: ['Tennis', 'Squash', 'Badminton'],
        availableSlots: _generateTimeSlots(now),
        rating: 4.5,
        reviewCount: 92,
        ownerId: 'owner7',
        amenities: {
          'Parking': true,
          'Changing Room': true,
          'Shower': true,
          'Water Facility': true,
          'Lighting': true,
          'Refreshments': true,
          'WiFi': true,
        },
        isActive: true,
        createdAt: now.subtract(const Duration(days: 25)),
        updatedAt: now,
      ),
      
      Turf(
        id: '8',
        name: 'Community Sports Ground',
        description: 'Affordable sports facility for the local community.',
        location: 'Banashankari, Bangalore',
        latitude: 12.9255,
        longitude: 77.5468,
        pricePerHour: 600.0,
        images: [
          'https://images.unsplash.com/photo-1571019613454-1cb2f99b2d8b?w=400',
          'https://images.unsplash.com/photo-1551698618-1dfe5d97d256?w=400',
        ],
        sports: ['Football', 'Cricket', 'Volleyball'],
        availableSlots: _generateTimeSlots(now),
        rating: 4.2,
        reviewCount: 167,
        ownerId: 'owner8',
        amenities: {
          'Parking': true,
          'Water Facility': true,
          'Lighting': true,
          'Seating Area': true,
        },
        isActive: true,
        createdAt: now.subtract(const Duration(days: 40)),
        updatedAt: now,
      ),
    ];
  }

  static List<TimeSlot> _generateTimeSlots(DateTime baseDate) {
    final slots = <TimeSlot>[];
    final startHour = 6;
    final endHour = 22;
    
    for (int hour = startHour; hour < endHour; hour++) {
      final startTime = DateTime(baseDate.year, baseDate.month, baseDate.day, hour);
      final endTime = DateTime(baseDate.year, baseDate.month, baseDate.day, hour + 1);
      
      slots.add(TimeSlot(
        id: 'slot_${hour}_${baseDate.millisecondsSinceEpoch}',
        startTime: startTime,
        endTime: endTime,
        isAvailable: hour % 3 != 0, // Some slots are booked for demo
        bookedBy: hour % 3 == 0 ? 'user_${hour % 5}' : null,
      ));
    }
    
    return slots;
  }
}
