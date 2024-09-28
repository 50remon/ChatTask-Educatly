import 'package:flutter/material.dart';
// this class oh sorry widget is created for the purpose of modularity
// it represents the single button like structure used to show a single message
// with the sender and timestamp information
// and we differentiate some styling based on the sender using the isMe boolean variable.

class MessageCard extends StatelessWidget {
  final String message;
  final String sender;
  final String timestamp;
  final bool isMe;
  MessageCard(
      {required this.message,
      required this.sender,
      required this.isMe,
      required this.timestamp});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(6.0),
      child: Column(
        crossAxisAlignment:
            isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Text(
            sender,
            style: const TextStyle(fontSize: 12, color: Colors.grey),
          ),
          Material(
            elevation: 5.0,
            borderRadius: isMe
                ? const BorderRadius.only(
                    topLeft: Radius.circular(25),
                    bottomLeft: Radius.circular(25),
                    topRight: Radius.circular(25))
                : const BorderRadius.only(
                    topRight: Radius.circular(25),
                    topLeft: Radius.circular(25),
                    bottomRight: Radius.circular(25)),
            color: isMe ? Colors.lightBlueAccent : Colors.white,
            child: Padding(
              padding:
                  const EdgeInsets.only(top: 8, left: 8, right: 8, bottom: 2),
              child: Column(
                crossAxisAlignment:
                    isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                children: [
                  Text(
                    message,
                    style: TextStyle(
                        fontSize: 15,
                        color: isMe ? Colors.white : Colors.black),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Text(
                    timestamp,
                    style: TextStyle(
                        fontSize: 11,
                        color: isMe ? Colors.white70 : Colors.black54),
                    // textAlign: TextAlign.start,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
