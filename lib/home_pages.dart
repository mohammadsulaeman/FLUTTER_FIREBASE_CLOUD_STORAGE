import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:storagefirebase/success_pages.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Future<FirebaseApp> future = Firebase.initializeApp();
  final storageRef = FirebaseStorage.instance.ref();
  File? imagesFile;
  ImagePicker picker = ImagePicker();

  // uploadImages
  Future uploadImages(File images) async {
    String fileName = images.path.split('/').last;
    try {
      TaskSnapshot snapshot = await await storageRef
          .child('/images/profile/$fileName')
          .putFile(images);
      if (snapshot.state == TaskState.success) {
        String downloadUrlImages = await snapshot.ref.getDownloadURL();
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: ((builder) => MySuccess(fileName: downloadUrlImages)),
          ),
        );
      }
    } on FirebaseException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.message.toString()),
        ),
      );
    }
  }

  // ambil gambar
  Future getImageCamera() async {
    final pickedFile =
        await picker.pickImage(source: ImageSource.camera, imageQuality: 100);
    if (pickedFile != null) {
      setState(() {
        imagesFile = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter Firebase Cloud Storage'),
      ),
      body: FutureBuilder(
        future: future,
        builder: ((context, snapshot) {
          if (snapshot.hasError) {
            return const CircularProgressIndicator();
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          } else {
            return Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  imagesFile != null
                      ? ClipOval(
                          child: Image.file(
                            imagesFile!,
                            width: 100,
                            height: 100,
                            fit: BoxFit.cover,
                          ),
                        )
                      : const SizedBox(
                          width: 100,
                          height: 100,
                          child: Icon(
                            Icons.person,
                          ),
                        ),
                  const Text(
                    'Choose Image',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Positioned(
                    child: CircleAvatar(
                      radius: 15,
                      backgroundColor: Colors.grey,
                      child: Center(
                        child: InkWell(
                          onTap: () {
                            showModalBottomSheet(
                              context: context,
                              builder: ((builder) => Container(
                                    width: MediaQuery.of(context).size.width,
                                    margin: const EdgeInsets.symmetric(
                                      horizontal: 20,
                                      vertical: 20,
                                    ),
                                    child: Column(
                                      children: [
                                        const Text(
                                          'Ambil Photo',
                                          style: TextStyle(
                                            fontSize: 20,
                                            color: Colors.black,
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 20,
                                        ),
                                        Container(
                                          margin: const EdgeInsets.symmetric(
                                            horizontal: 15,
                                            vertical: 15,
                                          ),
                                          child: ElevatedButton(
                                            style: ButtonStyle(
                                              backgroundColor:
                                                  MaterialStateProperty.all(
                                                Colors.blueGrey,
                                              ),
                                            ),
                                            onPressed: getImageCamera,
                                            child: const Text(
                                              'Camera',
                                              style: TextStyle(
                                                fontSize: 20,
                                                color: Colors.black,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  )),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(
                      top: 10,
                    ),
                    child: ElevatedButton(
                      onPressed: () {
                        uploadImages(imagesFile!);
                      },
                      child: const Text(
                        'Simpan',
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }
        }),
      ),
    );
  }
}
