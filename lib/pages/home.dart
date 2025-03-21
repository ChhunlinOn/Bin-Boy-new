import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:boybin/auth/auth_service.dart';
import 'package:boybin/auth/login.dart'; // Update this path as needed
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  UserData? userData;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  // Load user data from SharedPreferences
  Future<void> _loadUserData() async {
    setState(() {
      isLoading = true;
    });

    try {
      final userDataResult = await AuthService.getUserData();
      setState(() {
        userData = userDataResult;
        isLoading = false;
      });
    } catch (e) {
      print('Error loading user data: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  // Logout function
Future<void> logout() async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setBool('isLoggedIn', false);
  
  // Clear other auth data
  // await prefs.remove('authToken');
  // await prefs.remove('userId');
  
  // Navigate back to login screen
  Navigator.of(context).pushAndRemoveUntil(
    MaterialPageRoute(builder: (context) => LoginScreen()),
    (route) => false,
  );
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          'KDMV',
          style: TextStyle(
            color: Colors.blue,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        elevation: 0.0,
        leading: Container(
          alignment: Alignment.center,
          child: SvgPicture.asset(
            'assets/icons/arrow-left-solid.svg',
            height: 20,
            width: 20,
          ),
          margin: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        actions: [
          PopupMenuButton<String>(
            icon: Container(
              alignment: Alignment.center,
              width: 37,
              child: SvgPicture.asset(
                'assets/icons/dots-two-horizontal.svg',
                height: 5,
                width: 5,
              ),
              margin: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onSelected: (value) {
              if (value == 'logout') {
                logout();
              }
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
              const PopupMenuItem<String>(
                value: 'profile',
                child: Text('Profile'),
              ),
              const PopupMenuItem<String>(
                value: 'settings',
                child: Text('Settings'),
              ),
              const PopupMenuItem<String>(
                value: 'logout',
                child: Text('Logout'),
              ),
            ],
          ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : userData == null
              ? const Center(child: Text('No user data found'))
              : SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // User profile section
                      Container(
                        padding: const EdgeInsets.all(20),
                        child: Row(
                          children: [
                            // Profile image
                            CircleAvatar(
                              radius: 40,
                              backgroundImage: NetworkImage(
                                userData!.profileImageUrl.isNotEmpty
                                    ? userData!.profileImageUrl
                                    : 'https://via.placeholder.com/150',
                              ),
                              onBackgroundImageError: (_, __) {
                                // Handle image loading error
                              },
                              child: userData!.profileImageUrl.isEmpty
                                  ? const Icon(Icons.person, size: 40)
                                  : null,
                            ),
                            const SizedBox(width: 20),
                            // User info
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Welcome back,',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    userData!.userName,
                                    style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    userData!.email,
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      
                      // Divider
                      Divider(color: Colors.grey[300], height: 1),
                      
                      // Dashboard content
                      Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Dashboard',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 20),
                            
                            // Dashboard cards
                            GridView.count(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              crossAxisCount: 2,
                              crossAxisSpacing: 16,
                              mainAxisSpacing: 16,
                              children: [
                                _buildDashboardCard(
                                  icon: Icons.person,
                                  title: 'Profile',
                                  color: Colors.blue,
                                ),
                                _buildDashboardCard(
                                  icon: Icons.settings,
                                  title: 'Settings',
                                  color: Colors.orange,
                                ),
                                _buildDashboardCard(
                                  icon: Icons.history,
                                  title: 'History',
                                  color: Colors.green,
                                ),
                                _buildDashboardCard(
                                  icon: Icons.help_outline,
                                  title: 'Help',
                                  color: Colors.purple,
                                ),
                              ],
                            ),
                            
                            const SizedBox(height: 30),
                            
                            // Logout button
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: logout,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.red,
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(vertical: 15),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                child: const Text(
                                  'Logout',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
    );
  }

  // Helper method to build dashboard cards
  Widget _buildDashboardCard({
    required IconData icon,
    required String title,
    required Color color,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: color,
              size: 30,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}