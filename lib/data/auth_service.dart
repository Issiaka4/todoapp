import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';

// Instance globale accessible par vos autres fichiers (main.dart, auth_page.dart, etc.)
final authService = AuthService();

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Initialisation sans paramètres directs (Règle définitivement l'erreur "Couldn't find constructor")
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  // Récupération correcte du flux d'état d'authentification
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  Future<UserCredential?> signInWithGoogle() async {
    try {
      // Déclencher le flux d'authentification
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      if (googleUser == null) {
        return null; // L'utilisateur a annulé la connexion
      }

      // Obtenir les détails de l'authentification
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      // Créer l'identifiant pour Firebase Auth
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Connecter l'utilisateur à Firebase
      return await _auth.signInWithCredential(credential);
    } catch (e) {
      print("Erreur lors de la connexion Google: $e");
      return null;
    }
  }

  // Méthodes d'authentification classiques
  Future<UserCredential?> signIn(String email, String password) async {
    return await _auth.signInWithEmailAndPassword(email: email, password: password);
  }

  Future<UserCredential?> signUp(String email, String password) async {
    return await _auth.createUserWithEmailAndPassword(email: email, password: password);
  }

  Future<void> signOut() async {
    try {
      await _googleSignIn.signOut();
    } catch (_) {}
    await _auth.signOut();
  }
}