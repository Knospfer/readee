import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:readee/_domain/entities/filter_book_entity.dart';
import 'package:readee/_domain/models/book_model.dart';
import 'package:readee/_domain/repositories/book_repository.dart';
import 'package:readee/_domain/repositories/wishlist_repository.dart';

@injectable
class BookCubit extends Cubit<List<BookModel>> {
  final BookRepository _bookRepository;
  final WishlistRepository _wishlistRepository;
  StreamSubscription? _subscription;

  BookCubit(this._bookRepository, this._wishlistRepository) : super([]) {
    _init();
  }

  void search(FilterBookEntity? filter) {
    if (filter == null) return _init();
    _subscription?.cancel();

    if (filter.wishlisted) return _searchWishlist(filter);

    final stream = filter.name.isEmpty
        ? _bookRepository.stream()
        : _bookRepository.queryBy(filter.name);

    _subscription = stream.listen(
      (event) => emit(event.where((e) => e.owned == filter.owned).toList()),
    );
  }

  void _init() {
    if (_subscription != null) _subscription?.cancel();
    _subscription = _bookRepository.stream().listen((event) => emit(event));
  }

  void _searchWishlist(FilterBookEntity filter) {
    final bookName = filter.name;
    final owned = filter.owned;

    final stream = bookName.isEmpty
        ? _wishlistRepository.stream()
        : _wishlistRepository.queryBy(bookName);

    _subscription = stream.listen(
      (event) => emit(
        event.where((e) => e.owned == owned).toList(),
      ),
    );
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}
