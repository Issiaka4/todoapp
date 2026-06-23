import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'data/auth_service.dart';
import 'presentation/auth_page.dart';
import 'presentation/home_page.dart';

const firebaseOptions = FirebaseOptions(
  apiKey: "AIzaSyDEqrWJ0X2L5VO9X1AM90_Q6xOpc3awNls",
  authDomain: "bd-gest.firebaseapp.com",
  projectId: "bd-gest",
  storageBucket: "bd-gest.firebasestorage.app",
  messagingSenderId: "359718831332",
  appId: "1:359718831332:android:9b2f2acff6c12a182bd8f1",
  measurementId: "G-M6C6G34SXT",
);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp(
      options: firebaseOptions,
    );
  } catch (e) {
    debugPrint("Erreur d'initialisation Firebase : $e");
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Todo 3-Couches',
      theme: ThemeData(
        useMaterial3: true,
        primarySwatch: Colors.blue,
      ),
      home: StreamBuilder<User?>(
        stream: authService.authStateChanges,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }
          if (snapshot.hasData && snapshot.data != null) {
            return HomePage(user: snapshot.data!);
          }
          return const AuthPage();
        },
      ),
    );
  }
}