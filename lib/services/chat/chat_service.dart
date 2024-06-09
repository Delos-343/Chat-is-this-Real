import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ChatService {
  // get inst of firestore + auth
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // get user stream
  /*
    List<Map<String, dynamic> = 
    [
      {
        'email': oogabooga@gmail.com,
        'id': ...
      }
      {
        'email': grog@gmail.com,
        'id': ...
      }
    ]
  */
  Stream<List<Map<String, dynamic>>> getUserStream() {
    return _firestore.collection("Users").snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        // for each user
        final user = doc.data();

        // get user
        return user;
      }).toList();
    });
  }

  // send msg
  Future<void> sendMessage(String receiverID, message) async {
    // Get current user info
    final String currentUserID = _auth.currentUser!.uid;
    final String currentUserEmail = _auth.currentUser!.email!;
    final Timestamp timestamp = Timestamp.now();

    // Create new msg

    // Make a chat room between two users
  }

  // get msg
}
