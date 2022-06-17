import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:readee/_core/definitions/bloc_state.dart';
import 'package:readee/_domain/entities/book_detail_entity.dart';
import 'package:readee/_domain/models/book_model.dart';
import 'package:readee/_domain/models/book_owned_model.dart';
import 'package:readee/_domain/use_cases/borrow_use_case.dart';
import 'package:readee/_domain/use_cases/give_back_use_case.dart';
import 'package:readee/_domain/use_cases/update_deadline_use_case.dart';
import 'package:readee/_non_functional_requirements/detail_page_stream_use_case.dart';

part 'books_event.dart';
part 'books_state.dart';

@injectable
class BooksBloc extends Bloc<BooksEvent, BlocState<BookDetailEntity>> {
  final GiveBackUseCase _giveBackUseCase;
  final UpdateDeadlineUseCase _updateDeadlineUseCase;
  final BorrowUseCase _borrowUseCase;
  final DetailPageStreamUseCase _detailPageStreamUseCase;

  BooksBloc(
    this._giveBackUseCase,
    this._updateDeadlineUseCase,
    this._borrowUseCase,
    this._detailPageStreamUseCase,
  ) : super(Initial<BookDetailEntity>()) {
    on<BooksEvent>((event, emit) async {
      switch (event.runtimeType) {
        case BorrowBook:
          await _borrow(emit, event.book);
          break;
        case UpdateBookDeadline:
          await _act(event as BooksOwnedEvent, emit, _updateDeadline);
          break;
        case ReturnBook:
          await _act(event as BooksOwnedEvent, emit, _giveBackUseCase.giveBack);
          break;
        case InitializeStream:
          await _initStream(emit, event.book.id);
          break;
      }
    });
  }

  Future<void> _initStream(Emitter<BlocState> emit, String bookId) =>
      emit.forEach(
        _detailPageStreamUseCase.stream(bookId),
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

  Future<void> _borrow(Emitter<BlocState> emit, BookModel bookModel) async {
    final canBorrow = await _borrowUseCase.checkUserCanBorrowMoreBooks();
    if (!canBorrow) {
      emit(const ErrorReceived<BookDetailEntity>("You can borrow max 3 books"));
      return;
    }
    await _borrowUseCase.borrow(bookModel);
  }

  Future<void> _updateDeadline(BookModel book, BookOwnedModel bookOwned) async {
    if (bookOwned.date == null) return; //todo alert
    await _updateDeadlineUseCase.updateDeadline(book, bookOwned);
  }
}
