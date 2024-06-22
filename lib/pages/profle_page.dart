import 'package:flutter/material.dart';
import 'package:chat_is_this_real_app/services/auth/auth_service.dart';
import 'package:chat_is_this_real_app/components/tabs/feed_view.dart';
import 'package:chat_is_this_real_app/components/tabs/starred_view.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final AuthService _authService = AuthService();
  String? _userEmail;
  String? _userID;
  bool _isLoading = true;

  final List<Widget> tabs = const [
    // Feed
    Tab(
      icon: Icon(
        Icons.image,
        color: Colors.blueGrey,
      ),
    ),

    // Starred
    Tab(
      icon: Icon(
        Icons.video_collection,
        color: Colors.blueGrey,
      ),
    ),
  ];

  // Tab Bar Views
  final List<Widget> tabBarViews = const [
    // Feed View
    FeedView(),

    // Reels View
    StarredView(),
  ];

  @override
  void initState() {
    super.initState();
    _initializeUserDetails();
  }

  Future<void> _initializeUserDetails() async {
    try {
      // Fetch user details from AuthService
      final user = _authService.getCurrentUser();
      if (user != null) {
        setState(() {
          _userEmail = user.email;
          _userID = user.uid;
        });
      }
    } catch (e) {
      // Handle error
      print('Error fetching user details: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2, // Number of tabs
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.surface,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(kToolbarHeight),
          child: AppBar(
            centerTitle: true,
            title: Text(
              _userEmail ?? 'Profile',
              style: const TextStyle(
                fontSize: 15,
              ),
            ),
            backgroundColor: Colors.transparent,
            foregroundColor: Colors.grey.shade700,
          ),
        ),
        body: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : ListView(
                children: [
                  // Profile Picture
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          height: 100,
                          width: 100,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.blueGrey[100],
                          ),
                        ),

                        // Email
                        const SizedBox(height: 20),
                        Text(
                          _userEmail ?? 'Loading...',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 17,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Tab Bar
                  TabBar(
                    tabs: tabs,
                  ),
                  SizedBox(
                    height: 1000,
                    child: TabBarView(children: tabBarViews),
                  ),
                ],
              ),
      ),
    );
  }
}
