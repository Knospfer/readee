import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:readee/_domain/models/book_model.dart';
import 'package:readee/_domain/repositories/book_repository.dart';
import 'package:readee/_domain/repositories/my_books_repository.dart';

part 'books_event.dart';

part 'books_state.dart';

@injectable
class BooksBloc extends Bloc<BooksEvent, BlocState> {
  final BookRepository bookRepository;
  final MyBookRepository myBookRepository;

  BooksBloc(this.bookRepository, this.myBookRepository) : super(Initial()) {
    on<BooksEvent>((event, emit) async {
      switch (event.runtimeType) {
        case BorrowBook:
          await _act(event, emit, _borrow);
          break;
        case UpdateBookDeadline:
          await _act(event, emit, _updateDeadline);
          break;
        case LendBook:
          await _act(event, emit, _lend);
          break;
        case CheckBookOwnership:
          final book = await myBookRepository.getBook(event.book.id);
          emit(BookOwnershipChecked(book));
          break;
        default:
          break;
      }
    });
  }

  Future<void> _act(
    BooksEvent event,
    Emitter<BlocState> emit,
    Future<void> Function(BookModel book) callback,
  ) async {
    emit(Loading());
    await callback(event.book);
    emit(ActionPerformed());
  }

  Future<void> _borrow(BookModel bookModel) async {
    final updatedBook = bookModel.copyWith(
      date: DateTime.now(),
      copies: bookModel.copies - 1,
    );
    await bookRepository.updateBook(updatedBook);
    await myBookRepository.upsertBook(updatedBook);
  }

  Future<void> _updateDeadline(BookModel bookModel) async {
    final oneMonthFromNow = DateTime.now().add(const Duration(days: 30));
    final updatedBook = bookModel.copyWith(date: oneMonthFromNow);
    await bookRepository.updateBook(updatedBook);
    await myBookRepository.upsertBook(updatedBook);
  }

  Future<void> _lend(BookModel bookModel) async {
    final updatedBook = bookModel.copyWith(
      date: null,
      copies: bookModel.copies + 1,
    );
    await bookRepository.updateBook(updatedBook);
    await myBookRepository.removeBook(updatedBook);
  }
}
