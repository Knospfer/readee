part of 'books_bloc.dart';

@immutable
class BookOwnershipChecked extends BlocState<BookOwnedModel> {
  final BookOwnedModel? book;

  const BookOwnershipChecked(this.book);
}
