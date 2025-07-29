// Create new file: features/auth/presentation/view/reset_password_view.dart

import 'package:finalyearproject/app/service_locator/service_locator.dart';
import 'package:finalyearproject/core/utils/snackbar_helper.dart';
import 'package:finalyearproject/features/auth/presentation/view/login_view.dart';
import 'package:finalyearproject/features/auth/presentation/view_model/forgot_password_view_model/forgot_password_event.dart';
import 'package:finalyearproject/features/auth/presentation/view_model/forgot_password_view_model/forgot_password_state.dart';
import 'package:finalyearproject/features/auth/presentation/view_model/forgot_password_view_model/forgot_password_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ResetPasswordView extends StatelessWidget {
  final String token; // The token is passed to this view
  ResetPasswordView({super.key, required this.token});

  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => serviceLocator<ForgotPasswordViewModel>(),
      child: Scaffold(
        appBar: AppBar(title: const Text('Reset Password')),
        body: BlocListener<ForgotPasswordViewModel, ForgotPasswordState>(
          // The 'context' from this listener is passed to the snackbar
          listener: (context, state) {
            if (state is ForgotPasswordSuccess) {
              // --- FIX 1: Add context ---
              showMySnackBar(
                context: context,
                message: "Password reset successfully! Please login.",
              );
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (_) => LoginView()),
                (route) => false,
              );
            }
            if (state is ForgotPasswordFailure) {
              // --- FIX 2: Add context ---
              showMySnackBar(
                context: context,
                message: state.message,
                color: Colors.red,
              );
            }
          },
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                TextField(
                  controller: _passwordController,
                  decoration: const InputDecoration(labelText: 'New Password'),
                  obscureText: true,
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _confirmPasswordController,
                  decoration: const InputDecoration(labelText: 'Confirm New Password'),
                  obscureText: true,
                ),
                const SizedBox(height: 24),
                BlocBuilder<ForgotPasswordViewModel, ForgotPasswordState>(
                  // The 'context' from this builder is passed to the snackbar
                  builder: (context, state) {
                    return ElevatedButton(
                      onPressed: state is ForgotPasswordLoading
                          ? null
                          : () {
                              if (_passwordController.text !=
                                  _confirmPasswordController.text) {
                                // --- FIX 3: Add context ---
                                showMySnackBar(
                                  context: context,
                                  message: "Passwords do not match.",
                                  color: Colors.red,
                                );
                                return;
                              }
                              context.read<ForgotPasswordViewModel>().add(
                                    SubmitNewPasswordEvent(
                                      token,
                                      _passwordController.text,
                                    ),
                                  );
                            },
                      child: state is ForgotPasswordLoading
                          ? const CircularProgressIndicator()
                          : const Text('Reset Password'),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}