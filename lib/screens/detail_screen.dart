import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:readee/_core/definitions/bloc_state.dart';
import 'package:readee/_core/widgets/book_image.dart';
import 'package:readee/_domain/blocs/books/books_bloc.dart';
import 'package:readee/_domain/blocs/wishlist/wishlist_bloc.dart';
import 'package:readee/_domain/models/book_model.dart';
import 'package:readee/_domain/models/book_owned_model.dart';
import 'package:readee/depencency_injection.dart';

const loremIpsum = """ 
Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed consectetur eu velit sed malesuada. Duis placerat nulla eros, vitae porttitor tellus blandit at. Nullam nulla neque, placerat eget ante accumsan, congue placerat dui. Aliquam eu finibus leo, non lacinia ante. Praesent arcu lorem, tincidunt in dignissim a, volutpat vitae nulla. Mauris pharetra placerat turpis, ac tincidunt sem porta vitae. Sed id bibendum elit. Quisque rutrum, purus pharetra ornare scelerisque, nulla dolor dapibus ante, at tincidunt dui tellus nec est. Nulla ornare tellus ac arcu maximus, ac euismod justo rhoncus. Donec ac urna pharetra, feugiat erat quis, fermentum lorem. Etiam venenatis hendrerit est.
""";

class DetailScreen extends StatefulWidget implements AutoRouteWrapper {
  final BookModel book;

  const DetailScreen({super.key, required this.book});

  @override
  State<DetailScreen> createState() => _DetailScreenState();

  @override
  Widget wrappedRoute(BuildContext context) => MultiBlocProvider(
        providers: [
          BlocProvider(create: (_) => getIt<BooksBloc>()),
          BlocProvider(create: (_) => getIt<WishlistBloc>()),
        ],
        child: this,
      );
}

class _DetailScreenState extends State<DetailScreen> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      context.read<BooksBloc>().add(InitializeStream(widget.book));
      context.read<WishlistBloc>().add(InitStream(widget.book));
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final bottomSafeArea = MediaQuery.of(context).padding.bottom;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          _DetailAppBar(book: widget.book),
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _Header(book: widget.book),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      _DataTile(title: "Genre", body: widget.book.genre),
                      _DataTile(title: "Author", body: widget.book.author),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    "Overview",
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Text(
                    loremIpsum,
                    style: TextStyle(fontSize: 14),
                  ),
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
              child: const _AvailableBookCtas(),
            ),
          ),
        ],
      ),
    );
  }
}

class _DetailAppBar extends StatelessWidget {
  final BookModel book;

  const _DetailAppBar({required this.book});

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      backgroundColor: Colors.grey,
      pinned: true,
      actions: [
        BlocBuilder<WishlistBloc, BlocState<bool>>(builder: (context, state) {
          final acutalState = state is Loaded<bool> && state.data;

          return IconButton(
            icon: Icon(
              acutalState ? Icons.favorite : Icons.favorite_border,
              color: Colors.red,
            ),
            onPressed: () => context.read<WishlistBloc>().add(Toggle(book)),
          );
        }),
      ],
    );
  }
}

class _AvailableBookCtas extends StatelessWidget {
  const _AvailableBookCtas();

  void _borrowBook(BuildContext context, BookModel book) {
    context.read<BooksBloc>().add(BorrowBook(book));
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<BooksBloc, BlocState>(listener: (_, state) {
      if (state is ErrorReceived) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(state.error),
            duration: const Duration(seconds: 1),
          ),
        );
      }
    }, builder: (_, state) {
      if (state is! Loaded) return const SizedBox.shrink();
      final userBook = state.data.bookOwnedModel as BookOwnedModel?;
      final libraryBook = state.data.bookModel as BookModel;

      return Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (userBook == null) ...[
            ElevatedButton(
              onPressed: libraryBook.isAvailable
                  ? () => _borrowBook(context, libraryBook)
                  : null,
              child: Text(
                libraryBook.isAvailable ? "Borrow" : "Not Available",
                style: const TextStyle(color: Colors.white),
              ),
            ),
            if (!libraryBook.isAvailable)
              Center(
                child: Text.rich(
                  TextSpan(
                    text: "Available in ",
                    children: [
                      TextSpan(
                        text: "${libraryBook.daysRemaining} days",
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ),
          ] else ...[
            ElevatedButton(
              onPressed: () => context.read<BooksBloc>().add(
                    ReturnBook(libraryBook, userBook),
                  ),
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(Colors.red),
              ),
              child: const Text(
                "Return",
                style: TextStyle(color: Colors.white),
              ),
            ),
            TextButton(
              onPressed: () => context.read<BooksBloc>().add(
                    UpdateBookDeadline(libraryBook, userBook),
                  ),
              child: Text(
                "Keep it for 30 more days (${userBook.daysRemaining} remaining)",
              ),
            ),
          ],
        ],
      );
    });
  }
}

class _Header extends StatelessWidget {
  final BookModel book;

  const _Header({required this.book});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 16, bottom: 32),
      decoration: const BoxDecoration(
        color: Colors.grey,
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
      ),
      child: Column(
        children: [
          const BookImage(url: "", height: 200, width: 140),
          const SizedBox(height: 30),
          Text(
            book.name,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            "by ${book.author}",
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}

class _DataTile extends StatelessWidget {
  final String title;
  final String body;

  const _DataTile({required this.title, required this.body});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Center(
        child: Column(
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
            Text(
              body,
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
