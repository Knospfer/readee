import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:readee/_core/navigation.gr.dart';
import 'package:readee/_domain/book_model.dart';
import 'package:readee/depencency_injection.dart';
import 'package:readee/_domain/book_list_cubit.dart';
import 'package:readee/screens/filter_modal.dart';

class HomeScreen extends StatefulWidget implements AutoRouteWrapper {
  const HomeScreen({super.key});

  @override
  State<StatefulWidget> createState() => HomeState();

  @override
  Widget wrappedRoute(BuildContext context) => BlocProvider(
        create: (_) => getIt<BookCubit>(),
        child: this,
      );
}

class HomeState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Readee")),
      body: BlocBuilder<BookCubit, List<BookModel>>(
        builder: ((_, items) {
          return ListView.separated(
            itemCount: items.length,
            separatorBuilder: (_, __) => const Divider(),
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () => context.router.push(const DetailScreenRoute()),
                child: _BookListTile(book: items[index]),
              );
            },
          );
        }),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => showFilterModal(context),
        child: const Icon(Icons.search),
      ),
    );
  }
}

class _BookListTile extends StatelessWidget {
  final BookModel book;

  const _BookListTile({required this.book});

  @override
  Widget build(BuildContext context) {
    final bookAvailable = book.copies > 0;
    final color = bookAvailable ? Colors.green : Colors.orange;
    final icon =
        bookAvailable ? Icons.check_circle_outline : Icons.access_time_outlined;

    return ListTile(
      title: Text(book.name),
      subtitle: Text(book.author),
      leading: Icon(icon, color: color),
    );
  }
}
