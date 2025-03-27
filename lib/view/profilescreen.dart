import 'package:flutter/material.dart';
import 'package:boybin/bloc/user_bloc.dart';
import 'package:boybin/controllers/auth_controller.dart';
import 'package:boybin/models/user_model.dart';
import 'package:boybin/view/login_screen.dart';
import 'package:boybin/view/home_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfileSettingsScreen extends StatefulWidget {
  const ProfileSettingsScreen({Key? key}) : super(key: key);

  @override
  _ProfileSettingsScreenState createState() => _ProfileSettingsScreenState();
}

class _ProfileSettingsScreenState extends State<ProfileSettingsScreen> {
  final AuthController _authController = AuthController();
  int _selectedIndex = 3; // Profile tab is selected by default

  Future<void> _logout(BuildContext context) async {
    await _authController.logout();
    
    // Clear user in BLoC
    context.read<UserBloc>().add(ClearUserEvent());
    
    // Navigate back to login screen
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => const LoginScreen()),
      (route) => false,
    );
  }

  void _onItemTapped(int index) {
    if (index != 3) {
      // If not the profile tab, navigate back to home with the selected tab
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => HomePage(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserBloc, UserState>(
      builder: (context, state) {
        if (state is UserLoaded) {
          return _buildProfileScreen(context, state.user);
        } else {
          // If user is not loaded, redirect to login
          WidgetsBinding.instance.addPostFrameCallback((_) {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => const LoginScreen()),
            );
          });
          
          // Show loading while redirecting
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
      },
    );
  }

  Widget _buildProfileScreen(BuildContext context, User user) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A2035), // Dark navy background
      appBar: AppBar(
        backgroundColor: const Color(0xFF1A2035),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            children: [
              const SizedBox(height: 20),
              
              // Profile picture with edit button
              Stack(
                alignment: Alignment.center,
                children: [
                  // Outer circle
                  Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.blue.withOpacity(0.2),
                    ),
                  ),
                  
                  // Profile image
                  Container(
                    width: 110,
                    height: 110,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        image: NetworkImage(
                          user.profileImageUrl.isNotEmpty
                              ? user.profileImageUrl
                              : 'https://via.placeholder.com/150',
                        ),
                        fit: BoxFit.cover,
                      ),
                      border: Border.all(
                        color: const Color(0xFF1A2035),
                        width: 4,
                      ),
                    ),
                  ),
                  
                  // Edit button
                  Positioned(
                    bottom: 0,
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: const Color(0xFF1A2035),
                          width: 3,
                        ),
                      ),
                      child: const Icon(
                        Icons.edit,
                        color: Colors.white,
                        size: 16,
                      ),
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 20),
              
              // User name
              Text(
                user.userName,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              
              const SizedBox(height: 12),
              
              // Email pill
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  user.email,
                  style: TextStyle(
                    color: Colors.blue[200],
                    fontSize: 14,
                  ),
                ),
              ),
              
              const SizedBox(height: 40),
              
              // Settings options
              _buildSettingsOption(
                icon: Icons.edit,
                title: 'Change Profile Details',
                onTap: () {
                  // Handle change profile details
                },
              ),
              
              _buildSettingsOption(
                icon: Icons.home,
                title: 'See Tour Status',
                onTap: () {
                  // Handle see tour status
                },
              ),
              
              _buildSettingsOption(
                icon: Icons.lock,
                title: 'Change Password',
                onTap: () {
                  // Handle change password
                },
              ),
              
              _buildSettingsOption(
                icon: Icons.settings,
                title: 'Display and Notification Settings',
                onTap: () {
                  // Handle display and notification settings
                },
              ),
              
              _buildSettingsOption(
                icon: Icons.exit_to_app,
                title: 'Logout',
                isLogout: true,
                onTap: () {
                  _logout(context);
                },
              ),
              
              // Add some bottom padding to ensure content isn't hidden behind the navigation bar
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white, // Changed to white as requested
        selectedItemColor: Colors.green, // Changed to green to match the theme
        unselectedItemColor: Colors.grey,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: 'History',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.public),
            label: 'Explore',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsOption({
    required IconData icon,
    required String title,
    bool isLogout = false,
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          decoration: BoxDecoration(
            color: const Color(0xFF232B43), // Slightly lighter than background
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: isLogout 
                      ? Colors.red.withOpacity(0.1) 
                      : Colors.blue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  icon,
                  color: isLogout ? Colors.red : Colors.blue,
                  size: 20,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    color: isLogout ? Colors.red : Colors.white,
                    fontSize: 16,
                  ),
                ),
              ),
              Icon(
                Icons.chevron_right,
                color: isLogout ? Colors.red : Colors.grey,
                size: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}