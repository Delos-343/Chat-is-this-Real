// ignore_for_file: unused_field

import 'dart:io';

import 'package:chat_is_this_real_app/models/post.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class FeedView extends StatefulWidget {
  const FeedView({super.key});

  @override
  _FeedViewState createState() => _FeedViewState();
}

class _FeedViewState extends State<FeedView> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final Post _postService = Post(); // Inst of Post model

  List<String> _imageUrls = [];

  @override
  void initState() {
    super.initState();
    _loadImages();
  }

  Future<void> _loadImages() async {
    try {
      final List<String> imageUrls = [];

      // Fetch img from Firebase Storage based on existing entries
      for (int i = 1; i <= 6; i++) {
        final String imageUrl = await _getImageUrl(i);
        if (imageUrl.isNotEmpty) {
          imageUrls.add(imageUrl);
        }
      }

      setState(() {
        _imageUrls = imageUrls;
      });
    } catch (e) {
      print('Error loading images: $e');
    }
  }

  Future<String> _getImageUrl(int index) async {
    try {
      final String imagePath = 'images/image${index.toString()}.jpg';
      final ref =
          firebase_storage.FirebaseStorage.instance.ref().child(imagePath);
      final downloadUrl = await ref.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      print('Error fetching image $index: $e');
      return '';
    }
  }

  Future<void> _addImage() async {
    try {
      final pickedFile =
          await ImagePicker().pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        final File imageFile = File(pickedFile.path);
        await _postService.addPost(imageFile); // Add post using Post model
        await _loadImages();
      }
    } catch (e) {
      print('Error adding image: $e');
    }
  }

  Future<void> _editImage(int index) async {
    try {
      final pickedFile =
          await ImagePicker().pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        final File newImageFile = File(pickedFile.path);
        final String currentImageUrl = _imageUrls[index];
        await _postService.editPost(
            currentImageUrl, newImageFile); // Edit post using Post model
        await _loadImages();
      }
    } catch (e) {
      print('Error editing image: $e');
    }
  }

  Future<void> _deleteImage(int index) async {
    try {
      final String currentImageUrl = _imageUrls[index];
      await _postService
          .deletePost(currentImageUrl); // Delete post using Post model

      setState(() {
        _imageUrls.removeAt(index);
      });
    } catch (e) {
      print('Error deleting image: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 2.0),
        child: _imageUrls.isEmpty
            ? const Center(
                child: Text('No images yet'),
              )
            : MasonryGridView.count(
                crossAxisCount: 2,
                itemCount: _imageUrls.length,
                itemBuilder: (BuildContext context, int index) =>
                    GestureDetector(
                  onTap: () => _editImage(index), // Edit img on tap
                  onLongPress: () =>
                      _deleteImage(index), // Delete img on long press
                  child: Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: Image.network(
                        _imageUrls[index],
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                mainAxisSpacing: 2.0,
                crossAxisSpacing: 2.0,
              ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addImage,
        backgroundColor: Colors.lightBlue,
        child: const Icon(Icons.add),
      ),
    );
  }
}
