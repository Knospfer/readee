import 'package:flutter/material.dart';
import 'package:readee/_domain/book_model.dart';

class DetailScreen extends StatelessWidget {
  final BookModel book;
  const DetailScreen({super.key, required this.book});

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
