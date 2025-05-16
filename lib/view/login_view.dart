import 'package:flutter/material.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _obscurePassword = true;


  void _login() {
    if (_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Logging in...')));
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
          Image.asset('assets/images/login_page.png', fit: BoxFit.cover),
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // App name above the box
                  const Text(
                    'Gadi Khoj',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFB24747),
                      letterSpacing: 1.2,
                    ),
                  ),
                  const SizedBox(height: 24),
                  // White box with login form
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 10,
                          offset: Offset(0, 5),
                        ),
                      ],
                      borderRadius: BorderRadius.circular(32),
                    ),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text(
                            'Login',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w500,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 20),
                          TextFormField(
                            controller: _emailController,
                            decoration: _inputDecoration('Email', Icons.email),
                            validator:
                                (value) =>
                                    value!.isEmpty ? 'Enter your email' : null,
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
  controller: _passwordController,
  decoration: _inputDecoration('Password', Icons.lock).copyWith(
    suffixIcon: IconButton(
      icon: Icon(
        _obscurePassword ? Icons.visibility_off : Icons.visibility,
      ),
      onPressed: () {
        setState(() {
          _obscurePassword = !_obscurePassword;
        });
      },
    ),
  ),
  obscureText: _obscurePassword,
  validator: (value) =>
      value!.isEmpty ? 'Enter your password' : null,
),

                          const SizedBox(height: 8),
                          Align(
                            alignment: Alignment.centerRight,
                            child: TextButton(
                              onPressed: () {},
                              child: const Text('Forgot Password?'),
                            ),
                          ),
                          const SizedBox(height: 8),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: _login,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFFB24747),
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(32),
                                ),
                                padding: const EdgeInsets.symmetric(
                                  vertical: 16,
                                ),
                              ),
                              child: const Text('Login'),
                            ),
                          ),
                          const SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text("Don't have an account?"),
                              TextButton(
                                onPressed: () {
                                  Navigator.pushNamed(context, '/signup');
                                },
                                child: const Text('Sign up'),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
