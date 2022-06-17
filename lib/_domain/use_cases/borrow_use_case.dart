import 'package:injectable/injectable.dart';
import 'package:readee/_domain/models/book_model.dart';
import 'package:readee/_domain/models/book_owned_model.dart';
import 'package:readee/_domain/repositories/book_repository.dart';
import 'package:readee/_domain/repositories/my_books_repository.dart';
import 'package:readee/_domain/repositories/wishlist_repository.dart';

@lazySingleton
class BorrowUseCase {
  final BookRepository _bookRepository;
  final BookOwnedRepository _bookOwnedRepository;
  final WishlistRepository _wishlistRepository;

  BorrowUseCase(
    this._bookRepository,
    this._bookOwnedRepository,
    this._wishlistRepository,
  );

  Future<void> borrow(BookModel bookModel) async {
    final updatedBook = bookModel.copyWith(
      date: DateTime.now(),
      copies: bookModel.copies - 1,
      owned: true,
    );
    final newBook = BookOwnedModel(
      id: "",
      bookId: bookModel.id,
      date: DateTime.now().add(const Duration(days: 14)),
    );
    await _bookRepository.update(
      id: updatedBook.id,
      toJson: updatedBook.toJson,
    );
    await _bookOwnedRepository.addModelWithId(newBook);
    await _wishlistRepository.updateIfExisting(updatedBook);
  }

  Future<bool> checkUserCanBorrowMoreBooks() async {
    final userBooksNumber = await _bookOwnedRepository.getUserBooksNumber();

    return userBooksNumber <= 3;
  }
}
