import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutterfire/Notification/FCM_client.dart';
import 'package:flutterfire/Storage/download.dart';
import 'package:image_picker/image_picker.dart';

import '../Notification/FCM_admin.dart';

class Storage extends StatefulWidget {
  const Storage({super.key});

  @override
  State<Storage> createState() => _StorageState();
}

class _StorageState extends State<Storage> {
  // Notification Related Stuff

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

    FirebaseMessaging.onMessage.listen(respondToMessage);
    // FirebaseMessaging.instance.subscribeToTopic('topic');
    // FirebaseMessaging.instance.unsubscribeFromTopic('topic');
  }

  @override
  void initState() {
    super.initState();
    setUpInteractingMessaging();
  }

  int count = 0;
  String status = '';
  @override
  Widget build(BuildContext context) {
    final storageRef = FirebaseStorage.instance.ref();
    final imageFolderRef = storageRef.child('image');
    // final imageFolder = storageRef.child('Folder');

    return Scaffold(
        appBar: AppBar(
          title: const Text('Storage'),
          backgroundColor: Colors.greenAccent.shade100,
        ),
        body: Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text(
              status,
              style: const TextStyle(fontSize: 30),
            ),
            ElevatedButton(
                onPressed: () async {
                  /**
                           * 
                           *   var images = await imagePicker.pickMultiImage(
                              maxWidth: 100,
                              maxHeight: 100,
                              imageQuality: 1,
                              requestFullMetadata: true);
                          // final pickedImage =
                          //     await imagePicker.pickImage(source: ImageSource.camera);
                          for (var image in images) {
                            var file = File(image.path);
                            try {
                              imageRef.putFile(file);
                            } catch (e) {
                              print(e.toString());
                            }
                          }
                           *
                           *
                           */

                  ImagePicker imagePicker = ImagePicker();
                  // final pickedImage =
                  //     await imagePicker.pickImage(source: ImageSource.camera);

                  final pickedImages = await imagePicker.pickMultiImage();
                  for (var image in pickedImages) {
                    final file = File(image.path);
                    try {
                      final pickedImageRef = imageFolderRef.child(image.name);
                      var task = pickedImageRef.putFile(file);
                      task.snapshotEvents.listen((event) {
                        switch (event.state) {
                          case TaskState.running:
                            setState(() {
                              status =
                                  'Uploading...${((event.bytesTransferred / event.totalBytes) * 100).toInt()}%';
                            });

                            break;
                          case TaskState.success:
                            setState(() {
                              status = 'Completed.';
                            });

                            break;
                          default:
                            status = '';
                        }
                      });
                    } catch (e) {
                      print(e.toString());
                    }
                  }
                },
                child: const Text('Upload')),
            ElevatedButton(
                onPressed: () => Navigator.of(context).push(CupertinoPageRoute(
                      builder: (context) => const Download(),
                    )),
                child: const Text('Go to Download')),
            ElevatedButton(
                onPressed: () => Navigator.of(context).push(CupertinoPageRoute(
                      builder: (context) => const NotificationsPageClient(),
                    )),
                child: const Text('Client Side')),
            ElevatedButton(
                onPressed: () => Navigator.of(context).push(CupertinoPageRoute(
                      builder: (context) => const NotificationsPageAdmin(),
                    )),
                child: const Text('Admin Side')),
          ],
        )));
  }
}


/**
  Future<void> setUpInteractingWithMessages() async {
void _messageHandler(RemoteMessage message) {
    Map<String, dynamic> json = message.data;

    if (message.data['service'] != null) {
      Appointment appt = Appointment(
          name: json['name'],
          time: DateTime.parse(json['time']),
          service: json['service'],
          status: json['status'],
          id: json['id']);
      Navigator.push(context, MaterialPageRoute(builder: (context) => NotificationsPageAdmin(),))
    } else {
           Navigator.push(context, MaterialPageRoute(builder: (context) => NotificationsPageAdmin(),))

    }
  }


    FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
    firebaseMessaging.requestPermission(
        alert: true,
        announcement: true,
        badge: true,
        carPlay: true,
        criticalAlert: true,
        provisional: true,
        sound: true);

    print('Permission Granted');

    var initialMessage = await firebaseMessaging.getInitialMessage();
    if (initialMessage != null) {
      _messageHandler(initialMessage);
    }

    FirebaseMessaging.onMessageOpenedApp.listen(_messageHandler);
    FirebaseMessaging.onMessage.listen((event) async {
      RemoteNotification? notification = event.notification;
      AndroidNotification? android = event.notification?.android;

      FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
          FlutterLocalNotificationsPlugin();
      AndroidNotificationChannel androidNotificationChannel =
          const AndroidNotificationChannel(
        'schedular_channel', // id
        'Schedular Notifications', // title
        description:
            'This channel is used for Schedular app notifications.', // description
        importance: Importance.max,
      );

      await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()
          ?.createNotificationChannel(androidNotificationChannel);

      if (notification != null && android != null) {
        flutterLocalNotificationsPlugin.show(
            notification.hashCode,
            notification.title,
            notification.body,
            NotificationDetails(
              android: AndroidNotificationDetails(
                androidNotificationChannel.id,
                androidNotificationChannel.name,
                channelDescription: androidNotificationChannel.description,
              ),
            ));
      }
    });
  }

   */