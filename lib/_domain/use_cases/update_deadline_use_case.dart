import 'package:injectable/injectable.dart';
import 'package:readee/_domain/models/book_model.dart';
import 'package:readee/_domain/models/book_owned_model.dart';
import 'package:readee/_domain/repositories/book_repository.dart';
import 'package:readee/_domain/repositories/my_books_repository.dart';

@lazySingleton
class UpdateDeadlineUseCase {
  final BookRepository _bookRepository;
  final BookOwnedRepository _bookOwnedRepository;

  UpdateDeadlineUseCase(this._bookRepository, this._bookOwnedRepository);

  Future<void> updateDeadline(BookModel book, BookOwnedModel bookOwned) async {
    final oneMoreMonth = bookOwned.date?.add(const Duration(days: 30));
    final updatedBookOwned = bookOwned.copyWith(date: oneMoreMonth);
    final updatedBook = book.copyWith(date: oneMoreMonth);

    await _bookRepository.update(
      id: updatedBook.id,
      toJson: updatedBook.toJson,
    );
    await _bookOwnedRepository.update(
      id: updatedBookOwned.id,
      toJson: updatedBookOwned.toJson,
    );
  }
}