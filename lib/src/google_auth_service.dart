import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:isotope_auth/isotope_auth.dart';

class GoogleAuthService extends AuthServiceAdapter {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  @override
  Future<IsotopeIdentity> currentIdentity() async {
    final FirebaseUser user = await _firebaseAuth.currentUser();
    return _identityFromFirebase(user);
  }

  @override
  Stream<IsotopeIdentity> get onAuthStateChanged {
    authStateChangedController.stream;
    return _firebaseAuth.onAuthStateChanged.map(_identityFromFirebase);
  }

  @override
  AuthProvider get provider {
    return AuthProvider.anonymous;
  }

  @override
  Future<IsotopeIdentity> signIn(Map<String, dynamic> _credentials) async {
    final GoogleSignIn googleSignIn = GoogleSignIn();
    final GoogleSignInAccount googleUser = await googleSignIn.signIn();

    if (googleUser != null) {
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      if (googleAuth.accessToken != null && googleAuth.idToken != null) {
        final AuthResult authResult = await _firebaseAuth.signInWithCredential(
          GoogleAuthProvider.getCredential(
            idToken: googleAuth.idToken,
            accessToken: googleAuth.accessToken,
          )
        );

        return _identityFromFirebase(authResult.user);
      } 
      else {
        throw PlatformException(
          code: 'ERROR_MISSING_GOOGLE_AUTH_TOKEN',
          message: 'Missing Google Auth Token'
        );
      }
    } else {
      throw PlatformException(
        code: 'ERROR_ABORTED_BY_USER', 
        message: 'Sign in aborted by user'
      );
    }
  }

  @override
  Future<void> signOut() async {
    final GoogleSignIn googleSignIn = GoogleSignIn();
    await googleSignIn.signOut();
    return _firebaseAuth.signOut();
  }

  IsotopeIdentity _identityFromFirebase(FirebaseUser user) {
    if (user == null) {
      return null;
    }
    return IsotopeIdentity(
      uid: user.uid,
      email: user.email,
      displayName: user.displayName,
      photoUrl: user.photoUrl,
    );
  }
}
