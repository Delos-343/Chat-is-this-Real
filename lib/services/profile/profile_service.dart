import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:chat_is_this_real_app/services/auth/auth_service.dart';

class ProfileService {
  final AuthService _authService = AuthService();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<String?> fetchProfileImageUrl(String userId) async {
    try {
      final firebase_storage.Reference ref = firebase_storage
          .FirebaseStorage.instance
          .ref()
          .child('profile_images')
          .child(userId + '.jpg');
      final downloadUrl = await ref.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      print('Error fetching profile image url: $e');
      return null;
    }
  }

  Future<void> saveProfileImageUrl(String userId, String url) async {
    try {
      await _authService.saveProfileImageUrl(url);
      final user = _auth.currentUser;
      if (user != null) {
        await firebase_storage.FirebaseStorage.instance
            .ref()
            .child('profile_images')
            .child(userId + '.jpg')
            .putFile(File(url));
      }
    } catch (e) {
      print('Error saving profile image url: $e');
    }
  }

  Future<void> deleteProfileImage(String userId) async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        await firebase_storage.FirebaseStorage.instance
            .ref()
            .child('profile_images')
            .child(userId + '.jpg')
            .delete();
        await _authService.saveProfileImageUrl('');
      }
    } catch (e) {
      print('Error deleting profile image: $e');
    }
  }
}
