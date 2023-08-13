import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../Storage/download.dart';

class PhoneSignedInPage extends StatefulWidget {
  const PhoneSignedInPage({super.key});

  @override
  State<PhoneSignedInPage> createState() => _PhoneSignedInPageState();
}

class _PhoneSignedInPageState extends State<PhoneSignedInPage> {
  @override
  Widget build(BuildContext context) {
    var sms = TextEditingController();
    final ob = ModalRoute.of(context)!.settings.arguments
        as AuthenticationWithMobileNumber;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green.shade200,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            TextField(
              controller: sms,
              decoration: InputDecoration(border: OutlineInputBorder()),
            ),
            ElevatedButton(
                onPressed: () {
                  ob.verifyTheOTP(sms.text);
                },
                child: Text('Verify')),
            ElevatedButton(
                onPressed: () {
                  FirebaseAuth.instance.signOut();
                  Navigator.pop(context);
                },
                child: const Text('SignOut'))
          ],
        ),
      ),
    );
  }
}
