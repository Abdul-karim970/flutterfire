import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutterfire/download.dart';
import 'package:image_picker/image_picker.dart';

class Storage extends StatefulWidget {
  const Storage({super.key});

  @override
  State<Storage> createState() => _StorageState();
}

class _StorageState extends State<Storage> {
  int count = 0;
  String status = '';
  @override
  Widget build(BuildContext context) {
    final storageRef = FirebaseStorage.instance.ref();
    final imageFolderRef = storageRef.child('image');
    final imageFolder = storageRef.child('Folder');

    return Scaffold(
        appBar: AppBar(
          title: const Text('Storage'),
          backgroundColor: Colors.greenAccent.shade100,
        ),
        body: Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text(
              status,
              style: TextStyle(fontSize: 30),
            ),
            ElevatedButton(
                onPressed: () async {
                  /**
                           * 
                           *   var images = await imagePicker.pickMultiImage(
                              maxWidth: 100,
                              maxHeight: 100,
                              imageQuality: 1,
                              requestFullMetadata: true);
                          // final pickedImage =
                          //     await imagePicker.pickImage(source: ImageSource.camera);
                          for (var image in images) {
                            var file = File(image.path);
                            try {
                              imageRef.putFile(file);
                            } catch (e) {
                              print(e.toString());
                            }
                          }
                           * 
                           * 
                           */

                  ImagePicker imagePicker = ImagePicker();
                  // final pickedImage =
                  //     await imagePicker.pickImage(source: ImageSource.camera);

                  final pickedImages = await imagePicker.pickMultiImage();
                  for (var image in pickedImages) {
                    final file = File(image.path);
                    try {
                      final pickedImageRef = imageFolderRef.child(image.name);
                      var task = pickedImageRef.putFile(file);
                      task.snapshotEvents.listen((event) {
                        switch (event.state) {
                          case TaskState.running:
                            setState(() {
                              status =
                                  'Uploading...${((event.bytesTransferred / event.totalBytes) * 100).toInt()}%';
                            });

                            break;
                          case TaskState.success:
                            setState(() {
                              status = 'Completed.';
                            });

                            break;
                          default:
                            status = '';
                        }
                      });
                    } catch (e) {
                      print(e.toString());
                    }
                  }
                },
                child: const Text('Upload')),
            ElevatedButton(
                onPressed: () => Navigator.of(context).push(CupertinoPageRoute(
                      builder: (context) => Download(),
                    )),
                child: Text('Go to Download'))
          ],
        )));
  }
}
