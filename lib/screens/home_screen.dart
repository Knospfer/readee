import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:readee/_core/navigation/navigation.gr.dart';
import 'package:readee/_core/theme/theme_data.dart';
import 'package:readee/_core/widgets/book_image.dart';
import 'package:readee/_core/widgets/staggered_sliver_list.dart';
import 'package:readee/_core/widgets/standard_box_shadow.dart';
import 'package:readee/_domain/entities/filter_book_entity.dart';
import 'package:readee/_domain/models/book_model.dart';
import 'package:readee/depencency_injection.dart';
import 'package:readee/_domain/cubits/book_list_cubit.dart';
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
  final _key = GlobalKey<StaggeredSliverListState<BookModel>>();

  Future<void> _showFilter() async {
    final filter = await showFilterModal(context) as FilterBookEntity?;
    if (!mounted) return;
    context.read<BookCubit>().search(filter);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<BookCubit, List<BookModel>>(
        listener: ((_, items) {
          _key.currentState?.emptyList();
          _key.currentState?.addItemsStaggered(items);
        }),
        child: CustomScrollView(
          slivers: [
            _HomeHeader(onActionTap: _showFilter),
            const SliverPadding(padding: EdgeInsets.only(bottom: 32)),
            StaggeredSliverList<BookModel>(
              key: _key,
              builder: (_, item) {
                return GestureDetector(
                  onTap: () => context.router.push(
                    DetailScreenRoute(book: item),
                  ),
                  child: _BookListTile(book: item),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _HomeHeader extends StatelessWidget {
  final VoidCallback onActionTap;

  const _HomeHeader({required this.onActionTap});

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      backgroundColor: Colors.transparent,
      expandedHeight: 140,
      floating: false,
      pinned: true,
      elevation: 0,
      title: const Text("Readee"),
      actions: [
        IconButton(
          onPressed: onActionTap,
          icon: const Icon(Icons.search),
        ),
      ],
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          alignment: Alignment.bottomLeft,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text(
                "Hi reader!",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10),
              Text("What do you want to read today?"),
            ],
          ),
        ),
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
    final color = bookAvailable ? green : orange;
    final icon = bookAvailable ? Icons.check : Icons.close_rounded;

    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: const BorderRadius.all(Radius.circular(8)),
        boxShadow: [StandardBoxShadow()],
      ),
      margin: const EdgeInsets.symmetric(horizontal: 16).copyWith(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const BookImage(
            url: "", //TODO BOOK IMAGE
            height: 60,
            width: 60,
            margin: EdgeInsets.all(16),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  book.name,
                  style: const TextStyle(fontSize: 18),
                ),
                const SizedBox(height: 4),
                Text(
                  "by ${book.author}",
                  style: Theme.of(context).textTheme.subtitle1,
                ),
              ],
            ),
          ),
          const Expanded(child: SizedBox()),
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: color,
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(4),
              ),
            ),
            alignment: Alignment.center,
            child: Icon(icon, color: Colors.white),
          )
        ],
      ),
    );
  }
}
