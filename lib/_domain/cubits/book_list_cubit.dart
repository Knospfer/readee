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

    final wishlisted = filter.wishlisted;
    final bookName = filter.name;
    if (wishlisted == true) return _searchWishlist(bookName);

    if (bookName == null || bookName.isEmpty) return _init();

    _subscription = _bookRepository.query(bookName).listen((event) => emit(event));
  }

  void _init() {
    if (_subscription != null) _subscription?.cancel();
    _subscription = _bookRepository.stream().listen((event) => emit(event));
  }

  void _searchWishlist(String? bookName) {
    final stream = bookName == null || bookName.isEmpty
        ? _wishlistRepository.stream()
        : _wishlistRepository.query(bookName);
    _subscription = stream.listen((event) => emit(event));
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}
