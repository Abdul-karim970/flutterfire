import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutterfire/Auth/constants.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AfterAuthPage extends StatefulWidget {
  const AfterAuthPage({super.key});

  @override
  State<AfterAuthPage> createState() => _AfterAuthPageState();
}

class _AfterAuthPageState extends State<AfterAuthPage> {
  @override
  Widget build(BuildContext context) {
    var user = ModalRoute.of(context)!.settings.arguments as User;

    return Scaffold(
      appBar: AppBar(
        title: const Text('After Auth Page'),
        backgroundColor: Colors.green.shade200,
      ),
      body: Align(
        alignment: Alignment.topCenter,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Image.network(user.photoURL ??
                'https://img.freepik.com/free-photo/flag-pakistan_1401-192.jpg?w=740&t=st=1691749578~exp=1691750178~hmac=ea0367fbde1ef660f6cd68b4fed1b14ded549f9c98d006f4ae8f057de107d372'),
            Text('Welcome ${user.displayName}'),
            ElevatedButton(
                onPressed: () async {
                  var firebaseInstance = await FirebaseAuth.instance;
                  SharedPreferences sharedPreferences =
                      await SharedPreferences.getInstance();
                  firebaseInstance.signOut();
                  GoogleSignIn().signOut();
                  sharedPreferences.setBool(isLoggedIn, false);
                  Navigator.pop(context);
                },
                child: Text('SignOut'))
          ],
        ),
      ),
    );
  }
}
