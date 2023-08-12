import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class PhoneSignedInPage extends StatefulWidget {
  const PhoneSignedInPage({super.key});

  @override
  State<PhoneSignedInPage> createState() => _PhoneSignedInPageState();
}

class _PhoneSignedInPageState extends State<PhoneSignedInPage> {
  @override
  Widget build(BuildContext context) {
    final user = ModalRoute.of(context)!.settings.arguments as User;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green.shade200,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            DecoratedBox(decoration: BoxDecoration()),
            Text('Welcome User using ${user.phoneNumber}'),
            ElevatedButton(
                onPressed: () {
                  FirebaseAuth.instance.signOut();
                  Navigator.pop(context);
                },
                child: Text('SignOut'))
          ],
        ),
      ),
    );
  }
}
