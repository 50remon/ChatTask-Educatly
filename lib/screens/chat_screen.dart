import 'package:flutter/material.dart';
import 'package:flutter_master_chat_app/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_master_chat_app/services/message_stream.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../components/message_card.dart';

class ChatScreen extends StatefulWidget {
  static const String id = "chat_screen";

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _fireStore = FirebaseFirestore.instance;
  final Stream<QuerySnapshot> _messageStream = FirebaseFirestore.instance
      .collection('messages')
      .orderBy('createdAt')
      .snapshots();

  final _auth = FirebaseAuth.instance;
  final messageTextController = TextEditingController();
  late User loggedInUser;
  late String messages;

  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }

  void getCurrentUser() async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        loggedInUser = user;
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ProgressHUD(
      child: Builder(
        builder: (context) => Scaffold(
          backgroundColor: Colors.black,
          appBar: AppBar(
            title: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const Text('M️Chat sebtion'),
                Spacer(), // لإضافة مسافة بين النص والصورة
                CircleAvatar(
                  radius: 20.0, // تعديل الحجم حسب الحاجة
                  backgroundImage: AssetImage('images/master_chat_icon.png'),
                ),
              ],
            ),
            backgroundColor: Colors.lightBlueAccent,
          ),
          body: SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                MessageStream(
                  messageStream: _messageStream,
                  loggedInUser: loggedInUser,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          style: TextStyle(color: Colors.white), // لون النص
                          controller: messageTextController,
                          onChanged: (value) {
                            messages = value;
                          },
                          decoration: kMessageTextFieldDecoration.copyWith(
                            fillColor: Colors.grey[850], // لون خلفية حقل الإدخال
                            filled: true, // تأكيد ملء الخلفية
                            hintStyle: TextStyle(color: Colors.grey), // لون النص التلميحي
                          ),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          if (messages.isNotEmpty) {
                            _fireStore.collection('messages').add({
                              'messageText': messages,
                              'sender': loggedInUser.email,
                              'createdAt': Timestamp.now(),
                            });
                            messageTextController.clear();
                          }
                        },
                        child: const Text(
                          'Send',
                          style: kSendButtonTextStyle,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
