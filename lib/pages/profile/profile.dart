import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("profile"),
      ),
      body: Center(
        child: TextButton(
          onPressed: () {},
          child: const Text('Next'),
        ),
      ),
    );
  }
}
