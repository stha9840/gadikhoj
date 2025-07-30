// In: features/auth/presentation/view/profile_view.dart

import 'package:finalyearproject/core/utils/shake_detector.dart';
import 'package:finalyearproject/features/auth/domain/entity/user_entity.dart';
import 'package:finalyearproject/features/auth/presentation/view/login_view.dart';
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
  bool _isEditing = false;
  
  late final ShakeDetector _shakeDetector;
  
  // 1. Add a flag to prevent multiple dialogs
  bool _isLogoutDialogShowing = false;

  @override
  void initState() {
    super.initState();
    context.read<UserViewModel>().add(GetUserEvent());

    _shakeDetector = ShakeDetector(
      onPhoneShake: () {
        // 2. Check if a dialog is already showing or if the UI is loading.
        // If so, do nothing.
        if (_isLogoutDialogShowing || context.read<UserViewModel>().state is UserLoading) {
          return; 
        }
        
        // Set the flag to true and show the dialog
        setState(() {
          _isLogoutDialogShowing = true;
        });
        _showLogoutConfirmation(context);
      },
      // Optional: You can increase the threshold if the double-shake is still too sensitive
      // shakeThreshold: 15.0, 
    );
    _shakeDetector.startListening();
  }

  @override
  void dispose() {
    _shakeDetector.stopListening();
    _emailController.dispose();
    _usernameController.dispose();
    super.dispose();
  }

  // ... (Your build method remains exactly the same) ...
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text(
          'Profile',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.black87,
        actions: [
          BlocBuilder<UserViewModel, UserState>(
            builder: (context, state) {
              if (state is UserLoaded) {
                return IconButton(
                  onPressed: () {
                    setState(() {
                      _isEditing = !_isEditing;
                    });
                  },
                  icon: Icon(_isEditing ? Icons.close : Icons.edit),
                  tooltip: _isEditing ? 'Cancel Edit' : 'Edit Profile',
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ],
      ),
      body: BlocConsumer<UserViewModel, UserState>(
        listener: (context, state) {
          if (state is UserLoaded) {
            _usernameController.text = state.user.username ?? '';
            _emailController.text = state.user.email ?? '';
          }

          // Logout navigation
          if (state is UserLoggedOut) {
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (_) => const LoginView()),
              (route) => false,
            );
          }
        },
        builder: (context, state) {
          if (state is UserLoading) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text(
                    'Loading profile...',
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            );
          } else if (state is UserFailure) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, size: 64, color: Colors.red[300]),
                  const SizedBox(height: 16),
                  Text(
                    'Failed to load profile',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    state.message,
                    style: TextStyle(color: Colors.grey[600]),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    onPressed:
                        () => context.read<UserViewModel>().add(GetUserEvent()),
                    icon: const Icon(Icons.refresh),
                    label: const Text('Retry'),
                  ),
                ],
              ),
            );
          } else if (state is UserLoaded) {
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    // Avatar Section
                    Container(
                      margin: const EdgeInsets.only(bottom: 32),
                      child: Column(
                        children: [
                          Stack(
                            children: [
                              CircleAvatar(
                                radius: 60,
                                backgroundColor: Theme.of(context)
                                    .primaryColor
                                    .withOpacity(0.1),
                                child: Icon(
                                  Icons.person,
                                  size: 60,
                                  color: Theme.of(context).primaryColor,
                                ),
                              ),
                              if (_isEditing)
                                Positioned(
                                  bottom: 0,
                                  right: 0,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Theme.of(context).primaryColor,
                                      shape: BoxShape.circle,
                                    ),
                                    padding: const EdgeInsets.all(8),
                                    child: const Icon(
                                      Icons.camera_alt,
                                      color: Colors.white,
                                      size: 20,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Text(
                            state.user.username ?? 'User',
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            state.user.email ?? '',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Profile Form
                    Card(
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Personal Information',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 24),

                              // Username
                              TextFormField(
                                controller: _usernameController,
                                enabled: _isEditing,
                                decoration: InputDecoration(
                                  labelText: 'Username',
                                  prefixIcon: const Icon(Icons.person_outline),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  filled: !_isEditing,
                                  fillColor:
                                      _isEditing ? null : Colors.grey[100],
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter your first name';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 20),

                              // Email
                              TextFormField(
                                controller: _emailController,
                                enabled: _isEditing,
                                decoration: InputDecoration(
                                  labelText: 'Email',
                                  prefixIcon: const Icon(Icons.email_outlined),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  filled: !_isEditing,
                                  fillColor:
                                      _isEditing ? null : Colors.grey[100],
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter your email';
                                  }
                                  if (!RegExp(
                                          r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                                      .hasMatch(value)) {
                                    return 'Please enter a valid email address';
                                  }
                                  return null;
                                },
                              ),

                              if (_isEditing) ...[
                                const SizedBox(height: 32),
                                SizedBox(
                                  width: double.infinity,
                                  child: ElevatedButton.icon(
                                    onPressed: () {
                                      if (_formKey.currentState!.validate()) {
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
                                                ),
                                              );
                                          setState(() {
                                            _isEditing = false;
                                          });
                                        } else {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            const SnackBar(
                                              content: Text(
                                                  'Error: User ID not found. Cannot update.'),
                                              backgroundColor: Colors.red,
                                            ),
                                          );
                                        }
                                      }
                                    },
                                    icon: const Icon(Icons.save),
                                    label: const Text('Save Changes'),
                                    style: ElevatedButton.styleFrom(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 16),
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(12),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Logout Button (shows confirmation dialog)
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          _showLogoutConfirmation(context);
                        },
                        icon: const Icon(Icons.logout),
                        label: const Text('Logout'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey[800],
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Danger Zone
                    Card(
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Danger Zone',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: Colors.red,
                              ),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Delete your account permanently. This action cannot be undone.',
                              style: TextStyle(
                                color: Colors.red[700],
                              ),
                            ),
                            const SizedBox(height: 16),
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton.icon(
                                onPressed: () {
                                  _showDeleteAccountConfirmation(context, state.user.userId);
                                },
                                icon: const Icon(Icons.delete_forever),
                                label: const Text('Delete Account'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.red[700],
                                  foregroundColor: Colors.white,
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 16),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }

          // Default fallback UI
          return const Center(child: Text('No profile data.'));
        },
      ),
    );
  }

  // 3. Make the function async and reset the flag after the dialog is closed.
  void _showLogoutConfirmation(BuildContext context) async {
    await showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Row(
            children: [
              Icon(Icons.logout, color: Colors.grey[800]),
              const SizedBox(width: 8),
              const Text('Logout'),
            ],
          ),
          content: const Text(
            'Are you sure you want to logout?',
            style: TextStyle(fontWeight: FontWeight.w500),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(dialogContext).pop(); // Close this dialog first
                context.read<UserViewModel>().add(const LogoutEvent());
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey[800],
                foregroundColor: Colors.white,
              ),
              child: const Text('Logout'),
            ),
          ],
        );
      },
    );

    // This code runs *after* the dialog has been popped (closed).
    // Now we can allow a new dialog to be shown.
    setState(() {
      _isLogoutDialogShowing = false;
    });
  }
  
  // ... (Your _showDeleteAccountConfirmation method remains the same) ...
  void _showDeleteAccountConfirmation(BuildContext context, String? userId) {
    if (userId == null) return;
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Row(
            children: [
              Icon(Icons.delete_forever, color: Colors.red[700]),
              const SizedBox(width: 8),
              const Text('Delete Account'),
            ],
          ),
          content: const Text(
            'This action is irreversible. Are you sure you want to delete your account?',
            style: TextStyle(fontWeight: FontWeight.w500),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
                context.read<UserViewModel>().add(DeleteUserEvent(userId: userId));
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red[700],
                foregroundColor: Colors.white,
              ),
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }
}