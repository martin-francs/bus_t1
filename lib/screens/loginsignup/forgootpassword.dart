import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ForgotPasswordScreen extends StatelessWidget {
  final _emailController = TextEditingController();

  void _showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  Future<void> _resetPassword(BuildContext context) async {
    final email = _emailController.text.trim();
    try {
      // Check if email exists
      final methods =
          await FirebaseAuth.instance.fetchSignInMethodsForEmail(email);
      if (methods.isEmpty) {
        _showSnackBar(context, 'Email does not exist');
        return;
      }

      // Send password reset email
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);

      // Display success message or navigate to a success screen
      _showSnackBar(context, 'Password reset email sent');
    } catch (error) {
      print('Error: $error');
      _showSnackBar(context, 'An error occurred. Please try again.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Forgot Password'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              const SizedBox(
                height: 150,
              ),
              Text(
                'Enter your email to reset your password.',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => _resetPassword(context),
                child: const Text('Reset Password'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
