import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutterfire/signedIn_via_phone_page.dart';

class PhoneAuthPage extends StatefulWidget {
  const PhoneAuthPage({super.key});

  @override
  State<PhoneAuthPage> createState() => _PhoneAuthPageState();
}

class _PhoneAuthPageState extends State<PhoneAuthPage> {
  late TextEditingController phoneNoFieldController;
  late TextEditingController smsController;
  @override
  void initState() {
    super.initState();
    phoneNoFieldController = TextEditingController();
    smsController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green.shade200,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            SizedBox(
              width: 300,
              child: TextField(
                keyboardType: TextInputType.phone,
                controller: phoneNoFieldController,
                decoration: const InputDecoration(
                    hintText: 'Phone', border: OutlineInputBorder()),
              ),
            ),
            ElevatedButton(
                onPressed: () async {
                  var auth = FirebaseAuth.instance;
                  auth.verifyPhoneNumber(
                    phoneNumber: phoneNoFieldController.text.trim(),
                    verificationCompleted: (phoneAuthCredential) {
                      auth
                          .signInWithCredential(phoneAuthCredential)
                          .then((user) => {
                                Navigator.push(
                                    context,
                                    CupertinoPageRoute(
                                      settings:
                                          RouteSettings(arguments: user.user),
                                      builder: (context) =>
                                          const PhoneSignedInPage(),
                                    ))
                              });
                    },
                    verificationFailed: (error) => ScaffoldMessenger.of(context)
                        .showSnackBar(SnackBar(
                            content:
                                SnackBar(content: Text(error.toString())))),
                    codeSent: (verificationId, forceResendingToken) {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                              title: const Text('Verify sms'),
                              content: Column(
                                children: [
                                  SizedBox(
                                      width: 200,
                                      child: TextField(
                                        keyboardType: TextInputType.number,
                                        controller: smsController,
                                        decoration: const InputDecoration(
                                            border: OutlineInputBorder()),
                                      ))
                                ],
                              ),
                              actions: [
                                ElevatedButton(
                                    onPressed: () {
                                      try {
                                        var phoneAuthCredential =
                                            PhoneAuthProvider.credential(
                                                verificationId: verificationId,
                                                smsCode: smsController.text);
                                        auth
                                            .signInWithCredential(
                                                phoneAuthCredential)
                                            .then((user) {
                                          Navigator.push(
                                              context,
                                              CupertinoPageRoute(
                                                settings: RouteSettings(
                                                    arguments: user.user),
                                                builder: (context) =>
                                                    const PhoneSignedInPage(),
                                              ));
                                        });
                                      } on FirebaseAuthException catch (e) {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(SnackBar(
                                                content: Text(e.toString())));
                                      }
                                    },
                                    child: const Text('Done'))
                              ]);
                        },
                      );
                    },
                    timeout: const Duration(seconds: 120),
                    codeAutoRetrievalTimeout: (verificationId) {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          content:
                              SnackBar(content: Text('Request timed out'))));
                    },
                  );
                },
                child: const Text('Get Code'))
          ],
        ),
      ),
    );
  }
}
