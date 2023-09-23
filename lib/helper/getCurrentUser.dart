  import 'package:firebase_auth/firebase_auth.dart';

Future<String?> getCurrentUserId(FirebaseAuth auth) async {
    try {
      final user = auth.currentUser;
      return user?.uid;
    } catch (error) {
      print("Error getting user ID: $error");
      return null;
    }
  }