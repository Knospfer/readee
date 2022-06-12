import 'package:flutter/material.dart';

class DetailScreen extends StatelessWidget {
  const DetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Book detail"),
      ),
      body: const Center(
        child: Text("BOOOK"),
      ),
    );
  }
}
