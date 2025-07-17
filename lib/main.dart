import 'package:blood_bridge/screens/history_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'common/colors.dart';
import 'common/hive_boxes.dart';
import 'common/styles.dart';
import 'firebase_options.dart';
import 'screens/add_blood_request_screen.dart';
import 'screens/add_news_item.dart';
import 'screens/chat_screen.dart';
import 'screens/edit_profile_screen.dart';
import 'screens/home_screen.dart';
import 'screens/login_screen.dart';
import 'screens/news_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/registration_screen.dart';
import 'screens/splash_screen.dart';
import 'screens/tutorial_screen.dart';
import 'screens/who_can_donate_screen.dart';
import 'services/notification_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Hive
  await Hive.initFlutter();
  await Hive.openBox(ConfigBox.key);

  // Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Initialize Notification Service
  await NotificationService().initialize();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Blood Donation',
      theme: ThemeData(
        primarySwatch: MainColors.swatch,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        fontFamily: Fonts.text,
      ),
      initialRoute: SplashScreen.route,
      routes: {
        HomeScreen.route: (_) => const HomeScreen(),
        HistoryScreen.route: (_) => const HistoryScreen(),
        TutorialScreen.route: (_) => const TutorialScreen(),
        LoginScreen.route: (_) => const LoginScreen(),
        RegistrationScreen.route: (_) => const RegistrationScreen(),
        SplashScreen.route: (_) => const SplashScreen(),
        ProfileScreen.route: (_) => const ProfileScreen(),
        WhoCanDonateScreen.route: (_) => const WhoCanDonateScreen(),
        AddBloodRequestScreen.route: (_) => const AddBloodRequestScreen(),
        NewsScreen.route: (_) => const NewsScreen(),
        AddNewsItem.route: (_) => const AddNewsItem(),
        EditProfileScreen.route: (_) => const EditProfileScreen(),
        ChatScreen.route: (_) => const ChatScreen(), // Added chat screen route
      },
    );
  }
}