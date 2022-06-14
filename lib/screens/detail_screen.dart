import 'package:flutter/material.dart';
import 'package:readee/_domain/models/book_model.dart';

class DetailScreen extends StatelessWidget {
  final BookModel book;

  const DetailScreen({super.key, required this.book});

  @override
  Widget build(BuildContext context) {
    final bottomSafeArea = MediaQuery
        .of(context)
        .padding
        .bottom;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Book detail"),
      ),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ListTile(
                  title: const Text("Title"),
                  subtitle: Text(book.name),
                ),
                ListTile(
                  title: const Text("Author"),
                  subtitle: Text(book.author),
                ),
                ListTile(
                  title: const Text("Genre"),
                  subtitle: Text(book.genre),
                ),
              ],
            ),
          ),
          SliverFillRemaining(
            hasScrollBody: false,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16).copyWith(
                bottom: 16 + bottomSafeArea,
              ),
              child: book.isAvailable
                  ? _AvailableBookCtas(book: book)
                  : _UnavailableBook(book: book),
            ),
          ),
        ],
      ),
    );
  }
}

class _AvailableBookCtas extends StatelessWidget {
  final BookModel book;

  const _AvailableBookCtas({required this.book});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (!book.isAlreadyBorroedByUser)
          ElevatedButton(
            onPressed: () {},
            child: const Text("Borrow"),
          )
        else
          ...[
            ElevatedButton(
              onPressed: () {},
              child: const Text("Keep it for 30 more days"),
            ),
            ElevatedButton(
              onPressed: () {},
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(Colors.red),
              ),
              child: const Text("Return"),
            ),
          ],
      ],
    );
  }
}

class _UnavailableBook extends StatelessWidget {
  final BookModel book;

  const _UnavailableBook({required this.book});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "This book is currently NOT available!",
          style: TextStyle(color: Colors.red),
        ),
        const SizedBox(height: 8),
        Text.rich(
          TextSpan(
            text: "It will be available in ",
            children: [
              TextSpan(
                text: "${book.daysRemaining} days",
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
