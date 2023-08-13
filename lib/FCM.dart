import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import 'package:flutter/material.dart';

class NotificationPageClient extends StatefulWidget {
  const NotificationPageClient({super.key});

  @override
  State<NotificationPageClient> createState() => _NotificationPageClientState();
}

class _NotificationPageClientState extends State<NotificationPageClient> {
  Future<void> setUpInteractingMessaging() async {
    Future<void> respondToMessage(RemoteMessage message) async {
      print('I\'m not going to Any screen, run your default navigation');
    }

    RemoteMessage? remoteMessage =
        await FirebaseMessaging.instance.getInitialMessage();
    if (remoteMessage != null) {
      respondToMessage(remoteMessage);
    }
    FirebaseMessaging.onMessageOpenedApp.listen(respondToMessage);

    FirebaseMessaging.onBackgroundMessage(
      respondToMessage,
    );

    FirebaseMessaging.onMessage.listen(respondToMessage);
    FirebaseMessaging.instance.subscribeToTopic('topic');
    FirebaseMessaging.instance.unsubscribeFromTopic('topic');
  }

  @override
  void initState() {
    super.initState();
    setUpInteractingMessaging();

    // Push Notification Stuff
    var db = FirebaseFirestore.instance;
    FirebaseMessaging.instance.getToken().then((token) {
      db.collection('Notification').doc('Admin').update({'admin_token': token});
    });
  }

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
