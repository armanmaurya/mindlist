import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:todo_native/services/auth_service.dart';
import 'package:todo_native/screens/home_screen.dart';
import 'package:todo_native/widgets/buttons/google_signin_button.dart';

class GoogleSignInScreen extends StatefulWidget {
  const GoogleSignInScreen({super.key});

  @override
  State<GoogleSignInScreen> createState() => _GoogleSignInScreenState();
}

class _GoogleSignInScreenState extends State<GoogleSignInScreen> {
  bool _isSigningIn = false;
  String? _error;
  final AuthService _authService = AuthService();

  Future<void> _signInWithGoogle() async {
    setState(() {
      _isSigningIn = true;
      _error = null;
    });
    try {
      // Always sign out first to force account picker
      await _authService.signOut();
      final userCredential = await _authService.signInWithGoogle();
      if (userCredential == null) {
        setState(() {
          _isSigningIn = false;
        });
        return; // User cancelled
      }
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        CupertinoPageRoute(builder: (context) => const HomeScreen()),
      );
    } catch (e) {
      print('Sign in failed: $e');
      setState(() {
        _isSigningIn = false;
        _error = 'Sign in failed: ${e.toString()}';
      });
    }
    setState(() {
      _isSigningIn = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sign in with Google')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: GoogleSignInButton(
            isSigningIn: _isSigningIn,
            onPressed: _signInWithGoogle,
            error: _error,
          ),
        ),
      ),
    );
  }
}
