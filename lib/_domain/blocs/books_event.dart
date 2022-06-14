part of 'books_bloc.dart';

@immutable
abstract class BooksEvent {
  final BookModel book;

  const BooksEvent(this.book);
}

@immutable
class BorrowBook extends BooksEvent {
  const BorrowBook(super.book);
}

@immutable
class UpdateBookDeadline extends BooksEvent {
  const UpdateBookDeadline(super.book);
}

@immutable
class LendBook extends BooksEvent {
  const LendBook(super.book);
}
