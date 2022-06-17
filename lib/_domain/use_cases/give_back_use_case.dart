import 'package:injectable/injectable.dart';
import 'package:readee/_domain/models/book_model.dart';
import 'package:readee/_domain/models/book_owned_model.dart';
import 'package:readee/_domain/repositories/book_repository.dart';
import 'package:readee/_domain/repositories/my_books_repository.dart';

@lazySingleton
class GiveBackUseCase {
  final BookRepository _bookRepository;
  final BookOwnedRepository _bookOwnedRepository;

  GiveBackUseCase(this._bookRepository, this._bookOwnedRepository);

  Future<void> giveBack(BookModel book, BookOwnedModel bookOwned) async {
    final updatedBook = book.copyWith(
      date: null,
      copies: book.copies + 1,
    );
    await _bookRepository.update(
      id: updatedBook.id,
      toJson: updatedBook.toJson,
    );
    await _bookOwnedRepository.remove(bookOwned.id);
  }
}
