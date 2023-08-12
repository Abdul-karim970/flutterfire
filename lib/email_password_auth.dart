import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutterfire/Email_password_after_auth_page.dart';
import 'package:google_sign_in/google_sign_in.dart';

class EmailPasswordAuthPage extends StatefulWidget {
  const EmailPasswordAuthPage({super.key});

  @override
  State<EmailPasswordAuthPage> createState() => _EmailPasswordAuthPageState();
}

class _EmailPasswordAuthPageState extends State<EmailPasswordAuthPage> {
  late TextEditingController passwordFieldController;
  late TextEditingController emailFieldController;

  @override
  void initState() {
    super.initState();
    passwordFieldController = TextEditingController();
    emailFieldController = TextEditingController();
  }

  @override
  void dispose() {
    passwordFieldController.dispose();
    emailFieldController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var firebaseInstance = FirebaseAuth.instance;

    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.green.shade200,
        ),
        body: Center(
          child: SizedBox(
            width: 300,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextField(
                  controller: emailFieldController,
                  decoration: const InputDecoration(
                      hintText: 'Email', border: OutlineInputBorder()),
                ),
                TextField(
                  controller: passwordFieldController,
                  decoration: const InputDecoration(
                      hintText: 'Password', border: OutlineInputBorder()),
                ),
                ElevatedButton(
                    onPressed: () async {
                      try {
                        final userCredential = await firebaseInstance
                            .createUserWithEmailAndPassword(
                                email: emailFieldController.text,
                                password: passwordFieldController.text);
                        if (mounted) {
                          Navigator.push(
                              context,
                              CupertinoPageRoute(
                                  builder: (context) => const AfterAuthPage(),
                                  settings: RouteSettings(
                                      arguments: userCredential.user)));
                        }
                      } on FirebaseAuthException catch (exception) {
                        ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(exception.code)));

                        // if (exception.code == 'weak-password') {

                        // }
                        //  else if (exception.code == 'email-already-in-use') {
                        //   ScaffoldMessenger.of(context).showSnackBar(
                        //       const SnackBar(
                        //           content: Text(
                        //               'Email already registered! try to SignIn')));
                        // }
                      }
                    },
                    child: const Text('SignUp')),
                ElevatedButton(
                    onPressed: () async {
                      try {
                        final userCredential =
                            await firebaseInstance.signInWithEmailAndPassword(
                                email: emailFieldController.text,
                                password: passwordFieldController.text);
                        if (mounted) {
                          Navigator.push(
                              context,
                              CupertinoPageRoute(
                                  builder: (context) => const AfterAuthPage(),
                                  settings: RouteSettings(
                                      arguments: userCredential.user)));
                        }
                      } on FirebaseAuthException catch (exception) {
                        // if (e.code == 'user-not-found') {
                        //   ScaffoldMessenger.of(context).showSnackBar(
                        //       const SnackBar(
                        //           content: Text('User not registered!')));
                        // } else if (e.code == 'wrong-password') {
                        //   ScaffoldMessenger.of(context).showSnackBar(
                        //       const SnackBar(
                        //           content: Text('Incorrect password')));
                        // }
                        ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(exception.code)));
                      }
                    },
                    child: const Text('SignIn')),
                ElevatedButton(
                    onPressed: () async {
                      var credential = await signInWithGoogle();
                      Navigator.push(
                          context,
                          CupertinoPageRoute(
                              builder: (context) => const AfterAuthPage(),
                              settings:
                                  RouteSettings(arguments: credential.user)));
                    },
                    child: Text('Google')),
                ElevatedButton(
                    onPressed: () {
                      final firebaseInst = FirebaseAuth.instance;
                      firebaseInst.sendPasswordResetEmail(
                          email: emailFieldController.text);
                    },
                    child: Text('Reset Password')),
              ],
            ),
          ),
        ));
  }
}

Future<UserCredential> signInWithGoogle() async {
  final firebaseInst = FirebaseAuth.instance;

  // Trigger the authentication flow
  final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

  // Obtain the auth details from the request
  final GoogleSignInAuthentication? googleAuth =
      await googleUser?.authentication;

  // Create a new credential
  final credential = GoogleAuthProvider.credential(
    accessToken: googleAuth?.accessToken,
    idToken: googleAuth?.idToken,
  );
  // Once signed in, return the UserCredential
  return await firebaseInst.signInWithCredential(credential);
}
