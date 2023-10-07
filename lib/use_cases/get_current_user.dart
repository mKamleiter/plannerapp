import 'package:firebase_auth/firebase_auth.dart';

Future<String?> getCurrentUserId() async {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  print("1");
  try {
    final user = _auth.currentUser;
    print("2");
    print(user?.uid);
    return user?.uid;
  } catch (error) {
    print("Error getting user ID: $error");
    return null;
  }
}
