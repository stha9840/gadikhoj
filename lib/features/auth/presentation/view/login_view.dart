// In: features/auth/presentation/view/login_view.dart

import 'package:finalyearproject/app/service_locator/service_locator.dart';
import 'package:finalyearproject/core/utils/shake_detector.dart';
import 'package:finalyearproject/core/utils/snackbar_helper.dart';
import 'package:finalyearproject/features/auth/presentation/view/register_view.dart';
import 'package:finalyearproject/features/auth/presentation/view_model/forgot_password_view_model/forgot_password_event.dart';
import 'package:finalyearproject/features/auth/presentation/view_model/forgot_password_view_model/forgot_password_state.dart';
import 'package:finalyearproject/features/auth/presentation/view_model/forgot_password_view_model/forgot_password_view_model.dart';
import 'package:finalyearproject/features/auth/presentation/view_model/login_view_model/login_event.dart';
import 'package:finalyearproject/features/auth/presentation/view_model/login_view_model/login_state.dart';
import 'package:finalyearproject/features/auth/presentation/view_model/login_view_model/login_view_model.dart';
import 'package:finalyearproject/features/auth/presentation/view_model/register_view_model/register_view_model.dart';
import 'package:finalyearproject/features/navigation/presentation/view/dashboard_view.dart'; // Import your Dashboard/Home page
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final ValueNotifier<bool> _obscurePassword = ValueNotifier(true);
  final _gap = const SizedBox(height: 12);

  late final ShakeDetector _shakeDetector;

  @override
  void initState() {
    super.initState();
    _shakeDetector = ShakeDetector(
      onPhoneShake: () {
        if (context.read<LoginViewModel>().state is! LoginLoading) {
          _performLogin();
        }
      },
    );
    _shakeDetector.startListening();
  }

  @override
  void dispose() {
    _shakeDetector.stopListening();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _performLogin() {
    FocusScope.of(context).unfocus();
    if (_formKey.currentState!.validate()) {
      // THE FIX: Do NOT pass `context` in the event.
      context.read<LoginViewModel>().add(
            LoginWithEmailAndPasswordEvent(
              email: _emailController.text.trim(),
              password: _passwordController.text,
            ),
          );
    }
  }

  InputDecoration _inputDecoration(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon),
      contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
    );
  }

  void _showForgotPasswordDialog(BuildContext context) {
    final emailController = TextEditingController();
    showDialog(
      context: context,
      builder: (dialogContext) {
        return BlocProvider(
          create: (_) => serviceLocator<ForgotPasswordViewModel>(),
          child: BlocConsumer<ForgotPasswordViewModel, ForgotPasswordState>(
            listener: (context, state) {
              if (state is ForgotPasswordLinkSent) {
                Navigator.pop(context);
                showMySnackBar(
                  context: context,
                  message: "Reset link sent to your email!",
                );
              }
              if (state is ForgotPasswordFailure) {
                showMySnackBar(
                  context: context,
                  message: state.message,
                  color: Colors.red,
                );
              }
            },
            builder: (context, state) {
              return AlertDialog(
                title: const Text('Forgot Password'),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text('Enter your email to receive a password reset link.'),
                    const SizedBox(height: 16),
                    TextField(
                      controller: emailController,
                      decoration: _inputDecoration('Email', Icons.email),
                      keyboardType: TextInputType.emailAddress,
                    ),
                  ],
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(dialogContext),
                    child: const Text('Cancel'),
                  ),
                  ElevatedButton(
                    onPressed: state is ForgotPasswordLoading
                        ? null
                        : () {
                            if (emailController.text.trim().isNotEmpty) {
                              context.read<ForgotPasswordViewModel>().add(
                                    SendResetLinkEvent(emailController.text.trim()),
                                  );
                            }
                          },
                    child: state is ForgotPasswordLoading
                        ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2))
                        : const Text('Send Link'),
                  ),
                ],
              );
            },
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // THE FIX: Wrap the entire UI with a BlocListener to handle navigation and snackbars.
    return BlocListener<LoginViewModel, LoginState>(
      listener: (context, state) {
        if (state is LoginSuccess) {
          // The context is guaranteed to be valid here.
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (_) => DashboardView()),
            (route) => false,
          );
        }
        if (state is LoginFailure) {
          showMySnackBar(
            context: context,
            message: state.message,
            color: Colors.red,
          );
        }
      },
      child: BlocBuilder<LoginViewModel, LoginState>(
        builder: (context, state) {
          // The rest of the UI remains the same.
          return Scaffold(
            body: Stack(
              fit: StackFit.expand,
              children: [
                Image.asset('assets/images/login_page.png', fit: BoxFit.cover),
                Center(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Image.asset('assets/logos/gadikhojlogo.png', height: 120),
                        const SizedBox(height: 30),
                        Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, 4))],
                            borderRadius: BorderRadius.circular(24),
                          ),
                          child: Form(
                            key: _formKey,
                            child: Column(
                              children: [
                                const Text('Login', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.black87)),
                                const SizedBox(height: 16),
                                TextFormField(
                                  controller: _emailController,
                                  decoration: _inputDecoration('Email', Icons.email),
                                  validator: (value) => value!.isEmpty ? 'Enter your email' : null,
                                ),
                                _gap,
                                ValueListenableBuilder<bool>(
                                  valueListenable: _obscurePassword,
                                  builder: (context, obscure, _) {
                                    return TextFormField(
                                      controller: _passwordController,
                                      obscureText: obscure,
                                      decoration: _inputDecoration('Password', Icons.lock).copyWith(
                                        suffixIcon: IconButton(
                                          icon: Icon(obscure ? Icons.visibility_off : Icons.visibility),
                                          onPressed: () => _obscurePassword.value = !obscure,
                                        ),
                                      ),
                                      validator: (value) => value!.isEmpty ? 'Enter your password' : null,
                                    );
                                  },
                                ),
                                const SizedBox(height: 8),
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: TextButton(
                                    onPressed: () => _showForgotPasswordDialog(context),
                                    style: TextButton.styleFrom(padding: EdgeInsets.zero, minimumSize: Size.zero, tapTargetSize: MaterialTapTargetSize.shrinkWrap),
                                    child: const Text('Forgot Password?', style: TextStyle(fontSize: 13, color: Color(0xFFB24747), fontWeight: FontWeight.w500)),
                                  ),
                                ),
                                const SizedBox(height: 12),
                                SizedBox(
                                  width: double.infinity,
                                  child: ElevatedButton(
                                    onPressed: _performLogin,
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0xFFB24747),
                                      foregroundColor: Colors.white,
                                      padding: const EdgeInsets.symmetric(vertical: 12),
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                                    ),
                                    child: state is LoginLoading
                                        ? const CircularProgressIndicator(color: Colors.white)
                                        : const Text('Login'),
                                  ),
                                ),
                                const SizedBox(height: 14),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Text("Don't have an account?", style: TextStyle(fontSize: 13)),
                                    TextButton(
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => BlocProvider<RegisterViewModel>(
                                              create: (_) => serviceLocator<RegisterViewModel>(),
                                              child: SignUpView(),
                                            ),
                                          ),
                                        );
                                      },
                                      child: const Text('Sign up', style: TextStyle(fontSize: 13, color: Color.fromARGB(255, 36, 43, 255), fontWeight: FontWeight.w500)),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 30),
                      
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}