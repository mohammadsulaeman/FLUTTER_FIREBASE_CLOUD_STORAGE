import 'package:flutter/material.dart';
import 'package:flutter_cloud_storage/main.dart';

class MySuccessPage extends StatelessWidget {
  const MySuccessPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Success Pages'),
      ),
      body: Column(
        children: [
          Container(
            margin: const EdgeInsets.only(top: 5),
            child: const Text(
                'Data Success Terkirim, Silakan Periksa Firebase Console Anda'),
          ),
          Container(
            margin: const EdgeInsets.only(top: 5),
            child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => const MyApp()));
                },
                child: const Text('Back')),
          )
        ],
      ),
    );
  }
}
