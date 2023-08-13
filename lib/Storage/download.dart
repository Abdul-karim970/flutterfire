import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutterfire/Auth/signedIn_via_phone_page.dart';

import '../Auth/email_password_auth.dart';
import '../Auth/phone_auth_page.dart';

class Download extends StatefulWidget {
  const Download({super.key});

  @override
  State<Download> createState() => _DownloadState();
}

class _DownloadState extends State<Download> {
  final storageRef = FirebaseStorage.instance.ref();

  Widget image = const SizedBox();

  @override
  Widget build(BuildContext context) {
    final folderRef = storageRef.child('Folder');
    final imageRef = folderRef.child('image1');
    final imageFolderRef = storageRef.child('image');
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green.shade200,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                const SizedBox(
                  width: 200,
                  height: 200,
                ),
                Builder(
                  builder: (context) => image,
                ),
              ],
            ),
            ElevatedButton(
                onPressed: () async {
                  setState(() {
                    image = const CircularProgressIndicator();
                  });
                  try {
                    var data = await imageRef.getDownloadURL();
                    image = Container(
                      width: 200,
                      height: 200,
                      decoration: BoxDecoration(
                          color: Colors.blueGrey.shade100,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.black38,
                              blurRadius: 5,
                              offset: Offset(3, 3),
                            )
                          ],
                          image: DecorationImage(
                              fit: BoxFit.fill, image: NetworkImage(data))),
                    );
                    setState(() {});
                  } catch (e) {
                    ScaffoldMessenger.of(context)
                        .showSnackBar(SnackBar(content: Text(e.toString())));
                  }
                },
                child: const Text('Download')),
            ElevatedButton(
                onPressed: () async {
                  final newMetadata = SettableMetadata(
                      customMetadata: {'name': 'MyImage', 'id': 'unique'});
                  final meta = await imageRef.updateMetadata(newMetadata);
                  if (!mounted) {
                    return;
                  }

                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content:
                          Text('MetaData: ${meta.customMetadata!['name']}')));
                },
                child: const Text('Update Meta')),
            ElevatedButton(
                onPressed: () async {
                  ListResult fileList = await imageFolderRef.listAll();
                  for (var item in fileList.items) {
                    if (mounted) {
                      setState(() {
                        image = const CircularProgressIndicator();
                      });
                      var imageUrl = await item.getDownloadURL();
                      if (!mounted) {
                        return;
                      }

                      setState(() {
                        image = Container(
                          width: 200,
                          height: 200,
                          decoration: BoxDecoration(
                              color: Colors.blueGrey.shade100,
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: const [
                                BoxShadow(
                                  color: Colors.black38,
                                  blurRadius: 5,
                                  offset: Offset(3, 3),
                                )
                              ],
                              image: DecorationImage(
                                  fit: BoxFit.fill,
                                  image: NetworkImage(imageUrl))),
                        );
                      });

                      await Future.delayed(const Duration(seconds: 4));
                    }
                  }
                },
                child: const Text('Download All')),
            ElevatedButton(
                onPressed: () => Navigator.push(
                    context,
                    CupertinoPageRoute(
                      builder: (context) => const EmailPasswordAuthPage(),
                    )),
                child: const Text('Go to EmailAuth')),
            ElevatedButton(
                onPressed: () => Navigator.push(
                    context,
                    CupertinoPageRoute(
                      builder: (context) => const PhoneAuthPage(),
                    )),
                child: const Text('Go to Phone Auth')),
            ElevatedButton(
                onPressed: () {
                  AuthenticationWithMobileNumber withMobileNumber =
                      AuthenticationWithMobileNumber();
                  withMobileNumber
                      .loginWithMobileNumber(mobileNumber: '+923306861356')
                      .then((value) {
                    print('$value isTrue?');
                    value
                        ? Navigator.push(
                            context,
                            CupertinoPageRoute(
                              settings:
                                  RouteSettings(arguments: withMobileNumber),
                              builder: (context) => const PhoneSignedInPage(),
                            ))
                        : print(value);
                  });
                },
                child: const Text('Phone Waqas'))
          ],
        ),
      ),
    );
  }
}

class AuthenticationWithMobileNumber {
  String verificationCode = '';

  var auth = FirebaseAuth.instance;

  Future<bool> loginWithMobileNumber({
    required String mobileNumber,
  }) async {
    try {
      await auth.verifyPhoneNumber(
        timeout: const Duration(minutes: 2),
        phoneNumber: mobileNumber,
        verificationCompleted: (phoneAuthCredential) async {
          await auth.signInWithCredential(phoneAuthCredential).then((value) {
            print("Login suceess fully");
            print(value.user!.phoneNumber);
            print(value.user!.uid);
          });
        },
        verificationFailed: (error) async {
          print('This is the error ${error.code}');
        },
        codeSent: (verificationId, forceResendingToken) async {
          verificationCode = verificationId;
          print('code has send');
        },
        codeAutoRetrievalTimeout: (verificationId) {
          verificationCode = verificationId;
          print('code has send and verification id is $verificationId');
        },
      );
      return true;
    } on FirebaseAuthException catch (e) {
      print(e.code);
      return false;
    }
  }

  Future<bool> verifyTheOTP(String sms) async {
    print(verificationCode);

    try {
      PhoneAuthCredential authCredential = PhoneAuthProvider.credential(
          verificationId: verificationCode, smsCode: sms);
      print(authCredential.verificationId);
      await auth.signInWithCredential(authCredential).then((value) {
        print('successfully login');
      });
      return true;
    } catch (e) {
      return false;
    }

    // return credential.user != null ? true : false;
  }
}
