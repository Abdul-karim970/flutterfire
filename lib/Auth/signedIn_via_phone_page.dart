import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutterfire/Auth/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Storage/download.dart';

class PhoneSignedInPage extends StatefulWidget {
  const PhoneSignedInPage({super.key});

  @override
  State<PhoneSignedInPage> createState() => _PhoneSignedInPageState();
}

class _PhoneSignedInPageState extends State<PhoneSignedInPage> {
  @override
  Widget build(BuildContext context) {
    final sms = ModalRoute.of(context)!.settings.arguments as String;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green.shade200,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text(sms),
            // TextField(
            //   controller: sms,
            //   decoration: InputDecoration(border: OutlineInputBorder()),
            // ),
            // ElevatedButton(
            //     onPressed: () {
            //       ob.verifyTheOTP(sms.text);
            //     },
            //     child: Text('Verify')),
            ElevatedButton(
                onPressed: () async {
                  SharedPreferences sharedPreferences =
                      await SharedPreferences.getInstance();
                  FirebaseAuth.instance.signOut();
                  sharedPreferences.setBool(isLoggedInWithPhone, false);
                  sharedPreferences.setString(userPhone, '');
                  Navigator.pop(context);
                },
                child: const Text('SignOut'))
          ],
        ),
      ),
    );
  }
}
