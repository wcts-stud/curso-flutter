import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Stream<FirebaseUser> get user {
    return _firebaseAuth.onAuthStateChanged;
  }

  Future<FirebaseUser> googleSignIn() async {
    try {
      final GoogleSignInAccount googleSignInAccount = await _googleSignIn.signIn();
      final GoogleSignInAuthentication googleSignInAuthentication = await 
        googleSignInAccount.authentication;

      final AuthCredential authCredential = GoogleAuthProvider.getCredential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken
      );

      final FirebaseUser firebaseUser = 
        (await _firebaseAuth.signInWithCredential(authCredential)).user;

      return firebaseUser;
    } catch (error) {
      print(error);

      return null;
    }
  }

  void signOut() async {
    await _googleSignIn.signOut();
    await _firebaseAuth.signOut();
  }

}