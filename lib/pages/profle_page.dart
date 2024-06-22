import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
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
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(),
        body: ListView(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Following
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '1532',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                    SizedBox(height: 5),
                    Text(
                      'Following',
                      style: TextStyle(
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),

                // Profile Picture
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Container(
                    height: 100,
                    width: 100,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.blueGrey[100],
                    ),
                  ),
                ),

                // Followers
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '1574',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                    SizedBox(height: 5),
                    Text(
                      'Followers',
                      style: TextStyle(
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 20),

            // Name
            const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'ur_username ',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),

            const SizedBox(height: 5),

            // Bio
            Text(
              'A Flutter Redesign',
              style: TextStyle(
                  color: Colors.grey[600], fontWeight: FontWeight.w400),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 5),

            // Link
            Text(
              'Connect with Me',
              style: TextStyle(
                  color: Colors.blue[500], fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 20),

            // Buttons
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.grey[400],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Center(
                        child: Text(
                          'Edit Profile',
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Center(
                        child: Text(
                          'Contact',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

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
