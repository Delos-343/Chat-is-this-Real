import 'dart:io';
import 'package:flutter/material.dart';
import 'package:chat_is_this_real_app/services/profile/profile_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:chat_is_this_real_app/components/tabs/feed_view.dart';
import 'package:chat_is_this_real_app/components/tabs/starred_view.dart';
import 'package:image_picker/image_picker.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final ProfileService _profileService = ProfileService();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String? _userEmail;
  String? _userID;
  bool _isLoading = true;
  String? _imageUrl;

  final List<Widget> tabs = const [
    Tab(
      icon: Icon(
        Icons.image_outlined,
        color: Colors.blueGrey,
      ),
    ),
    Tab(
      icon: Icon(
        Icons.star_half,
        color: Colors.blueGrey,
      ),
    ),
  ];

  final List<Widget> tabBarViews = const [
    FeedView(),
    StarredView(),
  ];

  @override
  void initState() {
    super.initState();
    _initializeUserDetails();
  }

  Future<void> _initializeUserDetails() async {
    try {
      User? user = _auth.currentUser;
      if (user != null) {
        setState(() {
          _userEmail = user.email;
          _userID = user.uid;
        });
        await _fetchProfileImage();
      }
    } catch (e) {
      print('Error fetching user details: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _fetchProfileImage() async {
    try {
      String? imageUrl = await _profileService.fetchProfileImageUrl(_userID!);
      setState(() {
        _imageUrl = imageUrl;
      });
    } catch (e) {
      print('Error fetching profile img: $e');
    }
  }

  Future<void> _getImage(ImageSource source) async {
    try {
      final pickedFile = await ImagePicker().pickImage(source: source);
      if (pickedFile != null) {
        File imageFile = File(pickedFile.path);
        await _profileService.uploadProfileImage(imageFile, _userID!);
        setState(() {
          _imageUrl = pickedFile.path;
        });
      }
    } catch (e) {
      print('Error picking img: $e');
    }
  }

  Future<void> _removeImageFromStorage() async {
    try {
      await _profileService.removeProfileImage(_userID!);
      setState(() {
        _imageUrl = null;
      });
    } catch (e) {
      print('Error deleting profile img: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
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
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: () {
                            showModalBottomSheet(
                              context: context,
                              builder: (BuildContext context) {
                                return SafeArea(
                                  child: Wrap(
                                    children: <Widget>[
                                      ListTile(
                                        leading: const Icon(
                                          Icons.photo_library_outlined,
                                          color: Colors.green,
                                        ),
                                        title: const Text('Gallery'),
                                        onTap: () {
                                          _getImage(ImageSource.gallery);
                                          Navigator.pop(context);
                                        },
                                      ),
                                      ListTile(
                                        leading: const Icon(
                                          Icons.camera_alt_outlined,
                                          color: Colors.lightBlue,
                                        ),
                                        title: const Text('Camera'),
                                        onTap: () {
                                          _getImage(ImageSource.camera);
                                          Navigator.pop(context);
                                        },
                                      ),
                                      ListTile(
                                        leading: const Icon(
                                          Icons.cancel_outlined,
                                          color: Colors.red,
                                        ),
                                        title: const Text('Cancel'),
                                        onTap: () {
                                          Navigator.pop(context);
                                        },
                                      ),
                                      if (_imageUrl != null)
                                        ListTile(
                                          leading: const Icon(
                                            Icons.delete_outline,
                                            color: Colors.grey,
                                          ),
                                          title: const Text(
                                              'Remove Profile Picture'),
                                          onTap: () {
                                            _removeImageFromStorage();
                                            Navigator.pop(context);
                                          },
                                        ),
                                    ],
                                  ),
                                );
                              },
                            );
                          },
                          child: Container(
                            height: 100,
                            width: 100,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.blueGrey[100],
                              border: Border.all(
                                color: Colors.white,
                                width: 2.0,
                              ),
                              image: _imageUrl != null
                                  ? DecorationImage(
                                      image: NetworkImage(_imageUrl!),
                                      fit: BoxFit.cover,
                                    )
                                  : null,
                            ),
                            child: _imageUrl == null
                                ? Icon(
                                    Icons.add_a_photo,
                                    size: 40,
                                    color: Colors.grey[800],
                                  )
                                : null,
                          ),
                        ),
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
