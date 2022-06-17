part of 'books_bloc.dart';

@immutable
abstract class BooksEvent {
  final BookModel book;

  const BooksEvent(this.book);
}

@immutable
abstract class BooksOwnedEvent extends BooksEvent {
  final BookOwnedModel bookOwnedModel;

  const BooksOwnedEvent(super.book, this.bookOwnedModel);
}

@immutable
class InitializeStream extends BooksEvent {
  const InitializeStream(super.book);
}

@immutable
class BorrowBook extends BooksEvent {
  const BorrowBook(super.book);
}

@immutable
class UpdateBookDeadline extends BooksOwnedEvent {
  const UpdateBookDeadline(super.book, super.bookOwnedModel);
}

@immutable
class LendBook extends BooksOwnedEvent {
  const LendBook(super.book, super.bookOwnedModel);
}

class ToggleWishlist extends BooksOwnedEvent {
  static const _defaultBook = BookOwnedModel(id: "", bookId: "");

  const ToggleWishlist(BookModel book, BookOwnedModel? bookOwned)
      : super(book, bookOwned ?? _defaultBook);
}
