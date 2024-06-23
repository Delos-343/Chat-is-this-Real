import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class Post {
  final firebase_storage.FirebaseStorage _storage =
      firebase_storage.FirebaseStorage.instance;

  Future<void> addPost(File imageFile) async {
    try {
      final User? user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        print('User not authenticated.');
        return;
      }
      final ref = _storage
          .ref()
          .child('images')
          .child('${DateTime.now().millisecondsSinceEpoch}.jpg');
      await ref.putFile(imageFile);
    } catch (e) {
      print('Error adding image: $e');
      rethrow; // Throw the error again to handle in UI if needed
    }
  }

  Future<void> editPost(String currentImageUrl, File newImageFile) async {
    try {
      await deletePost(currentImageUrl); // Delete current image
      await addPost(newImageFile); // Add new image
    } catch (e) {
      print('Error editing image: $e');
      rethrow; // Throw the error again to handle in UI if needed
    }
  }

  Future<void> deletePost(String imageUrl) async {
    try {
      final firebase_storage.Reference ref =
          firebase_storage.FirebaseStorage.instance.refFromURL(imageUrl);
      await ref.delete();
    } catch (e) {
      print('Error deleting image: $e');
      rethrow; // Throw the error again to handle in UI if needed
    }
  }
}
