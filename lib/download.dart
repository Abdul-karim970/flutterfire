import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'email_password_auth.dart';
import 'phone_auth_page.dart';

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
            SizedBox(
              width: 200,
              height: 200,
              child: Builder(
                builder: (context) => image,
              ),
            ),
            ElevatedButton(
                onPressed: () async {
                  setState(() {
                    image = const CircularProgressIndicator();
                  });
                  try {
                    var data = await imageRef.getDownloadURL();
                    image = Image.network(data);
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
                        image = Image.network(imageUrl);
                      });

                      await Future.delayed(const Duration(seconds: 3));
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
                child: const Text('Go to Phone Auth'))
          ],
        ),
      ),
    );
  }
}
