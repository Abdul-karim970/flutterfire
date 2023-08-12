import 'package:firebase_messaging/firebase_messaging.dart';

import 'package:flutter/material.dart';

class Notifications extends StatefulWidget {
  const Notifications({super.key});

  @override
  State<Notifications> createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {
  // Future<void> setUpIntrectingMessages() async {
  //   final fireMessagesInstance = await FirebaseMessaging.instance;
  //   RemoteMessage? initialMessage =
  //       await fireMessagesInstance.getInitialMessage();

  //   FirebaseMessaging.onMessageOpenedApp.listen((remoteMessage) {});
  //   FirebaseMessaging.onBackgroundMessage((message) {

  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green.shade200,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
                onPressed: () async {
                  var messagingInstance = await FirebaseMessaging.instance;
                  var token = await messagingInstance.getToken();
                  messagingInstance.onTokenRefresh.listen((event) {});
                  print('This $token');
                },
                child: Text('Notification'))
          ],
        ),
      ),
    );
  }
}
