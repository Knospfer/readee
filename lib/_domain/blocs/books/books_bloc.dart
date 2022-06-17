import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:readee/_core/definitions/bloc_state.dart';
import 'package:readee/_domain/entities/book_detail_entity.dart';
import 'package:readee/_domain/models/book_model.dart';
import 'package:readee/_domain/models/book_owned_model.dart';
import 'package:readee/_domain/repositories/book_repository.dart';
import 'package:readee/_domain/repositories/my_books_repository.dart';
import 'package:readee/_domain/repositories/wishlist_repository.dart';
import 'package:rxdart/rxdart.dart';

part 'books_event.dart';

part 'books_state.dart';

@injectable
class BooksBloc extends Bloc<BooksEvent, BlocState<BookDetailEntity>> {
  final BookRepository _bookRepository;
  final BookOwnedRepository _bookOwnedRepository;
  final WishlistRepository _wishlistRepository;

  BooksBloc(
      this._bookRepository, this._bookOwnedRepository, this._wishlistRepository)
      : super(Initial<BookDetailEntity>()) {
    on<BooksEvent>((event, emit) async {
      switch (event.runtimeType) {
        case BorrowBook:
          await _borrow(event.book);
          break;
        case UpdateBookDeadline:
          await _act(event as BooksOwnedEvent, emit, _updateDeadline);
          break;
        case LendBook:
          await _act(event as BooksOwnedEvent, emit, _lend);
          break;
        case InitializeStream:
          await _initStream(emit, event.book.id);
          break;
      }
    });
  }

  Future<void> _initStream(Emitter<BlocState> emit, String bookId) =>
      emit.forEach(
        CombineLatestStream(
          [
            _bookRepository.singleItemStream(bookId),
            _bookOwnedRepository.singleBookStream(bookId)
          ],
          (values) => BookDetailEntity(
            values.first as BookModel,
            values.last as BookOwnedModel?,
          ),
        ),
        onData: (BookDetailEntity entity) => Loaded<BookDetailEntity>(entity),
      );

  Future<void> _act(
    BooksOwnedEvent event,
    Emitter<BlocState> emit,
    Future<void> Function(BookModel book, BookOwnedModel bookOwned) callback,
  ) async {
    // emit(Loading());
    await callback(event.book, event.bookOwnedModel);
    // emit(ActionPerformed());
  }

  Future<void> _borrow(BookModel bookModel) async {
    final canBorrow = await _checkUserCanBorrowMoreBooks();
    if (!canBorrow) return; //TODO ALERT

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
    await _bookOwnedRepository.addBook(newBook);
    await _wishlistRepository.updateIdExisting(updatedBook);
  }

  Future<void> _updateDeadline(BookModel book, BookOwnedModel bookOwned) async {
    if (bookOwned.date == null) return; //todo alert
    final oneMoreMonth = bookOwned.date?.add(const Duration(days: 30));
    final updatedBookOwned = bookOwned.copyWith(date: oneMoreMonth);
    final updatedBook = book.copyWith(date: oneMoreMonth);

    await _bookRepository.update(
      id: updatedBook.id,
      toJson: updatedBook.toJson,
    );
    await _bookOwnedRepository.updateBook(updatedBookOwned);
  }

  Future<void> _lend(BookModel book, BookOwnedModel bookOwned) async {
    final updatedBook = book.copyWith(
      date: null,
      copies: book.copies + 1,
    );
    await _bookRepository.update(
      id: updatedBook.id,
      toJson: updatedBook.toJson,
    );
    await _bookOwnedRepository.removeBook(bookOwned);
  }

  Future<bool> _checkUserCanBorrowMoreBooks() async {
    final userBooksNumber = await _bookOwnedRepository.getUserBooksNumber();

    return userBooksNumber <= 3;
  }
}