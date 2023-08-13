import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import 'package:flutter/material.dart';
import 'package:flutterfire/firebase_connstants.dart';

import 'appointment_modal.dart';
import 'package:http/http.dart' as http;

class NotificationsPageClient extends StatefulWidget {
  const NotificationsPageClient({super.key});

  @override
  State<NotificationsPageClient> createState() =>
      _NotificationsPageClientState();
}

class _NotificationsPageClientState extends State<NotificationsPageClient> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green.shade200,
        title: const Text('Client Page'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton(
                onPressed: () async {
                  var clientToken = await FirebaseMessaging.instance.getToken();

                  var db = FirebaseFirestore.instance;
                  db
                      .collection(collNotification)
                      .doc(docClientToken)
                      .set({docTokenFieldClientToken: clientToken});
                },
                child: const Text('Click to Ready')),
            ElevatedButton(
                onPressed: () async {
                  sendNotificationToAdmin(
                      appointment: Appointment(
                          name: 'AK',
                          time: DateTime(
                            2023,
                            8,
                            13,
                          ),
                          service: 'Project meeting',
                          status: 'Relaxing'));
                },
                child: const Text('Notification to Admin')),
          ],
        ),
      ),
    );
  }
}

sendNotificationToAdmin({required Appointment appointment}) async {
  var db = FirebaseFirestore.instance;
  var docSnapshot =
      await db.collection(collNotification).doc(docAdminToken).get();
  String token = docSnapshot.data()![docTokenFieldAdminToken];
  if (token.isEmpty) {
    print('Empty token');
    return;
  }
  var serverKey =
      'AAAANYBU12k:APA91bHPqjFV2cI-yi7m-6ut7uFc5fhvYFZWzWhTP7OG7EwjaeMj7Y-FdQarhAsSgk1CKeo6dWtLPEQcKozcY0-81JnpUCoFfHIRh2MO7F63ADd-GBDpj2ED6okM8su5YG3ORrsTX8cT';

  String constructFCMPayload(String token) {
    return jsonEncode(
      <String, dynamic>{
        'notification': <String, dynamic>{
          'body':
              "You have a new appointment for ${appointment.time.toString()} ${appointment.time.day}",
          'title': "New Appointment",
        },
        'data': <String, dynamic>{
          'id': appointment.id,
          'name': appointment.name,
          'time': appointment.time.toString(),
          'service': appointment.service,
          'status': appointment.status,
        },
        'to': token
      },
    );
  }

  try {
    var response = await http.post(Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'key=$serverKey',
        },
        body: constructFCMPayload(token));

    print('Posted Successfully ${response.statusCode}');
  } catch (e) {
    print('Notificatin Not Send');
  }
}
