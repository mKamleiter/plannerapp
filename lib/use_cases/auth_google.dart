import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();

  Future<User?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleSignInAccount = await googleSignIn.signIn();

      if (googleSignInAccount != null) {
        final GoogleSignInAuthentication googleSignInAuthentication = await googleSignInAccount.authentication;

        final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleSignInAuthentication.accessToken,
          idToken: googleSignInAuthentication.idToken,
        );

        final UserCredential authResult = await _auth.signInWithCredential(credential);
        final User? user = authResult.user;

        if (user != null) {
          // Benutzer in Firestore speichern
          final usersRef = FirebaseFirestore.instance.collection('users');
          final userDocument = usersRef.doc(user.uid);

          if (!(await userDocument.get()).exists) {
            await userDocument.set({
              'uid': user.uid,
              'email': user.email,
              'displayName': user.displayName,
              // ... Sie können hier weitere Felder hinzufügen
            });
          }

          return user;
        }
      }
    } catch (error) {
      print(error);
      return null;
    }
  }
}
