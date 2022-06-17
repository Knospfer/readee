import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:meta/meta.dart';
import 'package:readee/_core/definitions/bloc_state.dart';
import 'package:readee/_domain/models/book_model.dart';
import 'package:readee/_domain/repositories/wishlist_repository.dart';

part 'wishlist_event.dart';

@injectable
class WishlistBloc extends Bloc<WishlistEvent, BlocState<bool>> {
  final WishlistRepository _repository;

  WishlistBloc(this._repository) : super(Initial<bool>()) {
    on<WishlistEvent>((event, emit) async {
      switch (event.runtimeType) {
        case InitStream:
          await _initStream(emit, event.bookModel.id);
          break;
        case Toggle:
          await _toggleWishList(event.bookModel);
          break;
      }
    });
  }

  Future<void> _initStream(Emitter<BlocState> emit, String bookId) =>
      emit.forEach(
        _repository.singleBookStream(bookId),
        onData: (BookModel? book) => Loaded<bool>(book != null),
      );

  Future<void> _toggleWishList(BookModel bookModel) async {
    final acutalBook = await _repository.getBook(bookModel.id);

    acutalBook == null
        ? await _repository.addBook(bookModel)
        : await _repository.removeBook(acutalBook);
  }
}
