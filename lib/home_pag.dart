import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cloud_storage/succes_page.dart';
import 'package:image_picker/image_picker.dart';

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
  Future uploadImages(File images) async {
    String fileName = images.path.split('/').last;
    try {
      await storageRef
          .child('/images/profile/$fileName')
          .putFile(images)
          .then((p0) {
        print(p0);
        if (p0 != null) {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: ((context) => MySuccessPage()),
            ),
          );
        }
      });
    } on FirebaseException catch (e) {
      print(e);
    }
  }

  Future getImageCamera() async {
    final pickedfile =
        await picker.pickImage(source: ImageSource.camera, imageQuality: 80);
    if (pickedfile != null) {
      setState(() {
        imagesFile = File(pickedfile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Flutter Firebase Cloud Storage"),
        ),
        body: FutureBuilder(
            future: future,
            builder: ((context, snapshot) {
              if (snapshot.hasError) {
                return const Text('Error');
              }
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
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
                              child: Icon(Icons.person),
                            ),
                      const Text(
                        'Choose Image',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
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
                                        height: 100,
                                        width:
                                            MediaQuery.of(context).size.width,
                                        margin: const EdgeInsets.symmetric(
                                            vertical: 20, horizontal: 20),
                                        child: Column(
                                          children: [
                                            const Text(
                                              'Ambil Photo Profile',
                                              style: TextStyle(fontSize: 20),
                                            ),
                                            const SizedBox(
                                              height: 20,
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                ElevatedButton(
                                                  onPressed: getImageCamera,
                                                  child: const Text('Camera'),
                                                ),
                                              ],
                                            )
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
                        margin: const EdgeInsets.only(top: 5),
                        child: ElevatedButton(
                            onPressed: () {
                              uploadImages(imagesFile!);
                            },
                            child: const Text('Simpan')),
                      )
                    ],
                  ),
                );
              }
            })));
  }
}
