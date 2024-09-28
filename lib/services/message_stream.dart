import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../components/message_card.dart';

class MessageStream extends StatelessWidget {
   final  messageStream;
   final User loggedInUser;

  MessageStream({required this.messageStream, required this.loggedInUser});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: messageStream,
        builder: (context, snapshot) {

          //if error has happened during fetching the stream
          if (snapshot.hasError) {
            return const Text('Something went wrong');
          }
            // if the snapshot is in waiting state , waiting to fetch
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(
                backgroundColor: Colors.lightBlueAccent,
              ),
            );
          }

          //if all is well and good, do the following
          List<MessageCard> messageCardWidgets = [];

          var streamData = snapshot.data;
          var streamdata2 = streamData?.docs.reversed;
          String tempMessage;
          String tempSender;
          Timestamp tempTimeStamp;
          String formattedTime;
          final currentUser = loggedInUser.email;
//iterate through all the snapshot data that is fetched above and assign it to the MessageCard Parameter
// also we do the time format converting , to pick the time part only
// and the MessageCard widget is a custom widget that we built to use for displaying a single message

          for (var message in streamdata2!) {
            tempMessage = message['messageText'];
            tempSender = message['sender'];
            tempTimeStamp = message['createdAt'];
            var timeAndDate = tempTimeStamp.toDate().toString().split(" ");
            formattedTime = timeAndDate[1];
            var formattedTime2 = formattedTime.split(".");
            String formattedTime3 = formattedTime2[0];
            // print(formattedTime);
            // print(formattedTime3);

            messageCardWidgets.add(MessageCard(
              message: tempMessage,
              sender: tempSender,
              timestamp: formattedTime3,
              isMe: currentUser == tempSender,
            ));
          }
// and here after we collect every message(using MessageCard) in a list
          // we will return a list view, with all the messages
          return Expanded(
              child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 5,
            ),
            child: ListView(reverse: true, children: messageCardWidgets),
          ));
        });
  }
}
