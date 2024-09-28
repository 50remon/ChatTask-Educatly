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
      .orderBy(
        'createdAt',
      )
      .snapshots();

  final _auth = FirebaseAuth.instance;
  final messageTextController =
      TextEditingController(); // to clear the textField after sending the text
  late User loggedInUser; // to hold the currently loggedIn user
  late String messages;

  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }

  void getCurrentUser() async {
    // _auth.authStateChanges().listen((User? user) {
    //   if (user == null) {
    //     print('User is currently signed out!');
    //   } else {
    //     loggedInUser = user;
    //
    //     print('User is signed in!');
    //     // return loggedInUser.email.toString();
    //   }
    // });

    //or
    try {
      final user = _auth.currentUser;
      if (user != null) {
        loggedInUser = user;
      }
    } catch (e) {
      print(e);
    }
  }

  // from here on the two methods found below we don't need them for the chat app
  // am just keeping the code because i want to keep them

  // void getMessages() async {
  //   var messages = await _fireStore.collection('messages').get();
  //   // print(messages.docs.toList();
  //   for (var messages in messages.docs) {
  //     print(messages.data().values);
  //     for (var message in messages.data().values) {
  //       print(message);
  //     }
  //     print("***");
  //   }
  // }
  //
  // void getMessageFromStream() async {
  //   await for (var snapshot in _fireStore.collection('messages').snapshots()) {
  //     for (var messages in snapshot.docs) {
  //       print("here ..");
  //       print(messages.data());
  //       var a = messages.data();
  //       print("from " + a['sender']);
  //     }
  //   }
  // }

  // up to here
  //

  @override
  Widget build(BuildContext context) {
    return ProgressHUD(
      child: Builder(
        builder: (context) => Scaffold(
          appBar: AppBar(
            actions: <Widget>[
              IconButton(
                  icon: const Icon(Icons.logout_outlined),
                  onPressed: () async {
                    final progressIndicator = ProgressHUD.of(context);
                    progressIndicator?.showWithText("Signing Out ...");
                    await _auth.signOut();
                    Navigator.pop(context);
                    progressIndicator?.dismiss();
                  }),
            ],
            title: const Text('M️Chat'),
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
                Container(
                  decoration: kMessageContainerDecoration,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: TextField(
                          controller: messageTextController,
                          onChanged: (value) {
                            messages = value;
                          },
                          decoration: kMessageTextFieldDecoration,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          _fireStore.collection('messages').add({
                            'messageText': messages,
                            'sender': loggedInUser.email,
                            'createdAt': Timestamp.now()
                          });
                          messageTextController.clear();
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
