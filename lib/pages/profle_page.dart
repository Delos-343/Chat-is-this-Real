import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
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
  File? _image;

  final List<Widget> tabs = const [
    Tab(
      icon: Icon(
        Icons.image,
        color: Colors.blueGrey,
      ),
    ),
    Tab(
      icon: Icon(
        Icons.video_collection,
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
      final user = _authService.getCurrentUser();
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
      final firebase_storage.Reference ref = firebase_storage
          .FirebaseStorage.instance
          .ref()
          .child('profile_images')
          .child(_userID! + '.jpg');
      final downloadUrl = await ref.getDownloadURL();
      setState(() {
        _image = File(downloadUrl);
      });
    } catch (e) {
      print('Error fetching profile image: $e');
    }
  }

  Future<void> _getImage(ImageSource source) async {
    try {
      final pickedFile = await ImagePicker().pickImage(source: source);
      if (pickedFile != null) {
        setState(() {
          _image = File(pickedFile.path);
        });
        await _uploadImageToStorage();
      }
    } catch (e) {
      print('Error picking image: $e');
    }
  }

  Future<void> _uploadImageToStorage() async {
    if (_image == null) return;

    try {
      final firebase_storage.Reference ref = firebase_storage
          .FirebaseStorage.instance
          .ref()
          .child('profile_images')
          .child(_userID! + '.jpg');
      await ref.putFile(_image!);
      final imageUrl = await ref.getDownloadURL();
      print('Uploaded image url: $imageUrl');
    } catch (e) {
      print('Error uploading image to Firebase Storage: $e');
    }
  }

  Future<void> _removeImageFromStorage() async {
    if (_image == null) return;

    try {
      final firebase_storage.Reference ref = firebase_storage
          .FirebaseStorage.instance
          .ref()
          .child('profile_images')
          .child(_userID! + '.jpg');
      await ref.delete();
      print('Profile image deleted from storage.');
      setState(() {
        _image = null;
      });
    } catch (e) {
      print('Error deleting profile image from Firebase Storage: $e');
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
                                        leading: Icon(
                                          Icons.photo_library,
                                          color: Colors.green,
                                        ),
                                        title: Text('Gallery'),
                                        onTap: () {
                                          _getImage(ImageSource.gallery);
                                          Navigator.pop(context);
                                        },
                                      ),
                                      ListTile(
                                        leading: Icon(
                                          Icons.camera_alt,
                                          color: Colors.lightBlue,
                                        ),
                                        title: Text('Camera'),
                                        onTap: () {
                                          _getImage(ImageSource.camera);
                                          Navigator.pop(context);
                                        },
                                      ),
                                      ListTile(
                                        leading: Icon(
                                          Icons.cancel,
                                          color: Colors.red,
                                        ),
                                        title: Text('Cancel'),
                                        onTap: () {
                                          Navigator.pop(context);
                                        },
                                      ),
                                      if (_image != null)
                                        ListTile(
                                          leading: Icon(
                                            Icons.delete,
                                            color: Colors.grey,
                                          ),
                                          title: Text('Remove Profile Picture'),
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
                              image: _image != null
                                  ? DecorationImage(
                                      image: FileImage(_image!),
                                      fit: BoxFit.cover,
                                    )
                                  : null,
                            ),
                            child: _image == null
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
