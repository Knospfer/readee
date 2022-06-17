import 'package:injectable/injectable.dart';
import 'package:readee/_domain/entities/filter_book_entity.dart';
import 'package:readee/_domain/models/book_model.dart';
import 'package:readee/_domain/repositories/book_repository.dart';
import 'package:readee/_domain/repositories/wishlist_repository.dart';

@injectable
class FilterUseCase {
  final BookRepository _bookRepository;
  final WishlistRepository _wishlistRepository;

  FilterUseCase(this._bookRepository, this._wishlistRepository);

  Stream<List<BookModel>> initialStream() => _bookRepository.stream();

  Stream<List<BookModel>> search(FilterBookEntity filter) {
    if (filter.wishlisted) return _searchWishlist(filter);

    return _searchBook(filter.name);
  }

  Stream<List<BookModel>> _searchWishlist(FilterBookEntity filter) {
    final bookName = filter.name;

    return bookName.isEmpty
        ? _wishlistRepository.stream()
        : _wishlistRepository.queryBy(bookName);
  }

  Stream<List<BookModel>> _searchBook(String bookName) {
    return bookName.isEmpty
        ? _bookRepository.stream()
        : _bookRepository.queryBy(bookName);
  }
}
