import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:storagefirebase/home_pages.dart';

class MySuccess extends StatefulWidget {
  const MySuccess({super.key, required this.fileName});
  final String fileName;
  @override
  State<MySuccess> createState() => _MySuccessState();
}

class _MySuccessState extends State<MySuccess> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Data Success'),
        actions: [
          GestureDetector(
            child: const Icon(Icons.home),
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: ((context) => const MyHomePage())));
            },
          )
        ],
      ),
      body: Center(
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.only(top: 10, left: 10),
              child: ClipOval(
                child: Image.network(
                  widget.fileName,
                  width: 150,
                  height: 150,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(
                top: 10,
              ),
              child: const Text('Data Images Berhasil Di Kirim '),
            ),
          ],
        ),
      ),
    );
  }
}
