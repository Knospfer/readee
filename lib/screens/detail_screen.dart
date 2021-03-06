import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:readee/_core/definitions/bloc_state.dart';
import 'package:readee/_domain/blocs/books/books_bloc.dart';
import 'package:readee/_domain/blocs/wishlist/wishlist_bloc.dart';
import 'package:readee/_domain/models/book_model.dart';
import 'package:readee/_domain/models/book_owned_model.dart';
import 'package:readee/depencency_injection.dart';

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
      appBar: AppBar(
        title: const Text("Book detail"),
        actions: [
          BlocBuilder<WishlistBloc, BlocState<bool>>(builder: (context, state) {
            final acutalState = state is Loaded<bool> && state.data;

            return IconButton(
              onPressed: () => context.read<WishlistBloc>().add(
                    Toggle(widget.book),
                  ),
              icon: Icon(acutalState ? Icons.favorite : Icons.favorite_border),
            );
          }),
        ],
      ),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ListTile(
                  title: const Text("Title"),
                  subtitle: Text(widget.book.name),
                ),
                ListTile(
                  title: const Text("Author"),
                  subtitle: Text(widget.book.author),
                ),
                ListTile(
                  title: const Text("Genre"),
                  subtitle: Text(widget.book.genre),
                ),
                BlocBuilder<BooksBloc, BlocState>(builder: (_, state) {
                  if (state is! Loaded) return const SizedBox.shrink();

                  return _OwnedDaysLeft(book: state.data.bookOwnedModel);
                }),
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

class _AvailableBookCtas extends StatelessWidget {
  const _AvailableBookCtas();

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
      final userBook = state.data.bookOwnedModel;
      final libraryBook = state.data.bookModel;

      if (userBook == null && !libraryBook.isAvailable) {
        return _UnavailableBook(book: libraryBook);
      }

      return Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (userBook == null && libraryBook.isAvailable)
            ElevatedButton(
              onPressed: () => context.read<BooksBloc>().add(
                    BorrowBook(libraryBook),
                  ),
              child: const Text("Borrow"),
            )
          else ...[
            ElevatedButton(
              onPressed: () => context.read<BooksBloc>().add(
                    UpdateBookDeadline(libraryBook, userBook),
                  ),
              child: const Text("Keep it for 30 more days"),
            ),
            ElevatedButton(
              onPressed: () => context.read<BooksBloc>().add(
                    ReturnBook(libraryBook, userBook),
                  ),
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(Colors.red),
              ),
              child: const Text("Return"),
            ),
          ],
        ],
      );
    });
  }
}

class _UnavailableBook extends StatelessWidget {
  final BookModel? book;

  const _UnavailableBook({required this.book});

  @override
  Widget build(BuildContext context) {
    final actualBook = book;
    if (actualBook == null || actualBook.date == null) return const SizedBox();

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
                text: "${actualBook.daysRemaining} days",
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _OwnedDaysLeft extends StatelessWidget {
  final BookOwnedModel? book;

  const _OwnedDaysLeft({required this.book});

  @override
  Widget build(BuildContext context) {
    final acutalBook = book;
    if (acutalBook == null) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Text.rich(
        TextSpan(
          text: "You have ",
          children: [
            TextSpan(
              text: "${acutalBook.daysRemaining} days",
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            const TextSpan(text: " left"),
          ],
        ),
      ),
    );
  }
}
