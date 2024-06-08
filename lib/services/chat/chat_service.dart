import 'package:cloud_firestore/cloud_firestore.dart';

class ChatService {
  // get inst of firestore
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

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

  // receive msg
}
