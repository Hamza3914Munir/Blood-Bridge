import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hive/hive.dart';
import '../common/hive_boxes.dart';
import '../services/notification_service.dart';

class DonationTrackingHelper {
  static const String LAST_DONATION_KEY = 'last_donation_date';

  // Call this method when user marks a blood request as fulfilled (meaning they donated)
  static Future<void> recordDonation() async {
    try {
      final now = DateTime.now();
      final user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        // Store in Firestore
        await FirebaseFirestore.instance
            .collection('user_donations')
            .doc(user.uid)
            .set({
          'lastDonationDate': Timestamp.fromDate(now),
          'donationHistory': FieldValue.arrayUnion([Timestamp.fromDate(now)]),
        }, SetOptions(merge: true));

        // Store locally in Hive
        final box = Hive.box(ConfigBox.key);
        box.put(LAST_DONATION_KEY, now.millisecondsSinceEpoch);

        // Schedule next reminder notification (6 months from now)
        await NotificationService().updateDonationReminder(now);
      }
    } catch (e) {
      print('Error recording donation: $e');
    }
  }

  // Get last donation date
  static DateTime? getLastDonationDate() {
    final box = Hive.box(ConfigBox.key);
    final timestamp = box.get(LAST_DONATION_KEY);
    if (timestamp != null) {
      return DateTime.fromMillisecondsSinceEpoch(timestamp as int);
    }
    return null;
  }

  // Check if user is eligible to donate (6 months have passed)
  static bool isEligibleToDonate() {
    final lastDonation = getLastDonationDate();
    if (lastDonation == null) return true; // Never donated before

    final sixMonthsAgo = DateTime.now().subtract(const Duration(days: 180));
    return lastDonation.isBefore(sixMonthsAgo);
  }

  // Get days remaining until eligible
  static int getDaysUntilEligible() {
    final lastDonation = getLastDonationDate();
    if (lastDonation == null) return 0; // Never donated before

    final eligibleDate = lastDonation.add(const Duration(days: 180));
    final now = DateTime.now();

    if (eligibleDate.isBefore(now)) return 0; // Already eligible

    return eligibleDate.difference(now).inDays;
  }

  // Initialize donation tracking for existing users
  static Future<void> initializeDonationTracking() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        // Try to get last donation from Firestore
        final doc = await FirebaseFirestore.instance
            .collection('user_donations')
            .doc(user.uid)
            .get();

        if (doc.exists && doc.data() != null) {
          final data = doc.data()!;
          if (data['lastDonationDate'] != null) {
            final lastDonation = (data['lastDonationDate'] as Timestamp).toDate();

            // Store locally
            final box = Hive.box(ConfigBox.key);
            box.put(LAST_DONATION_KEY, lastDonation.millisecondsSinceEpoch);

            // Schedule notification if needed
            if (!isEligibleToDonate()) {
              await NotificationService().scheduleDonationReminder(lastDonation);
            }
          }
        }
      }
    } catch (e) {
      print('Error initializing donation tracking: $e');
    }
  }
}