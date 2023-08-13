import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutterfire/Notification/appointment_modal.dart';

import 'firebase_connstants.dart';
import 'package:http/http.dart' as http;

class NotificationsPageAdmin extends StatefulWidget {
  const NotificationsPageAdmin({super.key});

  @override
  State<NotificationsPageAdmin> createState() => _NotificationsPageAdminState();
}

class _NotificationsPageAdminState extends State<NotificationsPageAdmin> {
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
                  var adminToken = await FirebaseMessaging.instance.getToken();

                  var db = FirebaseFirestore.instance;
                  db
                      .collection(collNotification)
                      .doc(docAdminToken)
                      .set({docTokenFieldAdminToken: adminToken});
                },
                child: const Text('Click to Ready')),
            ElevatedButton(
                onPressed: () async {
                  sendConfirmationMessage(
                      appointment: Appointment(
                          name: 'AK',
                          time: DateTime(
                            2023,
                            8,
                            13,
                          ),
                          service: 'None',
                          status: 'Done'));
                },
                child: const Text('Notification to Client'))
          ],
        ),
      ),
    );
  }
}

sendConfirmationMessage({required Appointment appointment}) async {
  var db = FirebaseFirestore.instance;
  var serverKey =
      'AAAANYBU12k:APA91bHPqjFV2cI-yi7m-6ut7uFc5fhvYFZWzWhTP7OG7EwjaeMj7Y-FdQarhAsSgk1CKeo6dWtLPEQcKozcY0-81JnpUCoFfHIRh2MO7F63ADd-GBDpj2ED6okM8su5YG3ORrsTX8cT';
  var docSnapshot =
      await db.collection(collNotification).doc(docClientToken).get();
  String token = docSnapshot.data()![docTokenFieldClientToken];
  if (token.isEmpty) {
    return;
  }
  String constructResponseMessage(String token) {
    return jsonEncode({
      'notification': {
        'title': 'Appointment Confirmed!',
        'body': 'Most welcome Mr ${appointment.name}'
      },
      'data': {'name': appointment.name},
      'to': token,
    });
  }

  try {
    var response =
        await http.post(Uri.parse('https://fcm.googleapis.com/fcm/send'),
            headers: <String, String>{
              'Content-Type': 'application/json',
              'Authorization': 'key=$serverKey',
            },
            body: constructResponseMessage(token));

    print(
        'Successfully sent confirmation message. StatusCode: ${response.statusCode}');
  } catch (e) {
    print('Fail Sending Confirmation message $e');
  }
}
