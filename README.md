# PitchUp - Sports Turf Booking Platform

A modern, responsive web application built with Flutter Web and Firebase for booking sports turfs. Users can discover, view, and book sports turfs in their preferred location with a clean and intuitive interface.

## Features

- 🏟️ **Turf Discovery**: Browse and search for sports turfs by location and sport type
- 🔍 **Advanced Search**: Filter turfs by price range, amenities, and ratings
- 📱 **Responsive Design**: Works seamlessly across desktop, tablet, and mobile devices
- ⭐ **Rating System**: View ratings and reviews for each turf
- 🎯 **Real-time Data**: Firebase integration for live updates
- 🎨 **Modern UI**: Clean, attractive interface with smooth animations

## Tech Stack

- **Frontend**: Flutter Web
- **Backend**: Firebase (Firestore, Authentication, Storage)
- **State Management**: Provider
- **UI Framework**: Material Design 3
- **Fonts**: Google Fonts (Poppins)
- **Images**: Cached Network Images

## Project Structure

```
lib/
├── constants/          # App constants and configuration
├── models/            # Data models (Turf, User, Booking, Review)
├── screens/           # Main application screens
├── services/          # Firebase and API services
├── utils/             # Utility functions and sample data
├── widgets/           # Reusable UI components
└── main.dart          # Application entry point
```

## Getting Started

### Prerequisites

- Flutter SDK (3.9.2 or higher)
- Dart SDK
- Firebase account (for production deployment)

### Installation

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd pitchup_app
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Firebase Setup** (Optional - for production)
   - Create a new Firebase project at [Firebase Console](https://console.firebase.google.com/)
   - Add a web app to your project
   - Copy the Firebase configuration
   - Update `lib/constants/firebase_config.dart` with your config
   - Uncomment Firebase initialization in `main.dart`

4. **Run the application**
   ```bash
   flutter run -d web-server --web-port 8080
   ```

5. **Open in browser**
   Navigate to `http://localhost:8080`

## Demo Data

The application comes with sample data for demonstration purposes. The sample data includes:

- 8 different sports turfs across Bangalore
- Various sports types (Football, Cricket, Tennis, Badminton, etc.)
- Realistic pricing and ratings
- Time slot availability
- Amenities and features

## Features Overview

### Welcome Screen
- Animated landing page with app introduction
- Modern gradient design
- Feature highlights
- Call-to-action button

### Main Discovery Screen
- Search functionality by location and sport
- Featured turfs carousel
- Nearby turfs section
- Interactive sport selection

### Results Screen
- Advanced search and filtering
- Sort by rating, price, or name
- Horizontal turf cards for better browsing
- Empty state handling

### Turf Cards
- High-quality images with caching
- Rating and review display
- Price information
- Quick booking buttons
- Responsive design (vertical/horizontal layouts)

## Customization

### Colors and Themes
Update `lib/constants/app_constants.dart` to customize:
- Primary and secondary colors
- Text colors
- Border radius values
- Padding and margin constants

### Sports Types
Add or modify sports types in the `sportsTypes` list in `app_constants.dart`.

### Sample Data
Modify `lib/utils/sample_data.dart` to add more sample turfs or change existing data.

## Firebase Integration

To enable full Firebase functionality:

1. **Authentication**
   - Enable Email/Password authentication in Firebase Console
   - Uncomment authentication methods in `firebase_service.dart`

2. **Firestore Database**
   - Create Firestore database
   - Set up collections: `users`, `turfs`, `bookings`, `reviews`
   - Uncomment Firestore methods in `firebase_service.dart`

3. **Storage**
   - Enable Firebase Storage
   - Uncomment storage methods in `firebase_service.dart`

## Deployment

### Web Deployment

1. **Build for production**
   ```bash
   flutter build web --release
   ```

2. **Deploy to Firebase Hosting**
   ```bash
   firebase init hosting
   firebase deploy
   ```

3. **Deploy to other platforms**
   - Copy the `build/web` folder to your web server
   - Configure your server to serve the Flutter web app

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test thoroughly
5. Submit a pull request

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Support

For support and questions:
- Create an issue in the repository
- Contact the development team

## Future Enhancements

- [ ] User authentication and profiles
- [ ] Booking management system
- [ ] Payment integration
- [ ] Real-time notifications
- [ ] Mobile app versions
- [ ] Advanced filtering options
- [ ] Map integration for location-based search
- [ ] Review and rating system
- [ ] Admin dashboard for turf owners

---

Built with ❤️ using Flutter Web and Firebase