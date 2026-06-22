import 'package:flutter/material.dart';
import '../data/auth_service.dart'; // Importation du service

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  void _showSnackBar(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  void _handleSignIn() async {
    try {
      await authService.signIn(_emailController.text.trim(), _passwordController.text.trim());
    } catch (e) {
      _showSnackBar(e.toString());
    }
  }

  void _handleSignUp() async {
    try {
      await authService.signUp(_emailController.text.trim(), _passwordController.text.trim());
    } catch (e) {
      _showSnackBar(e.toString());
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Connexion / Inscription')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(controller: _emailController, decoration: const InputDecoration(labelText: 'Email')),
            TextField(controller: _passwordController, decoration: const InputDecoration(labelText: 'Mot de passe'), obscureText: true),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(onPressed: _handleSignIn, child: const Text('Se connecter')),
                ElevatedButton(onPressed: _handleSignUp, child: const Text("S'inscrire")),
              ],
            )
          ],
        ),
      ),
    );
  }
}