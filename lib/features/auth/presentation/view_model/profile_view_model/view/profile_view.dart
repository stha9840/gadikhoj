import 'package:finalyearproject/features/auth/domain/entity/user_entity.dart';
import 'package:finalyearproject/features/auth/presentation/view_model/profile_view_model/view_model/profile_event.dart';
import 'package:finalyearproject/features/auth/presentation/view_model/profile_view_model/view_model/profile_state.dart';
import 'package:finalyearproject/features/auth/presentation/view_model/profile_view_model/view_model/profile_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Fetch the user data when the widget is initialized
    context.read<UserViewModel>().add(GetUserEvent());
  }

  @override
  void dispose() {
    _emailController.dispose();
    _usernameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profile'), centerTitle: true),
      body: BlocConsumer<UserViewModel, UserState>(
        listener: (context, state) {
          if (state is UserLoaded) {
            // CORRECTED: Use '??' to provide a default empty string if the value is null.
            // This prevents the "type 'Null' is not a subtype of type 'String'" error.
            _usernameController.text = state.user.username ?? '';
            _emailController.text = state.user.email ?? '';
          }
        },
        builder: (context, state) {
          if (state is UserLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is UserFailure) {
            return Center(child: Text(state.message));
          } else if (state is UserLoaded) {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: _usernameController,
                      decoration: const InputDecoration(
                        labelText: 'First Name',
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your first name';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _emailController,
                      decoration: const InputDecoration(labelText: 'Email'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your email';
                        }
                        // Add more sophisticated email validation if needed
                        return null;
                      },
                    ),
                    const SizedBox(height: 32),
                    ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          // IMPROVEMENT: Add a null check for userId for safety.
                          final userId = state.user.userId;
                          if (userId != null) {
                            final updatedUser = UserEntity(
                              email: _emailController.text,
                              username: _usernameController.text,
                            );
                            context.read<UserViewModel>().add(
                                  UpdateUserEvent(
                                    userId: userId,
                                    user: updatedUser,
                                    context: context,
                                  ),
                                );
                          } else {
                            // Handle the case where userId is unexpectedly null
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text(
                                      'Error: User ID not found. Cannot update.')),
                            );
                          }
                        }
                      },
                      child: const Text('Update Profile'),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        // Show a confirmation dialog before deleting
                        showDialog(
                          context: context,
                          builder: (BuildContext dialogContext) {
                            return AlertDialog(
                              title: const Text('Delete Account'),
                              content: const Text(
                                'Are you sure you want to delete your account? This action cannot be undone.',
                              ),
                              actions: <Widget>[
                                TextButton(
                                  child: const Text('Cancel'),
                                  onPressed: () {
                                    Navigator.of(dialogContext).pop();
                                  },
                                ),
                                TextButton(
                                  child: const Text('Delete'),
                                  onPressed: () {
                                    Navigator.of(dialogContext).pop();
                                    // IMPROVEMENT: Add a null check for userId for safety.
                                    final userId = state.user.userId;
                                    if (userId != null) {
                                      context.read<UserViewModel>().add(
                                            DeleteUserEvent(
                                              userId: userId,
                                              context: context,
                                            ),
                                          );
                                    } else {
                                      // Handle the case where userId is unexpectedly null
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                            content: Text(
                                                'Error: User ID not found. Cannot delete.')),
                                      );
                                    }
                                  },
                                ),
                              ],
                            );
                          },
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                      ),
                      child: const Text('Delete Account'),
                    ),
                  ],
                ),
              ),
            );
          }
          // Default fallback UI
          return const Center(child: Text('Welcome to your profile!'));
        },
      ),
    );
  }
}