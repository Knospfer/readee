part of 'books_bloc.dart';

@immutable
abstract class BlocState {
  const BlocState();
}

class Initial extends BlocState {}

class ActionPerformed extends BlocState {}

class Loading extends BlocState {}

class ErrorReceived extends BlocState {}

@immutable
class BookOwnershipChecked extends BlocState {
  final BookModel? book;

  const BookOwnershipChecked(this.book);
}
