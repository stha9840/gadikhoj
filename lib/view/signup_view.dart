import 'package:flutter/material.dart';

class SignUpView extends StatefulWidget {
  const SignUpView({super.key});

  @override
  State<SignUpView> createState() => _SignUpViewState();
}

class _SignUpViewState extends State<SignUpView> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  void _signUp() {
    if (_formKey.currentState!.validate()) {
      if (_passwordController.text != _confirmPasswordController.text) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Passwords do not match')));
        return;
      }

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Signing up...')));
    }
  }

  InputDecoration _inputDecoration(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Background image
          Image.asset(
            'assets/images/login_page.png', // Path to your image
            fit: BoxFit.cover,
          ),
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white, // Solid white background
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 10,
                      offset: Offset(0, 5),
                    ),
                  ],
                  borderRadius: BorderRadius.circular(32), // Rounded corners
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        'Create Account',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _nameController,
                        decoration: _inputDecoration('Name', Icons.person),
                        validator:
                            (value) =>
                                value!.isEmpty ? 'Enter your name' : null,
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: _emailController,
                        decoration: _inputDecoration('Email', Icons.email),
                        validator:
                            (value) =>
                                value!.isEmpty ? 'Enter your email' : null,
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: _passwordController,
                        decoration: _inputDecoration('Password', Icons.lock),
                        obscureText: true,
                        validator:
                            (value) =>
                                value!.isEmpty ? 'Enter your password' : null,
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: _confirmPasswordController,
                        decoration: _inputDecoration(
                          'Confirm Password',
                          Icons.lock_outline,
                        ),
                        obscureText: true,
                        validator:
                            (value) =>
                                value!.isEmpty ? 'Confirm your password' : null,
                      ),
                      const SizedBox(height: 24),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _signUp,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF9ECEFE),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(40),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 16),
                          ),
                          child: const Text('Sign Up'),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          const Text('Already have an account?'),
                          TextButton(
                            onPressed: () {
                              Navigator.pushNamed(context, '/login');
                            },
                            child: const Text('Login'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
